package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.movimientos;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.event.SelectEvent;
import org.primefaces.event.UnselectEvent;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.entities.base.*;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.entities.compras.ComProveedor;
import py.com.capital.CapitaCreditos.entities.creditos.CreDesembolsoCabecera;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesPagoCabecera;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesPagoComprobanteDetalle;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesPagoValores;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.UtilsService;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;
import py.com.capital.CapitaCreditos.services.base.BsTipoValorService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobClienteService;
import py.com.capital.CapitaCreditos.services.compras.ComProveedorService;
import py.com.capital.CapitaCreditos.services.creditos.CreDesembolsoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesPagoService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;

import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/*
* 22 ene. 2024 - Elitebook
*/
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class TesPagoController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(TesPagoController.class);

	// PROPIOS
	private TesPagoCabecera tesPagoCabecera, tesPagoCabeceraSelected;
	private TesPagoComprobanteDetalle tesPagoComprobanteDetalleSelected;
	private List<TesPagoComprobanteDetalle> tesPagoComprobanteDetallesList;
	private TesPagoValores tesPagoValoresSelected;
	private List<TesPagoValores> tesPagoValoresList;
	private List<CreDesembolsoCabecera> desembolsoList;

	// FKs
	private BsTalonario bsTalonarioSelected;
	private CobCliente cobClienteSelected;
	private ComProveedor comProveedorSelected;

	// LAZY
	private LazyDataModel<TesPagoCabecera> lazyModel;
	private List<CreDesembolsoCabecera> lazyModelDesembolso;
	private LazyDataModel<BsTalonario> lazyModelTalonario;
	private LazyDataModel<CobCliente> lazyModelCliente;
	private LazyDataModel<ComProveedor> lazyModelProveedor;
	private LazyDataModel<BsTipoValor> lazyModelTipoValor;
	private LazyDataModel<TesBanco> lazyModelBanco;

	private List<String> estadoList;
	private boolean esNuegoRegistro;
	private boolean esVisibleFormulario = true;
	private boolean estaAutorizado;
	public BigDecimal montoTotalPago = BigDecimal.ZERO;
	public BigDecimal montoTotalPagoValores = BigDecimal.ZERO;
	private String tipoSaldoAFiltrar;
	private ParametrosReporte parametrosReporte;

	private static final String DT_NAME = "dt-pagos";

	// services
	@Autowired
	private TesPagoService tesPagoServiceImpl;

	@Autowired
	private CreDesembolsoService creDesembolsoServiceImpl;

	@Autowired
	private BsModuloService bsModuloServiceImpl;

	@Autowired
	private CobClienteService cobClienteServiceImpl;

	@Autowired
	private BsTipoValorService bsTipoValorServiceImpl;

	@Autowired
	private ComProveedorService comProveedorServiceImpl;

	@Autowired
	private TesBancoService tesBancoServiceImpl;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	private boolean puedeCrear, puedeEditar, puedeEliminar = false;
	@Autowired
	private SessionBean sessionBean;

	@Autowired
	private CommonsUtilitiesController commonsUtilitiesController;
	
	@Autowired
	private UtilsService utilsService;

	@Autowired
	private GenerarReporte generarReporte;

	@PostConstruct
	public void init() {
		this.cleanFields();
		this.sessionBean.cargarPermisos();
		puedeCrear = sessionBean.tienePermiso(getPaginaActual(), "CREAR");
		puedeEditar = sessionBean.tienePermiso(getPaginaActual(), "EDITAR");
		puedeEliminar = sessionBean.tienePermiso(getPaginaActual(), "ELIMINAR");
	}

	public void cleanFields() {
		// objetos
		this.tesPagoCabecera = null;
		this.tesPagoCabeceraSelected = null;
		this.tesPagoComprobanteDetalleSelected = null;
		this.tesPagoValoresSelected = null;
		this.bsTalonarioSelected = null;
		this.cobClienteSelected = null;
		this.comProveedorSelected = null;
		this.desembolsoList = null;

		// lazy
		this.lazyModel = null;
		this.lazyModelDesembolso = null;
		this.lazyModelTalonario = null;
		this.lazyModelCliente = null;
		this.lazyModelProveedor = null;
		this.lazyModelTipoValor = null;
		this.lazyModelBanco = null;

		this.esNuegoRegistro = true;
		this.estaAutorizado = false;
		this.esVisibleFormulario = !esVisibleFormulario;
		this.tipoSaldoAFiltrar = "";

		// listas
		tesPagoComprobanteDetallesList = new ArrayList<>();
		tesPagoValoresList = new ArrayList<>();
		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado(), "ANULADO");

	}

	// GETTERS Y SETTERS
	public TesPagoCabecera getTesPagoCabecera() {
		if (Objects.isNull(tesPagoCabecera)) {
			tesPagoCabecera = new TesPagoCabecera();
			tesPagoCabecera.setFechaPago(LocalDate.now());
			tesPagoCabecera.setTipoOperacion("FACTURA");
			tesPagoCabecera.setEstado(Estado.ACTIVO.getEstado());
			tesPagoCabecera.setIndAutorizado("N");
			tesPagoCabecera.setBsEmpresa(new BsEmpresa());
			tesPagoCabecera.setCobHabilitacionCaja(new CobHabilitacionCaja());
			tesPagoCabecera.setBsTalonario(new BsTalonario());
			tesPagoCabecera.getBsTalonario().setBsTipoComprobante(new BsTipoComprobante());
			if (!this.commonsUtilitiesController.validarSiTengaHabilitacionAbierta()) {
				this.tesPagoCabecera.setCobHabilitacionCaja(this.commonsUtilitiesController.getHabilitacionAbierta());
			} else {
				validarCajaDelUsuario(true);
			}

		}
		return tesPagoCabecera;
	}

	public void setTesPagoCabecera(TesPagoCabecera tesPagoCabecera) {
		this.tesPagoCabecera = tesPagoCabecera;
	}

	public TesPagoCabecera getTesPagoCabeceraSelected() {
		if (Objects.isNull(tesPagoCabeceraSelected)) {
			tesPagoCabeceraSelected = new TesPagoCabecera();
			tesPagoCabeceraSelected.setFechaPago(LocalDate.now());
			tesPagoCabeceraSelected.setEstado(Estado.ACTIVO.getEstado());
			tesPagoCabeceraSelected.setIndAutorizado("N");
			tesPagoCabeceraSelected.setBsEmpresa(new BsEmpresa());
			tesPagoCabeceraSelected.setCobHabilitacionCaja(new CobHabilitacionCaja());
			tesPagoCabeceraSelected.setBsTalonario(new BsTalonario());
			tesPagoCabeceraSelected.getBsTalonario().setBsTipoComprobante(new BsTipoComprobante());
			if (!this.commonsUtilitiesController.validarSiTengaHabilitacionAbierta()) {
				this.tesPagoCabecera.setCobHabilitacionCaja(this.commonsUtilitiesController.getHabilitacionAbierta());
			} else {
				validarCajaDelUsuario(true);
			}

		}
		return tesPagoCabeceraSelected;
	}

	public void setTesPagoCabeceraSelected(TesPagoCabecera tesPagoCabeceraSelected) {
		if (!Objects.isNull(tesPagoCabeceraSelected)) {

			tesPagoCabeceraSelected.getTesPagoComprobanteDetallesList()
					.sort(Comparator.comparing(TesPagoComprobanteDetalle::getNroOrden));
			tesPagoCabeceraSelected.getTesPagoValoresList().sort(Comparator.comparing(TesPagoValores::getNroOrden));

			this.estaAutorizado = tesPagoCabeceraSelected.getIndAutorizado().equalsIgnoreCase("S");
			if (this.estaAutorizado) {
				/*
				 * this.tesPagoValoresList =
				 * this.cobCobrosValoresServiceImpl.buscarValoresPorComprobanteLista(
				 * this.commonsUtilitiesController.getIdEmpresaLogueada(),
				 * cobReciboCabeceraSelected.getId(), "RECIBO");
				 */
				this.montoTotalPago = BigDecimal.ZERO;/*
														 * tesPagoValoresList.stream().map(CobCobrosValores::
														 * getMontoValor) .reduce(BigDecimal.ZERO, BigDecimal::add);
														 */
				// getResultadoResta();
			}
			this.tesPagoComprobanteDetallesList = tesPagoCabeceraSelected.getTesPagoComprobanteDetallesList();
			this.tesPagoValoresList = tesPagoCabeceraSelected.getTesPagoValoresList();
			this.montoTotalPago = tesPagoCabeceraSelected.getMontoTotalPago();
			this.montoTotalPagoValores = tesPagoCabeceraSelected.getMontoTotalPago();
			tesPagoCabecera = tesPagoCabeceraSelected; 
			tesPagoCabeceraSelected = null;
			this.esNuegoRegistro = false;
			this.esVisibleFormulario = true;
		}
		this.tesPagoCabeceraSelected = tesPagoCabeceraSelected;
	}

	public TesPagoComprobanteDetalle getTesPagoComprobanteDetalleSelected() {
		if (Objects.isNull(tesPagoComprobanteDetalleSelected)) {
			tesPagoComprobanteDetalleSelected = new TesPagoComprobanteDetalle();
			tesPagoComprobanteDetalleSelected.setMontoPagado(BigDecimal.ZERO);
			tesPagoComprobanteDetalleSelected.setTesPagoCabecera(new TesPagoCabecera());
		}
		return tesPagoComprobanteDetalleSelected;
	}

	public void setTesPagoComprobanteDetalleSelected(TesPagoComprobanteDetalle tesPagoComprobanteDetalleSelected) {
		this.tesPagoComprobanteDetalleSelected = tesPagoComprobanteDetalleSelected;
	}

	public TesPagoValores getTesPagoValoresSelected() {
		if (Objects.isNull(tesPagoValoresSelected)) {
			tesPagoValoresSelected = new TesPagoValores();
			tesPagoValoresSelected.setFechaValor(LocalDate.now());
			tesPagoValoresSelected.setFechaVencimiento(LocalDate.now());
			tesPagoValoresSelected.setTesBanco(new TesBanco());
			tesPagoValoresSelected.getTesBanco().setBsPersona(new BsPersona());
			tesPagoValoresSelected.setIndEntregadoBoolean(false);
			tesPagoValoresSelected.setNroValor("0");
			tesPagoValoresSelected.setMontoValor(BigDecimal.ZERO);
			tesPagoValoresSelected.setBsEmpresa(new BsEmpresa());
			tesPagoValoresSelected.setBsTipoValor(new BsTipoValor());
			tesPagoValoresSelected.setTesPagoCabecera(new TesPagoCabecera());
		}
		return tesPagoValoresSelected;
	}

	public void setTesPagoValoresSelected(TesPagoValores tesPagoValoresSelected) {
		this.tesPagoValoresSelected = tesPagoValoresSelected;
	}

	public BsTalonario getBsTalonarioSelected() {
		if (Objects.isNull(bsTalonarioSelected)) {
			this.bsTalonarioSelected = new BsTalonario();
			this.bsTalonarioSelected.setEstado(Estado.ACTIVO.getEstado());
			this.bsTalonarioSelected.setBsTimbrado(new BsTimbrado());
			this.bsTalonarioSelected.setBsTipoComprobante(new BsTipoComprobante());
		}
		return bsTalonarioSelected;
	}

	public void setBsTalonarioSelected(BsTalonario bsTalonarioSelected) {
		if (!Objects.isNull(bsTalonarioSelected)) {
			this.tesPagoCabecera.setBsTalonario(bsTalonarioSelected);
			bsTalonarioSelected = null;
		}
		this.bsTalonarioSelected = bsTalonarioSelected;
	}

	public CobCliente getCobClienteSelected() {
		if (Objects.isNull(cobClienteSelected)) {
			this.cobClienteSelected = new CobCliente();
			this.cobClienteSelected.setBsEmpresa(new BsEmpresa());
			this.cobClienteSelected.setBsPersona(new BsPersona());
		}
		return cobClienteSelected;
	}

	public void setCobClienteSelected(CobCliente cobClienteSelected) {
		if (!Objects.isNull(cobClienteSelected)) {
			this.tesPagoCabecera.setBeneficiario(cobClienteSelected.getBsPersona().getNombreCompleto());
			this.tesPagoCabecera.setIdBeneficiario(cobClienteSelected.getId());
			this.cobClienteSelected = cobClienteSelected;
			lazyModelDesembolso = null;
			getLazyModelDesembolso();
			PrimeFaces.current().ajax().update(":form:manageComprobante", ":form:dt-desembolso",
					":form:dt-comprobantes");
			// cobClienteSelected = null;
		}
		this.cobClienteSelected = cobClienteSelected;
	}

	public ComProveedor getComProveedorSelected() {
		if (Objects.isNull(comProveedorSelected)) {
			this.comProveedorSelected = new ComProveedor();
			this.comProveedorSelected.setBsEmpresa(new BsEmpresa());
			this.comProveedorSelected.setBsPersona(new BsPersona());
		}
		return comProveedorSelected;
	}

	public void setComProveedorSelected(ComProveedor comProveedorSelected) {
		if (!Objects.isNull(cobClienteSelected)) {
			this.tesPagoCabecera.setBeneficiario(comProveedorSelected.getBsPersona().getNombreCompleto());
			this.tesPagoCabecera.setIdBeneficiario(comProveedorSelected.getId());
			this.comProveedorSelected = comProveedorSelected;
			// TODO: aqui recargar los saldos proveedores
			// lazyModelDesembolso = null;
			// getLazyModelDesembolso();
			PrimeFaces.current().ajax().update(":form:manageComprobante", ":form:dt-desembolso",
					":form:dt-comprobantes");

		}
		this.comProveedorSelected = comProveedorSelected;
	}

	public List<TesPagoComprobanteDetalle> getTesPagoComprobanteDetallesList() {
		return tesPagoComprobanteDetallesList;
	}

	public void setTesPagoComprobanteDetallesList(List<TesPagoComprobanteDetalle> tesPagoComprobanteDetallesList) {
		this.tesPagoComprobanteDetallesList = tesPagoComprobanteDetallesList;
	}

	public List<TesPagoValores> getTesPagoValoresList() {
		return tesPagoValoresList;
	}

	public void setTesPagoValoresList(List<TesPagoValores> tesPagoValoresList) {
		this.tesPagoValoresList = tesPagoValoresList;
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

	public boolean isEstaAutorizado() {
		return estaAutorizado;
	}

	public void setEstaAutorizado(boolean estaAutorizado) {
		this.estaAutorizado = estaAutorizado;
	}

	public BigDecimal getMontoTotalPago() {
		return montoTotalPago;
	}

	public void setMontoTotalPago(BigDecimal montoTotalPago) {
		this.montoTotalPago = montoTotalPago;
	}

	public BigDecimal getMontoTotalPagoValores() {
		return montoTotalPagoValores;
	}

	public void setMontoTotalPagoValores(BigDecimal montoTotalPagoValores) {
		this.montoTotalPagoValores = montoTotalPagoValores;
	}

	public TesBancoService getTesBancoServiceImpl() {
		return tesBancoServiceImpl;
	}

	public void setTesBancoServiceImpl(TesBancoService tesBancoServiceImpl) {
		this.tesBancoServiceImpl = tesBancoServiceImpl;
	}

	public String getTipoSaldoAFiltrar() {
		return tipoSaldoAFiltrar;
	}

	public void setTipoSaldoAFiltrar(String tipoSaldoAFiltrar) {
		if (!StringUtils.isAllBlank(tipoSaldoAFiltrar)) {
			this.tesPagoCabecera.setTipoOperacion(tipoSaldoAFiltrar);
			// lazyModelDesembolso = null;
			// getLazyModelDesembolso();
			// TODO:aca debo implementar cuando es proveedor traer saldos de compras
			// PrimeFaces.current().ajax().update(":form:manageComprobante",
			// ":form:dt-comprobantes");
		}
		this.tipoSaldoAFiltrar = tipoSaldoAFiltrar;
	}

	public List<CreDesembolsoCabecera> getDesembolsoList() {
		return desembolsoList;
	}

	public void setDesembolsoList(List<CreDesembolsoCabecera> desembolsoList) {
		this.desembolsoList = desembolsoList;
	}
	
	public ParametrosReporte getParametrosReporte() {
		if (Objects.isNull(parametrosReporte)) {
			parametrosReporte = new ParametrosReporte();
			parametrosReporte.setCodModulo(Modulos.CREDITOS.getModulo());
			parametrosReporte.setFormato("PDF");
		}
		return parametrosReporte;
	}

	public void setParametrosReporte(ParametrosReporte parametrosReporte) {
		this.parametrosReporte = parametrosReporte;
	}

	public boolean isPuedeCrear() {
		return puedeCrear;
	}

	public void setPuedeCrear(boolean puedeCrear) {
		this.puedeCrear = puedeCrear;
	}

	public boolean isPuedeEditar() {
		return puedeEditar;
	}

	public void setPuedeEditar(boolean puedeEditar) {
		this.puedeEditar = puedeEditar;
	}

	public boolean isPuedeEliminar() {
		return puedeEliminar;
	}

	public void setPuedeEliminar(boolean puedeEliminar) {
		this.puedeEliminar = puedeEliminar;
	}

	// LAZY
	public LazyDataModel<TesPagoCabecera> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<TesPagoCabecera>(this.tesPagoServiceImpl
					.buscarTesPagoCabeceraActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<TesPagoCabecera> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public List<CreDesembolsoCabecera> getLazyModelDesembolso() {
		if (Objects.isNull(lazyModelDesembolso)) {
			List<CreDesembolsoCabecera> listaFiltrada = new ArrayList<CreDesembolsoCabecera>();
			if (!Objects.isNull(this.cobClienteSelected)) {
				if (!Objects.isNull(this.cobClienteSelected.getId())) {
					listaFiltrada = (List<CreDesembolsoCabecera>) creDesembolsoServiceImpl
							.buscarCreDesembolsoParaPagosTesoreriarLista(
									this.commonsUtilitiesController.getIdEmpresaLogueada(),
									this.cobClienteSelected.getId());
				}
			} else {
				listaFiltrada = creDesembolsoServiceImpl.buscarCreDesembolsoCabeceraActivosLista(
						this.commonsUtilitiesController.getIdEmpresaLogueada());
			}
			lazyModelDesembolso = listaFiltrada;
		}
		return lazyModelDesembolso;
	}

	public void setLazyModelDesembolso(List<CreDesembolsoCabecera> lazyModelDesembolso) {
		this.lazyModelDesembolso = lazyModelDesembolso;
	}

	public LazyDataModel<BsTalonario> getLazyModelTalonario() {
		if (Objects.isNull(lazyModelTalonario)) {
			var moduloCredito = this.bsModuloServiceImpl.findByCodigo(Modulos.TESORERIA.getModulo());
			lazyModelTalonario = new GenericLazyDataModel<BsTalonario>(
					this.commonsUtilitiesController.bsTalonarioPorModuloLista(
							this.commonsUtilitiesController.getIdEmpresaLogueada(), moduloCredito.getId()));

		}
		return lazyModelTalonario;
	}

	public void setLazyModelTalonario(LazyDataModel<BsTalonario> lazyModelTalonario) {
		this.lazyModelTalonario = lazyModelTalonario;
	}

	public LazyDataModel<CobCliente> getLazyModelCliente() {
		if (Objects.isNull(lazyModelCliente)) {
			lazyModelCliente = new GenericLazyDataModel<CobCliente>((List<CobCliente>) cobClienteServiceImpl
					.buscarClienteActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModelCliente;
	}

	public void setLazyModelCliente(LazyDataModel<CobCliente> lazyModelCliente) {
		this.lazyModelCliente = lazyModelCliente;
	}

	public LazyDataModel<ComProveedor> getLazyModelProveedor() {
		if (Objects.isNull(lazyModelProveedor)) {
			lazyModelProveedor = new GenericLazyDataModel<ComProveedor>((List<ComProveedor>) comProveedorServiceImpl
					.buscarComProveedorActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModelProveedor;
	}

	public void setLazyModelProveedor(LazyDataModel<ComProveedor> lazyModelProveedor) {
		this.lazyModelProveedor = lazyModelProveedor;
	}

	public LazyDataModel<BsTipoValor> getLazyModelTipoValor() {
		if (Objects.isNull(lazyModelTipoValor)) {
			lazyModelTipoValor = new GenericLazyDataModel<BsTipoValor>((List<BsTipoValor>) bsTipoValorServiceImpl
					.buscarTipoValorActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()).stream()
					.filter(tipo -> tipo.getBsModulo().getCodigo().equalsIgnoreCase(Modulos.COBRANZAS.getModulo()))
					.collect(Collectors.toList()));
		}
		return lazyModelTipoValor;
	}

	public void setLazyModelTipoValor(LazyDataModel<BsTipoValor> lazyModelTipoValor) {
		this.lazyModelTipoValor = lazyModelTipoValor;
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

	// SERVICES
	public TesPagoService getTesPagoServiceImpl() {
		return tesPagoServiceImpl;
	}

	public void setTesPagoServiceImpl(TesPagoService tesPagoServiceImpl) {
		this.tesPagoServiceImpl = tesPagoServiceImpl;
	}

	public CreDesembolsoService getCreDesembolsoServiceImpl() {
		return creDesembolsoServiceImpl;
	}

	public void setCreDesembolsoServiceImpl(CreDesembolsoService creDesembolsoServiceImpl) {
		this.creDesembolsoServiceImpl = creDesembolsoServiceImpl;
	}

	public BsModuloService getBsModuloServiceImpl() {
		return bsModuloServiceImpl;
	}

	public void setBsModuloServiceImpl(BsModuloService bsModuloServiceImpl) {
		this.bsModuloServiceImpl = bsModuloServiceImpl;
	}

	public CobClienteService getCobClienteServiceImpl() {
		return cobClienteServiceImpl;
	}

	public void setCobClienteServiceImpl(CobClienteService cobClienteServiceImpl) {
		this.cobClienteServiceImpl = cobClienteServiceImpl;
	}

	public BsTipoValorService getBsTipoValorServiceImpl() {
		return bsTipoValorServiceImpl;
	}

	public void setBsTipoValorServiceImpl(BsTipoValorService bsTipoValorServiceImpl) {
		this.bsTipoValorServiceImpl = bsTipoValorServiceImpl;
	}

	public ComProveedorService getComProveedorServiceImpl() {
		return comProveedorServiceImpl;
	}

	public void setComProveedorServiceImpl(ComProveedorService comProveedorServiceImpl) {
		this.comProveedorServiceImpl = comProveedorServiceImpl;
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

	public UtilsService getUtilsService() {
		return utilsService;
	}

	public void setUtilsService(UtilsService utilsService) {
		this.utilsService = utilsService;
	}

	public GenerarReporte getGenerarReporte() {
		return generarReporte;
	}

	public void setGenerarReporte(GenerarReporte generarReporte) {
		this.generarReporte = generarReporte;
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
			LOGGER.error("Ocurrio un error al Guardar", e);
		}
	}

	public void onRowSelect(SelectEvent<CreDesembolsoCabecera> event) {
		CreDesembolsoCabecera desembolso = event.getObject();
		if (desembolso != null) {
			formatearDesembolsoAcomprobanteDetalle();
		}
	}

	public void onRowUnselect(UnselectEvent<CreDesembolsoCabecera> event) {
		CreDesembolsoCabecera desembolso = event.getObject();
		if (desembolso != null) {
			formatearDesembolsoAcomprobanteDetalle();
		}
	}

	public void calcularTotalesDetalle() {
		this.montoTotalPago = BigDecimal.ZERO;
		tesPagoCabecera.setMontoTotalPago(BigDecimal.ZERO);
		this.tesPagoComprobanteDetallesList.forEach(valor -> {
			montoTotalPago = montoTotalPago.add(valor.getMontoPagado());
		});
		tesPagoCabecera.setMontoTotalPago(montoTotalPago);

	}

	public void formatearDesembolsoAcomprobanteDetalle() {
		this.tesPagoComprobanteDetallesList = new ArrayList<>();
		// TODO:para acceder al indice
		IntStream.range(0, desembolsoList.size()).forEach(i -> {
			CreDesembolsoCabecera desembolso = desembolsoList.get(i);

			TesPagoComprobanteDetalle detalle = new TesPagoComprobanteDetalle();
			detalle.setIdCuotaSaldo(desembolso.getId());
			detalle.setMontoPagado(desembolso.getMontoTotalCapital());
			detalle.setNroOrden(i + 1); // Si deseas empezar desde 1
			detalle.setTipoComprobante("DESEMBOLSO");

			tesPagoComprobanteDetallesList.add(detalle);
		});
		this.calcularTotalesDetalle();
		PrimeFaces.current().ajax().update(":form:dt-comprobantes", ":form:btnGuardar", ":form:btnAddComprobante");
	}

	public void limpiarDetalleComprobantes() {
		this.tesPagoComprobanteDetallesList = new ArrayList<>();
		this.montoTotalPago = BigDecimal.ZERO;
		PrimeFaces.current().ajax().update(":form:dt-comprobantes", ":form:btnGuardar", ":form:btnAddComprobante",
				":form:dt-valores");
	}

	public void addValorDetalle() {
		if (!Objects.isNull(tesPagoValoresSelected)) {
			tesPagoValoresSelected.setBsEmpresa(this.sessionBean.getUsuarioLogueado().getBsEmpresa());
			tesPagoValoresSelected.setTipoOperacion(this.tesPagoCabecera.getTipoOperacion());
			Optional<TesPagoValores> existente = this.tesPagoValoresList.stream().filter(det -> {
				return det.getBsTipoValor().getId() == this.tesPagoValoresSelected.getBsTipoValor().getId()
						&& det.getNroValor() == this.tesPagoValoresSelected.getNroValor();
			}).findFirst();
			if (!existente.isPresent()) {
				if (CollectionUtils.isEmpty(this.tesPagoValoresList)) {
					tesPagoValoresSelected.setNroOrden(1);
				} else {
					Optional<Integer> maxNroOrden = this.tesPagoValoresList.stream().map(TesPagoValores::getNroOrden)
							.max(Integer::compareTo);
					if (maxNroOrden.isPresent()) {
						tesPagoValoresSelected.setNroOrden(maxNroOrden.get() + 1);
					} else {
						tesPagoValoresSelected.setNroOrden(1);
					}
				}
				this.tesPagoValoresList.add(tesPagoValoresSelected);
			} else {
				tesPagoValoresSelected.setNroOrden(existente.get().getNroOrden());
				int indice = this.tesPagoValoresList.indexOf(existente.get());
				this.tesPagoValoresList.set(indice, tesPagoValoresSelected);
			}
			this.montoTotalPagoValores = montoTotalPagoValores.add(tesPagoValoresSelected.getMontoValor());
			tesPagoValoresSelected = null;
			getTesPagoValoresSelected();
		} else {
			tesPagoValoresSelected = null;
			getTesPagoValoresSelected();
		}

		PrimeFaces.current().ajax().update("form:messages", "dt-valores", ":form:managePagoValor");
	}

	public void limpiarDetalleValores() {
		this.montoTotalPagoValores = BigDecimal.ZERO;
		this.tesPagoValoresList = new ArrayList<>();
		PrimeFaces.current().ajax().update("form:messages", "dt-valores");
	}

	public void guardar() {

		try {
			if (this.montoTotalPagoValores.compareTo(this.montoTotalPago) != 0) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
						"El monto en valores y en comprobantes debe coincidir.");
				return;
			}
			if (Objects.isNull(this.tesPagoCabecera.getBsTalonario())
					|| Objects.isNull(this.tesPagoCabecera.getBsTalonario().getId())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un Talonario.");
				return;
			}
			this.tesPagoCabecera.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			this.tesPagoCabecera.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
			if (CollectionUtils.isNotEmpty(tesPagoComprobanteDetallesList) && tesPagoComprobanteDetallesList.size() > 0
					|| CollectionUtils.isNotEmpty(tesPagoValoresList) && tesPagoValoresList.size() > 0) {
				this.tesPagoCabecera.getTesPagoComprobanteDetallesList().addAll(tesPagoComprobanteDetallesList);
				this.tesPagoCabecera.getTesPagoValoresList().addAll(tesPagoValoresList);
				this.tesPagoCabecera.setCabeceraADetalle();
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
						"Debe cargar comprobantes y valores.");
				return;
			}

			if (Objects.isNull(this.tesPagoCabecera.getId())) {
				try {
					this.tesPagoCabecera.setNroPago(this.tesPagoServiceImpl.calcularNroPagoDisponible(
							commonsUtilitiesController.getIdEmpresaLogueada(),
							this.tesPagoCabecera.getBsTalonario().getId()));
					String formato = "%s-%s-%09d";
					this.tesPagoCabecera.setNroPagoCompleto(String.format(formato,
							this.tesPagoCabecera.getBsTalonario().getBsTimbrado().getCodEstablecimiento(),
							this.tesPagoCabecera.getBsTalonario().getBsTimbrado().getCodExpedicion(),
							this.tesPagoCabecera.getNroPago()));

				} catch (Exception e) {
					LOGGER.error("Ocurrio un error al obtener la habilitacion. O calcular el nroPago disponible.",
							System.err);
					e.printStackTrace(System.err);
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
							e.getMessage().substring(0, e.getMessage().length()) + "...");
				}

			}
			if (!Objects.isNull(this.tesPagoServiceImpl.save(tesPagoCabecera))) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se guardo correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", e);
			// e.printStackTrace(System.err);
			String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);

			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		}
	}

	public void delete() {
		try {
			if (Objects.isNull(this.tesPagoCabecera.isIndImpresoBoolean())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Ya fue Impreso.");
				return;
			}
			if (Objects.isNull(this.tesPagoCabecera.isIndAutorizadoBoolean())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Ya fue Autorizado.");
				return;
			}
			if (!Objects.isNull(this.tesPagoCabecera)) {
				this.tesPagoServiceImpl.deleteById(this.tesPagoCabecera.getId());
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se elimino correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al eliminar", e);
			// e.printStackTrace(System.err);
			String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		}
	}
	
	public void imprimir(String tipo) {
		try {
			this.parametrosReporte = null;
			getParametrosReporte();
			this.prepareParams();
			if(StringUtils.equalsAny(tipo, "PAGARE")) {
				this.parametrosReporte.setReporte("CrePagare");
				// key
				this.parametrosReporte.getParametros().add("p_nombre");
				this.parametrosReporte.getParametros().add("p_documento");
				this.parametrosReporte.getParametros().add("p_monto");
				this.parametrosReporte.getParametros().add("p_vencimiento");
				this.parametrosReporte.getParametros().add("p_fecha");
				this.parametrosReporte.getParametros().add("p_cant_cuota");
				this.parametrosReporte.getParametros().add("p_monto_cuota");

				// values
				this.parametrosReporte.getValores().add(this.tesPagoCabecera.getBeneficiario());
				this.parametrosReporte.getValores().add("documento aqui");
				this.parametrosReporte.getValores().add(String.valueOf(this.tesPagoCabecera.getMontoTotalPago()));
				this.parametrosReporte.getValores().add("vencimiento aqui");
				this.parametrosReporte.getValores().add("fecha aqui");
				this.parametrosReporte.getValores().add("cantidad_cuota aqui");
				this.parametrosReporte.getValores().add("monto de cuota aqui");
				//TODO: aca restrinjo el registro si es pagare
				if (this.utilsService.actualizarRegistro("tes_pagos_cabecera", "ind_impreso = 'S'",
						" bs_empresa_id = " + commonsUtilitiesController.getIdEmpresaLogueada() + " and id = "	+ this.tesPagoCabecera.getId())) {
				} else {
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡CUIDADO!",
							"No se pudo actualizar el registro.");
					return;
				}
			}else {
				this.parametrosReporte.setReporte("CreContrato");
				// key
				this.parametrosReporte.getParametros().add("p_nombre");
				this.parametrosReporte.getParametros().add("p_documento");
				this.parametrosReporte.getParametros().add("p_monto");
				
				// values
				this.parametrosReporte.getValores().add(this.tesPagoCabecera.getBeneficiario());
				this.parametrosReporte.getValores().add("documento aqui");
				this.parametrosReporte.getValores().add(String.valueOf(this.tesPagoCabecera.getMontoTotalPago()));
				
			}
			if (!(Objects.isNull(parametrosReporte) && Objects.isNull(parametrosReporte.getFormato()))
					&& CollectionUtils.isNotEmpty(this.parametrosReporte.getParametros())
					&& CollectionUtils.isNotEmpty(this.parametrosReporte.getValores())) {
				this.generarReporte.procesarReporte(parametrosReporte);
				
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡CUIDADO!",
						"Debes seccionar los parametros validos.");
				return;
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update(":form");
			
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", e);
			// e.printStackTrace(System.err);
			String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);
			PrimeFaces.current().ajax().update(":form");

		}
	}
	
	/*
	 * Recordar que el orden en la que se agregan los valores en las listas SI
	 * importan ya que en el backend se procesa como llave valor y va ir pareando en
	 * el mismo orden
	 */
	private void prepareParams() {
		// basicos
		// Obtener la fecha y hora actual
		LocalDateTime now = LocalDateTime.now();

		DateTimeFormatter formatterDiaHora = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
		String formattedDateTimeDiaHora = now.format(formatterDiaHora);
		this.parametrosReporte.getParametros().add(ApplicationConstant.REPORT_PARAM_IMAGEN_PATH);
		this.parametrosReporte.getParametros().add(ApplicationConstant.REPORT_PARAM_NOMBRE_IMAGEN);
		this.parametrosReporte.getParametros().add(ApplicationConstant.REPORT_PARAM_IMPRESO_POR);
		this.parametrosReporte.getParametros().add(ApplicationConstant.REPORT_PARAM_DIA_HORA);
		this.parametrosReporte.getParametros().add(ApplicationConstant.REPORT_PARAM_DESC_EMPRESA);

		this.parametrosReporte.getValores().add(ApplicationConstant.PATH_IMAGEN_EMPRESA);
		this.parametrosReporte.getValores().add(ApplicationConstant.IMAGEN_EMPRESA_NAME);
		this.parametrosReporte.getValores()
				.add(this.sessionBean.getUsuarioLogueado().getBsPersona().getNombreCompleto());
		this.parametrosReporte.getValores().add(formattedDateTimeDiaHora);
		this.parametrosReporte.getValores()
				.add(this.sessionBean.getUsuarioLogueado().getBsEmpresa().getNombreFantasia());
		// basico

		DateTimeFormatter formatToDateParam = DateTimeFormatter.ofPattern("dd/MM/yyy");
		

	}

	public String getPaginaActual() {
		FacesContext facesContext = FacesContext.getCurrentInstance();
		if (facesContext != null) {
			HttpServletRequest request = (HttpServletRequest) facesContext.getExternalContext().getRequest();
			String uri = request.getRequestURI();
			String pagina = uri.substring(uri.lastIndexOf("/") + 1);
			return pagina;
		}
		return null;
	}
	
	
}
