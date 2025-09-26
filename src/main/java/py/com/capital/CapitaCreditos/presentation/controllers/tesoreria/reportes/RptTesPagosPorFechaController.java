package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.reportes;

import org.apache.commons.collections4.CollectionUtils;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.PrimeFaces;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

/*
* 15 dic. 2023 - Elitebook
*/
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class RptTesPagosPorFechaController {

	private ParametrosReporte parametrosReporte;

	private LocalDate fecDesde;
	private LocalDate fecHasta;

	@Autowired
	private GenerarReporte generarReporte;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	private SessionBean sessionBean;

	@Autowired
	private CommonsUtilitiesController commonsUtilitiesController;

	public void cleanFields() {
		this.fecDesde = null;
		this.fecHasta = null;
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
			parametrosReporte.setReporte("TesPagosPorFecha");
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

	// LAZY

	// SERVICES
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

	public void downloadReport() {
		this.prepareParams();
		if (parametrosReporte == null
				|| parametrosReporte.getFormato() == null
				|| CollectionUtils.isEmpty(parametrosReporte.getParametros())
				|| CollectionUtils.isEmpty(parametrosReporte.getValores())) {

			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡CUIDADO!",
					"Debes seccionar los parametros validos.");
			return;
		}
		/* si usamos JS no es para xls descomentar si usamos JS
            //descomentar esto si quieres previsualizar primero el archivo tener en cuenta que debes permitir popups
            //String scriptJs = this.generarReporte.openAndPrintReportWithJS(parametrosReporte);
            //descomentar esto si solo quieres descargar directamente el archivo
            //String scriptJs = this.generarReporte.downloadReportWithJS(parametrosReporte, parametrosReporte.getReporte());
            PrimeFaces.current().executeScript(scriptJs);
         */
		// si usamos JSF
		if(this.generarReporte.procesarReporte(parametrosReporte)){
			//FacesContext.getCurrentInstance().responseComplete();
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
					"Se imprimio correctamente.");
			this.cleanFields();
		}else{
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡NO!",
					"No se pudo imprimir.");
		}
		PrimeFaces.current().ajax().update("form:messages");

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
		this.parametrosReporte.getParametros().add("p_fecha_inicio");
		this.parametrosReporte.getParametros().add("p_fecha_fin");

		// values
		this.parametrosReporte.getValores().add(Long.valueOf(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		this.parametrosReporte.getValores().add(fecDesde.format(formatToDateParam));
		this.parametrosReporte.getValores().add(fecHasta.format(formatToDateParam));

	}

}
