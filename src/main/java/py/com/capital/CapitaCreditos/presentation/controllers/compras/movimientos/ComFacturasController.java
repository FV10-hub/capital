package py.com.capital.CapitaCreditos.presentation.controllers.compras.movimientos;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsIva;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobSaldo;
import py.com.capital.CapitaCreditos.entities.compras.ComFacturaCabecera;
import py.com.capital.CapitaCreditos.entities.compras.ComFacturaDetalle;
import py.com.capital.CapitaCreditos.entities.compras.ComProveedor;
import py.com.capital.CapitaCreditos.entities.compras.ComSaldo;
import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;
import py.com.capital.CapitaCreditos.entities.ventas.VenFacturaDetalle;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.UtilsService;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;
import py.com.capital.CapitaCreditos.services.compras.ComFacturasService;
import py.com.capital.CapitaCreditos.services.compras.ComProveedorService;
import py.com.capital.CapitaCreditos.services.compras.ComSaldoService;
import py.com.capital.CapitaCreditos.services.stock.StoArticuloService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Scope(ViewScope.SCOPE_VIEW)
public class ComFacturasController {
    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */
    private static final Logger LOGGER = LogManager.getLogger(ComFacturasController.class);

    //objetos
    private ComFacturaCabecera comFacturaCabecera, comFacturaCabeceraSelected;
    private ComFacturaDetalle comFacturaDetalle;
    private StoArticulo stoArticuloSelected;

    //lazy
    private LazyDataModel<ComFacturaCabecera> lazyModel;
    private LazyDataModel<StoArticulo> lazyModelArticulos;
    private LazyDataModel<ComProveedor> lazyModelProveedor;

    //listas
    List<ComSaldo> listaSaldoAGenerar;

    //atributos
    private List<String> estadoList;
    private boolean esNuegoRegistro;
    private boolean esVisibleFormulario = true;
    private boolean estaPagado;


    private static final String DT_NAME = "dt-facturas";

    //beans
    @Autowired
    private ComFacturasService comFacturasServiceImpl;

    @Autowired
    private ComProveedorService comProveedorServiceImpl;

    @Autowired
    private BsModuloService bsModuloServiceImpl;

    @Autowired
    private ComSaldoService comSaldoServiceImpl;


    @Autowired
    private StoArticuloService stoArticuloServiceImpl;

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
        this.comFacturaCabecera = null;
        this.comFacturaCabeceraSelected = null;
        this.stoArticuloSelected = null;
        this.comFacturaDetalle = null;
        this.lazyModel = null;
        this.lazyModelArticulos = null;
        this.lazyModelProveedor = null;

