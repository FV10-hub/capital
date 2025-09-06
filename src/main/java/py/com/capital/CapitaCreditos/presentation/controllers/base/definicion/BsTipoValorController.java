package py.com.capital.CapitaCreditos.presentation.controllers.base.definicion;

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
import py.com.capital.CapitaCreditos.entities.base.BsModulo;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;
import py.com.capital.CapitaCreditos.services.base.BsTipoValorService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import java.util.List;
import java.util.Objects;

/*
 * 30 nov. 2023 - Elitebook
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class BsTipoValorController {

    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */
    private static final Logger LOGGER = LogManager.getLogger(BsTipoValorController.class);

    private BsTipoValor bsTipoValor, bsTipoValorSelected;
    private LazyDataModel<BsTipoValor> lazyModel;
    private LazyDataModel<BsModulo> lazyModuloList;

    private BsModulo bsModuloSelected;
    private boolean esNuegoRegistro;

    private List<String> estadoList;

    private static final String DT_NAME = "dt-tipovalor";
    private static final String DT_DIALOG_NAME = "manageTipoValorDialog";

    @Autowired
    private BsModuloService bsModuloServiceImpl;

    @Autowired
    private BsTipoValorService bsTipoValorServiceImpl;

    /**
     * Propiedad de la logica de negocio inyectada con JSF y Spring.
     */
    @Autowired
    private SessionBean sessionBean;

    @PostConstruct
    public void init() {
        this.cleanFields();

    }

    public void cleanFields() {
        this.bsTipoValor = null;
        this.bsTipoValorSelected = null;
        this.bsModuloSelected = null;
        this.esNuegoRegistro = true;

        this.lazyModel = null;
        this.lazyModuloList = null;

        this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
    }

    // GETTERS Y SETTERS
    public BsTipoValor getBsTipoValor() {
        if (Objects.isNull(bsTipoValor)) {
            this.bsTipoValor = new BsTipoValor();
            this.bsTipoValor.setEstado(Estado.ACTIVO.getEstado());
            this.bsTipoValor.setBsEmpresa(new BsEmpresa());
            this.bsTipoValor.setBsModulo(new BsModulo());
        }
        return bsTipoValor;
    }

    public void setBsTipoValor(BsTipoValor bsTipoValor) {
        this.bsTipoValor = bsTipoValor;
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
        if (!Objects.isNull(bsTipoValorSelected)) {
            this.bsTipoValor = bsTipoValorSelected;
            bsTipoValorSelected = null;
            this.esNuegoRegistro = false;
        }
        this.bsTipoValorSelected = bsTipoValorSelected;
    }

    public boolean isEsNuegoRegistro() {
        return esNuegoRegistro;
    }

    public void setEsNuegoRegistro(boolean esNuegoRegistro) {
        this.esNuegoRegistro = esNuegoRegistro;
    }

    public List<String> getEstadoList() {
        return estadoList;
    }

    public void setEstadoList(List<String> estadoList) {
        this.estadoList = estadoList;
    }

    public BsModuloService getBsModuloServiceImpl() {
        return bsModuloServiceImpl;
    }

    public void setBsModuloServiceImpl(BsModuloService bsModuloServiceImpl) {
        this.bsModuloServiceImpl = bsModuloServiceImpl;
    }

    public BsTipoValorService getBsTipoValorServiceImpl() {
        return bsTipoValorServiceImpl;
    }

    public void setBsTipoValorServiceImpl(BsTipoValorService bsTipoValorServiceImpl) {
        this.bsTipoValorServiceImpl = bsTipoValorServiceImpl;
    }

    public SessionBean getSessionBean() {
        return sessionBean;
    }

    public void setSessionBean(SessionBean sessionBean) {
        this.sessionBean = sessionBean;
    }

    public BsModulo getBsModuloSelected() {
        if (Objects.isNull(bsModuloSelected)) {
            bsModuloSelected = new BsModulo();
        }
        return bsModuloSelected;
    }

    public void setBsModuloSelected(BsModulo bsModuloSelected) {
        if (!Objects.isNull(bsModuloSelected.getId())) {
            this.bsTipoValor.setBsModulo(bsModuloSelected);
            bsModuloSelected = null;
        }
        this.bsModuloSelected = bsModuloSelected;
    }

    // LAZY
    public LazyDataModel<BsTipoValor> getLazyModel() {
        if (Objects.isNull(lazyModel)) {
            lazyModel = new GenericLazyDataModel<BsTipoValor>((List<BsTipoValor>) bsTipoValorServiceImpl
                    .buscarTipoValorActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
        }
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<BsTipoValor> lazyModel) {
        this.lazyModel = lazyModel;
    }

    public LazyDataModel<BsModulo> getLazyModuloList() {
        if (Objects.isNull(lazyModuloList)) {
            lazyModuloList = new GenericLazyDataModel<BsModulo>(
                    (List<BsModulo>) bsModuloServiceImpl.buscarModulosActivosLista());
        }
        return lazyModuloList;
    }

    public void setLazyModuloList(LazyDataModel<BsModulo> lazyModuloList) {
        this.lazyModuloList = lazyModuloList;
    }

    // METODOS
    public void guardar() {
        if (Objects.isNull(bsTipoValor.getBsModulo()) || Objects.isNull(bsTipoValor.getBsModulo().getId())) {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar una Modulo.");
            return;
        }
        try {
            this.bsTipoValor.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
            this.bsTipoValor.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            if (!Objects.isNull(bsTipoValorServiceImpl.save(this.bsTipoValor))) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se guardo correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().executeScript("PF('" + DT_DIALOG_NAME + "').hide()");
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            e.printStackTrace(System.err);

            Throwable cause = e.getCause();
            while (cause != null) {
                if (cause instanceof ConstraintViolationException) {
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                            "El tipo de comprobante ya existe.");
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
            if (!Objects.isNull(this.bsTipoValor)) {
                this.bsTipoValorServiceImpl.deleteById(this.bsTipoValor.getId());
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se elimino correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al eliminar", System.err);
            // e.printStackTrace(System.err);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    e.getMessage().substring(0, e.getMessage().length()) + "...");
        }

    }

}
