package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.movimientos;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.PrimeFaces;
import org.primefaces.event.SelectEvent;
import org.primefaces.event.UnselectEvent;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.*;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.entities.compras.ComProveedor;
import py.com.capital.CapitaCreditos.entities.compras.ComSaldo;
import py.com.capital.CapitaCreditos.entities.creditos.CreDesembolsoCabecera;
import py.com.capital.CapitaCreditos.entities.tesoreria.*;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.UtilsService;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;
import py.com.capital.CapitaCreditos.services.base.BsTipoValorService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobClienteService;
import py.com.capital.CapitaCreditos.services.compras.ComProveedorService;
import py.com.capital.CapitaCreditos.services.compras.ComSaldoService;
import py.com.capital.CapitaCreditos.services.creditos.CreDesembolsoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesChequeraService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesPagoService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
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

    private TesBanco tesBancoSelected;

    private BsTipoValor bsTipoValorSelected;
    private List<TesPagoValores> tesPagoValoresList;
    private List<CreDesembolsoCabecera> desembolsoList;

    private List<ComSaldo> saldoList;

    private List<Long> idSaldosAPagarList = new ArrayList<>();

    // FKs
    private BsTalonario bsTalonarioSelected;
    private CobCliente cobClienteSelected;
    private ComProveedor comProveedorSelected;

    // LAZY
    private LazyDataModel<TesPagoCabecera> lazyModel;
    private List<CreDesembolsoCabecera> lazyModelDesembolso;

    private List<ComSaldo> lazyModelSaldos;
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

    @Autowired
    private ComSaldoService comSaldoServiceImpl;

    /**
     * Propiedad de la logica de negocio inyectada con JSF y Spring.
     */
    private boolean puedeCrear, puedeEditar, puedeEliminar = false;
    @Autowired
    private SessionBean sessionBean;

    @Autowired
    private CommonsUtilitiesController commonsUtilitiesController;



    @Autowired
    private TesChequeraService tesChequeraServiceImpl;

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
        this.saldoList = null;
        this.lazyModelSaldos = null;
        this.tesBancoSelected = null;
        this.bsTipoValorSelected = null;

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
        System.out.println("paso pro el select ");
        var a = 0;
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
        if (!Objects.isNull(comProveedorSelected)) {
            this.tesPagoCabecera.setBeneficiario(comProveedorSelected.getBsPersona().getNombreCompleto());
            this.tesPagoCabecera.setIdBeneficiario(comProveedorSelected.getId());
            this.comProveedorSelected = comProveedorSelected;
            lazyModelSaldos = null;
            getLazyModelSaldos();
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
            if (tipoSaldoAFiltrar.equalsIgnoreCase("DESEMBOLSO")) {
                lazyModelDesembolso = null;
                getLazyModelDesembolso();
            } else {
                lazyModelSaldos = null;
                getLazyModelSaldos();
            }

            PrimeFaces.current().ajax().update(":form:manageComprobante",
                    ":form:dt-comprobantes");
        }
        this.tipoSaldoAFiltrar = tipoSaldoAFiltrar;
    }

    public List<CreDesembolsoCabecera> getDesembolsoList() {
        return desembolsoList;
    }

    public void setDesembolsoList(List<CreDesembolsoCabecera> desembolsoList) {
        this.desembolsoList = desembolsoList;
    }

    public List<ComSaldo> getSaldoList() {
        return saldoList;
    }

    public void setSaldoList(List<ComSaldo> saldoList) {
        this.saldoList = saldoList;
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

    public TesBanco getTesBancoSelected() {
        if (Objects.isNull(tesBancoSelected)) {
            this.tesBancoSelected = new TesBanco();
            this.tesBancoSelected.setBsMoneda(new BsMoneda());
            this.tesBancoSelected.setBsEmpresa(new BsEmpresa());
            this.tesBancoSelected.setBsPersona(new BsPersona());
        }
        return tesBancoSelected;
    }

    public void setTesBancoSelected(TesBanco tesBancoSelected) {
        if (Objects.nonNull(tesBancoSelected)) {
            //comparo que el saldo del banco pueda pagar
            if (this.montoTotalPago.compareTo(tesBancoSelected.getSaldoCuenta()) > 0) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_WARN, "¡CUIDADO!",
                        "El banco no tiene saldo suficiente para realizar este pago.");
                tesPagoValoresSelected.setTesBanco(new TesBanco());
                tesPagoValoresSelected.getTesBanco().setBsPersona(new BsPersona());
                PrimeFaces.current().ajax().update("form:messages", ":form:bancoLb");
                return;
            }
            this.tesPagoValoresSelected.setTesBanco(tesBancoSelected);
            tesBancoSelected = null;
        }
        this.tesBancoSelected = tesBancoSelected;
    }

    public BsTipoValor getBsTipoValorSelected() {
        if (Objects.isNull(bsTipoValorSelected)) {
            this.bsTipoValorSelected = new BsTipoValor();
            this.bsTipoValorSelected.setBsEmpresa(new BsEmpresa());
            this.bsTipoValorSelected.setBsModulo(new BsModulo());
        }
        return bsTipoValorSelected;
    }

    public void setBsTipoValorSelected(BsTipoValor bsTipoValorSelected) {
        if (Objects.nonNull(bsTipoValorSelected)) {
            this.tesPagoValoresSelected.setMontoValor(this.montoTotalPago);
            if (bsTipoValorSelected.getCodTipo().equalsIgnoreCase("CHE")) {
                Optional<TesChequera> chequera = this.tesChequeraServiceImpl.findByBanco(
                        this.commonsUtilitiesController.getIdEmpresaLogueada(),
                        this.tesPagoValoresSelected.getTesBanco().getId()
                );
                if (chequera.isPresent()) {
                    //asigno con for update
                    long numeroAsignado = this.tesChequeraServiceImpl.asignarNumeroDesdeChequera(
                            this.commonsUtilitiesController.getIdEmpresaLogueada(),
                            this.tesPagoValoresSelected.getTesBanco().getId());

                    if (this.tesChequeraServiceImpl.validarNumero(
                            this.commonsUtilitiesController.getIdEmpresaLogueada(),
                            chequera.get().getId(),
                            numeroAsignado
                    )) {
                        this.tesPagoValoresSelected.setNroValor(String.valueOf(numeroAsignado));
                        this.tesPagoValoresSelected.setFechaValor(LocalDate.now());
                    } else {
                        this.tesPagoValoresSelected.setBsTipoValor(new BsTipoValor());
                        this.tesPagoValoresSelected.setNroValor(null);
                        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_WARN, "¡CUIDADO!",
                                "El numero asignado no esta en un rango valido.");
                        PrimeFaces.current().ajax().update("form:messages", ":form:nroValorLb");
                        return;
                    }
                }


            }
            bsTipoValorSelected = null;
        }
        this.bsTipoValorSelected = bsTipoValorSelected;
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
                                    this.cobClienteSelected.getId()).stream()
                            .filter(desembolso -> desembolso.getIndFacturado().equalsIgnoreCase("N") &&
                                    desembolso.getIndDesembolsado().equalsIgnoreCase("N"))
                            .collect(Collectors.toList());
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
                    .filter(tipo -> tipo.getBsModulo().getCodigo().equalsIgnoreCase(Modulos.TESORERIA.getModulo()))
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

    public List<ComSaldo> getLazyModelSaldos() {
        if (Objects.isNull(lazyModelSaldos)) {
            final Long empresaId = commonsUtilitiesController.getIdEmpresaLogueada();
            Long proveedorId = (tesPagoCabecera != null && tesPagoCabecera.getIdBeneficiario() != null)
                    ? tesPagoCabecera.getIdBeneficiario()
                    : null;
            String tipo = StringUtils.isNotBlank(tipoSaldoAFiltrar) ? tipoSaldoAFiltrar : null;

            lazyModelSaldos = comSaldoServiceImpl.buscarSaldosFiltrados(empresaId, proveedorId, tipo);

        }
        return lazyModelSaldos;
    }

    public void setLazyModelSaldos(List<ComSaldo> lazyModelSaldos) {
        this.lazyModelSaldos = lazyModelSaldos;
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

    public ComSaldoService getComSaldoServiceImpl() {
        return comSaldoServiceImpl;
    }

    public void setComSaldoServiceImpl(ComSaldoService comSaldoServiceImpl) {
        this.comSaldoServiceImpl = comSaldoServiceImpl;
    }

    public TesChequeraService getTesChequeraServiceImpl() {
        return tesChequeraServiceImpl;
    }

    public void setTesChequeraServiceImpl(TesChequeraService tesChequeraServiceImpl) {
        this.tesChequeraServiceImpl = tesChequeraServiceImpl;
    }

    //METODOS
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


    public void onRowSelectSaldo(SelectEvent<ComSaldo> event) {
        ComSaldo saldo = event.getObject();
        if (saldo != null) {
            formatearSaldoAcomprobanteDetalle();
        }
    }

    public void onRowUnselectSaldo(UnselectEvent<ComSaldo> event) {
        ComSaldo saldo = event.getObject();
        if (saldo != null) {
            formatearSaldoAcomprobanteDetalle();
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

    public void formatearSaldoAcomprobanteDetalle() {
        this.tesPagoComprobanteDetallesList = new ArrayList<>();
        IntStream.range(0, saldoList.size()).forEach(i -> {
            ComSaldo saldo = saldoList.get(i);

            TesPagoComprobanteDetalle detalle = new TesPagoComprobanteDetalle();
            detalle.setIdCuotaSaldo(saldo.getId());
            detalle.setMontoPagado(saldo.getSaldoCuota());
            detalle.setNroOrden(i + 1);
            detalle.setTipoComprobante("FACTURA");

            tesPagoComprobanteDetallesList.add(detalle);
            this.idSaldosAPagarList.add(saldo.getId());
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
                    /*this.tesPagoCabecera.setNroPago(this.tesPagoServiceImpl.calcularNroPagoDisponible(
                            commonsUtilitiesController.getIdEmpresaLogueada(),
                            this.tesPagoCabecera.getBsTalonario().getId()));*/
                    this.tesPagoCabecera.setNroPago(this.commonsUtilitiesController.asignarNumeroDesdeTalonario(
                            commonsUtilitiesController.getIdEmpresaLogueada(),
                            this.tesPagoCabecera.getBsTalonario().getId(),
                            this.commonsUtilitiesController.getCodUsuarioLogueada()
                    ));
                    if (!this.commonsUtilitiesController.validarNumero(commonsUtilitiesController.getIdEmpresaLogueada(),
                            this.tesPagoCabecera.getBsTalonario().getId(),
                            this.tesPagoCabecera.getNroPago())) {
                        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                                "El numero de factura calculado esta fuera de rango de vigencia.");
                        return;
                    }
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
                if (!idSaldosAPagarList.isEmpty()) {
                    Long empresaId = tesPagoCabecera.getBsEmpresa().getId();
                    Long proveedorId = tesPagoCabecera.getIdBeneficiario();

                    int updated = comSaldoServiceImpl.pagarSaldosPorIds(
                            empresaId, proveedorId, idSaldosAPagarList, this.commonsUtilitiesController.getCodUsuarioLogueada()
                            , BigDecimal.ZERO);

                    if (updated < idSaldosAPagarList.size()) {
                        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡VERIFICAR!",
                                "La cantidad de registros actualizados en saldos no coincide.");
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
                //TODO reestablezco el importe en saldos y ver de optimizar mas adelante
                if (this.tesPagoCabecera.getTipoOperacion().equalsIgnoreCase("FACTURA")) {
                    Long empresaId = tesPagoCabecera.getBsEmpresa().getId();
                    Long proveedorId = tesPagoCabecera.getIdBeneficiario();
                    this.tesPagoCabecera.getTesPagoComprobanteDetallesList().forEach(comprobante -> {
                        idSaldosAPagarList.add(comprobante.getIdCuotaSaldo());
                    });
                    int updated = comSaldoServiceImpl.reestablecerSaldosPorIds(
                            empresaId, proveedorId, idSaldosAPagarList, this.commonsUtilitiesController.getCodUsuarioLogueada()
                            , this.tesPagoCabecera.getMontoTotalPago());
                    LOGGER.info(String.format("saldos eliminados para el proveedor %s %s", updated, proveedorId));
                }
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
