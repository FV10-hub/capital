package py.com.capital.CapitaCreditos.presentation.controllers.ventas.movimientos;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.entities.base.*;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobSaldo;
import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;
import py.com.capital.CapitaCreditos.entities.ventas.VenCondicionVenta;
import py.com.capital.CapitaCreditos.entities.ventas.VenFacturaCabecera;
import py.com.capital.CapitaCreditos.entities.ventas.VenFacturaDetalle;
import py.com.capital.CapitaCreditos.entities.ventas.VenVendedor;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.UtilsService;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;
import py.com.capital.CapitaCreditos.services.base.BsParametroService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobClienteService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobSaldoService;
import py.com.capital.CapitaCreditos.services.stock.StoArticuloService;
import py.com.capital.CapitaCreditos.services.ventas.VenCondicionVentaService;
import py.com.capital.CapitaCreditos.services.ventas.VenFacturasService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/*
 * 4 ene. 2024 - Elitebook
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class VenNotasCreditosController {

    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */

    private static final Logger LOGGER = LogManager.getLogger(VenNotasCreditosController.class);

    private VenFacturaCabecera venFacturaCabecera, venFacturaCabeceraSelected, venFacturaAsociada;
    private BsTalonario bsTalonarioSelected;
    private StoArticulo stoArticuloSelected;

    private CobCliente cobClienteSelected;
    private VenFacturaDetalle detalle;
    private LazyDataModel<VenFacturaCabecera> lazyModel;

    private LazyDataModel<VenFacturaCabecera> lazyModelFacturas;

    private LazyDataModel<CobCliente> lazyModelCliente;
    List<CobSaldo> listaSaldoAGenerar;
    private ParametrosReporte parametrosReporte;

    private List<String> estadoList;
    private boolean esNuegoRegistro;
    private boolean esVisibleFormulario = true;
    private boolean estaCobrado;

    private String nroFacturaAsociadoCompleto;

    private static final String DT_NAME = "dt-facturas";

    // services
    @Autowired
    private VenFacturasService venFacturasServiceImpl;

    @Autowired
    private CobClienteService cobClienteServiceImpl;

    @Autowired
    private StoArticuloService stoArticuloServiceImpl;

    @Autowired
    private BsParametroService bsParametroServiceImpl;

    @Autowired
    private BsModuloService bsModuloServiceImpl;

    @Autowired
    private VenCondicionVentaService venCondicionVentaServiceImpl;

    @Autowired
    private CobSaldoService cobSaldoServiceImpl;


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
        this.venFacturaCabecera = null;
        this.venFacturaCabeceraSelected = null;
        this.venFacturaAsociada = null;
        this.bsTalonarioSelected = null;
        this.stoArticuloSelected = null;
        this.cobClienteSelected = null;
        this.detalle = null;
        this.lazyModel = null;
        this.lazyModelCliente = null;
        this.lazyModelFacturas = null;
        this.parametrosReporte = null;

        this.esNuegoRegistro = true;
        this.estaCobrado = false;
        this.esVisibleFormulario = !esVisibleFormulario;
        this.nroFacturaAsociadoCompleto = null;
        this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado(), "ANULADO");
        this.listaSaldoAGenerar = new ArrayList<CobSaldo>();
    }

    // GETTERS Y SETTERS
    public VenFacturaCabecera getVenFacturaCabecera() {
        if (Objects.isNull(venFacturaCabecera)) {
            this.estaCobrado = false;
            var moduloVentas = this.bsModuloServiceImpl.findByCodigo(Modulos.VENTAS.getModulo());
            this.bsTalonarioSelected = this.commonsUtilitiesController.bsTalonarioPorModuloLista(
                            this.commonsUtilitiesController.getIdEmpresaLogueada(), moduloVentas.getId())
                    .stream()
                    .filter(t -> t.getBsTipoComprobante().getCodTipoComprobante().equalsIgnoreCase("NCR"))
                    .findFirst().orElse(new BsTalonario());
            var condicionAux = this.venCondicionVentaServiceImpl.buscarVenCondicionVentaActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada())
                    .stream()
                    .filter(con -> con.getCodCondicion().equalsIgnoreCase("NCR") &&
                            con.getBsEmpresa().getId() == this.commonsUtilitiesController.getIdEmpresaLogueada())
                    .findFirst()
                    .orElse(new VenCondicionVenta());
            venFacturaCabecera = new VenFacturaCabecera();
            venFacturaCabecera.setFechaFactura(LocalDate.now());
            venFacturaCabecera.setIndCobrado("N");
            venFacturaCabecera.setIdComprobante(null);
            venFacturaCabecera.setTipoFactura("NCR");
            venFacturaCabecera.setEstado(Estado.ACTIVO.getEstado());
            venFacturaCabecera.setBsEmpresa(new BsEmpresa());
            venFacturaCabecera.setVenCondicionVenta(condicionAux);
            venFacturaCabecera.setBsTalonario(this.bsTalonarioSelected);
            venFacturaCabecera.setCobCliente(new CobCliente());
            venFacturaCabecera.getCobCliente().setBsPersona(new BsPersona());
            venFacturaCabecera.setVenVendedor(new VenVendedor());
            venFacturaCabecera.getVenVendedor().setBsPersona(new BsPersona());

            if (!this.commonsUtilitiesController.validarSiTengaHabilitacionAbierta()) {
                this.venFacturaCabecera
                        .setCobHabilitacionCaja(this.commonsUtilitiesController.getHabilitacionAbierta());
            } else {
                validarCajaDelUsuario(true);
            }

        }
        return venFacturaCabecera;
    }

    public void setVenFacturaCabecera(VenFacturaCabecera venFacturaCabecera) {
        this.venFacturaCabecera = venFacturaCabecera;
    }

    public VenFacturaCabecera getVenFacturaCabeceraSelected() {
        if (Objects.isNull(venFacturaCabeceraSelected)) {
            venFacturaCabeceraSelected = new VenFacturaCabecera();
            venFacturaCabeceraSelected.setFechaFactura(LocalDate.now());
            venFacturaCabeceraSelected.setBsEmpresa(new BsEmpresa());
            venFacturaCabeceraSelected.setVenCondicionVenta(new VenCondicionVenta());
            venFacturaCabeceraSelected.setVenCondicionVenta(new VenCondicionVenta());
            venFacturaCabeceraSelected.setBsTalonario(new BsTalonario());
            venFacturaCabeceraSelected.getBsTalonario().setBsTipoComprobante(new BsTipoComprobante());
            venFacturaCabeceraSelected.setCobCliente(new CobCliente());
            venFacturaCabeceraSelected.getCobCliente().setBsPersona(new BsPersona());
            venFacturaCabeceraSelected.setVenVendedor(new VenVendedor());
            venFacturaCabeceraSelected.getVenVendedor().setBsPersona(new BsPersona());

            if (!this.commonsUtilitiesController.validarSiTengaHabilitacionAbierta()) {
                this.venFacturaCabeceraSelected
                        .setCobHabilitacionCaja(this.commonsUtilitiesController.getHabilitacionAbierta());
            } else {
                validarCajaDelUsuario(true);
            }

        }
        return venFacturaCabeceraSelected;
    }

    public void setVenFacturaCabeceraSelected(VenFacturaCabecera venFacturaCabeceraSelected) {
        if (!Objects.isNull(venFacturaCabeceraSelected)) {
            venFacturaCabecera = venFacturaCabeceraSelected;
            venFacturaCabeceraSelected = null;
            this.esNuegoRegistro = false;
            this.esVisibleFormulario = true;
        }
        this.venFacturaCabeceraSelected = venFacturaCabeceraSelected;
    }

    public VenFacturaCabecera getVenFacturaAsociada() {
        if (Objects.isNull(venFacturaAsociada)) {
            venFacturaAsociada = new VenFacturaCabecera();
            venFacturaAsociada.setFechaFactura(LocalDate.now());
            venFacturaAsociada.setIndCobrado("N");
            venFacturaAsociada.setIdComprobante(null);
            venFacturaAsociada.setTipoFactura("");
            venFacturaAsociada.setEstado(Estado.ACTIVO.getEstado());
            venFacturaAsociada.setBsEmpresa(new BsEmpresa());
            venFacturaAsociada.setVenCondicionVenta(new VenCondicionVenta());
            venFacturaAsociada.setVenCondicionVenta(new VenCondicionVenta());
            venFacturaAsociada.setBsTalonario(new BsTalonario());
            venFacturaAsociada.getBsTalonario().setBsTipoComprobante(new BsTipoComprobante());
            venFacturaAsociada.setCobCliente(new CobCliente());
            venFacturaAsociada.getCobCliente().setBsPersona(new BsPersona());
            venFacturaAsociada.setVenVendedor(new VenVendedor());
            venFacturaAsociada.getVenVendedor().setBsPersona(new BsPersona());
        }
        return venFacturaAsociada;
    }

    public void setVenFacturaAsociada(VenFacturaCabecera venFacturaAsociada) {
        if (!Objects.isNull(venFacturaAsociada)) {
            this.nroFacturaAsociadoCompleto = venFacturaAsociada.getNroFacturaCompleto();
            venFacturaCabecera.setCobCliente(venFacturaAsociada.getCobCliente());
            venFacturaCabecera.setVenVendedor(venFacturaAsociada.getVenVendedor());
            venFacturaCabecera.setIdComprobante(venFacturaAsociada.getId());
            venFacturaAsociada.getVenFacturaDetalleList().stream().forEach(factAsociada -> {
                this.detalle = new VenFacturaDetalle();
                this.detalle.setId(null);
                this.detalle.setEstado(Estado.ACTIVO.getEstado());
                this.detalle.setUsuarioModificacion(this.commonsUtilitiesController.getCodUsuarioLogueada());
                this.detalle.setCantidad(factAsociada.getCantidad());
                this.detalle.setNroOrden(factAsociada.getNroOrden());
                this.detalle.setPrecioUnitario(factAsociada.getPrecioUnitario());
                this.detalle.setMontoGravado(factAsociada.getMontoGravado());
                this.detalle.setMontoExento(factAsociada.getMontoExento());
                this.detalle.setMontoIva(factAsociada.getMontoIva());
                this.detalle.setMontoLinea(factAsociada.getMontoLinea());
                this.detalle.setCodIva(factAsociada.getCodIva());
                this.detalle.setStoArticulo(factAsociada.getStoArticulo());
                this.detalle.setStoArticulo(factAsociada.getStoArticulo());

                this.venFacturaCabecera.addDetalle(this.detalle);
            });
            this.venFacturaCabecera.calcularTotales();
        }
        this.venFacturaAsociada = null;
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
            this.venFacturaCabecera.setBsTalonario(bsTalonarioSelected);
            bsTalonarioSelected = null;
        }
        this.bsTalonarioSelected = bsTalonarioSelected;
    }

    public StoArticulo getStoArticuloSelected() {
        if (Objects.isNull(stoArticuloSelected)) {
            this.stoArticuloSelected = new StoArticulo();
            this.stoArticuloSelected.setBsEmpresa(new BsEmpresa());
            this.stoArticuloSelected.setBsIva(new BsIva());
        }
        return stoArticuloSelected;
    }

    public void setStoArticuloSelected(StoArticulo stoArticuloSelected) {
        if (stoArticuloSelected != null) {
            BigDecimal existencia = this.stoArticuloServiceImpl.retornaExistenciaArticulo(stoArticuloSelected.getId(),
                    this.commonsUtilitiesController.getIdEmpresaLogueada());
            if (stoArticuloSelected.getIndInventariable().equalsIgnoreCase("S")
                    && existencia.compareTo(BigDecimal.ZERO) <= 0) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                        "El Articulo no tiene existencia suficiente.");
                PrimeFaces.current().ajax().update("form:messages", "form:btnAddDetalle");
                return;
            }
            detalle.setStoArticulo(stoArticuloSelected);
            detalle.setCantidad(1);
            detalle.setCodIva(stoArticuloSelected.getBsIva().getCodIva());
            detalle.setPrecioUnitario(stoArticuloSelected.getPrecioUnitario());
            detalle.setMontoLinea(stoArticuloSelected.getPrecioUnitario());
        }
        this.stoArticuloSelected = stoArticuloSelected;
    }

    public VenFacturaDetalle getDetalle() {
        if (Objects.isNull(detalle)) {
            detalle = new VenFacturaDetalle();
            detalle.setVenFacturaCabecera(new VenFacturaCabecera());
            detalle.setStoArticulo(new StoArticulo());
        }
        return detalle;
    }

    public void setDetalle(VenFacturaDetalle detalle) {
        this.detalle = detalle;
    }

    public CobCliente getCobClienteSelected() {
        if (Objects.isNull(cobClienteSelected)) {
            cobClienteSelected = new CobCliente();
            cobClienteSelected.setBsEmpresa(new BsEmpresa());
            cobClienteSelected.setBsPersona(new BsPersona());
        }
        return cobClienteSelected;
    }

    public void setCobClienteSelected(CobCliente cobClienteSelected) {
        this.cobClienteSelected = cobClienteSelected;
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

    public ParametrosReporte getParametrosReporte() {
        //TODO: aca ver los reportes
        if (Objects.isNull(parametrosReporte)) {
            parametrosReporte = new ParametrosReporte();
            parametrosReporte.setCodModulo(Modulos.VENTAS.getModulo());
            parametrosReporte.setReporte("VenNotaCredito");
            parametrosReporte.setFormato("PDF");
        }
        return parametrosReporte;
    }

    public void setParametrosReporte(ParametrosReporte parametrosReporte) {
        this.parametrosReporte = parametrosReporte;
    }

    public String getNroFacturaAsociadoCompleto() {
        return nroFacturaAsociadoCompleto;
    }

    public void setNroFacturaAsociadoCompleto(String nroFacturaAsociadoCompleto) {
        this.nroFacturaAsociadoCompleto = nroFacturaAsociadoCompleto;
    }

    // LAZY
    public LazyDataModel<VenFacturaCabecera> getLazyModel() {
        if (Objects.isNull(lazyModel)) {
            // ordena la lista por fecha y por nroComprobante DESC
            List<VenFacturaCabecera> listaOrdenada = venFacturasServiceImpl
                    .buscarVenFacturaCabeceraActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada())
                    .stream()
                    .filter(f -> f.getTipoFactura().equalsIgnoreCase("NCR"))
                    .sorted(Comparator.comparing(VenFacturaCabecera::getFechaFactura).reversed()
                            .thenComparing(Comparator.comparing(VenFacturaCabecera::getNroFacturaCompleto).reversed()))
                    .collect(Collectors.toList());
            lazyModel = new GenericLazyDataModel<VenFacturaCabecera>((List<VenFacturaCabecera>) listaOrdenada);
        }
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<VenFacturaCabecera> lazyModel) {
        this.lazyModel = lazyModel;
    }

    public LazyDataModel<VenFacturaCabecera> getLazyModelFacturas() {
        if (Objects.isNull(lazyModelFacturas)) {
            List<VenFacturaCabecera> listaOrdenada;
            //TODO: aca debo hacer una funcion que busque comprobantes solo con saldos
            if (this.venFacturaCabecera != null
                    && this.venFacturaCabecera.getCobCliente() != null
                    && this.venFacturaCabecera.getCobCliente().getId() != null) {
                listaOrdenada = venFacturasServiceImpl
                        .buscarVenFacturaCabeceraActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada())
                        .stream()
                        .filter(f -> f.getCobCliente().getId() == this.cobClienteSelected.getId())
                        .sorted(Comparator.comparing(VenFacturaCabecera::getFechaFactura).reversed()
                                .thenComparing(Comparator.comparing(VenFacturaCabecera::getNroFacturaCompleto).reversed()))
                        .collect(Collectors.toList());
            } else {
                listaOrdenada = venFacturasServiceImpl
                        .buscarVenFacturaCabeceraActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada())
                        .stream()
                        .sorted(Comparator.comparing(VenFacturaCabecera::getFechaFactura).reversed()
                                .thenComparing(Comparator.comparing(VenFacturaCabecera::getNroFacturaCompleto).reversed()))
                        .collect(Collectors.toList());
            }
            lazyModelFacturas = new GenericLazyDataModel<VenFacturaCabecera>((List<VenFacturaCabecera>) listaOrdenada);

        }
        return lazyModelFacturas;
    }

    public void setLazyModelFacturas(LazyDataModel<VenFacturaCabecera> lazyModelFacturas) {
        this.lazyModelFacturas = lazyModelFacturas;
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

    // SERVICES
    public VenFacturasService getVenFacturasServiceImpl() {
        return venFacturasServiceImpl;
    }

    public void setVenFacturasServiceImpl(VenFacturasService venFacturasServiceImpl) {
        this.venFacturasServiceImpl = venFacturasServiceImpl;
    }

    public CobClienteService getCobClienteServiceImpl() {
        return cobClienteServiceImpl;
    }

    public void setCobClienteServiceImpl(CobClienteService cobClienteServiceImpl) {
        this.cobClienteServiceImpl = cobClienteServiceImpl;
    }

    public StoArticuloService getStoArticuloServiceImpl() {
        return stoArticuloServiceImpl;
    }

    public void setStoArticuloServiceImpl(StoArticuloService stoArticuloServiceImpl) {
        this.stoArticuloServiceImpl = stoArticuloServiceImpl;
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

    public VenCondicionVentaService getVenCondicionVentaServiceImpl() {
        return venCondicionVentaServiceImpl;
    }

    public void setVenCondicionVentaServiceImpl(VenCondicionVentaService venCondicionVentaServiceImpl) {
        this.venCondicionVentaServiceImpl = venCondicionVentaServiceImpl;
    }

    public CobSaldoService getCobSaldoServiceImpl() {
        return cobSaldoServiceImpl;
    }

    public void setCobSaldoServiceImpl(CobSaldoService cobSaldoServiceImpl) {
        this.cobSaldoServiceImpl = cobSaldoServiceImpl;
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

    // METODOS
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
            CommonUtils.redireccionar("/faces/pages/cliente/cobranzas/definicion/CobHabilitacionCaja.xhtml");
        } catch (IOException e) {
            e.printStackTrace();
            LOGGER.error("Ocurrio un error al Guardar", e);
        }
    }

    public void calculaTotalLineaDetalle() {
        BigDecimal existencia = this.stoArticuloServiceImpl.retornaExistenciaArticulo(detalle.getStoArticulo().getId(),
                this.commonsUtilitiesController.getIdEmpresaLogueada());
        if (detalle.getStoArticulo().getIndInventariable().equalsIgnoreCase("S")
                && existencia.compareTo(new BigDecimal(detalle.getCantidad())) < 0) {
            detalle.setStoArticulo(new StoArticulo());
            detalle.setCantidad(1);
            detalle.setCodIva(null);
            detalle.setPrecioUnitario(BigDecimal.ZERO);
            detalle.setMontoLinea(BigDecimal.ZERO);
            stoArticuloSelected = null;
            getStoArticuloSelected();
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    "El Articulo no tiene existencia suficiente.");
            PrimeFaces.current().ajax().update("form:messages", "form:articuloLb", "form:codIvaLb", "form:totalineaLb",
                    "form:precioLb", "form:form:btnAddDetalle");
            return;
        }
        detalle.setMontoLinea(
                detalle.getStoArticulo().getPrecioUnitario().multiply(new BigDecimal(detalle.getCantidad())));
    }

    public void abrirDialogoAddDetalle() {
        detalle = new VenFacturaDetalle();
        detalle.setVenFacturaCabecera(new VenFacturaCabecera());
        detalle.setStoArticulo(new StoArticulo());
    }

    public void eliminaDetalle() {
        venFacturaCabecera.getVenFacturaDetalleList().removeIf(det -> det.equals(detalle));
        this.detalle = null;
        this.venFacturaCabecera.calcularTotales();
        PrimeFaces.current().ajax().update(":form:dt-detalle");
    }

    private void cargaDetalleVenta() {
        if (Objects.isNull(detalle.getCodIva())) {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    "Debe seleccionar un Articulo para definir el tipo impuesto.");
            return;
        }
        if (CollectionUtils.isEmpty(venFacturaCabecera.getVenFacturaDetalleList())) {
            detalle.setNroOrden(1);
        } else {
            Optional<Integer> maxNroOrden = venFacturaCabecera.getVenFacturaDetalleList().stream()
                    .map(VenFacturaDetalle::getNroOrden).max(Integer::compareTo);
            if (maxNroOrden.isPresent()) {
                detalle.setNroOrden(maxNroOrden.get() + 1);
            } else {
                detalle.setNroOrden(1);
            }
        }
        venFacturaCabecera.setMontoTotalGravada(BigDecimal.ZERO);
        venFacturaCabecera.setMontoTotalExenta(BigDecimal.ZERO);
        venFacturaCabecera.setMontoTotalIva(BigDecimal.ZERO);
        venFacturaCabecera.setMontoTotalFactura(BigDecimal.ZERO);

        this.detalle.setEstado(Estado.ACTIVO.getEstado());
        this.detalle.setUsuarioModificacion(this.sessionBean.getUsuarioLogueado().getCodUsuario());
        this.venFacturaCabecera.addDetalle(detalle);
        this.venFacturaCabecera.calcularTotales();
        this.venFacturaCabecera.setCabeceraADetalle();

        detalle = null;
        PrimeFaces.current().ajax().update(":form:dt-detalle", ":form:btnGuardar");
    }

    private void parseaDetalleASaldo(VenFacturaCabecera factura) {
        if (!Objects.isNull(factura)) {

            boolean tipoCondicion = "CON".equalsIgnoreCase(factura.getVenCondicionVenta().getCodCondicion());
            this.listaSaldoAGenerar = new ArrayList<CobSaldo>();
            if (tipoCondicion) {

                /*
                 * TODO: COMENTADO POR QUE FACTURAS AL CONTADO NO VAN A GENERAR SALDOY SE VAN A
                 * COBRAR AL MOMENTO CobSaldo saldo = new CobSaldo();
                 *
                 * saldo.setIdComprobante(factura.getId()); saldo.setTipoComprobante("FACTURA");
                 * saldo.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario()
                 * ); saldo.setNroComprobanteCompleto(factura.getNroFacturaCompleto());
                 *
                 * // montos saldo.setIdCuota(factura.getId()); saldo.setNroCuota(1);
                 * saldo.setMontoCuota(factura.getMontoTotalFactura());
                 * saldo.setSaldoCuota(factura.getMontoTotalFactura());
                 *
                 * saldo.setFechaVencimiento(factura.getFechaFactura());
                 *
                 * saldo.setCobCliente(this.venFacturaCabecera.getCobCliente());
                 * saldo.setBsEmpresa(factura.getBsEmpresa());
                 * this.listaSaldoAGenerar.add(saldo);
                 */
            } else {
                int plazo = factura.getVenCondicionVenta().getPlazo().intValue();
                BigDecimal montoCuota = factura.getMontoTotalFactura()
                        .divide(factura.getVenCondicionVenta().getPlazo());
                LocalDate fechaVencimiento = LocalDate.of(factura.getFechaFactura().getYear(),
                        factura.getFechaFactura().getMonth(), factura.getFechaFactura().getDayOfMonth());
                int diaHabilPrimerVencimiento = fechaVencimiento.getDayOfMonth();
                for (int i = 1; i <= plazo; i++) {
                    CobSaldo saldo = new CobSaldo();

                    saldo.setIdComprobante(factura.getIdComprobante());
                    saldo.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
                    saldo.setTipoComprobante("NCR");
                    saldo.setNroComprobanteCompleto(factura.getNroFacturaCompleto());

                    // montos
                    saldo.setIdCuota(factura.getId());
                    saldo.setNroCuota(i);
                    saldo.setMontoCuota(montoCuota.negate());
                    //TODO: pongo en cero ya que se va aplicar al guardar
                    saldo.setSaldoCuota(BigDecimal.ZERO);

                    saldo.setFechaVencimiento(fechaVencimiento);

                    // otros
                    if (i == 1) {
                        saldo.setFechaVencimiento(fechaVencimiento);
                        fechaVencimiento = fechaVencimiento.plusMonths(1);
                    } else {
                        int ultimoDiaHabilActual = YearMonth.from(fechaVencimiento).atEndOfMonth().getDayOfMonth();
                        if (ultimoDiaHabilActual < diaHabilPrimerVencimiento) {
                            fechaVencimiento = LocalDate.of(fechaVencimiento.getYear(), fechaVencimiento.getMonth(),
                                    ultimoDiaHabilActual);
                            saldo.setFechaVencimiento(fechaVencimiento);
                            fechaVencimiento = LocalDate.of(fechaVencimiento.getYear(),
                                    fechaVencimiento.plusMonths(1).getMonth(), diaHabilPrimerVencimiento);
                        } else if (fechaVencimiento.getMonth() == Month.FEBRUARY) {
                            fechaVencimiento = LocalDate.of(fechaVencimiento.getYear(), fechaVencimiento.getMonth(),
                                    diaHabilPrimerVencimiento);
                            saldo.setFechaVencimiento(fechaVencimiento);
                            fechaVencimiento = LocalDate.of(fechaVencimiento.getYear(),
                                    fechaVencimiento.plusMonths(1).getMonth(), diaHabilPrimerVencimiento);
                        } else {
                            saldo.setFechaVencimiento(fechaVencimiento);
                            fechaVencimiento = fechaVencimiento.plusMonths(1);
                        }
                    }
                    saldo.setCobCliente(this.venFacturaCabecera.getCobCliente());
                    saldo.setBsEmpresa(factura.getBsEmpresa());
                    this.listaSaldoAGenerar.add(saldo);
                }
            }

        }
    }

    public void limpiarDetalle() {
        this.listaSaldoAGenerar = new ArrayList<CobSaldo>();
        venFacturaCabecera.setVenFacturaDetalleList(new ArrayList<VenFacturaDetalle>());
        venFacturaCabecera.setMontoTotalGravada(BigDecimal.ZERO);
        venFacturaCabecera.setMontoTotalExenta(BigDecimal.ZERO);
        venFacturaCabecera.setMontoTotalIva(BigDecimal.ZERO);
        venFacturaCabecera.setMontoTotalFactura(BigDecimal.ZERO);
        PrimeFaces.current().ajax().update(":form:btnLimpiar");
    }

    public void guardar() {
        try {
            if (Objects.isNull(this.venFacturaCabecera.getBsTalonario())
                    || Objects.isNull(this.venFacturaCabecera.getBsTalonario().getId())) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un Talonario.");
                return;
            }
            if (Objects.isNull(this.venFacturaCabecera.getVenCondicionVenta())
                    || Objects.isNull(this.venFacturaCabecera.getVenCondicionVenta().getId())) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                        "Debe seleccionar una Condicion de Venta.");
                return;
            }
            if (CollectionUtils.isEmpty(venFacturaCabecera.getVenFacturaDetalleList())
                    || venFacturaCabecera.getVenFacturaDetalleList().size() == 0) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                        "Debe cargar algun detalle para guardar.");
                return;
            }
            this.venFacturaCabecera.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            this.venFacturaCabecera.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
            if (Objects.isNull(this.venFacturaCabecera.getId())) {
                this.venFacturaCabecera.setIndImpresoBoolean(false);
                this.venFacturaCabecera.setNroFactura(this.venFacturasServiceImpl.calcularNroFacturaDisponible(
                        commonsUtilitiesController.getIdEmpresaLogueada(),
                        this.venFacturaCabecera.getBsTalonario().getId()));
                String formato = "%s-%s-%09d";
                this.venFacturaCabecera.setNroFacturaCompleto(String.format(formato,
                        this.venFacturaCabecera.getBsTalonario().getBsTimbrado().getCodEstablecimiento(),
                        this.venFacturaCabecera.getBsTalonario().getBsTimbrado().getCodExpedicion(),
                        this.venFacturaCabecera.getNroFactura()));
            }
            this.venFacturaCabecera.setCabeceraADetalle();
            VenFacturaCabecera facturaGuardada = this.venFacturasServiceImpl.save(this.venFacturaCabecera);

            if (!Objects.isNull(facturaGuardada)) {
                if (facturaGuardada.getTipoFactura().equalsIgnoreCase("NCR")) {
                    parseaDetalleASaldo(facturaGuardada);
                }
                if (!Objects.isNull(this.cobSaldoServiceImpl.saveAll(listaSaldoAGenerar))) {
                    List<CobSaldo> saldosAsociados = this.cobSaldoServiceImpl
                            .buscarSaldoPorIdComprobantePorTipoComprobantePorCliente(
                                    this.commonsUtilitiesController.getIdEmpresaLogueada(),
                                    this.venFacturaCabecera.getCobCliente().getId(),
                                    this.venFacturaCabecera.getIdComprobante(),
                                    "FACTURA");
                    BigDecimal montoNcPendiente = facturaGuardada.getMontoTotalFactura().abs();
                    for (CobSaldo cuota : saldosAsociados) {
                        if (cuota.getSaldoCuota().compareTo(BigDecimal.ZERO) > 0 && montoNcPendiente.compareTo(BigDecimal.ZERO) > 0) {
                            // El monto a restar es el menor entre el saldo de la cuota y lo que resta de la NC
                            BigDecimal aRestar = cuota.getSaldoCuota().min(montoNcPendiente);
                            cuota.setSaldoCuota(cuota.getSaldoCuota().subtract(aRestar));
                            montoNcPendiente = montoNcPendiente.subtract(aRestar);
                        }
                    }
                    if (!Objects.isNull(this.cobSaldoServiceImpl.saveAll(saldosAsociados))) {
                        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                                "El registro se guardo correctamente.");
                    } else {
                        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                                "No se Pudieron actualizar los saldos.");
                    }

                } else {
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                            "No se Pudieron crear los saldos.");
                }

            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_FATAL, "¡ERROR!", "No se pudo insertar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            e.printStackTrace(System.err);

            Throwable cause = e.getCause();
            while (cause != null) {
                if (cause instanceof ConstraintViolationException) {
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "La factura ya fue creada.");
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
            if (Objects.isNull("S".equalsIgnoreCase(this.venFacturaCabecera.getIndImpreso()))) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Ya fue impreso.");
                return;
            }
            if (!Objects.isNull(this.venFacturaCabecera)) {
                this.venFacturasServiceImpl.deleteById(this.venFacturaCabecera.getId());
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se elimino correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            // e.printStackTrace(System.err);
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
                this.generarReporte.procesarReporte(parametrosReporte);
                if (this.utilsService.actualizarRegistro("ven_facturas_cabecera", "ind_impreso = 'S'",
                        " bs_empresa_id = " + commonsUtilitiesController.getIdEmpresaLogueada() + " and id = " + this.venFacturaCabecera.getId())) {
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
            LOGGER.error("Ocurrio un error al Guardar", e);
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
        this.parametrosReporte.getParametros().add(ApplicationConstant.SUB_PARAM_REPORT_DIR);

        this.parametrosReporte.getValores().add(ApplicationConstant.PATH_IMAGEN_EMPRESA);
        this.parametrosReporte.getValores().add(ApplicationConstant.IMAGEN_EMPRESA_NAME);
        this.parametrosReporte.getValores()
                .add(this.sessionBean.getUsuarioLogueado().getBsPersona().getNombreCompleto());
        this.parametrosReporte.getValores().add(formattedDateTimeDiaHora);
        this.parametrosReporte.getValores()
                .add(this.sessionBean.getUsuarioLogueado().getBsEmpresa().getNombreFantasia());
        this.parametrosReporte.getValores().add(ApplicationConstant.SUB_REPORT_DIR);
        // basico

        DateTimeFormatter formatToDateParam = DateTimeFormatter.ofPattern("dd/MM/yyy");
        // key
        this.parametrosReporte.getParametros().add("p_empresa_id");
        this.parametrosReporte.getParametros().add("p_factura_id");

        // values
        this.parametrosReporte.getValores().add(this.commonsUtilitiesController.getIdEmpresaLogueada());
        this.parametrosReporte.getValores().add(this.venFacturaCabecera.getId());

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

    public void execute() {
        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                "Se imprimio correctamente.");
        PrimeFaces.current().ajax().update(":form:messages");
    }


}
