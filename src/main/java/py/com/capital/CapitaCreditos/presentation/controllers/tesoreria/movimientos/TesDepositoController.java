package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.movimientos;

import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.view.ViewScoped;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.event.SelectEvent;
import org.primefaces.event.ToggleSelectEvent;
import org.primefaces.event.UnselectEvent;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDeposito;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCobrosValoresService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesDepositoService;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Component
@ViewScoped
public class TesDepositoController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(TesDepositoController.class);

	private TesDeposito tesDeposito, tesDepositoSelected;
	private CobCobrosValores cobCobrosValoresSelected;
	private LazyDataModel<TesDeposito> lazyModel;
	private List<CobCobrosValores> lazyModelValores;
	private LazyDataModel<TesBanco> lazyModelBanco;
	private List<CobCobrosValores> cobrosValoresList;

	private List<String> estadoList;
	private boolean esNuegoRegistro;
	private boolean esVisibleFormulario = true;
	public BigDecimal montoTotalDeposito = BigDecimal.ZERO;

	private static final String DT_NAME = "dt-deposito";

	// services
	@Autowired
	private TesDepositoService tesDepositoServiceImpl;

	@Autowired
	private CobCobrosValoresService cobCobrosValoresServiceImpl;

	@Autowired
	private TesBancoService tesBancoServiceImpl;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	private SessionBean sessionBean;

	@Autowired
	private CommonsUtilitiesController commonsUtilitiesController;

	@PostConstruct
	public void init() {
		this.cleanFields();

	}

	public void cleanFields() {
		this.tesDeposito = null;
		this.tesDepositoSelected = null;
		this.cobCobrosValoresSelected = null;

		this.lazyModel = null;
		this.lazyModelValores = null;
		this.lazyModelBanco = null;

		this.esNuegoRegistro = true;
		this.esVisibleFormulario = !esVisibleFormulario;
		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado(), "ANULADO");
		this.cobrosValoresList = new ArrayList<>();

	}

	public TesDeposito getTesDeposito() {
		if (Objects.isNull(tesDeposito)) {
			this.tesDeposito = new TesDeposito();
			this.tesDeposito.setMontoTotalDeposito(BigDecimal.ZERO);
			this.tesDeposito.setBsEmpresa(new BsEmpresa());
			this.tesDeposito.setTesBanco(new TesBanco());
			this.tesDeposito.getTesBanco().setBsPersona(new BsPersona());
			this.tesDeposito.setCobHabilitacionCaja(new CobHabilitacionCaja());
			this.tesDeposito.setEstado(Estado.ACTIVO.getEstado());
			this.tesDeposito.setFechaDeposito(LocalDate.now());

			if (!this.commonsUtilitiesController.validarSiTengaHabilitacionAbierta()) {
				this.tesDeposito.setCobHabilitacionCaja(this.commonsUtilitiesController.getHabilitacionAbierta());
			} else {
				validarCajaDelUsuario(true);
			}
		}
		return tesDeposito;
	}

	public void setTesDeposito(TesDeposito tesDeposito) {
		this.tesDeposito = tesDeposito;
	}

	public TesDeposito getTesDepositoSelected() {
		if (Objects.isNull(tesDepositoSelected)) {
			this.tesDepositoSelected = new TesDeposito();
			this.tesDepositoSelected.setMontoTotalDeposito(BigDecimal.ZERO);
			this.tesDepositoSelected.setBsEmpresa(new BsEmpresa());
			this.tesDepositoSelected.setTesBanco(new TesBanco());
			this.tesDepositoSelected.getTesBanco().setBsPersona(new BsPersona());
			this.tesDepositoSelected.setCobHabilitacionCaja(new CobHabilitacionCaja());
			this.tesDepositoSelected.setEstado(Estado.ACTIVO.getEstado());
			this.tesDepositoSelected.setFechaDeposito(LocalDate.now());

			if (!this.commonsUtilitiesController.validarSiTengaHabilitacionAbierta()) {
				this.tesDeposito.setCobHabilitacionCaja(this.commonsUtilitiesController.getHabilitacionAbierta());
			} else {
				validarCajaDelUsuario(true);
			}
		}
		return tesDepositoSelected;
	}

	public void setTesDepositoSelected(TesDeposito tesDepositoSelected) {
		if (!Objects.isNull(tesDepositoSelected)) {
			this.cobrosValoresList = this.cobCobrosValoresServiceImpl.buscarValoresDepositoLista(
					this.commonsUtilitiesController.getIdEmpresaLogueada(), tesDepositoSelected.getId());
			this.cobrosValoresList.sort(Comparator.comparing(CobCobrosValores::getNroOrden));
			tesDeposito = tesDepositoSelected;
			tesDepositoSelected = null;
			this.esNuegoRegistro = false;
			this.esVisibleFormulario = true;
		}
		this.tesDepositoSelected = tesDepositoSelected;
	}

	public CobCobrosValores getCobCobrosValoresSelected() {
		if (Objects.isNull(cobCobrosValoresSelected)) {
			cobCobrosValoresSelected = new CobCobrosValores();
			cobCobrosValoresSelected.setFechaValor(LocalDate.now());
			cobCobrosValoresSelected.setFechaVencimiento(LocalDate.now());
			cobCobrosValoresSelected.setIndDepositadoBoolean(false);
			cobCobrosValoresSelected.setNroValor("0");
			cobCobrosValoresSelected.setMontoValor(BigDecimal.ZERO);
			cobCobrosValoresSelected.setBsEmpresa(new BsEmpresa());
			cobCobrosValoresSelected.setBsTipoValor(new BsTipoValor());

		}
		return cobCobrosValoresSelected;
	}

	public void setCobCobrosValoresSelected(CobCobrosValores cobCobrosValoresSelected) {
		this.cobCobrosValoresSelected = cobCobrosValoresSelected;
	}

	public LazyDataModel<TesDeposito> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<TesDeposito>(this.tesDepositoServiceImpl
					.buscarTesDepositoActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<TesDeposito> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public List<CobCobrosValores> getLazyModelValores() {
		if (Objects.isNull(lazyModelValores)) {
			List<CobCobrosValores> listaFiltrada = this.cobCobrosValoresServiceImpl
					.buscarCobCobrosValoresActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()).stream()
					.filter(valor -> valor.getIndDepositado().equalsIgnoreCase("N"))
					.sorted(Comparator.comparing(CobCobrosValores::getFechaValor)).collect(Collectors.toList());
			lazyModelValores = listaFiltrada;
		}
		return lazyModelValores;
	}

	public void setLazyModelValores(List<CobCobrosValores> lazyModelValores) {
		this.lazyModelValores = lazyModelValores;
	}

	public LazyDataModel<TesBanco> getLazyModelBanco() {
		if (Objects.isNull(lazyModelBanco)) {
			lazyModelBanco = new GenericLazyDataModel<TesBanco>((List<TesBanco>) tesBancoServiceImpl
					.buscarTesBancoActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModelBanco;
	}

	public void setLazyModelBanco(LazyDataModel<TesBanco> lazyModelBanco) {
		this.lazyModelBanco = lazyModelBanco;
	}

	public CobCobrosValoresService getCobCobrosValoresServiceImpl() {
		return cobCobrosValoresServiceImpl;
	}

	public void setCobCobrosValoresServiceImpl(CobCobrosValoresService cobCobrosValoresServiceImpl) {
		this.cobCobrosValoresServiceImpl = cobCobrosValoresServiceImpl;
	}

	public List<CobCobrosValores> getCobrosValoresList() {
		return cobrosValoresList;
	}

	public void setCobrosValoresList(List<CobCobrosValores> cobrosValoresList) {
		this.cobrosValoresList = cobrosValoresList;
	}

	public List<String> getEstadoList() {
		return estadoList;
	}

	public void setEstadoList(List<String> estadoList) {
		this.estadoList = estadoList;
	}

	public boolean isEsNuegoRegistro() {
		return esNuegoRegistro;
	}

	public void setEsNuegoRegistro(boolean esNuegoRegistro) {
		this.esNuegoRegistro = esNuegoRegistro;
	}

	public boolean isEsVisibleFormulario() {
		return esVisibleFormulario;
	}

	public void setEsVisibleFormulario(boolean esVisibleFormulario) {
		this.esVisibleFormulario = esVisibleFormulario;
	}

	public TesDepositoService getTesDepositoServiceImpl() {
		return tesDepositoServiceImpl;
	}

	public void setTesDepositoServiceImpl(TesDepositoService tesDepositoServiceImpl) {
		this.tesDepositoServiceImpl = tesDepositoServiceImpl;
	}

	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	public CommonsUtilitiesController getCommonsUtilitiesController() {
		return commonsUtilitiesController;
	}

	public void setCommonsUtilitiesController(CommonsUtilitiesController commonsUtilitiesController) {
		this.commonsUtilitiesController = commonsUtilitiesController;
	}

	public BigDecimal getMontoTotalDeposito() {
		return montoTotalDeposito;
	}

	public void setMontoTotalDeposito(BigDecimal montoTotalDeposito) {
		this.montoTotalDeposito = montoTotalDeposito;
	}

	public TesBancoService getTesBancoServiceImpl() {
		return tesBancoServiceImpl;
	}

	public void setTesBancoServiceImpl(TesBancoService tesBancoServiceImpl) {
		this.tesBancoServiceImpl = tesBancoServiceImpl;
	}

	public void eliminaDetalle() {
		this.cobrosValoresList.removeIf(det -> det.equals(cobCobrosValoresSelected));
		calcularTotalesDetalle();
	}

	public void limpiarDetalle() {
		this.cobrosValoresList = new ArrayList<>();
		this.montoTotalDeposito = BigDecimal.ZERO;
		PrimeFaces.current().ajax().update(":form:btnLimpiar", ":form:dt-detalle", ":form:dt-valor");
	}

	public void calcularTotalesDetalle() {
		this.montoTotalDeposito = BigDecimal.ZERO;
		tesDeposito.setMontoTotalDeposito(BigDecimal.ZERO);
		this.cobrosValoresList.forEach(valor -> {
			montoTotalDeposito = montoTotalDeposito.add(valor.getMontoValor());
		});
		tesDeposito.setMontoTotalDeposito(montoTotalDeposito);

	}

	public void onRowSelect(SelectEvent<CobCobrosValores> event) {
		this.cobCobrosValoresSelected = event.getObject();
		this.calcularTotalesDetalle();
		this.cobCobrosValoresSelected = null;
		getCobCobrosValoresSelected();
		PrimeFaces.current().ajax().update(":form:dt-detalle", ":form:btnGuardar", ":form:dt-valor");
	}

	public void onRowUnselect(UnselectEvent<CobCobrosValores> event) {
		this.cobCobrosValoresSelected = event.getObject();
		this.calcularTotalesDetalle();
		this.cobCobrosValoresSelected = null;
		getCobCobrosValoresSelected();
		PrimeFaces.current().ajax().update(":form:dt-detalle", ":form:btnGuardar", ":form:dt-valor");
	}

	public void selectAllToggle(ToggleSelectEvent event) {
		if (event.isSelected()) {
			this.cobrosValoresList.addAll(lazyModelValores);
			this.calcularTotalesDetalle();

		} else {
			limpiarDetalle();
		}
		PrimeFaces.current().ajax().update(":form:dt-detalle", ":form:btnGuardar", ":form:dt-valor");
	}

	public void validarCajaDelUsuario(boolean tieneHab) {
		if (tieneHab) {
			PrimeFaces.current().executeScript("PF('dlgNoTieneHabilitacion').show()");
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
			return;
		}
	}
	
	public void redireccionarAHabilitaciones() {
		try {
			PrimeFaces.current().executeScript("PF('dlgNoTieneHabilitacion').hide()");
			CommonUtils.redireccionar("/pages/cliente/cobranzas/definicion/CobHabilitacionCaja.xhtml");
		} catch (IOException e) {
			e.printStackTrace();
			LOGGER.error("Ocurrio un error al Guardar", System.err);
		}
	}

	public void guardar() {
		try {
			if (Objects.isNull(this.tesDeposito.getTesBanco())
					|| Objects.isNull(this.tesDeposito.getTesBanco().getId())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un banco.");
				return;
			}
			this.tesDeposito.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			this.tesDeposito.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());

			TesDeposito depositoGuardado = this.tesDepositoServiceImpl.save(tesDeposito);
			if (!Objects.isNull(depositoGuardado)) {
				if (CollectionUtils.isNotEmpty(cobrosValoresList) && cobrosValoresList.size() > 0) {
					this.cobrosValoresList = cobrosValoresList.stream().map(cobro -> {
						cobro.setIndDepositadoBoolean(true);
						cobro.setTesDeposito(depositoGuardado);
						cobro.setFechaDeposito(depositoGuardado.getFechaDeposito());
						return cobro;
					}).collect(Collectors.toList());
					this.cobCobrosValoresServiceImpl.saveAll(cobrosValoresList);
				}
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se guardo correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
			}

			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", System.err);
			e.printStackTrace(System.err);

			Throwable cause = e.getCause();
			while (cause != null) {
				if (cause instanceof ConstraintViolationException) {
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "El DEPOSITO ya fue creado.");
					break;
				}
				cause = cause.getCause();
			}

			if (cause == null) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
						e.getMessage().substring(0, e.getMessage().length()) + "...");
			}

			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		}

	}

	public void delete() {
		try {
			if (!Objects.isNull(this.tesDeposito)) {
				this.tesDepositoServiceImpl.deleteById(this.tesDeposito.getId());
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se elimino correctamente.");

			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", System.err);
			e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");
		}

	}

}