        this.esNuegoRegistro = true;
        this.estaPagado = false;
        this.esVisibleFormulario = !esVisibleFormulario;
        this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado(), "ANULADO");
        this.listaSaldoAGenerar = new ArrayList<ComSaldo>();
    }

    //getters y setters
    public ComFacturaCabecera getComFacturaCabecera() {
        if (Objects.isNull(comFacturaCabecera)) {
            comFacturaCabecera = new ComFacturaCabecera();
            comFacturaCabecera.setFechaFactura(LocalDate.now());
            comFacturaCabecera.setIndPagado("N");
            comFacturaCabecera.setTipoFactura("FACTURA");
            comFacturaCabecera.setEstado(Estado.ACTIVO.getEstado());
            comFacturaCabecera.setBsEmpresa(new BsEmpresa());
            comFacturaCabecera.setComProveedor(new ComProveedor());
            comFacturaCabecera.getComProveedor().setBsPersona(new BsPersona());

        }
        return comFacturaCabecera;
    }

    public void setComFacturaCabecera(ComFacturaCabecera comFacturaCabecera) {
        this.comFacturaCabecera = comFacturaCabecera;
    }

    public ComFacturaCabecera getComFacturaCabeceraSelected() {
        if (Objects.isNull(comFacturaCabeceraSelected)) {
            comFacturaCabeceraSelected = new ComFacturaCabecera();
            comFacturaCabeceraSelected.setFechaFactura(LocalDate.now());
            comFacturaCabeceraSelected.setIndPagado("N");
            comFacturaCabeceraSelected.setTipoFactura("FACTURA");
            comFacturaCabeceraSelected.setEstado(Estado.ACTIVO.getEstado());
            comFacturaCabeceraSelected.setBsEmpresa(new BsEmpresa());
            comFacturaCabeceraSelected.setComProveedor(new ComProveedor());
            comFacturaCabeceraSelected.getComProveedor().setBsPersona(new BsPersona());

        }
        return comFacturaCabeceraSelected;
    }

    public void setComFacturaCabeceraSelected(ComFacturaCabecera comFacturaCabeceraSelected) {
        if (!Objects.isNull(comFacturaCabeceraSelected)) {
            comFacturaCabeceraSelected.getComFacturaDetalleList()
                    .sort(Comparator.comparing(ComFacturaDetalle::getNroOrden));
            this.estaPagado = comFacturaCabeceraSelected.getIndPagado().equalsIgnoreCase("S");
            if (this.estaPagado) {
            }
            comFacturaCabecera = comFacturaCabeceraSelected;
            comFacturaCabeceraSelected = null;
            this.esNuegoRegistro = false;
            this.esVisibleFormulario = true;
        }
        this.comFacturaCabeceraSelected = comFacturaCabeceraSelected;
    }

    public ComFacturaDetalle getComFacturaDetalle() {
        if (Objects.isNull(comFacturaDetalle)) {
            comFacturaDetalle = new ComFacturaDetalle();
            comFacturaDetalle.setComFacturaCabecera(new ComFacturaCabecera());
            comFacturaDetalle.setStoArticulo(new StoArticulo());
        }
        return comFacturaDetalle;
    }

    public void setComFacturaDetalle(ComFacturaDetalle comFacturaDetalle) {
        this.comFacturaDetalle = comFacturaDetalle;
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

    public boolean isEstaPagado() {
        return estaPagado;
    }

    public void setEstaPagado(boolean estaPagado) {
        this.estaPagado = estaPagado;
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
            this.comFacturaDetalle.setStoArticulo(stoArticuloSelected);
            this.comFacturaDetalle.setCantidad(1);
            this.comFacturaDetalle.setCodIva(stoArticuloSelected.getBsIva().getCodIva());
            this.comFacturaDetalle.setPrecioUnitario(stoArticuloSelected.getPrecioUnitario());
            this.comFacturaDetalle.setMontoLinea(stoArticuloSelected.getPrecioUnitario());
        }
        this.stoArticuloSelected = stoArticuloSelected;
    }

    public ComFacturasService getComFacturasServiceImpl() {
        return comFacturasServiceImpl;
    }

    public void setComFacturasServiceImpl(ComFacturasService comFacturasServiceImpl) {
        this.comFacturasServiceImpl = comFacturasServiceImpl;
    }

    public ComProveedorService getComProveedorServiceImpl() {
        return comProveedorServiceImpl;
    }

    public void setComProveedorServiceImpl(ComProveedorService comProveedorServiceImpl) {
        this.comProveedorServiceImpl = comProveedorServiceImpl;
    }

    public BsModuloService getBsModuloServiceImpl() {
        return bsModuloServiceImpl;
    }

    public void setBsModuloServiceImpl(BsModuloService bsModuloServiceImpl) {
        this.bsModuloServiceImpl = bsModuloServiceImpl;
    }

    public ComSaldoService getComSaldoServiceImpl() {
        return comSaldoServiceImpl;
    }

    public void setComSaldoServiceImpl(ComSaldoService comSaldoServiceImpl) {
        this.comSaldoServiceImpl = comSaldoServiceImpl;
    }

    public StoArticuloService getStoArticuloServiceImpl() {
        return stoArticuloServiceImpl;
    }

    public void setStoArticuloServiceImpl(StoArticuloService stoArticuloServiceImpl) {
        this.stoArticuloServiceImpl = stoArticuloServiceImpl;
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

    public SessionBean getSessionBean() {
        return sessionBean;
    }

    public void setSessionBean(SessionBean sessionBean) {
        this.sessionBean = sessionBean;
    }

    //lazy

    public LazyDataModel<ComFacturaCabecera> getLazyModel() {
        if (Objects.isNull(lazyModel)) {
            // ordena la lista por fecha y por nroComprobante DESC
            List<ComFacturaCabecera> listaOrdenada = comFacturasServiceImpl
                    .buscarComFacturaCabeceraActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada())
                    .stream()
                    .sorted(Comparator.comparing(ComFacturaCabecera::getFechaFactura).reversed()
                            .thenComparing(Comparator.comparing(ComFacturaCabecera::getNroFacturaCompleto).reversed()))
                    .collect(Collectors.toList());
            lazyModel = new GenericLazyDataModel<ComFacturaCabecera>((List<ComFacturaCabecera>) listaOrdenada);
        }
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<ComFacturaCabecera> lazyModel) {
        this.lazyModel = lazyModel;
    }

    public LazyDataModel<StoArticulo> getLazyModelArticulos() {
        if (Objects.isNull(lazyModelArticulos)) {
            List<StoArticulo> listaFiltrada = (List<StoArticulo>) stoArticuloServiceImpl
                    .buscarStoArticuloActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()).stream()
                    .filter(articulo -> "S".equals(articulo.getIndInventariable())).collect(Collectors.toList());
            lazyModelArticulos = new GenericLazyDataModel<StoArticulo>(listaFiltrada);
        }
        return lazyModelArticulos;
    }

    public void setLazyModelArticulos(LazyDataModel<StoArticulo> lazyModelArticulos) {
        this.lazyModelArticulos = lazyModelArticulos;
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

    public void calculaTotalLineaDetalle() {
        comFacturaDetalle.setMontoLinea(
                comFacturaDetalle.getStoArticulo().getPrecioUnitario().multiply(new BigDecimal(comFacturaDetalle.getCantidad())));
    }

    public void agregarDetalle() {
        if (StringUtils.equalsIgnoreCase("NCR", comFacturaCabecera.getTipoFactura())) {
            // TODO: aca debo implementar notas de creditos
            return;
        }
        cargaDetalle();
    }

    private void cargaDetalle() {
        if (Objects.isNull(comFacturaDetalle.getCodIva())) {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    "Debe seleccionar un Articulo para definir el tipo impuesto.");
            return;
        }
        if (CollectionUtils.isEmpty(comFacturaCabecera.getComFacturaDetalleList())) {
            comFacturaDetalle.setNroOrden(1);
        } else {
            Optional<Integer> maxNroOrden = comFacturaCabecera.getComFacturaDetalleList().stream()
                    .map(ComFacturaDetalle::getNroOrden).max(Integer::compareTo);
            if (maxNroOrden.isPresent()) {
                comFacturaDetalle.setNroOrden(maxNroOrden.get() + 1);
            } else {
                comFacturaDetalle.setNroOrden(1);
            }
        }
        comFacturaCabecera.setMontoTotalGravada(BigDecimal.ZERO);
        comFacturaCabecera.setMontoTotalExenta(BigDecimal.ZERO);
        comFacturaCabecera.setMontoTotalIva(BigDecimal.ZERO);
        comFacturaCabecera.setMontoTotalFactura(BigDecimal.ZERO);

        this.comFacturaDetalle.setEstado(Estado.ACTIVO.getEstado());
        this.comFacturaDetalle.setUsuarioModificacion(this.sessionBean.getUsuarioLogueado().getCodUsuario());
        this.comFacturaCabecera.addDetalle(comFacturaDetalle);
        this.comFacturaCabecera.calcularTotales();
        this.comFacturaCabecera.setCabeceraADetalle();

        comFacturaDetalle = null;
        PrimeFaces.current().ajax().update(":form:dt-comFacturaDetalle", ":form:btnGuardar", ":form:btnLimpiar");
    }

    public void abrirDialogoAddDetalle() {
        comFacturaDetalle = new ComFacturaDetalle();
        comFacturaDetalle.setComFacturaCabecera(new ComFacturaCabecera());
        comFacturaDetalle.setStoArticulo(new StoArticulo());
    }

    public void eliminaDetalle() {
        comFacturaCabecera.getComFacturaDetalleList().removeIf(det -> det.equals(comFacturaDetalle));
        this.comFacturaDetalle = null;
        this.comFacturaCabecera.calcularTotales();
        PrimeFaces.current().ajax().update(":form:dt-comFacturaDetalle", ":form:btnGuardar", ":form:btnLimpiar");
    }

    public void limpiarDetalle() {
        this.listaSaldoAGenerar = new ArrayList<ComSaldo>();
        this.comFacturaCabecera.setComFacturaDetalleList(new ArrayList<ComFacturaDetalle>());
        this.comFacturaCabecera.setMontoTotalGravada(BigDecimal.ZERO);
        this.comFacturaCabecera.setMontoTotalExenta(BigDecimal.ZERO);
        this.comFacturaCabecera.setMontoTotalIva(BigDecimal.ZERO);
        this.comFacturaCabecera.setMontoTotalFactura(BigDecimal.ZERO);
        PrimeFaces.current().ajax().update(":form:btnLimpiar");
    }

    private void prepararSaldoAGenerarCredito() {
        if (!Objects.isNull(this.comFacturaCabecera)) {
            ComSaldo saldo = new ComSaldo();

            saldo.setIdComprobate(comFacturaCabecera.getId());
            saldo.setTipoComprobante("FACTURA");
            saldo.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            saldo.setNroComprobanteCompleto(this.comFacturaCabecera.getNroFacturaCompleto());

            // montos
            saldo.setNroCuota(1);
            saldo.setMontoCuota(this.comFacturaCabecera.getMontoTotalFactura());
            saldo.setSaldoCuota(this.comFacturaCabecera.getMontoTotalFactura());

            // otros
            saldo.setFechaVencimiento(LocalDate.now());
            saldo.setComProveedor(this.comFacturaCabecera.getComProveedor());
            saldo.setBsEmpresa(this.comFacturaCabecera.getBsEmpresa());
            this.listaSaldoAGenerar.add(saldo);
        }
    }

    public void guardar() {
        try {
            if (CollectionUtils.isEmpty(comFacturaCabecera.getComFacturaDetalleList())
                    || comFacturaCabecera.getComFacturaDetalleList().size() == 0) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                        "Debe cargar algun detalle para guardar.");
                return;
            }
            this.comFacturaCabecera.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            this.comFacturaCabecera.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());

            ComFacturaCabecera facturaGuardada = this.comFacturasServiceImpl.save(this.comFacturaCabecera);

            if (!Objects.isNull(facturaGuardada)) {

                if (!facturaGuardada.getEstado().equalsIgnoreCase("ANULADO")){
                    this.prepararSaldoAGenerarCredito();
                    this.comSaldoServiceImpl.save(this.listaSaldoAGenerar.stream().findFirst().get());
                }
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se guardo correctamente.");

            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_FATAL, "¡ERROR!", "No se pudo insertar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", System.err);
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
            if (!Objects.isNull(this.comFacturaCabecera)) {
                this.comFacturasServiceImpl.deleteById(this.comFacturaCabecera.getId());
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se elimino correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", System.err);
            // e.printStackTrace(System.err);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    e.getMessage().substring(0, e.getMessage().length()) + "...");
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
