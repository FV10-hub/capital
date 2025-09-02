package py.com.capital.CapitaCreditos.presentation.controllers.creditos.movimientos;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.entities.creditos.CreMotivoPrestamo;
import py.com.capital.CapitaCreditos.entities.creditos.CreSolicitudCredito;
import py.com.capital.CapitaCreditos.entities.ventas.VenVendedor;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.cobranzas.CobClienteService;
import py.com.capital.CapitaCreditos.services.creditos.CreMotivoPrestamoService;
import py.com.capital.CapitaCreditos.services.creditos.CreSolicitudCreditoService;
import py.com.capital.CapitaCreditos.services.ventas.VenVendedorService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

/*
 * 27 dic. 2023 - Elitebook
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class CreSolicitudCreditoController {

    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */
    private static final Logger LOGGER = LogManager.getLogger(CreSolicitudCreditoController.class);

    private CreSolicitudCredito creSolicitudCredito, creSolicitudCreditoSelected;
    private CreMotivoPrestamo creMotivoPrestamoSelected;
    private VenVendedor venVendedorSelected;
    private CobCliente cobClienteSelected;
    private LazyDataModel<CreSolicitudCredito> lazyModel;
    private LazyDataModel<CobCliente> lazyModelCliente;
    private LazyDataModel<VenVendedor> lazyModelVenVendedor;
    private LazyDataModel<CreMotivoPrestamo> lazyModelCreMotivoPrestamo;
    private List<String> estadoList;
    private boolean esNuegoRegistro;

    private static final String DT_NAME = "dt-solicitud";
    private static final String DT_DIALOG_NAME = "manageSolicitudDialog";

    @Autowired
    private CreSolicitudCreditoService creSolicitudCreditoServiceImpl;

    @Autowired
    private CreMotivoPrestamoService creMotivoPrestamoServiceImpl;

    @Autowired
    private CobClienteService cobClienteServiceImpl;

    @Autowired
    private VenVendedorService venVendedorServiceImpl;

    /**
     * Propiedad de la logica de negocio inyectada con JSF y Spring.
     */
    private boolean puedeCrear, puedeEditar, puedeEliminar = false;
    @Autowired
    private SessionBean sessionBean;

    @PostConstruct
    public void init() {
        this.cleanFields();
        this.sessionBean.cargarPermisos();
        puedeCrear = sessionBean.tienePermiso(getPaginaActual(), "CREAR");
        puedeEditar = sessionBean.tienePermiso(getPaginaActual(), "EDITAR");
        puedeEliminar = sessionBean.tienePermiso(getPaginaActual(), "ELIMINAR");
    }

    public void cleanFields() {
        this.creSolicitudCredito = null;
        this.creSolicitudCreditoSelected = null;
        this.creMotivoPrestamoSelected = null;
        this.venVendedorSelected = null;
        this.cobClienteSelected = null;
        this.lazyModel = null;
        this.lazyModelCliente = null;
        this.lazyModelVenVendedor = null;
        this.lazyModelCreMotivoPrestamo = null;
        this.esNuegoRegistro = true;
        this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
    }

    public CreSolicitudCredito getCreSolicitudCredito() {
        if (Objects.isNull(creSolicitudCredito)) {
            this.creSolicitudCredito = new CreSolicitudCredito();
            this.creSolicitudCredito.setFechaSolicitud(LocalDate.now());
            this.creSolicitudCredito.setPrimerVencimiento(LocalDate.now());
            this.creSolicitudCredito.setEstado(Estado.ACTIVO.getEstado());
            this.creSolicitudCredito.setBsEmpresa(new BsEmpresa());
            this.creSolicitudCredito.setCobCliente(new CobCliente());
            this.creSolicitudCredito.getCobCliente().setBsPersona(new BsPersona());
            this.creSolicitudCredito.setVenVendedor(new VenVendedor());
            this.creSolicitudCredito.getVenVendedor().setBsPersona(new BsPersona());
            this.creSolicitudCredito.setCreMotivoPrestamo(new CreMotivoPrestamo());
        }
        return creSolicitudCredito;
    }

    public void setCreSolicitudCredito(CreSolicitudCredito creSolicitudCredito) {
        this.creSolicitudCredito = creSolicitudCredito;
    }

    public CreSolicitudCredito getCreSolicitudCreditoSelected() {
        if (Objects.isNull(creSolicitudCreditoSelected)) {
            this.creSolicitudCreditoSelected = new CreSolicitudCredito();
            this.creSolicitudCreditoSelected.setFechaSolicitud(LocalDate.now());
            this.creSolicitudCreditoSelected.setPrimerVencimiento(LocalDate.now());
            this.creSolicitudCreditoSelected.setBsEmpresa(new BsEmpresa());
            this.creSolicitudCreditoSelected.setCobCliente(new CobCliente());
            this.creSolicitudCreditoSelected.getCobCliente().setBsPersona(new BsPersona());
            this.creSolicitudCreditoSelected.setVenVendedor(new VenVendedor());
            this.creSolicitudCreditoSelected.getVenVendedor().setBsPersona(new BsPersona());
            this.creSolicitudCreditoSelected.setCreMotivoPrestamo(new CreMotivoPrestamo());
        }
        return creSolicitudCreditoSelected;
    }

    public void setCreSolicitudCreditoSelected(CreSolicitudCredito creSolicitudCreditoSelected) {
        if (!Objects.isNull(creSolicitudCreditoSelected)) {
            this.creSolicitudCredito = creSolicitudCreditoSelected;
            creSolicitudCreditoSelected = null;
            this.esNuegoRegistro = false;
        }
        this.creSolicitudCreditoSelected = creSolicitudCreditoSelected;
    }

    public CreMotivoPrestamo getCreMotivoPrestamoSelected() {
        if (Objects.isNull(creMotivoPrestamoSelected)) {
            this.creMotivoPrestamoSelected = new CreMotivoPrestamo();
        }
        return creMotivoPrestamoSelected;
    }

    public void setCreMotivoPrestamoSelected(CreMotivoPrestamo creMotivoPrestamoSelected) {
        if (!Objects.isNull(creMotivoPrestamoSelected)) {
            this.creSolicitudCredito.setCreMotivoPrestamo(creMotivoPrestamoSelected);
        }
        this.creMotivoPrestamoSelected = creMotivoPrestamoSelected;
    }

    public VenVendedor getVenVendedorSelected() {
        if (Objects.isNull(venVendedorSelected)) {
            this.venVendedorSelected = new VenVendedor();
            this.venVendedorSelected.setBsEmpresa(new BsEmpresa());
            this.venVendedorSelected.setBsPersona(new BsPersona());
        }
        return venVendedorSelected;
    }

    public void setVenVendedorSelected(VenVendedor venVendedorSelected) {
        if (!Objects.isNull(venVendedorSelected)) {
            this.creSolicitudCredito.setVenVendedor(venVendedorSelected);
        }
        this.venVendedorSelected = venVendedorSelected;
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
            this.creSolicitudCredito.setCobCliente(cobClienteSelected);
        }
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

    // SERVICES
    public CreSolicitudCreditoService getCreSolicitudCreditoServiceImpl() {
        return creSolicitudCreditoServiceImpl;
    }

    public void setCreSolicitudCreditoServiceImpl(CreSolicitudCreditoService creSolicitudCreditoServiceImpl) {
        this.creSolicitudCreditoServiceImpl = creSolicitudCreditoServiceImpl;
    }

    public CreMotivoPrestamoService getCreMotivoPrestamoServiceImpl() {
        return creMotivoPrestamoServiceImpl;
    }

    public void setCreMotivoPrestamoServiceImpl(CreMotivoPrestamoService creMotivoPrestamoServiceImpl) {
        this.creMotivoPrestamoServiceImpl = creMotivoPrestamoServiceImpl;
    }

    public CobClienteService getCobClienteServiceImpl() {
        return cobClienteServiceImpl;
    }

    public void setCobClienteServiceImpl(CobClienteService cobClienteServiceImpl) {
        this.cobClienteServiceImpl = cobClienteServiceImpl;
    }

    public VenVendedorService getVenVendedorServiceImpl() {
        return venVendedorServiceImpl;
    }

    public void setVenVendedorServiceImpl(VenVendedorService venVendedorServiceImpl) {
        this.venVendedorServiceImpl = venVendedorServiceImpl;
    }

    public SessionBean getSessionBean() {
        return sessionBean;
    }

    public void setSessionBean(SessionBean sessionBean) {
        this.sessionBean = sessionBean;
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
    public LazyDataModel<CreSolicitudCredito> getLazyModel() {
        if (Objects.isNull(lazyModel)) {
            lazyModel = new GenericLazyDataModel<CreSolicitudCredito>(
                    (List<CreSolicitudCredito>) creSolicitudCreditoServiceImpl
                            .buscarSolicitudActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
        }
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<CreSolicitudCredito> lazyModel) {
        this.lazyModel = lazyModel;
    }

    public LazyDataModel<CobCliente> getLazyModelCliente() {
        if (Objects.isNull(lazyModelCliente)) {
            lazyModelCliente = new GenericLazyDataModel<CobCliente>((List<CobCliente>) cobClienteServiceImpl
                    .buscarClienteActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
        }
        return lazyModelCliente;
    }

    public void setLazyModelCliente(LazyDataModel<CobCliente> lazyModelCliente) {
        this.lazyModelCliente = lazyModelCliente;
    }

    public LazyDataModel<VenVendedor> getLazyModelVenVendedor() {
        if (Objects.isNull(lazyModelVenVendedor)) {
            lazyModelVenVendedor = new GenericLazyDataModel<VenVendedor>((List<VenVendedor>) venVendedorServiceImpl
                    .buscarVenVendedorActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
        }
        return lazyModelVenVendedor;
    }

    public void setLazyModelVenVendedor(LazyDataModel<VenVendedor> lazyModelVenVendedor) {
        this.lazyModelVenVendedor = lazyModelVenVendedor;
    }

    public LazyDataModel<CreMotivoPrestamo> getLazyModelCreMotivoPrestamo() {
        if (Objects.isNull(lazyModelCreMotivoPrestamo)) {
            lazyModelCreMotivoPrestamo = new GenericLazyDataModel<CreMotivoPrestamo>(
                    creMotivoPrestamoServiceImpl.buscarCreMotivoPrestamoActivosLista());
        }
        return lazyModelCreMotivoPrestamo;
    }

    public void setLazyModelCreMotivoPrestamo(LazyDataModel<CreMotivoPrestamo> lazyModelCreMotivoPrestamo) {
        this.lazyModelCreMotivoPrestamo = lazyModelCreMotivoPrestamo;
    }

    // METODOS
    public void seteaMismoValor() {
        this.creSolicitudCredito.setMontoAprobado(this.creSolicitudCredito.getMontoSolicitado());
    }

    public void guardar() {
        try {
            if (Objects.isNull(this.creSolicitudCredito.getCobCliente()) || Objects.isNull(this.creSolicitudCredito.getCobCliente().getId())) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un Cliente.");
                return;
            }
            if (Objects.isNull(this.creSolicitudCredito.getVenVendedor()) || Objects.isNull(this.creSolicitudCredito.getVenVendedor().getId())) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un Vendedor.");
                return;
            }
            this.creSolicitudCredito.setIndDesembolsado("N");
            this.creSolicitudCredito.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            this.creSolicitudCredito.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
            if (!Objects.isNull(this.creSolicitudCreditoServiceImpl.save(creSolicitudCredito))) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se guardo correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().executeScript("PF('" + DT_DIALOG_NAME + "').hide()");
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", System.err);
            // e.printStackTrace(System.err);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    e.getMessage().substring(0, e.getMessage().length()) + "...");
        }

    }

    public void delete() {
        try {
            if (!Objects.isNull(this.creSolicitudCredito)) {
                this.creSolicitudCreditoServiceImpl.deleteById(this.creSolicitudCredito.getId());
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
