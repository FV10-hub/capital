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
import py.com.capital.CapitaCreditos.entities.base.BsModulo;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Objects;

/**
 * descomentar si por algun motivo se necesita trabajar directo con spring
 * //@Component y // @Autowired
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class BsModuloController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(BsModuloController.class);

	private BsModulo bsModulo, bsModuloSelected;
	private LazyDataModel<BsModulo> lazyModel;
	private List<String> estadoList;
	private boolean esNuegoRegistro;

	@Autowired
	private BsModuloService bsModuloServiceImpl;
	
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
		this.bsModulo = null;
		this.bsModuloSelected = null;
		this.lazyModel = null;
		this.esNuegoRegistro = true;
		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS & SETTERS
	public BsModulo getBsModulo() {
		if (Objects.isNull(bsModulo)) {
			this.bsModulo = new BsModulo();
			this.bsModulo.setEstado(Estado.ACTIVO.getEstado());
		}
		return bsModulo;
	}

	public void setBsModulo(BsModulo bsModulo) {
		this.bsModulo = bsModulo;
	}

	public BsModulo getBsModuloSelected() {
		if (Objects.isNull(bsModuloSelected)) {
			this.bsModuloSelected = new BsModulo();

		}
		return bsModuloSelected;
	}

	public void setBsModuloSelected(BsModulo bsModuloSelected) {
		if (!Objects.isNull(bsModuloSelected)) {
			this.bsModulo = bsModuloSelected;
			this.esNuegoRegistro = false;
		}
		this.bsModuloSelected = bsModuloSelected;
	}

	public List<String> getEstadoList() {
		return estadoList;
	}

	public void setEstadoList(List<String> estadoList) {
		this.estadoList = estadoList;
	}

	public LazyDataModel<BsModulo> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<BsModulo>(bsModuloServiceImpl.buscarTodosLista());
		}

		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<BsModulo> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public BsModuloService getBsModuloServiceImpl() {
		return bsModuloServiceImpl;
	}

	public void setBsModuloServiceImpl(BsModuloService bsModuloServiceImpl) {
		this.bsModuloServiceImpl = bsModuloServiceImpl;
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

	// METODOS
	public void guardar() {
		try {
			this.bsModulo.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			if (!Objects.isNull(bsModuloServiceImpl.guardar(this.bsModulo))) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se guardo correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().executeScript("PF('manageModuloDialog').hide()");
			PrimeFaces.current().ajax().update("form:messages", "form:dt-modulo");
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", e);
			// e.printStackTrace(System.err);
			String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);
			PrimeFaces.current().ajax().update("form:messages", "form:dt-modulo");
		}

	}

	public void delete() {
		try {
			if (!Objects.isNull(this.bsModuloSelected)) {
				this.bsModuloServiceImpl.eliminar(this.bsModuloSelected.getId());
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se elimino correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:dt-modulo");
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al eliminar", e);
			// e.printStackTrace(System.err);
			String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);
			PrimeFaces.current().ajax().update("form:messages", "form:dt-modulo");
		}

	}
	
}
