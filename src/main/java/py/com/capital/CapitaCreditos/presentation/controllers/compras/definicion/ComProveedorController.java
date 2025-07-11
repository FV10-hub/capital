package py.com.capital.CapitaCreditos.presentation.controllers.compras.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.compras.ComProveedor;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsPersonaService;
import py.com.capital.CapitaCreditos.services.compras.ComProveedorService;

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
public class ComProveedorController {
	
	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(ComProveedorController.class);

	private ComProveedor comProveedor, comProveedorSelected;
	private LazyDataModel<ComProveedor> lazyModel;
	private LazyDataModel<BsPersona> lazyPersonaList;

	private BsPersona bsPersonaSelected;
	private boolean esNuegoRegistro;

	private List<String> estadoList;

	private static final String DT_NAME = "dt-proveedor";
	private static final String DT_DIALOG_NAME = "manageProveedorDialog";

	@Autowired
	private BsPersonaService bsPersonaServiceImpl;

	@Autowired
	private ComProveedorService comProveedorServiceImpl;

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
		this.comProveedor = null;
		this.comProveedorSelected = null;
		this.bsPersonaSelected = null;
		this.esNuegoRegistro = true;

		this.lazyModel = null;
		this.lazyPersonaList = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS Y SETTERS
	public ComProveedor getComProveedor() {
		if (Objects.isNull(comProveedor)) {
			this.comProveedor = new ComProveedor();
			this.comProveedor.setBsEmpresa(new BsEmpresa());
			this.comProveedor.setBsPersona(new BsPersona());
		}
		return comProveedor;
	}

	public void setComProveedor(ComProveedor comProveedor) {
		this.comProveedor = comProveedor;
	}

	public ComProveedor getComProveedorSelected() {
		if (Objects.isNull(comProveedorSelected)) {
			this.comProveedorSelected = new ComProveedor();
			this.comProveedorSelected.setBsEmpresa(new BsEmpresa());
			this.comProveedorSelected.setBsPersona(new BsPersona());
		}
		return comProveedorSelected;
	}

	public void setComProveedorSelected(ComProveedor comProveedorSelected) {
		if (!Objects.isNull(comProveedorSelected)) {
			this.comProveedor = comProveedorSelected;
			comProveedorSelected = null;
			this.esNuegoRegistro = false;
		}
		this.comProveedorSelected = comProveedorSelected;
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

	public ComProveedorService getComProveedorServiceImpl() {
		return comProveedorServiceImpl;
	}

	public void setComProveedorServiceImpl(ComProveedorService comProveedorServiceImpl) {
		this.comProveedorServiceImpl = comProveedorServiceImpl;
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
			this.comProveedor.setBsPersona(bsPersonaSelected);
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

	// LAZY
	public LazyDataModel<ComProveedor> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<ComProveedor>((List<ComProveedor>) comProveedorServiceImpl
					.buscarComProveedorActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<ComProveedor> lazyModel) {
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

	// METODOS
	public void guardar() {
		if (Objects.isNull(comProveedor.getBsPersona()) || Objects.isNull(comProveedor.getBsPersona().getId())) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar una Persona.");
			return;
		}
		try {
			this.comProveedor.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			this.comProveedor.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
			if (!Objects.isNull(comProveedorServiceImpl.save(this.comProveedor))) {
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
							"El proveedor para esta persona ya existe.");
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
			if (!Objects.isNull(this.comProveedor)) {
				this.comProveedorServiceImpl.deleteById(this.comProveedor.getId());
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
