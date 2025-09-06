package py.com.capital.CapitaCreditos.presentation.controllers.creditos.reportes;

import org.apache.commons.collections4.CollectionUtils;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.*;
import py.com.capital.CapitaCreditos.services.cobranzas.CobClienteService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
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
public class RptCreDesembolsoPorFechaClienteController {

	private ParametrosReporte parametrosReporte;

	private LocalDate fecDesde;
	private LocalDate fecHasta;
	private CobCliente cobClienteSelected;
	private LazyDataModel<CobCliente> lazyModelCliente;
	

	@Autowired
	private GenerarReporte generarReporte;

	@Autowired
	private CobClienteService cobClienteServiceImpl;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	private SessionBean sessionBean;

	@Autowired
	private CommonsUtilitiesController commonsUtilitiesController;

	public void cleanFields() {
		this.cobClienteSelected = null;
		this.fecDesde = null;
		this.fecHasta = null;
		this.lazyModelCliente = null;
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
			parametrosReporte.setCodModulo(Modulos.CREDITOS.getModulo());
			parametrosReporte.setReporte("CreDesembolsoPorFecha");
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

	public CobCliente getCobClienteSelected() {
		if (Objects.isNull(cobClienteSelected)) {
			this.cobClienteSelected = new CobCliente();
			this.cobClienteSelected.setBsEmpresa(new BsEmpresa());
			this.cobClienteSelected.setBsPersona(new BsPersona());
		}
		return cobClienteSelected;
	}

	public void setCobClienteSelected(CobCliente cobClienteSelected) {
		this.cobClienteSelected = cobClienteSelected;
	}

	// LAZY
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

	// SERVICES
	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	public CobClienteService getCobClienteServiceImpl() {
		return cobClienteServiceImpl;
	}

	public void setCobClienteServiceImpl(CobClienteService cobClienteServiceImpl) {
		this.cobClienteServiceImpl = cobClienteServiceImpl;
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
		this.parametrosReporte.getParametros().add("p_cliente_id");
		this.parametrosReporte.getParametros().add("p_fecha_inicio");
		this.parametrosReporte.getParametros().add("p_fecha_fin");

		// values
		this.parametrosReporte.getValores().add(Long.valueOf(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		this.parametrosReporte.getValores().add(this.cobClienteSelected.getId() != null ? (Long) this.cobClienteSelected.getId() : null);	
		this.parametrosReporte.getValores().add(fecDesde.format(formatToDateParam));
		this.parametrosReporte.getValores().add(fecHasta.format(formatToDateParam));

	}

}
