package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsMonedaService;
import py.com.capital.CapitaCreditos.services.base.BsPersonaService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/*
* 30 nov. 2023 - Elitebook
*/
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class TesBancoController {
	
	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(TesBancoController.class);

	private TesBanco tesBanco, tesBancoSelected;
	private LazyDataModel<TesBanco> lazyModel;
	private LazyDataModel<BsPersona> lazyPersonaList;
	private LazyDataModel<BsMoneda> lazyMonedaList;

	private BsPersona bsPersonaSelected;
	private boolean esNuegoRegistro;

	private List<String> estadoList;

	private static final String DT_NAME = "dt-banco";
	private static final String DT_DIALOG_NAME = "manageBancoDialog";

	@Autowired
	private BsPersonaService bsPersonaServiceImpl;

	@Autowired
	private TesBancoService tesBancoServiceImpl;
	
	@Autowired
	private BsMonedaService bsMonedaServiceImpl;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	private SessionBean sessionBean;

	@Autowired
	private CommonsUtilitiesController commonsUtilitiesController;

	@PostConstruct
	public void init() {
		this.cleanFields();

	}

	public void cleanFields() {
		this.tesBanco = null;
		this.tesBancoSelected = null;
		this.bsPersonaSelected = null;
		this.esNuegoRegistro = true;

		this.lazyModel = null;
		this.lazyPersonaList = null;
		this.lazyMonedaList = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS Y SETTERS
	public TesBanco getTesBanco() {
		if (Objects.isNull(tesBanco)) {
			this.tesBanco = new TesBanco();
			this.tesBanco.setEstado(Estado.ACTIVO.getEstado());
			this.tesBanco.setBsMoneda(new BsMoneda());
			this.tesBanco.setBsEmpresa(new BsEmpresa());
			this.tesBanco.setBsPersona(new BsPersona());
		}
		return tesBanco;
	}

	public void setTesBanco(TesBanco tesBanco) {
		this.tesBanco = tesBanco;
	}

	public TesBanco getTesBancoSelected() {
		if (Objects.isNull(tesBancoSelected)) {
			this.tesBancoSelected = new TesBanco();
			this.tesBancoSelected.setBsMoneda(new BsMoneda());
			this.tesBancoSelected.setBsEmpresa(new BsEmpresa());
			this.tesBancoSelected.setBsPersona(new BsPersona());
		}
		return tesBancoSelected;
	}

	public void setTesBancoSelected(TesBanco tesBancoSelected) {
		if (!Objects.isNull(tesBancoSelected)) {
			this.tesBanco = tesBancoSelected;
			tesBancoSelected = null;
			this.esNuegoRegistro = false;
		}
		this.tesBancoSelected = tesBancoSelected;
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

	public BsPersonaService getBsPersonaServiceImpl() {
		return bsPersonaServiceImpl;
	}

	public void setBsPersonaServiceImpl(BsPersonaService bsPersonaServiceImpl) {
		this.bsPersonaServiceImpl = bsPersonaServiceImpl;
	}

	public TesBancoService getTesBancoServiceImpl() {
		return tesBancoServiceImpl;
	}

	public void setTesBancoServiceImpl(TesBancoService tesBancoServiceImpl) {
		this.tesBancoServiceImpl = tesBancoServiceImpl;
	}

	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	public BsPersona getBsPersonaSelected() {
		if (Objects.isNull(bsPersonaSelected)) {
			bsPersonaSelected = new BsPersona();
		}
		return bsPersonaSelected;
	}

	public void setBsPersonaSelected(BsPersona bsPersonaSelected) {
		if (!Objects.isNull(bsPersonaSelected.getId())) {
			this.tesBanco.setBsPersona(bsPersonaSelected);
			bsPersonaSelected = null;
		}

		this.bsPersonaSelected = bsPersonaSelected;
	}

	public CommonsUtilitiesController getCommonsUtilitiesController() {
		return commonsUtilitiesController;
	}

	public void setCommonsUtilitiesController(CommonsUtilitiesController commonsUtilitiesController) {
		this.commonsUtilitiesController = commonsUtilitiesController;
	}
	

	public BsMonedaService getBsMonedaServiceImpl() {
		return bsMonedaServiceImpl;
	}

	public void setBsMonedaServiceImpl(BsMonedaService bsMonedaServiceImpl) {
		this.bsMonedaServiceImpl = bsMonedaServiceImpl;
	}

	// LAZY
	public LazyDataModel<TesBanco> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<TesBanco>((List<TesBanco>) tesBancoServiceImpl
					.buscarTesBancoActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<TesBanco> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public LazyDataModel<BsPersona> getLazyPersonaList() {
		if (Objects.isNull(lazyPersonaList)) {
			lazyPersonaList = new GenericLazyDataModel<BsPersona>(bsPersonaServiceImpl
					.buscarTodosLista()
					.stream()
					.filter(persona -> persona.getEstado().equalsIgnoreCase(Estado.ACTIVO.getEstado()))
					.collect(Collectors.toList()));
		}
		return lazyPersonaList;
	}

	public void setLazyPersonaList(LazyDataModel<BsPersona> lazyPersonaList) {
		this.lazyPersonaList = lazyPersonaList;
	}

	public LazyDataModel<BsMoneda> getLazyMonedaList() {
		if (Objects.isNull(lazyMonedaList)) {
			lazyMonedaList = new GenericLazyDataModel<BsMoneda>((List<BsMoneda>) bsMonedaServiceImpl.findAll());
		}
		return lazyMonedaList;
	}

	public void setLazyMonedaList(LazyDataModel<BsMoneda> lazyMonedaList) {
		this.lazyMonedaList = lazyMonedaList;
	}


	// METODOS
	public void guardar() {
		if (Objects.isNull(tesBanco.getBsPersona()) || Objects.isNull(tesBanco.getBsPersona().getId())) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar una Persona.");
			return;
		}
		try {
			this.tesBanco.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			this.tesBanco.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
			if (!Objects.isNull(tesBancoServiceImpl.save(this.tesBanco))) {
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
			e.printStackTrace(System.err);

			Throwable cause = e.getCause();
			while (cause != null) {
				if (cause instanceof ConstraintViolationException) {
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
							"El banco ya existe.");
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
			if (!Objects.isNull(this.tesBanco)) {
				this.tesBancoServiceImpl.deleteById(this.tesBanco.getId());
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se elimino correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al eliminar", System.err);
			//e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");
		}

	}

}
