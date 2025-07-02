package py.com.capital.CapitaCreditos.presentation.controllers.base.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.entities.base.BsTimbrado;
import py.com.capital.CapitaCreditos.entities.base.BsTipoComprobante;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsTalonarioService;
import py.com.capital.CapitaCreditos.services.base.BsTimbradoService;
import py.com.capital.CapitaCreditos.services.base.BsTipoComprobanteService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.view.ViewScoped;
import javax.inject.Named;
import java.util.List;
import java.util.Objects;

/*
* 2 ene. 2024 - Elitebook
*/
@Named
@ViewScoped
public class BsTalonarioController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(BsTalonarioController.class);

	private BsTalonario bsTalonario, bsTalonarioSelected;
	private LazyDataModel<BsTalonario> lazyModel;
	private LazyDataModel<BsTimbrado> lazyModelBsTimbrado;
	private LazyDataModel<BsTipoComprobante> lazyModelBsTipoComprobante;

	private boolean esNuegoRegistro;

	private List<String> estadoList;

	private static final String DT_NAME = "dt-talonario";
	private static final String DT_DIALOG_NAME = "manageTalonarioDialog";

	@Autowired
	private BsTalonarioService bsTalonarioServiceImpl;

	@Autowired
	private BsTimbradoService bsTimbradoServiceImpl;

	@Autowired
	private BsTipoComprobanteService bsTipoComprobanteServiceImpl;

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
		this.bsTalonario = null;
		this.bsTalonarioSelected = null;
		this.esNuegoRegistro = true;

		this.lazyModel = null;
		this.lazyModelBsTimbrado = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS Y SETTERS
	public BsTalonario getBsTalonario() {
		if (Objects.isNull(bsTalonario)) {
			this.bsTalonario = new BsTalonario();
			this.bsTalonario.setEstado(Estado.ACTIVO.getEstado());
			this.bsTalonario.setBsTimbrado(new BsTimbrado());
			this.bsTalonario.setBsTipoComprobante(new BsTipoComprobante());
		}
		return bsTalonario;
	}

	public void setBsTalonario(BsTalonario bsTalonario) {
		this.bsTalonario = bsTalonario;
	}

	public BsTalonario getBsTalonarioSelected() {
		if (Objects.isNull(bsTalonarioSelected)) {
			this.bsTalonarioSelected = new BsTalonario();
			this.bsTalonarioSelected.setEstado(Estado.ACTIVO.getEstado());
			this.bsTalonarioSelected.setBsTimbrado(new BsTimbrado());
			this.bsTalonarioSelected.setBsTipoComprobante(new BsTipoComprobante());
		}
		return bsTalonarioSelected;
	}

	public void setBsTalonarioSelected(BsTalonario bsTalonarioSelected) {
		if (!Objects.isNull(bsTalonarioSelected)) {
			this.bsTalonario = bsTalonarioSelected;
			bsTalonarioSelected = null;
			this.esNuegoRegistro = false;
		}
		this.bsTalonarioSelected = bsTalonarioSelected;
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

	public BsTalonarioService getBsTalonarioServiceImpl() {
		return bsTalonarioServiceImpl;
	}

	public void setBsTalonarioServiceImpl(BsTalonarioService bsTalonarioServiceImpl) {
		this.bsTalonarioServiceImpl = bsTalonarioServiceImpl;
	}

	public BsTimbradoService getBsTimbradoServiceImpl() {
		return bsTimbradoServiceImpl;
	}

	public void setBsTimbradoServiceImpl(BsTimbradoService bsTimbradoServiceImpl) {
		this.bsTimbradoServiceImpl = bsTimbradoServiceImpl;
	}

	public BsTipoComprobanteService getBsTipoComprobanteServiceImpl() {
		return bsTipoComprobanteServiceImpl;
	}

	public void setBsTipoComprobanteServiceImpl(BsTipoComprobanteService bsTipoComprobanteServiceImpl) {
		this.bsTipoComprobanteServiceImpl = bsTipoComprobanteServiceImpl;
	}

	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	public LazyDataModel<BsTalonario> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<BsTalonario>((List<BsTalonario>) bsTalonarioServiceImpl
					.buscarBsTalonarioActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<BsTalonario> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public LazyDataModel<BsTimbrado> getLazyModelBsTimbrado() {
		if (Objects.isNull(lazyModelBsTimbrado)) {
			lazyModelBsTimbrado = new GenericLazyDataModel<BsTimbrado>((List<BsTimbrado>) bsTimbradoServiceImpl
					.buscarBsTimbradoActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyModelBsTimbrado;
	}

	public void setLazyModelBsTimbrado(LazyDataModel<BsTimbrado> lazyModelBsTimbrado) {
		this.lazyModelBsTimbrado = lazyModelBsTimbrado;
	}

	public LazyDataModel<BsTipoComprobante> getLazyModelBsTipoComprobante() {
		if (Objects.isNull(lazyModelBsTipoComprobante)) {
			lazyModelBsTipoComprobante = new GenericLazyDataModel<BsTipoComprobante>(
					(List<BsTipoComprobante>) bsTipoComprobanteServiceImpl
							.buscarBsTipoComprobanteActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyModelBsTipoComprobante;
	}

	public void setLazyModelBsTipoComprobante(LazyDataModel<BsTipoComprobante> lazyModelBsTipoComprobante) {
		this.lazyModelBsTipoComprobante = lazyModelBsTipoComprobante;
	}
	
	// METODOS
		public void guardar() {
			try {
				this.bsTalonario.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
				if (!Objects.isNull(bsTalonarioServiceImpl.save(this.bsTalonario))) {
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
								"El talonario ya existe.");
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
				if (!Objects.isNull(this.bsTalonario)) {
					this.bsTalonarioServiceImpl.deleteById(this.bsTalonario.getId());
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
