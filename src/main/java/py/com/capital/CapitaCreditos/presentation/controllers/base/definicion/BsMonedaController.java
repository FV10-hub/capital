/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.controllers.base.definicion;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.view.ViewScoped;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsMonedaService;

import java.io.Serializable;
import java.util.List;
import java.util.Objects;

/**
 * descomentar si por algun motivo se necesita trabajar directo con spring
 * //@Component y // @Autowired
 */
@Component
@ViewScoped
//@Component
public class BsMonedaController implements Serializable {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(BsMonedaController.class);

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	// lazy
	private LazyDataModel<BsMoneda> lazyModel;

	// objetos
	private BsMoneda bsMoneda, bsMonedaSelected;
	private boolean esNuegoRegistro;

	// listas
	private List<String> estadoList;

	private static final String DT_NAME = "dt-moneda";
	private static final String DT_DIALOG_NAME = "manageMonedaDialog";

	// servicios
	@Autowired
	private BsMonedaService bsMonedaServiceImpl;

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
		this.bsMoneda = null;
		this.bsMonedaSelected = null;
		this.esNuegoRegistro = true;

		this.lazyModel = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS & SETTERS
	public BsMoneda getBsMoneda() {
		if (Objects.isNull(bsMoneda)) {
			this.bsMoneda = new BsMoneda();
		}
		return bsMoneda;
	}

	public void setBsMoneda(BsMoneda bsMoneda) {
		this.bsMoneda = bsMoneda;
	}

	public BsMoneda getBsMonedaSelected() {
		if (Objects.isNull(bsMonedaSelected)) {
			this.bsMonedaSelected = new BsMoneda();
		}
		return bsMonedaSelected;
	}

	public void setBsMonedaSelected(BsMoneda bsMonedaSelected) {
		if (!Objects.isNull(bsMonedaSelected)) {
			this.bsMoneda = bsMonedaSelected;
			this.esNuegoRegistro = false;
		}
		this.bsMonedaSelected = bsMonedaSelected;
	}

	public BsMonedaService getBsMonedaServiceImpl() {
		return bsMonedaServiceImpl;
	}

	public void setBsMonedaServiceImpl(BsMonedaService bsMonedaServiceImpl) {
		this.bsMonedaServiceImpl = bsMonedaServiceImpl;
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

	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	// LAZY
	public LazyDataModel<BsMoneda> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<BsMoneda>((List<BsMoneda>) bsMonedaServiceImpl.findAll());
		}

		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<BsMoneda> lazyModel) {
		this.lazyModel = lazyModel;
	}

	// METODOS
	public void guardar() {
		try {
			this.bsMoneda.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			if (!Objects.isNull(bsMonedaServiceImpl.save(this.bsMoneda))) {
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
							"El codigo para esta moneda ya existe.");
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
			if (!Objects.isNull(this.bsMonedaSelected)) {
				this.bsMonedaServiceImpl.deleteById(this.bsMonedaSelected.getId());
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
		}

	}

}
