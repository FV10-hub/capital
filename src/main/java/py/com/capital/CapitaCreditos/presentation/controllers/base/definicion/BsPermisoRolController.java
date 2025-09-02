/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.controllers.base.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.event.SelectEvent;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsMenu;
import py.com.capital.CapitaCreditos.entities.base.BsPermisoRol;
import py.com.capital.CapitaCreditos.entities.base.BsRol;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobSaldo;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsMenuService;
import py.com.capital.CapitaCreditos.services.base.BsPermisoRolService;
import py.com.capital.CapitaCreditos.services.base.BsRolService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;

import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * descomentar si por algun motivo se necesita trabajar directo con spring
 * //@Component y // @Autowired
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class BsPermisoRolController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(BsPermisoRolController.class);

	private BsPermisoRol bsPermisoRol, bsPermisoRolSelected;
	private LazyDataModel<BsPermisoRol> lazyModel;
	private LazyDataModel<BsMenu> lazyMenuList;
	private LazyDataModel<BsRol> lazyRolList;
	private boolean esNuegoRegistro;

	private static final String DT_NAME = "dt-permiso";
	private static final String DT_DIALOG_NAME = "managePermisoDialog";

	@Autowired
	private BsPermisoRolService bsPermisoRolServiceImpl;

	@Autowired
	private BsMenuService bsMenuServiceImpl;

	@Autowired
	private BsRolService bsRolServiceImpl;

	private boolean puedeCrear, puedeEditar, puedeEliminar = false;
	
	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
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
		this.bsPermisoRol = null;
		this.bsPermisoRolSelected = null;
		this.lazyModel = null;
		this.lazyMenuList = null;
		this.lazyRolList = null;
		this.esNuegoRegistro = true;
	}

	// GETTERS & SETTERS
	public BsPermisoRol getBsPermisoRol() {
		if (Objects.isNull(bsPermisoRol)) {
			bsPermisoRol = new BsPermisoRol();
			bsPermisoRol.setDescripcion("PERMISOS");
			bsPermisoRol.setPuedeCrear(false);
			bsPermisoRol.setPuedeEditar(false);
			bsPermisoRol.setPuedeEliminar(false);
			bsPermisoRol.setBsMenu(new BsMenu());
			bsPermisoRol.setRol(new BsRol());
		}
		return bsPermisoRol;
	}

	public void setBsPermisoRol(BsPermisoRol bsPermisoRol) {
		this.bsPermisoRol = bsPermisoRol;
	}

	public BsPermisoRol getBsPermisoRolSelected() {
		if (Objects.isNull(bsPermisoRolSelected)) {
			bsPermisoRolSelected = new BsPermisoRol();
			bsPermisoRolSelected.setBsMenu(new BsMenu());
			bsPermisoRolSelected.setRol(new BsRol());
		}
		return bsPermisoRolSelected;
	}

	public void setBsPermisoRolSelected(BsPermisoRol bsPermisoRolSelected) {
		if (!Objects.isNull(bsPermisoRolSelected)) {
			this.bsPermisoRol = bsPermisoRolSelected;
			this.esNuegoRegistro = false;
		}
		this.bsPermisoRolSelected = bsPermisoRolSelected;
	}

	public LazyDataModel<BsPermisoRol> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			//ordeno de forma descendente
			lazyModel = new GenericLazyDataModel<BsPermisoRol>(this.bsPermisoRolServiceImpl.buscarTodosLista()
					.stream()
					.sorted(Comparator.comparing(BsPermisoRol::getId).reversed())
					.collect(Collectors.toList()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<BsPermisoRol> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public LazyDataModel<BsMenu> getLazyMenuList() {
		if (Objects.isNull(lazyMenuList)) {
			lazyMenuList = new GenericLazyDataModel<BsMenu>(this.bsMenuServiceImpl.buscarTodosLista());
		}
		return lazyMenuList;
	}

	public void setLazyMenuList(LazyDataModel<BsMenu> lazyMenuList) {
		this.lazyMenuList = lazyMenuList;
	}

	public LazyDataModel<BsRol> getLazyRolList() {
		if (Objects.isNull(lazyRolList)) {
			lazyRolList = new GenericLazyDataModel<BsRol>((List<BsRol>) this.bsRolServiceImpl.findAll());
		}
		return lazyRolList;
	}

	public void setLazyRolList(LazyDataModel<BsRol> lazyRolList) {
		this.lazyRolList = lazyRolList;
	}

	public BsPermisoRolService getBsPermisoRolServiceImpl() {
		return bsPermisoRolServiceImpl;
	}

	public void setBsPermisoRolServiceImpl(BsPermisoRolService bsPermisoRolServiceImpl) {
		this.bsPermisoRolServiceImpl = bsPermisoRolServiceImpl;
	}

	public BsMenuService getBsMenuServiceImpl() {
		return bsMenuServiceImpl;
	}

	public void setBsMenuServiceImpl(BsMenuService bsMenuServiceImpl) {
		this.bsMenuServiceImpl = bsMenuServiceImpl;
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
	
	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
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

	// METODOS
	public void guardar() {
		try {
			this.bsPermisoRol.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			if (!Objects.isNull(bsPermisoRolServiceImpl.save(bsPermisoRol))) {
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
							"El permiso ya existe.");
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
			if (!Objects.isNull(this.bsPermisoRolSelected)) {
				this.bsPermisoRolServiceImpl.deleteById(this.bsPermisoRolSelected.getId());
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

	public void onRowSelectMenu(SelectEvent<BsMenu> event) {
		if (!Objects.isNull(event.getObject())) {
			this.bsPermisoRol.setBsMenu(event.getObject());
			PrimeFaces.current().ajax().update("form:manage-permiso");
			PrimeFaces.current().executeScript("PF('dlgMenu').hide()");

		}
	}

	public void onRowSelectRol(SelectEvent<BsRol> event) {
		if (!Objects.isNull(event.getObject())) {
			this.bsPermisoRol.setRol(event.getObject());
			PrimeFaces.current().ajax().update("form:manage-permiso");
			PrimeFaces.current().executeScript("PF('dlgRol').hide()");

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
