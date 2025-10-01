package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.reportes;

import org.apache.commons.collections4.CollectionUtils;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.base.BsPersonaService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/*
 * 15 dic. 2023 - Elitebook
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class RptTesExtractoPorBancoController {

    private ParametrosReporte parametrosReporte;

    private LocalDate fecDesde;
    private LocalDate fecHasta;
    private TesBanco tesBancoSelected;
    private LazyDataModel<TesBanco> lazyModelBanco;
    private String indConciliado;


    @Autowired
    private GenerarReporte generarReporte;

    @Autowired
    private TesBancoService tesBancoServiceImpl;

    /**
     * Propiedad de la logica de negocio inyectada con JSF y Spring.
     */
    @Autowired
    private SessionBean sessionBean;

    @Autowired
    private CommonsUtilitiesController commonsUtilitiesController;

    public void cleanFields() {
        this.tesBancoSelected = null;
        this.fecDesde = null;
        this.fecHasta = null;
        this.lazyModelBanco = null;
        this.parametrosReporte = null;
    }

    @PostConstruct
    public void init() {
        this.cleanFields();

    }

    // GETTERS Y SETTERS
    public ParametrosReporte getParametrosReporte() {
        if (Objects.isNull(parametrosReporte)) {
            parametrosReporte = new ParametrosReporte();
            parametrosReporte.setCodModulo(Modulos.TESORERIA.getModulo());
            parametrosReporte.setReporte("TesExtractoBancarioPorFecha");
        }
        return parametrosReporte;
    }

    public void setParametrosReporte(ParametrosReporte parametrosReporte) {
        this.parametrosReporte = parametrosReporte;
    }

    public GenerarReporte getGenerarReporte() {
        return generarReporte;
    }

    public void setGenerarReporte(GenerarReporte generarReporte) {
        this.generarReporte = generarReporte;
    }

    public LocalDate getFecDesde() {
        if (Objects.isNull(fecDesde))
            fecDesde = LocalDate.now();
        return fecDesde;
    }

    public void setFecDesde(LocalDate fecDesde) {
        this.fecDesde = fecDesde;
    }

    public LocalDate getFecHasta() {
        if (Objects.isNull(fecHasta))
            fecHasta = LocalDate.now();
        return fecHasta;
    }

    public void setFecHasta(LocalDate fecHasta) {
        this.fecHasta = fecHasta;
    }

    public TesBanco getTesBancoSelected() {
        if (Objects.isNull(tesBancoSelected)){
            this.tesBancoSelected = new TesBanco();
            this.tesBancoSelected.setBsMoneda(new BsMoneda());
            this.tesBancoSelected.setBsEmpresa(new BsEmpresa());
            this.tesBancoSelected.setBsPersona(new BsPersona());
        }
        return tesBancoSelected;
    }

    public void setTesBancoSelected(TesBanco tesBancoSelected) {
        this.tesBancoSelected = tesBancoSelected;
    }

    // LAZY
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

    public String getIndConciliado() {
        return indConciliado;
    }

    public void setIndConciliado(String indConciliado) {
        this.indConciliado = indConciliado;
    }

    // SERVICES
    public SessionBean getSessionBean() {
        return sessionBean;
    }

    public void setSessionBean(SessionBean sessionBean) {
        this.sessionBean = sessionBean;
    }

    public TesBancoService getTesBancoServiceImpl() {
        return tesBancoServiceImpl;
    }

    public void setTesBancoServiceImpl(TesBancoService tesBancoServiceImpl) {
        this.tesBancoServiceImpl = tesBancoServiceImpl;
    }

    public CommonsUtilitiesController getCommonsUtilitiesController() {
        return commonsUtilitiesController;
    }

    public void setCommonsUtilitiesController(CommonsUtilitiesController commonsUtilitiesController) {
        this.commonsUtilitiesController = commonsUtilitiesController;
    }

    public void downloadReport() {
        this.prepareParams();
        if (!(Objects.isNull(parametrosReporte) && Objects.isNull(parametrosReporte.getFormato()))
                && CollectionUtils.isNotEmpty(this.parametrosReporte.getParametros())
                && CollectionUtils.isNotEmpty(this.parametrosReporte.getValores())) {
			/* si usamos JS no es para xls descomentar si usamos JS
            //descomentar esto si quieres previsualizar primero el archivo tener en cuenta que debes permitir popups
            //String scriptJs = this.generarReporte.openAndPrintReportWithJS(parametrosReporte);
            //descomentar esto si solo quieres descargar directamente el archivo
            //String scriptJs = this.generarReporte.downloadReportWithJS(parametrosReporte, parametrosReporte.getReporte());
            PrimeFaces.current().executeScript(scriptJs);
         */
            // si usamos JSF
            if (this.generarReporte.procesarReporte(parametrosReporte)) {
                //FacesContext.getCurrentInstance().responseComplete();
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "Se imprimio correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡NO!",
                        "No se pudo imprimir.");
            }

        } else {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡CUIDADO!",
                    "Debes seccionar los parametros validos.");
        }
        this.cleanFields();
        PrimeFaces.current().ajax().update(":form", "form:messages");

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
        this.parametrosReporte.getParametros().add("p_banco_id");
        this.parametrosReporte.getParametros().add("p_fecha_inicio");
        this.parametrosReporte.getParametros().add("p_fecha_fin");

        // values
        this.parametrosReporte.getValores().add(Long.valueOf(this.commonsUtilitiesController.getIdEmpresaLogueada()));
        this.parametrosReporte.getValores().add(this.tesBancoSelected.getId() != null ? (Long) this.tesBancoSelected.getId() : null);
        this.parametrosReporte.getValores().add(fecDesde.format(formatToDateParam));
        this.parametrosReporte.getValores().add(fecHasta.format(formatToDateParam));

    }

}
