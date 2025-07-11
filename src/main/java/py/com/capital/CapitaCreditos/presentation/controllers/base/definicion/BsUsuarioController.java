/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.controllers.base.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.base.BsRol;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsEmpresaService;
import py.com.capital.CapitaCreditos.services.base.BsPersonaService;
import py.com.capital.CapitaCreditos.services.base.BsRolService;
import py.com.capital.CapitaCreditos.services.base.BsUsuarioService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * descomentar si por algun motivo se necesita trabajar directo con spring
 * //@Component y // @Autowired
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class BsUsuarioController implements Serializable {
	
	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(BsUsuarioController.class);

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	// lazy
	private LazyDataModel<BsUsuario> lazyModel;
	private LazyDataModel<BsPersona> lazyPersonaList;
	private LazyDataModel<BsRol> lazyRolList;
	private LazyDataModel<BsEmpresa> lazyEmpresaList;
	public List<BsUsuario> listafiltrada;

	// objetos
	private BsUsuario bsUsuario, bsUsuarioSelected;
	private BsPersona bsPersonaSelected;
	private BsRol bsRolSelected;
	private boolean esNuegoRegistro;
	private BsEmpresa bsEmpresaSelected;
	
	// listas
	private List<String> estadoList;

	private static final String DT_NAME = "dt-usuario";
	private static final String DT_DIALOG_NAME = "manageUsuarioDialog";

	// servicios
	@Autowired
	private BsUsuarioService bsUsuarioServiceImpl;

	@Autowired
	private BsPersonaService bsPersonaServiceImpl;

	@Autowired
	private BsRolService bsRolServiceImpl;
	
	@Autowired
	private BsEmpresaService bsEmpresaServiceImpl;
	
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
		this.bsUsuario = null;
		this.bsUsuarioSelected = null;
		this.bsPersonaSelected = null;
		this.bsRolSelected = null;
		this.esNuegoRegistro = true;
		this.bsEmpresaSelected = null;
		this.listafiltrada= new ArrayList<BsUsuario>(); 

		this.lazyModel = null;
		this.lazyPersonaList = null;
		this.lazyRolList = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS & SETTERS
	public BsUsuario getBsUsuario() {
		if (Objects.isNull(bsUsuario)) {
			this.bsUsuario = new BsUsuario();
			this.bsUsuario.setBsPersona(new BsPersona());
			this.bsUsuario.setBsEmpresa(new BsEmpresa());
			this.bsUsuario.setRol(new BsRol());
		}
		return bsUsuario;
	}

	public void setBsUsuario(BsUsuario bsUsuario) {
		this.bsUsuario = bsUsuario;
	}

	public BsUsuario getBsUsuarioSelected() {
		if (Objects.isNull(bsUsuarioSelected)) {
			this.bsUsuarioSelected = new BsUsuario();
			this.bsUsuarioSelected.setBsPersona(new BsPersona());
			this.bsUsuarioSelected.setBsEmpresa(new BsEmpresa());
			this.bsUsuarioSelected.setRol(new BsRol());
		}
		return bsUsuarioSelected;
	}

	public void setBsUsuarioSelected(BsUsuario bsUsuarioSelected) {
		if (!Objects.isNull(bsUsuarioSelected)) {
			this.bsUsuario = bsUsuarioSelected;
			this.esNuegoRegistro = false;
		}
		this.bsUsuarioSelected = bsUsuarioSelected;
	}
	
	public BsEmpresa getBsEmpresaSelected() {
		if (Objects.isNull(bsEmpresaSelected)) {
			this.bsEmpresaSelected = new BsEmpresa();
			this.bsEmpresaSelected.setBsPersona(new BsPersona());
		}
		return bsEmpresaSelected;
	}

	public void setBsEmpresaSelected(BsEmpresa bsEmpresaSelected) {
		if (!Objects.isNull(bsEmpresaSelected.getId())) {
			this.bsUsuario.setBsEmpresa(bsEmpresaSelected);
			bsEmpresaSelected = null;
		}
		this.bsEmpresaSelected = bsEmpresaSelected;
	}

	public List<String> getEstadoList() {
		return estadoList;
	}

	public void setEstadoList(List<String> estadoList) {
		this.estadoList = estadoList;
	}

	public BsUsuarioService getBsUsuarioServiceImpl() {
		return bsUsuarioServiceImpl;
	}

	public void setBsUsuarioServiceImpl(BsUsuarioService bsUsuarioServiceImpl) {
		this.bsUsuarioServiceImpl = bsUsuarioServiceImpl;
	}

	public BsPersona getBsPersonaSelected() {
		if(Objects.isNull(bsPersonaSelected)) {
			bsPersonaSelected = new BsPersona();
		}
		return bsPersonaSelected;
	}

	public void setBsPersonaSelected(BsPersona bsPersonaSelected) {
		if (!Objects.isNull(bsPersonaSelected.getId())) {
			this.bsUsuario.setBsPersona(bsPersonaSelected);
			bsPersonaSelected = null;
		}
		
		this.bsPersonaSelected = bsPersonaSelected;
	}

	public BsPersonaService getBsPersonaServiceImpl() {
		return bsPersonaServiceImpl;
	}

	public void setBsPersonaServiceImpl(BsPersonaService bsPersonaServiceImpl) {
		this.bsPersonaServiceImpl = bsPersonaServiceImpl;
	}

	public BsRol getBsRolSelected() {
		if (Objects.isNull(bsRolSelected)) {
			this.bsRolSelected = new BsRol();
		}
		return bsRolSelected;
	}

	public void setBsRolSelected(BsRol bsRolSelected) {
		if (!Objects.isNull(bsRolSelected.getId())) {
			this.bsUsuario.setRol(bsRolSelected);
			bsRolSelected = null;
		}
		this.bsRolSelected = bsRolSelected;
	}

	public BsRolService getBsRolServiceImpl() {
		return bsRolServiceImpl;
	}

	public void setBsRolServiceImpl(BsRolService bsRolServiceImpl) {
		this.bsRolServiceImpl = bsRolServiceImpl;
	}

	public boolean isEsNuegoRegistro() {
		return esNuegoRegistro;
	}

	public void setEsNuegoRegistro(boolean esNuegoRegistro) {
		this.esNuegoRegistro = esNuegoRegistro;
	}

	public BsEmpresaService getBsEmpresaServiceImpl() {
		return bsEmpresaServiceImpl;
	}

	public void setBsEmpresaServiceImpl(BsEmpresaService bsEmpresaServiceImpl) {
		this.bsEmpresaServiceImpl = bsEmpresaServiceImpl;
	}
	
	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	// LAZY
	public LazyDataModel<BsUsuario> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<BsUsuario>((List<BsUsuario>) bsUsuarioServiceImpl.findAll());
		}

		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<BsUsuario> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public LazyDataModel<BsRol> getLazyRolList() {
		if (Objects.isNull(lazyRolList)) {
			lazyRolList = new GenericLazyDataModel<BsRol>((List<BsRol>) bsRolServiceImpl.findAll());
		}
		return lazyRolList;
	}

	public void setLazyRolList(LazyDataModel<BsRol> lazyRolList) {
		this.lazyRolList = lazyRolList;
	}

	public LazyDataModel<BsPersona> getLazyPersonaList() {
		if (Objects.isNull(lazyPersonaList)) {
			lazyPersonaList = new GenericLazyDataModel<BsPersona>(bsPersonaServiceImpl.buscarTodosLista());
		}
		return lazyPersonaList;
	}

	public void setLazyPersonaList(LazyDataModel<BsPersona> lazyPersonaList) {
		this.lazyPersonaList = lazyPersonaList;
	}
	
	public LazyDataModel<BsEmpresa> getLazyEmpresaList() {
		if (Objects.isNull(lazyEmpresaList)) {
			lazyEmpresaList = new GenericLazyDataModel<BsEmpresa>((List<BsEmpresa>) bsEmpresaServiceImpl.findAll());
		}
		return lazyEmpresaList;
	}

	public void setLazyEmpresaList(LazyDataModel<BsEmpresa> lazyEmpresaList) {
		this.lazyEmpresaList = lazyEmpresaList;
	}

	// METODOS
	public void guardar() {
		if(Objects.isNull(bsUsuario.getBsEmpresa()) || Objects.isNull(bsUsuario.getBsEmpresa().getId())) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar una Empresa.");
			return;
		}
		if(Objects.isNull(bsUsuario.getBsPersona()) || Objects.isNull(bsUsuario.getBsPersona().getId())) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar una Persona.");
			return;
		}
		try {
			this.bsUsuario.setCodUsuario(this.bsUsuario.getCodUsuario().toLowerCase());
			this.bsUsuario.encryptPassword();
			this.bsUsuario.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			if (!Objects.isNull(bsUsuarioServiceImpl.save(this.bsUsuario))) {
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
							"El Usuario ya existe.");
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
			if (!Objects.isNull(this.bsUsuarioSelected)) {
				this.bsUsuarioServiceImpl.deleteById(this.bsUsuarioSelected.getId());
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
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", e.getMessage().substring(0, e.getMessage().length())+"...");
		}

	}
	
}
