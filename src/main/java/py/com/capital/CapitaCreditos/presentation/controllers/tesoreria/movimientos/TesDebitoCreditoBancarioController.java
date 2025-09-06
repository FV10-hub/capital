package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.movimientos;

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
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDebitoCreditoBancario;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsMonedaService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesDebitoCreditoBancarioService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

@Component
@Scope(ViewScope.SCOPE_VIEW)
public class TesDebitoCreditoBancarioController {

    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */
    private static final Logger LOGGER = LogManager.getLogger(TesDebitoCreditoBancarioController.class);

    private TesDebitoCreditoBancario tesDebitoCreditoBancario, tesDebitoCreditoBancarioSelected;

    private LazyDataModel<TesDebitoCreditoBancario> lazyModel;

    private LazyDataModel<TesBanco> lazyModelBancoSaliente;

    private LazyDataModel<TesBanco> lazyModelBancoEntrante;

    private List<String> estadoList;

    private List<BsMoneda> lazyModelMoneda;
    private boolean esNuegoRegistro;
    private boolean esVisibleFormulario = true;

    private static final String DT_NAME = "dt-debitos-creditos";

    // services
    @Autowired
    private TesDebitoCreditoBancarioService tesDebitoCreditoBancarioServiceImpl;

    @Autowired
    private TesBancoService tesBancoServiceImpl;

    @Autowired
    private BsMonedaService bsMonedaServiceImpl;

    /**
     * Propiedad de la logica de negocio inyectada con JSF y Spring.
     */
    private boolean puedeCrear, puedeEditar, puedeEliminar = false;
    @Autowired
    private SessionBean sessionBean;

    @Autowired
    private CommonsUtilitiesController commonsUtilitiesController;

    @PostConstruct
    public void init() {
        this.cleanFields();
        this.sessionBean.cargarPermisos();
        puedeCrear = sessionBean.tienePermiso(getPaginaActual(), "CREAR");
        puedeEditar = sessionBean.tienePermiso(getPaginaActual(), "EDITAR");
        puedeEliminar = sessionBean.tienePermiso(getPaginaActual(), "ELIMINAR");
    }

