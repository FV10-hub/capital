package py.com.capital.CapitaCreditos.presentation.controllers.compras.reportes;

import org.apache.commons.collections4.CollectionUtils;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.compras.ComProveedor;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.compras.ComProveedorService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Objects;

/*
 * 15 dic. 2023 - Elitebook
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class RptComComprasPorFechaProveedoresController {

    private ParametrosReporte parametrosReporte;

    private LocalDate fecDesde;
    private LocalDate fecHasta;
    private ComProveedor ComProveedorSelected;
    private LazyDataModel<ComProveedor> lazyModelProveedor;


    @Autowired
    private GenerarReporte generarReporte;

    @Autowired
    private ComProveedorService ComProveedorServiceImpl;

    /**
     * Propiedad de la logica de negocio inyectada con JSF y Spring.
     */
    @Autowired
    private SessionBean sessionBean;

    @Autowired
    private CommonsUtilitiesController commonsUtilitiesController;

    public void cleanFields() {
        this.ComProveedorSelected = null;
        this.fecDesde = null;
        this.fecHasta = null;
        this.lazyModelProveedor = null;
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
            parametrosReporte.setCodModulo(Modulos.COMPRAS.getModulo());
            parametrosReporte.setReporte("ComComprasPorFecha");
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

    public ComProveedor getComProveedorSelected() {
        if (Objects.isNull(ComProveedorSelected)) {
            this.ComProveedorSelected = new ComProveedor();
            this.ComProveedorSelected.setBsEmpresa(new BsEmpresa());
            this.ComProveedorSelected.setBsPersona(new BsPersona());
        }
        return ComProveedorSelected;
    }

    public void setComProveedorSelected(ComProveedor ComProveedorSelected) {
        this.ComProveedorSelected = ComProveedorSelected;
    }

    // LAZY
    public LazyDataModel<ComProveedor> getLazyModelProveedor() {
        if (Objects.isNull(lazyModelProveedor)) {
            lazyModelProveedor = new GenericLazyDataModel<ComProveedor>((List<ComProveedor>) ComProveedorServiceImpl
                    .buscarComProveedorActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
        }
        return lazyModelProveedor;
    }

    public void setLazyModelProveedor(LazyDataModel<ComProveedor> lazyModelProveedor) {
        this.lazyModelProveedor = lazyModelProveedor;
    }

    // SERVICES
    public SessionBean getSessionBean() {
        return sessionBean;
    }

    public void setSessionBean(SessionBean sessionBean) {
        this.sessionBean = sessionBean;
    }

    public ComProveedorService getComProveedorServiceImpl() {
        return ComProveedorServiceImpl;
    }

    public void setComProveedorServiceImpl(ComProveedorService ComProveedorServiceImpl) {
        this.ComProveedorServiceImpl = ComProveedorServiceImpl;
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
            this.generarReporte.procesarReporte(parametrosReporte);
            this.cleanFields();
        } else {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡CUIDADO!",
                    "Debes seccionar los parametros validos.");
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
        this.parametrosReporte.getParametros().add("p_proveedor_id");
        this.parametrosReporte.getParametros().add("p_fecha_inicio");
        this.parametrosReporte.getParametros().add("p_fecha_fin");

        // values
        this.parametrosReporte.getValores().add(Long.valueOf(this.commonsUtilitiesController.getIdEmpresaLogueada()));
        this.parametrosReporte.getValores().add(this.ComProveedorSelected.getId() != null ? (Long) this.ComProveedorSelected.getId() : null);
        this.parametrosReporte.getValores().add(fecDesde.format(formatToDateParam));
        this.parametrosReporte.getValores().add(fecHasta.format(formatToDateParam));

    }

}
