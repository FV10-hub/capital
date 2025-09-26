package py.com.capital.CapitaCreditos.presentation.controllers.cobranzas.definicion;

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
import py.com.capital.CapitaCreditos.dtos.SqlSelectBuilder;
import py.com.capital.CapitaCreditos.dtos.SqlUpdateBuilder;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobArqueosCajas;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCaja;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.UtilsService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobArqueosCajaService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCajaService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobHabilitacionCajaService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/*
 * 28 dic. 2023 - Elitebook
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class CobHabilitacionCajaController {
    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */
    private static final Logger LOGGER = LogManager.getLogger(CobHabilitacionCajaController.class);

    private CobHabilitacionCaja cobHabilitacionCaja, cobHabilitacionCajaSelected;
    private CobCaja cobCajaSelected;

    private CobArqueosCajas cobArqueosCajas;

    private List<CobArqueosCajas> arqueosCajasList;
    private LazyDataModel<CobHabilitacionCaja> lazyModel;
    private List<String> estadoList;
    private static final String DT_NAME = "dt-habilitacion";
    private static final String DT_DIALOG_NAME = "manageHabilitacionDialog";
    private boolean esNuegoRegistro;
    private boolean tieneHabilitacionAbiertaRendered;
    DateTimeFormatter horaFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

    private BigDecimal montoCheque;
    private BigDecimal montoEfectivo;
    private BigDecimal montoTarjeta;

    private ParametrosReporte parametrosReporte;

    @Autowired
    private CobHabilitacionCajaService cobHabilitacionCajaServiceImpl;

    @Autowired
    private CobCajaService cobCajaServiceImpl;

    @Autowired
    private CobArqueosCajaService cobArqueosCajaServiceImpl;

    @Autowired
    private UtilsService utilsService;

    @Autowired
    private GenerarReporte generarReporte;

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
        this.cobCajaSelected = this.cobCajaServiceImpl.usuarioTieneCaja(this.sessionBean.getUsuarioLogueado().getId());
        this.validarCajaDelUsuario(this.cobCajaSelected);
        if (!Objects.isNull(this.cobCajaSelected)) {
            this.validarHabilitacion();
        }

        this.cobHabilitacionCaja = null;
        this.cobHabilitacionCajaSelected = null;
        this.cobArqueosCajas = null;
        this.lazyModel = null;
        this.esNuegoRegistro = true;
        this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
        this.arqueosCajasList = new ArrayList<>();
    }

    // GETTERS & SETTERS
    public CobHabilitacionCaja getCobHabilitacionCaja() {

        if (Objects.isNull(cobHabilitacionCaja)) {
            this.cobHabilitacionCaja = new CobHabilitacionCaja();
            this.cobHabilitacionCaja.setFechaApertura(LocalDateTime.now());
            this.cobHabilitacionCaja.setIndImpreso(false);
            this.cobHabilitacionCaja.setFechaCierre(null);
            this.cobHabilitacionCaja.setHoraApertura(LocalDateTime.now().format(horaFormatter));
            this.cobHabilitacionCaja.setHoraCierre(null);
            this.cobHabilitacionCaja.setCobCaja(this.cobCajaSelected);
            this.cobHabilitacionCaja.setIndCerradoBoolean(false);
            this.cobHabilitacionCaja.setEstado(Estado.ACTIVO.getEstado());
            this.cobHabilitacionCaja.setBsUsuario(sessionBean.getUsuarioLogueado());
        }
        return cobHabilitacionCaja;
    }

    public void setCobHabilitacionCaja(CobHabilitacionCaja cobHabilitacionCaja) {
        this.cobHabilitacionCaja = cobHabilitacionCaja;
    }

    public CobHabilitacionCaja getCobHabilitacionCajaSelected() {
        if (Objects.isNull(cobHabilitacionCajaSelected)) {
            this.cobHabilitacionCajaSelected = new CobHabilitacionCaja();
            this.cobHabilitacionCajaSelected.setFechaApertura(LocalDateTime.now());
            this.cobHabilitacionCajaSelected.setFechaCierre(LocalDateTime.now());
            this.cobHabilitacionCajaSelected.setHoraApertura(LocalDateTime.now().format(horaFormatter));
            this.cobHabilitacionCajaSelected.setHoraCierre(LocalDateTime.now().format(horaFormatter));
            this.cobHabilitacionCajaSelected.setCobCaja(new CobCaja());
            this.cobHabilitacionCajaSelected.setIndCerradoBoolean(false);
            this.cobHabilitacionCajaSelected.setEstado(Estado.ACTIVO.getEstado());
            this.cobHabilitacionCajaSelected.setBsUsuario(sessionBean.getUsuarioLogueado());
        }
        return cobHabilitacionCajaSelected;
    }

    public void setCobHabilitacionCajaSelected(CobHabilitacionCaja cobHabilitacionCajaSelected) {
        if (!Objects.isNull(cobHabilitacionCajaSelected)) {
            this.cobHabilitacionCaja = cobHabilitacionCajaSelected;
            this.resumenCobros(this.sessionBean.getUsuarioLogueado().getBsEmpresa().getId(),
                    this.sessionBean.getUsuarioLogueado().getId(),
                    this.cobHabilitacionCaja.getNroHabilitacion().longValue());
            cobHabilitacionCajaSelected = null;
            this.esNuegoRegistro = false;
            var listaAux = this.cobArqueosCajaServiceImpl.buscarCobArqueosCajasActivosLista
                    (this.sessionBean.getUsuarioLogueado().getBsEmpresa().getId(), this.cobHabilitacionCaja.getId());
            if (!CollectionUtils.isEmpty(listaAux)) {
                this.arqueosCajasList = listaAux;
            } else {
                this.arqueosCajasList = new ArrayList<>();
            }
        }
        this.cobHabilitacionCajaSelected = cobHabilitacionCajaSelected;
    }

    public CobArqueosCajas getCobArqueosCajas() {
        if (Objects.isNull(cobArqueosCajas)) {
            this.prepararNuevoArqueoCaja();
        }
        return cobArqueosCajas;
    }

    public void setCobArqueosCajas(CobArqueosCajas cobArqueosCajas) {
        this.cobArqueosCajas = cobArqueosCajas;
    }

    public List<CobArqueosCajas> getArqueosCajasList() {
        return arqueosCajasList;
    }

    public void setArqueosCajasList(List<CobArqueosCajas> arqueosCajasList) {
        this.arqueosCajasList = arqueosCajasList;
    }

    public LazyDataModel<CobHabilitacionCaja> getLazyModel() {
        if (Objects.isNull(lazyModel)) {
            lazyModel = new GenericLazyDataModel<CobHabilitacionCaja>(this.cobHabilitacionCajaServiceImpl
                    .buscarCobHabilitacionCajaActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
        }
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<CobHabilitacionCaja> lazyModel) {
        this.lazyModel = lazyModel;
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

    public SessionBean getSessionBean() {
        return sessionBean;
    }

    public void setSessionBean(SessionBean sessionBean) {
        this.sessionBean = sessionBean;
    }

    public boolean isTieneHabilitacionAbiertaRendered() {
        return tieneHabilitacionAbiertaRendered;
    }

    public void setTieneHabilitacionAbiertaRendered(boolean tieneHabilitacionAbiertaRendered) {
        this.tieneHabilitacionAbiertaRendered = tieneHabilitacionAbiertaRendered;
    }

    public CobArqueosCajaService getCobArqueosCajaServiceImpl() {
        return cobArqueosCajaServiceImpl;
    }

    public void setCobArqueosCajaServiceImpl(CobArqueosCajaService cobArqueosCajaServiceImpl) {
        this.cobArqueosCajaServiceImpl = cobArqueosCajaServiceImpl;
    }

    public CobCaja getCobCajaSelected() {
        return cobCajaSelected;
    }

    public void setCobCajaSelected(CobCaja cobCajaSelected) {
        this.cobCajaSelected = cobCajaSelected;
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

    public ParametrosReporte getParametrosReporte() {
        if (Objects.isNull(parametrosReporte)) {
            parametrosReporte = new ParametrosReporte();
            parametrosReporte.setCodModulo(Modulos.COBRANZAS.getModulo());
            parametrosReporte.setReporte("CobRendicionCaja");
            parametrosReporte.setFormato("PDF");
        }
        return parametrosReporte;
    }

    public void setParametrosReporte(ParametrosReporte parametrosReporte) {
        this.parametrosReporte = parametrosReporte;
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

    public BigDecimal getMontoCheque() {
        return montoCheque;
    }

    public void setMontoCheque(BigDecimal montoCheque) {
        this.montoCheque = montoCheque;
    }

    public BigDecimal getMontoEfectivo() {
        return montoEfectivo;
    }

    public void setMontoEfectivo(BigDecimal montoEfectivo) {
        this.montoEfectivo = montoEfectivo;
    }

    public BigDecimal getMontoTarjeta() {
        return montoTarjeta;
    }

    public void setMontoTarjeta(BigDecimal montoTarjeta) {
        this.montoTarjeta = montoTarjeta;
    }

    // METODOS
    public void validarCajaDelUsuario(CobCaja caja) {
        if (Objects.isNull(caja)) {
            PrimeFaces.current().executeScript("PF('dlgNoTieneCaja').show()");
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
            return;
        }
    }

    public void validarHabilitacion() {
        String valor = this.cobHabilitacionCajaServiceImpl
                .validaHabilitacionAbierta(this.sessionBean.getUsuarioLogueado().getId(), this.cobCajaSelected.getId());
        this.tieneHabilitacionAbiertaRendered = valor.equalsIgnoreCase("S");
        PrimeFaces.current().ajax().update("form:messages", "form:btnNuevo");
        return;

    }

    public void redireccionarACajas() {
        try {
            PrimeFaces.current().executeScript("PF('dlgNoTieneCaja').hide()");
            CommonUtils.redireccionar("/faces/pages/cliente/cobranzas/definicion/CobCaja.xhtml");
        } catch (IOException e) {
            e.printStackTrace();
            LOGGER.error("Ocurrio un error al Guardar", e);
        }
    }

    public void setFechaYHoraCierre() {
        if (this.cobHabilitacionCaja.isIndCerradoBoolean()) {
            this.cobHabilitacionCaja.setFechaCierre(LocalDateTime.now());
            this.cobHabilitacionCaja.setHoraCierre(LocalDateTime.now().format(horaFormatter));
        } else {
            this.cobHabilitacionCaja.setFechaCierre(null);
            this.cobHabilitacionCaja.setHoraCierre(null);
        }

    }

    public void guardar() {
        // FALTA REVISAR POR UQE CREA EN VEZ DE EDITAR
        try {
            if (Objects.isNull(this.cobHabilitacionCaja.getId())) {
                this.cobHabilitacionCaja
                        .setNroHabilitacion(cobHabilitacionCajaServiceImpl.calcularNroHabilitacionDisponible());
            }

            this.cobHabilitacionCaja.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            this.setFechaYHoraCierre();
            if (!Objects.isNull(cobHabilitacionCajaServiceImpl.save(this.cobHabilitacionCaja))) {
                if (this.arqueosCajasList.stream().findFirst().isPresent()) {
                    this.cobArqueosCajaServiceImpl.save(this.arqueosCajasList.stream().findFirst().get());
                }

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
                            "El nro. Habilitacion ya existe.");
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
            if (!Objects.isNull(this.cobHabilitacionCaja)) {
                this.cobHabilitacionCajaServiceImpl.deleteById(this.cobHabilitacionCaja.getId());
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
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        }

    }

    public void prepararNuevoArqueoCaja() {
        this.cobArqueosCajas = new CobArqueosCajas();
        this.cobArqueosCajas.setCobHabilitacionCaja(this.cobHabilitacionCaja);
        this.cobArqueosCajas.setBsEmpresa(this.sessionBean.getUsuarioLogueado().getBsEmpresa());
        this.cobArqueosCajas.setUsuarioModificacion(this.sessionBean.getUsuarioLogueado().getCodUsuario());
    }

    public void addArqueoCaja() {
        if (!Objects.isNull(cobArqueosCajas)) {
            arqueosCajasList.add(cobArqueosCajas);
            PrimeFaces.current().ajax().update("form:messages", ":form:dt-arqueos", ":form:btnAddArqueo", ":form:btnGuardar", ":form:btnImpImprimir");
            PrimeFaces.current().executeScript("PF('manageArqueoDialog').hide()");
        }
    }

    public void deleteArqueo() {
        try {
            this.arqueosCajasList = new ArrayList<>();
            if (!Objects.isNull(this.cobArqueosCajas)) {
                if (!Objects.isNull(this.cobArqueosCajas.getId())) {
                    this.cobArqueosCajaServiceImpl.deleteById(this.cobArqueosCajas.getId());
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                            "El registro se elimino correctamente.");
                }

            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
            }
            PrimeFaces.current().ajax().update("form:messages", ":form:dt-arqueos", ":form:btnAddArqueo", ":form:btnGuardar");
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al eliminar", System.err);
            // e.printStackTrace(System.err);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    e.getMessage().substring(0, e.getMessage().length()) + "...");
            PrimeFaces.current().ajax().update("form:messages", "form:dt-arqueos");
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

    public void imprimir() {
        try {
            this.parametrosReporte = null;
            getParametrosReporte();
            this.prepareParams();
            SqlUpdateBuilder ub;
            // key
            this.parametrosReporte.getParametros().add("p_empresa_id");
            this.parametrosReporte.getParametros().add("p_usuario_id");
            this.parametrosReporte.getParametros().add("p_nro_habilitacion");
            this.parametrosReporte.getParametros().add("p_usuario");
            this.parametrosReporte.getParametros().add("p_periodo");

            // values
            this.parametrosReporte.getValores().add(this.sessionBean.getUsuarioLogueado().getBsEmpresa().getId());
            this.parametrosReporte.getValores().add(this.sessionBean.getUsuarioLogueado().getId());
            this.parametrosReporte.getValores().add(this.cobHabilitacionCaja.getNroHabilitacion().longValue());
            this.parametrosReporte.getValores().add(this.sessionBean.getUsuarioLogueado().getCodUsuario());
            LocalDateTime now = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
            this.parametrosReporte.getValores().add(String.format("Del %s al %s.",
                    this.cobHabilitacionCaja.getFechaApertura().format(formatter),
                    this.cobHabilitacionCaja.isIndCerradoBoolean() ? this.cobHabilitacionCaja.getFechaCierre().format(formatter) : now.format(formatter)));

            //TODO: aca restrinjo el registro si es pagare
            ub = SqlUpdateBuilder.table("public.cob_habilitaciones_cajas")
                    .set("ind_impreso", "S")
                    .whereEq("id", this.cobHabilitacionCaja.getId());

            if (!(Objects.isNull(parametrosReporte) && Objects.isNull(parametrosReporte.getFormato()))
                    && CollectionUtils.isNotEmpty(this.parametrosReporte.getParametros())
                    && CollectionUtils.isNotEmpty(this.parametrosReporte.getValores())) {

                if (this.utilsService.updateDinamico(ub)) {
                    this.cobHabilitacionCaja = this.utilsService.reload(this.cobHabilitacionCaja.getClass(), this.cobHabilitacionCaja.getId());
                    this.generarReporte.procesarReporte(parametrosReporte);
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                            "Se imprimio correctamente.");
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

        } catch (
                Exception e) {
            LOGGER.error("Ocurrio un error al Imprimir", e);
            // e.printStackTrace(System.err);
            String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);
            PrimeFaces.current().ajax().update(":form");

        }

    }

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


    }

    public void execute() {
        //TODO esto sirve para ejecutar un comportamiento en paralelo con JS
        /*String mensaje = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("mensaje");
        String boton = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("boton");
        if (mensaje != null || boton != null) {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                    "Se imprimio correctamente.");
        } else {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡CUIDADO!",
                    "Debes seccionar los parametros validos.");
        }

        PrimeFaces.current().executeScript("PF('imprimirDialog').hide();");
        PrimeFaces.current().executeScript("PF('imprimirPagareDialog').hide();");*/
        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                "Se imprimio correctamente.");
        System.out.println("paso por aca");
        PrimeFaces.current().ajax().update(":form:messages");

        //retorna un valor al front
        //PrimeFaces.current().ajax().addCallbackParam("serverTime", System.currentTimeMillis());

        //html como atraparlo
        //<p:remoteCommand name="rc" update="msgs" action="#{remoteCommandView.execute}"
        //oncomplete="alert('Return value from server: ' + args.serverTime)"/>


    }

    public void resumenCobros(Long empresaId, Long usuarioId, Long habilitacion) {
        // 1. construir cada bloque con tu SqlSelectBuilder
        SqlSelectBuilder facturas = SqlSelectBuilder.from("ven_facturas_cabecera c")
                .select("tv.cod_tipo || ' - ' || tv.descripcion AS tipo_valor")
                .select("SUM(COALESCE(c.monto_total_factura,0)) AS tot_comprobante")
                .join("cob_habilitaciones_cajas hab ON hab.id = c.cob_habilitacion_caja_id")
                .join("cob_cajas caj ON hab.bs_cajas_id = caj.id AND hab.bs_usuario_id = caj.bs_usuario_id AND caj.bs_empresa_id = c.bs_empresa_id")
                .join("bs_talonarios tal ON c.bs_talonario_id = tal.id")
                .join("bs_tipo_comprobantes tip ON tal.bs_tipo_comprobante_id = tip.id")
                .join("cob_cobros_valores val ON c.bs_empresa_id = val.bs_empresa_id AND c.id = val.id_comprobante")
                .join("bs_tipo_valor tv ON val.bs_empresa_id = tv.bs_empresa_id AND val.bs_tipo_valor_id = tv.id")
                .where("c.bs_empresa_id = :empresaId")
                .where("caj.bs_usuario_id = :usuarioId")
                .where("hab.nro_habilitacion = :habilitacion")
                .where("tip.cod_tip_comprobante = 'CON'")
                .groupBy("tv.cod_tipo, tv.descripcion");

        SqlSelectBuilder recibos = SqlSelectBuilder.from("cob_recibos_cabecera c")
                .select("tv.cod_tipo || ' - ' || tv.descripcion AS tipo_valor")
                .select("SUM(COALESCE(c.monto_total_recibo,0)) AS tot_comprobante")
                .join("cob_habilitaciones_cajas hab ON hab.id = c.cob_habilitacion_id")
                .join("cob_cajas caj ON hab.bs_cajas_id = caj.id AND hab.bs_usuario_id = caj.bs_usuario_id AND caj.bs_empresa_id = c.bs_empresa_id")
                .join("bs_talonarios tal ON c.bs_talonario_id = tal.id")
                .join("bs_tipo_comprobantes tip ON tal.bs_tipo_comprobante_id = tip.id")
                .join("cob_cobros_valores val ON c.bs_empresa_id = val.bs_empresa_id AND c.id = val.id_comprobante")
                .join("bs_tipo_valor tv ON val.bs_empresa_id = tv.bs_empresa_id AND val.bs_tipo_valor_id = tv.id")
                .where("c.bs_empresa_id = :empresaId")
                .where("caj.bs_usuario_id = :usuarioId")
                .where("hab.nro_habilitacion = :habilitacion")
                .where("tip.cod_tip_comprobante = 'REC'")
                .groupBy("tv.cod_tipo, tv.descripcion");

        // 2. Unión manual
        String sql = "SELECT resumen.tipo_valor, SUM(resumen.tot_comprobante) AS total_cobrado " +
                "FROM (" + facturas.build() + " UNION ALL " + recibos.build() + ") resumen " +
                "GROUP BY resumen.tipo_valor " +
                "ORDER BY resumen.tipo_valor";

        Map<String, Object> params = Map.of(
                "empresaId", empresaId,
                "usuarioId", usuarioId,
                "habilitacion", habilitacion
        );

        List<Object[]> cobros = utilsService.ejecutarQuery(sql, params);
        Map<String, BigDecimal> montos = new HashMap<>();

        for (Object[] row : cobros) {
            String tipoValor = (String) row[0];
            BigDecimal monto = (BigDecimal) row[1];
            montos.put(tipoValor, monto);
        }

        this.montoCheque = montos.getOrDefault("CHE - CHEQUE", BigDecimal.ZERO);
        this.montoEfectivo = montos.getOrDefault("EFE - EFECTIVO", BigDecimal.ZERO);
        this.montoTarjeta = montos.getOrDefault("TAR - TARJETA", BigDecimal.ZERO);


    }


}