    public void cleanFields() {
        this.tesDebitoCreditoBancario = null;
        this.tesDebitoCreditoBancarioSelected = null;

        this.lazyModel = null;
        this.lazyModelBancoSaliente = null;
        this.lazyModelBancoEntrante = null;
        this.lazyModelMoneda = null;

        this.esNuegoRegistro = true;
        this.esVisibleFormulario = !esVisibleFormulario;
        this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado(), "ANULADO");

    }

    public TesDebitoCreditoBancario getTesDebitoCreditoBancario() {
        if (Objects.isNull(tesDebitoCreditoBancario)) {
            tesDebitoCreditoBancario = new TesDebitoCreditoBancario();
            tesDebitoCreditoBancario.setTesBancoSaliente(new TesBanco());
            tesDebitoCreditoBancario.getTesBancoSaliente().setBsPersona(new BsPersona());
            tesDebitoCreditoBancario.setTesBancoEntrante(new TesBanco());
            tesDebitoCreditoBancario.getTesBancoEntrante().setBsPersona(new BsPersona());
            tesDebitoCreditoBancario.setCobHabilitacionCaja(new CobHabilitacionCaja());
            tesDebitoCreditoBancario.setBsMoneda(new BsMoneda());
            tesDebitoCreditoBancario.setBsEmpresa(new BsEmpresa());
            tesDebitoCreditoBancario.setEstado(Estado.ACTIVO.getEstado());
            tesDebitoCreditoBancario.setFechaDebito(LocalDate.now());
            if (!this.commonsUtilitiesController.validarSiTengaHabilitacionAbierta()) {
                this.tesDebitoCreditoBancario.setCobHabilitacionCaja(this.commonsUtilitiesController.getHabilitacionAbierta());
            } else {
                validarCajaDelUsuario(true);
            }
        }
        return tesDebitoCreditoBancario;
    }

    public void setTesDebitoCreditoBancario(TesDebitoCreditoBancario tesDebitoCreditoBancario) {
        this.tesDebitoCreditoBancario = tesDebitoCreditoBancario;
    }

    public TesDebitoCreditoBancario getTesDebitoCreditoBancarioSelected() {
        if (Objects.isNull(tesDebitoCreditoBancarioSelected)) {
            tesDebitoCreditoBancarioSelected = new TesDebitoCreditoBancario();
            tesDebitoCreditoBancarioSelected.setTesBancoSaliente(new TesBanco());
            tesDebitoCreditoBancarioSelected.getTesBancoSaliente().setBsPersona(new BsPersona());
            tesDebitoCreditoBancarioSelected.setTesBancoEntrante(new TesBanco());
            tesDebitoCreditoBancarioSelected.getTesBancoEntrante().setBsPersona(new BsPersona());
            tesDebitoCreditoBancarioSelected.setCobHabilitacionCaja(new CobHabilitacionCaja());
            tesDebitoCreditoBancarioSelected.setBsMoneda(new BsMoneda());
            tesDebitoCreditoBancarioSelected.setBsEmpresa(new BsEmpresa());
        }
        return tesDebitoCreditoBancarioSelected;
    }

    public void setTesDebitoCreditoBancarioSelected(TesDebitoCreditoBancario tesDebitoCreditoBancarioSelected) {
        if (!Objects.isNull(tesDebitoCreditoBancarioSelected)) {
            tesDebitoCreditoBancario = tesDebitoCreditoBancarioSelected;
            tesDebitoCreditoBancarioSelected = null;
            this.esNuegoRegistro = false;
            this.esVisibleFormulario = true;
        }
        this.tesDebitoCreditoBancarioSelected = tesDebitoCreditoBancarioSelected;
    }


    public LazyDataModel<TesDebitoCreditoBancario> getLazyModel() {
        if (Objects.isNull(lazyModel)) {
            lazyModel = new GenericLazyDataModel<TesDebitoCreditoBancario>(this.tesDebitoCreditoBancarioServiceImpl
                    .buscarTesDebitoCreditoBancarioActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
        }
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<TesDebitoCreditoBancario> lazyModel) {
        this.lazyModel = lazyModel;
    }

    public LazyDataModel<TesBanco> getLazyModelBancoSaliente() {
        if (Objects.isNull(lazyModelBancoSaliente)) {
            if (this.tesDebitoCreditoBancario != null
                    && this.tesDebitoCreditoBancario.getBsMoneda() != null
                    && this.tesDebitoCreditoBancario.getBsMoneda().getId() != null) {
                lazyModelBancoSaliente = new GenericLazyDataModel<TesBanco>(
                        tesBancoServiceImpl.buscarTesBancoActivosPorMonedaLista(
                                this.tesDebitoCreditoBancario.getBsMoneda().getId()));
            } else {
                lazyModelBancoSaliente = new GenericLazyDataModel<TesBanco>(
                        tesBancoServiceImpl.buscarTesBancoActivosLista(
                                this.commonsUtilitiesController.getIdEmpresaLogueada()));
            }
        }
        return lazyModelBancoSaliente;
    }

    public void setLazyModelBancoSaliente(LazyDataModel<TesBanco> lazyModelBancoSaliente) {
        this.lazyModelBancoSaliente = lazyModelBancoSaliente;
    }

    public LazyDataModel<TesBanco> getLazyModelBancoEntrante() {
        if (Objects.isNull(lazyModelBancoEntrante)) {
            if (this.tesDebitoCreditoBancario != null
                    && this.tesDebitoCreditoBancario.getBsMoneda() != null
                    && this.tesDebitoCreditoBancario.getBsMoneda().getId() != null) {
                lazyModelBancoEntrante = new GenericLazyDataModel<TesBanco>(
                        tesBancoServiceImpl.buscarTesBancoActivosPorMonedaLista(
                                this.tesDebitoCreditoBancario.getBsMoneda().getId()));
            } else {
                lazyModelBancoEntrante = new GenericLazyDataModel<TesBanco>(
                        tesBancoServiceImpl.buscarTesBancoActivosLista(
                                this.commonsUtilitiesController.getIdEmpresaLogueada()));
            }
        }
        return lazyModelBancoEntrante;
    }

    public void setLazyModelBancoEntrante(LazyDataModel<TesBanco> lazyModelBancoEntrante) {
        this.lazyModelBancoEntrante = lazyModelBancoEntrante;
    }

    public List<BsMoneda> getLazyModelMoneda() {
        if (Objects.isNull(lazyModelMoneda)) {
            lazyModelMoneda = (List<BsMoneda>) this.bsMonedaServiceImpl.findAll();
        }
        return lazyModelMoneda;
    }

    public void setLazyModelMoneda(List<BsMoneda> lazyModelMoneda) {
        this.lazyModelMoneda = lazyModelMoneda;
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

    public TesBancoService getTesBancoServiceImpl() {
        return tesBancoServiceImpl;
    }

    public void setTesBancoServiceImpl(TesBancoService tesBancoServiceImpl) {
        this.tesBancoServiceImpl = tesBancoServiceImpl;
    }

    public TesDebitoCreditoBancarioService getTesDebitoCreditoBancarioServiceImpl() {
        return tesDebitoCreditoBancarioServiceImpl;
    }

    public void setTesDebitoCreditoBancarioServiceImpl(TesDebitoCreditoBancarioService tesDebitoCreditoBancarioServiceImpl) {
        this.tesDebitoCreditoBancarioServiceImpl = tesDebitoCreditoBancarioServiceImpl;
    }

    public BsMonedaService getBsMonedaServiceImpl() {
        return bsMonedaServiceImpl;
    }

    public void setBsMonedaServiceImpl(BsMonedaService bsMonedaServiceImpl) {
        this.bsMonedaServiceImpl = bsMonedaServiceImpl;
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

    public void onModuloChange() {
        //TODO: debo tener en cuenta que se filtre los bancos y no se pueda selecccionar el mismo para salida y entrante
        tesDebitoCreditoBancario.getTesBancoSaliente().setBsPersona(new BsPersona());
        tesDebitoCreditoBancario.setTesBancoEntrante(new TesBanco());
        tesDebitoCreditoBancario.getTesBancoEntrante().setBsPersona(new BsPersona());
        tesDebitoCreditoBancario.setMontoTotalEntrada(BigDecimal.ZERO);
        tesDebitoCreditoBancario.setMontoTotalSalida(BigDecimal.ZERO);
        this.lazyModelBancoSaliente = null;
        this.lazyModelBancoEntrante = null;
        this.getLazyModelBancoSaliente();
        this.getLazyModelBancoEntrante();


    }

    public void seteaMismoValor() {
        this.tesDebitoCreditoBancario.setMontoTotalEntrada(this.tesDebitoCreditoBancario.getMontoTotalSalida());
    }

    public void guardar() {
        try {
            if (Objects.isNull(this.tesDebitoCreditoBancario.getTesBancoSaliente())
                    || Objects.isNull(this.tesDebitoCreditoBancario.getTesBancoSaliente().getId())) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un banco Saliente.");
                return;
            }
            if (Objects.isNull(this.tesDebitoCreditoBancario.getTesBancoEntrante())
                    || Objects.isNull(this.tesDebitoCreditoBancario.getTesBancoEntrante().getId())) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un banco Entrante.");
                return;
            }
            this.tesDebitoCreditoBancario.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            this.tesDebitoCreditoBancario.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());

            TesDebitoCreditoBancario debCredGuardado = this.tesDebitoCreditoBancarioServiceImpl.save(tesDebitoCreditoBancario);
            if (!Objects.isNull(debCredGuardado)) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se guardo correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
            }

            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
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
            if (!Objects.isNull(this.tesDebitoCreditoBancario)) {
                this.tesDebitoCreditoBancarioServiceImpl.deleteById(this.tesDebitoCreditoBancario.getId());
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se elimino correctamente.");

            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            e.printStackTrace(System.err);
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