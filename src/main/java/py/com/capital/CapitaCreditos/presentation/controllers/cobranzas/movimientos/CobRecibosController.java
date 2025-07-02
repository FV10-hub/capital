package py.com.capital.CapitaCreditos.presentation.controllers.cobranzas.movimientos;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.entities.base.*;
import py.com.capital.CapitaCreditos.entities.cobranzas.*;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.UtilsService;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;
import py.com.capital.CapitaCreditos.services.base.BsParametroService;
import py.com.capital.CapitaCreditos.services.base.BsTipoValorService;
import py.com.capital.CapitaCreditos.services.cobranzas.*;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.view.ViewScoped;
import javax.inject.Named;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

/*
* 4 ene. 2024 - Elitebook
*/
@Named
@ViewScoped
public class CobRecibosController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(CobRecibosController.class);

	/*
	 * TODO: en el repositorio tengo implementado metodos para busqueda rapida por
	 * cobrador y cliente eso debo implementar en el caso de tener muchos registros
	 * en recibos
	 */

	private CobReciboCabecera cobReciboCabecera, cobReciboCabeceraSelected;
	private BsTalonario bsTalonarioSelected;
	private CobSaldo cobSaldoSelected;
	private CobHabilitacionCaja cobHabilitacionCaja;
	private CobCaja cobCajaSelected;
	private CobCliente cobClienteSelected;
	private CobReciboDetalle detalle;
	private CobCobrosValores cobCobrosValoresSelected;
	private LazyDataModel<CobReciboCabecera> lazyModel;
	private LazyDataModel<CobHabilitacionCaja> lazyModelHabilitacion;
	private LazyDataModel<CobSaldo> lazyModelSaldos;
	private LazyDataModel<BsTalonario> lazyModelTalonario;
	private LazyDataModel<CobCliente> lazyModelCliente;
	private LazyDataModel<CobCobrador> lazyModelCobCobrador;
	private LazyDataModel<BsTipoValor> lazyModelTipoValor;
	
	private List<CobCobrosValores> cobrosValoresList;
	public BigDecimal montoTotalCobro = BigDecimal.ZERO;
	private ParametrosReporte parametrosReporte;

	private List<String> estadoList;
	private boolean esNuegoRegistro;
	private boolean esVisibleFormulario = true;
	private boolean tieneHabilitacionAbiertaRendered;
	private boolean estaCobrado;
	private String tipoSaldoAFiltrar;

	private static final String DT_NAME = "dt-recibos";

	// services
	@Autowired
	private CobRecibosService cobRecibosServiceImpl;

	@Autowired
	private CobClienteService cobClienteServiceImpl;

	@Autowired
	private CobCobradorService cobCobradorServiceImpl;

	@Autowired
	private CobHabilitacionCajaService cobHabilitacionCajaServiceImpl;

	@Autowired
	private CobCajaService cobCajaServiceImpl;

	@Autowired
	private BsParametroService bsParametroServiceImpl;

	@Autowired
	private BsModuloService bsModuloServiceImpl;

	@Autowired
	private CobSaldoService cobSaldoServiceImpl;
	
	@Autowired
	private CobCobrosValoresService cobCobrosValoresServiceImpl;

	@Autowired
	private BsTipoValorService bsTipoValorServiceImpl;

	// CobSaldoServiceImpl

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
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

	}

	public void cleanFields() {
		this.cobCajaSelected = this.cobCajaServiceImpl.usuarioTieneCaja(this.sessionBean.getUsuarioLogueado().getId());
		if (!Objects.isNull(this.cobCajaSelected)) {
			this.validarHabilitacion();
		}
		this.cobReciboCabecera = null;
		this.cobReciboCabeceraSelected = null;
		this.bsTalonarioSelected = null;
		this.cobSaldoSelected = null;
		this.detalle = null;
		this.cobHabilitacionCaja = null;
		this.cobClienteSelected = null;
		this.cobCobrosValoresSelected = null;
		

		this.lazyModel = null;
		this.lazyModelHabilitacion = null;
		this.lazyModelSaldos = null;
		this.lazyModelTalonario = null;
		this.lazyModelCliente = null;
		this.lazyModelCobCobrador = null;
		this.lazyModelTipoValor = null;

		this.estaCobrado = false;
		this.esNuegoRegistro = true;
		this.esVisibleFormulario = !esVisibleFormulario;
		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado(), "ANULADO");
		this.cobrosValoresList = new ArrayList<>();
		this.tipoSaldoAFiltrar = "";
		
	}

	// GETTERS Y SETTERS
	public CobReciboCabecera getCobReciboCabecera() {
		if (Objects.isNull(cobReciboCabecera)) {
			cobReciboCabecera = new CobReciboCabecera();
			cobReciboCabecera.setFechaRecibo(LocalDate.now());
			cobReciboCabecera.setEstado(Estado.ACTIVO.getEstado());
			cobReciboCabecera.setIndCobrado("N");
			cobReciboCabecera.setIndImpresoBoolean(false);
			cobReciboCabecera.setBsEmpresa(new BsEmpresa());
			cobReciboCabecera.setCobHabilitacionCaja(new CobHabilitacionCaja());
			cobReciboCabecera.setBsTalonario(new BsTalonario());
			cobReciboCabecera.getBsTalonario().setBsTipoComprobante(new BsTipoComprobante());
			cobReciboCabecera.setCobCliente(new CobCliente());
			cobReciboCabecera.getCobCliente().setBsPersona(new BsPersona());
			cobReciboCabecera.setCobCobrador(new CobCobrador());
			cobReciboCabecera.getCobCobrador().setBsPersona(new BsPersona());

		}
		return cobReciboCabecera;
	}

	public void setCobReciboCabecera(CobReciboCabecera cobReciboCabecera) {
		this.cobReciboCabecera = cobReciboCabecera;
	}

	public CobReciboCabecera getCobReciboCabeceraSelected() {
		if (Objects.isNull(cobReciboCabeceraSelected)) {
			cobReciboCabeceraSelected = new CobReciboCabecera();
			cobReciboCabeceraSelected.setFechaRecibo(LocalDate.now());
			cobReciboCabeceraSelected.setEstado(Estado.ACTIVO.getEstado());
			cobReciboCabeceraSelected.setIndCobrado("N");
			cobReciboCabeceraSelected.setIndImpresoBoolean(false);
			cobReciboCabeceraSelected.setBsEmpresa(new BsEmpresa());
			cobReciboCabeceraSelected.setCobHabilitacionCaja(new CobHabilitacionCaja());
			cobReciboCabeceraSelected.setBsTalonario(new BsTalonario());
			cobReciboCabeceraSelected.getBsTalonario().setBsTipoComprobante(new BsTipoComprobante());
			cobReciboCabeceraSelected.setCobCliente(new CobCliente());
			cobReciboCabeceraSelected.getCobCliente().setBsPersona(new BsPersona());
			cobReciboCabeceraSelected.setCobCobrador(new CobCobrador());
			cobReciboCabeceraSelected.getCobCobrador().setBsPersona(new BsPersona());

		}
		return cobReciboCabeceraSelected;
	}

	public void setCobReciboCabeceraSelected(CobReciboCabecera cobReciboCabeceraSelected) {
		if (!Objects.isNull(cobReciboCabeceraSelected)) {
			cobReciboCabeceraSelected.getCobReciboDetalleList()
					.sort(Comparator.comparing(CobReciboDetalle::getNroOrden));
			this.estaCobrado = cobReciboCabeceraSelected.getIndCobrado().equalsIgnoreCase("S");
			if (this.estaCobrado) {
				this.cobrosValoresList = this.cobCobrosValoresServiceImpl.buscarValoresPorComprobanteLista(
						this.commonsUtilitiesController.getIdEmpresaLogueada(), cobReciboCabeceraSelected.getId(),
						"RECIBO");
				this.montoTotalCobro = cobrosValoresList.stream().map(CobCobrosValores::getMontoValor)
						.reduce(BigDecimal.ZERO, BigDecimal::add);
				getResultadoResta();
			}
			cobReciboCabecera = cobReciboCabeceraSelected;
			cobReciboCabeceraSelected = null;
			this.esNuegoRegistro = false;
			this.esVisibleFormulario = true;
		}
		this.cobReciboCabeceraSelected = cobReciboCabeceraSelected;
	}

	public CobHabilitacionCaja getCobHabilitacionCaja() {
		if (Objects.isNull(cobHabilitacionCaja)) {
			cobHabilitacionCaja = new CobHabilitacionCaja();
			this.cobHabilitacionCaja = new CobHabilitacionCaja();
			this.cobHabilitacionCaja.setFechaApertura(LocalDateTime.now());
			this.cobHabilitacionCaja.setFechaCierre(null);
			this.cobHabilitacionCaja.setHoraCierre(null);
			this.cobHabilitacionCaja.setCobCaja(this.cobCajaSelected);
			this.cobHabilitacionCaja.setIndCerradoBoolean(false);
			this.cobHabilitacionCaja.setEstado(Estado.ACTIVO.getEstado());
			this.cobHabilitacionCaja.setBsUsuario(sessionBean.getUsuarioLogueado());
		}
		return cobHabilitacionCaja;
	}

	public void setCobHabilitacionCaja(CobHabilitacionCaja cobHabilitacionCaja) {
		if (!Objects.isNull(cobHabilitacionCaja)) {
			this.cobReciboCabecera.setCobHabilitacionCaja(cobHabilitacionCaja);
			cobHabilitacionCaja = null;
		}
		this.cobHabilitacionCaja = cobHabilitacionCaja;
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
			this.cobReciboCabecera.setBsTalonario(bsTalonarioSelected);
			bsTalonarioSelected = null;
		}
		this.bsTalonarioSelected = bsTalonarioSelected;
	}

	public CobSaldo getCobSaldoSelected() {
		if (Objects.isNull(cobSaldoSelected)) {
			this.cobSaldoSelected = new CobSaldo();
			this.cobSaldoSelected.setBsEmpresa(new BsEmpresa());
			this.cobSaldoSelected.setCobCliente(new CobCliente());
		}
		return cobSaldoSelected;
	}

	public void setCobSaldoSelected(CobSaldo cobSaldoSelected) {
		if (cobSaldoSelected != null) {
			LocalDate fechaHoy = LocalDate.now();
			Long diasAtraso = fechaHoy.isAfter(cobSaldoSelected.getFechaVencimiento())
					? ChronoUnit.DAYS.between(cobSaldoSelected.getFechaVencimiento(), fechaHoy)
					: 0;

			detalle.setCobSaldo(cobSaldoSelected);
			detalle.setCantidad(1);
			detalle.setIdCuotaSaldo(cobSaldoSelected.getId());
			detalle.setDiasAtraso(diasAtraso.intValue());
			detalle.setMontoPagado(cobSaldoSelected.getSaldoCuota());
		}
		this.cobSaldoSelected = cobSaldoSelected;
	}

	public CobReciboDetalle getDetalle() {
		if (Objects.isNull(detalle)) {
			detalle = new CobReciboDetalle();
			detalle.setCobReciboCabecera(new CobReciboCabecera());
			detalle.setCobSaldo(new CobSaldo());
		}
		return detalle;
	}

	public void setDetalle(CobReciboDetalle detalle) {
		this.detalle = detalle;
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
			this.cobReciboCabecera.setCobCliente(cobClienteSelected);
			this.lazyModelSaldos = null;
			getLazyModelSaldos();
		}
		this.cobClienteSelected = cobClienteSelected;
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
	
	public List<CobCobrosValores> getCobrosValoresList() {
		return cobrosValoresList;
	}

	public void setCobrosValoresList(List<CobCobrosValores> cobrosValoresList) {
		this.cobrosValoresList = cobrosValoresList;
	}

	public boolean isTieneHabilitacionAbiertaRendered() {
		return tieneHabilitacionAbiertaRendered;
	}

	public void setTieneHabilitacionAbiertaRendered(boolean tieneHabilitacionAbiertaRendered) {
		this.tieneHabilitacionAbiertaRendered = tieneHabilitacionAbiertaRendered;
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

	public boolean isEstaCobrado() {
		return estaCobrado;
	}

	public void setEstaCobrado(boolean estaCobrado) {
		this.estaCobrado = estaCobrado;
	}

	public String getTipoSaldoAFiltrar() {
		return tipoSaldoAFiltrar;
	}

	public void setTipoSaldoAFiltrar(String tipoSaldoAFiltrar) {
		if(!StringUtils.isAllBlank(tipoSaldoAFiltrar)) {
			lazyModelSaldos = null;
			getLazyModelSaldos();
			PrimeFaces.current().ajax().update(":form:manageDetalle" ,":form:dt-saldo");
		}
		this.tipoSaldoAFiltrar = tipoSaldoAFiltrar;
	}
	
	public ParametrosReporte getParametrosReporte() {
		if (Objects.isNull(parametrosReporte)) {
			parametrosReporte = new ParametrosReporte();
			parametrosReporte.setCodModulo(Modulos.COBRANZAS.getModulo());
			parametrosReporte.setReporte("CobRecibo");
			parametrosReporte.setFormato("PDF");
		}
		return parametrosReporte;
	}

	public void setParametrosReporte(ParametrosReporte parametrosReporte) {
		this.parametrosReporte = parametrosReporte;
	}

	// LAZY
	public LazyDataModel<CobReciboCabecera> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			//ordena la lista por fecha y por nroComprobante DESC
			List<CobReciboCabecera> listaOrdenada = cobRecibosServiceImpl
			        .buscarCobReciboCabeceraActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada())
			        .stream()
			        .sorted(
			            Comparator.comparing(CobReciboCabecera::getFechaRecibo).reversed()
			            .thenComparing(Comparator.comparing(CobReciboCabecera::getNroReciboCompleto).reversed())
			        )
			        .collect(Collectors.toList());
			lazyModel = new GenericLazyDataModel<CobReciboCabecera>(listaOrdenada);
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<CobReciboCabecera> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public LazyDataModel<CobHabilitacionCaja> getLazyModelHabilitacion() {
		if (Objects.isNull(lazyModelHabilitacion)) {
			lazyModelHabilitacion = new GenericLazyDataModel<CobHabilitacionCaja>(
					(List<CobHabilitacionCaja>) cobHabilitacionCajaServiceImpl.buscarCobHabilitacionCajaActivosLista(
							this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModelHabilitacion;
	}

	public void setLazyModelHabilitacion(LazyDataModel<CobHabilitacionCaja> lazyModelHabilitacion) {
		this.lazyModelHabilitacion = lazyModelHabilitacion;
	}

	public LazyDataModel<CobSaldo> getLazyModelSaldos() {
		if (Objects.isNull(lazyModelSaldos)) {
			List<CobSaldo> listaFiltrada = new ArrayList<CobSaldo>();
			if (!Objects.isNull(this.cobReciboCabecera)) {
				if (!Objects.isNull(this.cobReciboCabecera.getCobCliente())
						|| this.cobReciboCabecera.getCobCliente().getId() != null) {
					
					if(!StringUtils.isAllBlank(tipoSaldoAFiltrar) || !(StringUtils.equalsIgnoreCase(tipoSaldoAFiltrar, ""))) {
						listaFiltrada = (List<CobSaldo>) cobSaldoServiceImpl
								.buscarCobSaldoActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()).stream()
								.filter(saldo -> saldo.getCobCliente().getId() == this.cobReciboCabecera.getCobCliente()
										.getId())
								.filter(saldo -> saldo.getSaldoCuota().compareTo(BigDecimal.ZERO) > 0)
								.filter(saldo -> saldo.getTipoComprobante().equalsIgnoreCase(tipoSaldoAFiltrar))
								.sorted(Comparator.comparing(CobSaldo::getFechaVencimiento)).collect(Collectors.toList());
					}else {
						listaFiltrada = (List<CobSaldo>) cobSaldoServiceImpl
								.buscarCobSaldoActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()).stream()
								.filter(saldo -> saldo.getCobCliente().getId() == this.cobReciboCabecera.getCobCliente()
										.getId())
								.filter(saldo -> saldo.getSaldoCuota().compareTo(BigDecimal.ZERO) > 0)
								.sorted(Comparator.comparing(CobSaldo::getFechaVencimiento)).collect(Collectors.toList());
					}
					
					
				} else {
					listaFiltrada = (List<CobSaldo>) cobSaldoServiceImpl
							.buscarCobSaldoActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()).stream()
							.sorted(Comparator.comparing(CobSaldo::getFechaVencimiento)).collect(Collectors.toList());
				}
			}

			lazyModelSaldos = new GenericLazyDataModel<CobSaldo>(listaFiltrada);
		}
		return lazyModelSaldos;
	}

	public void setLazyModelSaldos(LazyDataModel<CobSaldo> lazyModelSaldos) {
		this.lazyModelSaldos = lazyModelSaldos;
	}

	public LazyDataModel<BsTalonario> getLazyModelTalonario() {
		if (Objects.isNull(lazyModelTalonario)) {
			var moduloCredito = this.bsModuloServiceImpl.findByCodigo(Modulos.COBRANZAS.getModulo());
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

	public LazyDataModel<CobCobrador> getLazyModelCobCobrador() {
		if (Objects.isNull(lazyModelCobCobrador)) {
			lazyModelCobCobrador = new GenericLazyDataModel<CobCobrador>((List<CobCobrador>) cobCobradorServiceImpl
					.buscarCobradorActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModelCobCobrador;
	}

	public void setLazyModelCobCobrador(LazyDataModel<CobCobrador> lazyModelCobCobrador) {
		this.lazyModelCobCobrador = lazyModelCobCobrador;
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

	// SERVICES
	public CobRecibosService getCobRecibosServiceImpl() {
		return cobRecibosServiceImpl;
	}

	public void setCobRecibosServiceImpl(CobRecibosService cobRecibosServiceImpl) {
		this.cobRecibosServiceImpl = cobRecibosServiceImpl;
	}

	public CobClienteService getCobClienteServiceImpl() {
		return cobClienteServiceImpl;
	}

	public void setCobClienteServiceImpl(CobClienteService cobClienteServiceImpl) {
		this.cobClienteServiceImpl = cobClienteServiceImpl;
	}

	public CobCobradorService getCobCobradorServiceImpl() {
		return cobCobradorServiceImpl;
	}

	public void setCobCobradorServiceImpl(CobCobradorService cobCobradorServiceImpl) {
		this.cobCobradorServiceImpl = cobCobradorServiceImpl;
	}

	public CobHabilitacionCajaService getCobHabilitacionCajaServiceImpl() {
		return cobHabilitacionCajaServiceImpl;
	}

	public void setCobHabilitacionCajaServiceImpl(CobHabilitacionCajaService cobHabilitacionCajaServiceImpl) {
		this.cobHabilitacionCajaServiceImpl = cobHabilitacionCajaServiceImpl;
	}

	public CobCajaService getCobCajaServiceImpl() {
		return cobCajaServiceImpl;
	}

	public void setCobCajaServiceImpl(CobCajaService cobCajaServiceImpl) {
		this.cobCajaServiceImpl = cobCajaServiceImpl;
	}

	public BsParametroService getBsParametroServiceImpl() {
		return bsParametroServiceImpl;
	}

	public void setBsParametroServiceImpl(BsParametroService bsParametroServiceImpl) {
		this.bsParametroServiceImpl = bsParametroServiceImpl;
	}

	public BsModuloService getBsModuloServiceImpl() {
		return bsModuloServiceImpl;
	}

	public void setBsModuloServiceImpl(BsModuloService bsModuloServiceImpl) {
		this.bsModuloServiceImpl = bsModuloServiceImpl;
	}

	public CobSaldoService getCobSaldoServiceImpl() {
		return cobSaldoServiceImpl;
	}

	public void setCobSaldoServiceImpl(CobSaldoService cobSaldoServiceImpl) {
		this.cobSaldoServiceImpl = cobSaldoServiceImpl;
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
	
	public CobCobrosValoresService getCobCobrosValoresServiceImpl() {
		return cobCobrosValoresServiceImpl;
	}

	public void setCobCobrosValoresServiceImpl(CobCobrosValoresService cobCobrosValoresServiceImpl) {
		this.cobCobrosValoresServiceImpl = cobCobrosValoresServiceImpl;
	}

	public BigDecimal getMontoTotalCobro() {
		return montoTotalCobro;
	}

	public void setMontoTotalCobro(BigDecimal montoTotalCobro) {
		this.montoTotalCobro = montoTotalCobro;
	}

	public BsTipoValorService getBsTipoValorServiceImpl() {
		return bsTipoValorServiceImpl;
	}

	public void setBsTipoValorServiceImpl(BsTipoValorService bsTipoValorServiceImpl) {
		this.bsTipoValorServiceImpl = bsTipoValorServiceImpl;
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

	// METODOS
	public void addCobroDetalle() {
		if (!Objects.isNull(cobCobrosValoresSelected)) {
			cobCobrosValoresSelected.setBsEmpresa(this.sessionBean.getUsuarioLogueado().getBsEmpresa());
			cobCobrosValoresSelected.setTipoComprobante("RECIBO");
			Optional<CobCobrosValores> existente = this.cobrosValoresList.stream().filter(det -> {
				return det.getBsTipoValor().getId() == this.cobCobrosValoresSelected.getBsTipoValor().getId()
						&& det.getNroValor() == this.cobCobrosValoresSelected.getNroValor();
			}).findFirst();
			if (!existente.isPresent()) {
				if (CollectionUtils.isEmpty(this.cobrosValoresList)) {
					cobCobrosValoresSelected.setNroOrden(1);
				} else {
					Optional<Integer> maxNroOrden = this.cobrosValoresList.stream().map(CobCobrosValores::getNroOrden)
							.max(Integer::compareTo);
					if (maxNroOrden.isPresent()) {
						cobCobrosValoresSelected.setNroOrden(maxNroOrden.get() + 1);
					} else {
						cobCobrosValoresSelected.setNroOrden(1);
					}
				}
				this.cobrosValoresList.add(cobCobrosValoresSelected);
			} else {
				cobCobrosValoresSelected.setNroOrden(existente.get().getNroOrden());
				int indice = this.cobrosValoresList.indexOf(existente.get());
				this.cobrosValoresList.set(indice, cobCobrosValoresSelected);
			}
			this.montoTotalCobro = montoTotalCobro.add(cobCobrosValoresSelected.getMontoValor());
			this.cobReciboCabecera.setIndCobrado("S");
			cobCobrosValoresSelected = null;
			getCobCobrosValoresSelected();
		} else {
			cobCobrosValoresSelected = null;
			getCobCobrosValoresSelected();
		}

		PrimeFaces.current().ajax().update("form:messages", "form:dt-cobros", ":form:manageCobroValor");
	}

	public void limpiarCobroDetalle() {
		this.montoTotalCobro = BigDecimal.ZERO;
		this.cobReciboCabecera.setIndCobrado("N");
		this.cobrosValoresList = new ArrayList<>();
		getResultadoResta();
		PrimeFaces.current().ajax().update("form:messages", "form:dt-cobros");
	}

	public BigDecimal getResultadoResta() {
		if (!Objects.isNull(cobReciboCabecera)) {
			BigDecimal montoTotalFactura = cobReciboCabecera.getMontoTotalRecibo();
			return montoTotalFactura.subtract(montoTotalCobro);
		}
		return BigDecimal.ZERO;

	}
	
	
	public void validarHabilitacion() {
		String valor = this.cobHabilitacionCajaServiceImpl
				.validaHabilitacionAbierta(this.sessionBean.getUsuarioLogueado().getId(), this.cobCajaSelected.getId());
		this.tieneHabilitacionAbiertaRendered = valor.equalsIgnoreCase("N");
		validarCajaDelUsuario(this.tieneHabilitacionAbiertaRendered);
		PrimeFaces.current().ajax().update("form:messages", "form:btnNuevo");
		return;

	}

	public void validarCajaDelUsuario(boolean tieneHab) {
		if (tieneHab) {
			PrimeFaces.current().executeScript("PF('dlgNoTieneCaja').show()");
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
			return;
		}
	}

	public void redireccionarAHabilitaciones() {
		try {
			PrimeFaces.current().executeScript("PF('dlgNoTieneCaja').hide()");
			CommonUtils.redireccionar("/pages/cliente/cobranzas/definicion/CobHabilitacionCaja.xhtml");
		} catch (IOException e) {
			e.printStackTrace();
			LOGGER.error("Ocurrio un error al Guardar", System.err);
		}
	}

	public void abrirDialogoAddDetalle() {
		detalle = new CobReciboDetalle();
		detalle.setCobReciboCabecera(new CobReciboCabecera());
		detalle.setCobSaldo(new CobSaldo());
	}

	public void eliminaDetalle() {
		cobReciboCabecera.getCobReciboDetalleList().removeIf(det -> det.equals(detalle));
		this.detalle = null;
		this.cobReciboCabecera.calcularTotales();
		PrimeFaces.current().ajax().update(":form:dt-detalle");
	}
	
	public void limpiarDetalle() {
		cobReciboCabecera.setCobReciboDetalleList((new ArrayList<CobReciboDetalle>()));
		cobReciboCabecera.setMontoTotalRecibo(BigDecimal.ZERO);
		PrimeFaces.current().ajax().update(":form:btnLimpiar");
	}

	public void agregarDetalle() {
		if (detalle.getMontoPagado().compareTo(cobSaldoSelected.getSaldoCuota()) < 0) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					"El monto a pagar no puede ser menor al saldo.");
			PrimeFaces.current().ajax().update("form:messages", "form:articuloLb", "form:precioLb",
					"form:form:btnAddDetalle");
			return;
		}
		Optional<CobReciboDetalle> existente = cobReciboCabecera.getCobReciboDetalleList().stream()
				.filter(det -> det.getCobSaldo().getId() == detalle.getCobSaldo().getId()).findFirst();
		if (!existente.isPresent()) {
			if (CollectionUtils.isEmpty(cobReciboCabecera.getCobReciboDetalleList())) {
				detalle.setNroOrden(1);
			} else {
				Optional<Integer> maxNroOrden = cobReciboCabecera.getCobReciboDetalleList().stream()
						.map(CobReciboDetalle::getNroOrden).max(Integer::compareTo);
				if (maxNroOrden.isPresent()) {
					detalle.setNroOrden(maxNroOrden.get() + 1);
				} else {
					detalle.setNroOrden(1);
				}
			}
			this.cobReciboCabecera.addDetalle(detalle);
		} else {
			detalle.setNroOrden(existente.get().getNroOrden());
			int indice = cobReciboCabecera.getCobReciboDetalleList().indexOf(existente.get());
			cobReciboCabecera.getCobReciboDetalleList().set(indice, detalle);
		}
		this.cobReciboCabecera.setCabeceraADetalle();
		this.cobReciboCabecera.calcularTotales();
		detalle = null;
		PrimeFaces.current().ajax().update(":form:dt-detalle", ":form:btnGuardar");
	}

	public void guardar() {
		try {
			if (Objects.isNull(this.cobReciboCabecera.getId())) {
				try {
					this.cobHabilitacionCaja = cobHabilitacionCajaServiceImpl
							.buscarCobHabilitacionCajaActivosLista(
									this.commonsUtilitiesController.getIdEmpresaLogueada())
							.stream().filter(hab -> hab.getIndCerrado().equalsIgnoreCase("N")).findFirst().get();
					if (Objects.nonNull(this.cobHabilitacionCaja)) {
						this.cobReciboCabecera.setCobHabilitacionCaja(cobHabilitacionCaja);
					}
					this.cobReciboCabecera.setNroRecibo(this.cobRecibosServiceImpl.calcularNroReciboDisponible(
							commonsUtilitiesController.getIdEmpresaLogueada(),
							this.cobReciboCabecera.getBsTalonario().getId()));
					String formato = "%s-%s-%09d";
					this.cobReciboCabecera.setNroReciboCompleto(String.format(formato,
							this.cobReciboCabecera.getBsTalonario().getBsTimbrado().getCodEstablecimiento(),
							this.cobReciboCabecera.getBsTalonario().getBsTimbrado().getCodExpedicion(),
							this.cobReciboCabecera.getNroRecibo()));

				} catch (Exception e) {
					LOGGER.error("Ocurrio un error al obtener la habilitacion. O calcular el nroRecibo disponible.",
							System.err);
					e.printStackTrace(System.err);
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
							e.getMessage().substring(0, e.getMessage().length()) + "...");
				}

			}
			
			if (Objects.isNull(this.cobReciboCabecera.getBsTalonario())
					|| Objects.isNull(this.cobReciboCabecera.getBsTalonario().getId())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un Talonario.");
				return;
			}
			if (Objects.isNull(this.cobReciboCabecera.getCobHabilitacionCaja())
					|| Objects.isNull(this.cobReciboCabecera.getCobHabilitacionCaja().getId())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
						"No tiene una Habilitacion asignada.");
				return;
			}
			this.cobReciboCabecera.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			this.cobReciboCabecera.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());

			
			
			CobReciboCabecera reciboGuardado = this.cobRecibosServiceImpl.save(cobReciboCabecera);
			if (!Objects.isNull(reciboGuardado)) {
				
				if (CollectionUtils.isNotEmpty(cobrosValoresList) && cobrosValoresList.size() > 0) {
					if (!(montoTotalCobro.compareTo(reciboGuardado.getMontoTotalRecibo()) == 0)) {
						CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "El cobro debe ser exacto.");
						return;
					}
					this.cobrosValoresList = cobrosValoresList.stream().map(cobro -> {
						cobro.setUsuarioModificacion(reciboGuardado.getUsuarioModificacion());
						cobro.setIdComprobate(reciboGuardado.getId());
						cobro.setNroComprobanteCompleto(reciboGuardado.getNroReciboCompleto());
						cobro.setTipoComprobante("RECIBO");
						return cobro;
					}).collect(Collectors.toList());
					if (CollectionUtils.isEmpty(this.cobCobrosValoresServiceImpl.saveAll(cobrosValoresList))) {
						CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
								"No se guardaron los cobros.");
					}
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
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "El recibo ya fue creado.");
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
			if (Objects.isNull(this.cobReciboCabecera.isIndImpresoBoolean())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Ya fue Impreso.");
				return;
			}
			if (!Objects.isNull(this.cobReciboCabecera)) {
				this.cobRecibosServiceImpl.deleteById(this.cobReciboCabecera.getId());
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
	
	public void imprimir() {
		try {
			getParametrosReporte();
			this.prepareParams();
			if (!(Objects.isNull(parametrosReporte) && Objects.isNull(parametrosReporte.getFormato()))
					&& CollectionUtils.isNotEmpty(this.parametrosReporte.getParametros())
					&& CollectionUtils.isNotEmpty(this.parametrosReporte.getValores())) {
				this.generarReporte.descargarReporte(parametrosReporte);
				if (this.utilsService.actualizarRegistro("cob_recibos_cabecera", "ind_impreso = 'S'",
						" bs_empresa_id = " + commonsUtilitiesController.getIdEmpresaLogueada() + " and id = "	+ this.cobReciboCabecera.getId())) {
				} else {
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡CUIDADO!",
							"No se pudo actualizar el registro.");
					return;
				}
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡CUIDADO!",
						"Debes seccionar los parametros validos.");
				return;
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update(":form");
			
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", System.err);
			e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");

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
		// key
		this.parametrosReporte.getParametros().add("p_empresa_id");
		this.parametrosReporte.getParametros().add("p_recibo_id");

		// values
		this.parametrosReporte.getValores().add(this.commonsUtilitiesController.getIdEmpresaLogueada());
		this.parametrosReporte.getValores().add(this.cobReciboCabecera.getId());

	}

}
