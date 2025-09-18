package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.definicion;

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
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesChequera;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.presentation.utils.Modulos;
import py.com.capital.CapitaCreditos.services.base.BsTipoValorService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesChequeraService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import java.math.BigInteger;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/*
 * 2 ene. 2024 - Elitebook
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class TesChequeraController {

    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */
    private static final Logger LOGGER = LogManager.getLogger(TesChequeraController.class);

    private TesChequera tesChequera, tesChequeraSelected;
    private LazyDataModel<TesChequera> lazyModel;
    private LazyDataModel<TesBanco> lazyModelBanco;
    private LazyDataModel<BsTipoValor> lazyModelTipoValor;

    private boolean esNuegoRegistro;

    private List<String> estadoList;

    private static final String DT_NAME = "dt-chequera";
    private static final String DT_DIALOG_NAME = "manageChequeraDialog";

    @Autowired
    private BsTipoValorService bsTipoValorServiceImpl;

    @Autowired
    private TesBancoService tesBancoServiceImpl;

    @Autowired
    private TesChequeraService tesChequeraServiceImpl;

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
        this.tesChequera = null;
        this.tesChequeraSelected = null;
        this.esNuegoRegistro = true;

        this.lazyModel = null;
        this.lazyModelBanco = null;
        this.lazyModelTipoValor = null;

        this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
    }

    // GETTERS Y SETTERS
    public TesChequera getTesChequera() {
        if (Objects.isNull(tesChequera)) {
            this.tesChequera = new TesChequera();
            this.tesChequera.setProximoNumero(BigInteger.ZERO);
            this.tesChequera.setEstado(Estado.ACTIVO.getEstado());
            this.tesChequera.setBsEmpresa(new BsEmpresa());
            this.tesChequera.setTesBanco(new TesBanco());
            this.tesChequera.getTesBanco().setBsPersona(new BsPersona());
            this.tesChequera.setBsTipoValor(new BsTipoValor());
        }
        return tesChequera;
    }

    public void setTesChequera(TesChequera tesChequera) {
        this.tesChequera = tesChequera;
    }

    public TesChequera getTesChequeraSelected() {
        if (Objects.isNull(tesChequeraSelected)) {
            this.tesChequeraSelected = new TesChequera();
            this.tesChequeraSelected.setProximoNumero(BigInteger.ZERO);
            this.tesChequeraSelected.setEstado(Estado.ACTIVO.getEstado());
            this.tesChequeraSelected.setBsEmpresa(new BsEmpresa());
            this.tesChequeraSelected.setTesBanco(new TesBanco());
            this.tesChequeraSelected.getTesBanco().setBsPersona(new BsPersona());
            this.tesChequeraSelected.setBsTipoValor(new BsTipoValor());
        }
        return tesChequeraSelected;
    }

    public void setTesChequeraSelected(TesChequera tesChequeraSelected) {
        if (!Objects.isNull(tesChequeraSelected)) {
            this.tesChequera = tesChequeraSelected;
            tesChequeraSelected = null;
            this.esNuegoRegistro = false;
        }
        this.tesChequeraSelected = tesChequeraSelected;
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

    public TesBancoService getTesBancoServiceImpl() {
        return tesBancoServiceImpl;
    }

    public void setTesBancoServiceImpl(TesBancoService tesBancoServiceImpl) {
        this.tesBancoServiceImpl = tesBancoServiceImpl;
    }

    public TesChequeraService getTesChequeraServiceImpl() {
        return tesChequeraServiceImpl;
    }

    public void setTesChequeraServiceImpl(TesChequeraService tesChequeraServiceImpl) {
        this.tesChequeraServiceImpl = tesChequeraServiceImpl;
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

    public LazyDataModel<TesChequera> getLazyModel() {
        if (Objects.isNull(lazyModel)) {
            lazyModel = new GenericLazyDataModel<TesChequera>((List<TesChequera>) tesChequeraServiceImpl
                    .buscarTesChequeraActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
        }
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<TesChequera> lazyModel) {
        this.lazyModel = lazyModel;
    }

    public LazyDataModel<TesBanco> getLazyModelBanco() {
        if (Objects.isNull(lazyModelBanco)) {
            lazyModelBanco = new GenericLazyDataModel<TesBanco>((List<TesBanco>) tesBancoServiceImpl
                    .buscarTesBancoActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
        }
        return lazyModelBanco;
    }

    public void setLazyModelBanco(LazyDataModel<TesBanco> lazyModelBanco) {
        this.lazyModelBanco = lazyModelBanco;
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

    // METODOS
    public void guardar() {
        try {
            this.tesChequera.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            this.tesChequera.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
            if (!Objects.isNull(tesChequeraServiceImpl.save(this.tesChequera))) {
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
            // e.printStackTrace(System.err);
            String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);

            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        }

    }

    public void delete() {
        try {
            if (!Objects.isNull(this.tesChequera)) {
                this.tesChequeraServiceImpl.deleteById(this.tesChequera.getId());
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

}
