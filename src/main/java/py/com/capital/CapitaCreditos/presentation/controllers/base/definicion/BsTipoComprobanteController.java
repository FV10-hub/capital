package py.com.capital.CapitaCreditos.presentation.controllers.base.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsModulo;
import py.com.capital.CapitaCreditos.entities.base.BsTipoComprobante;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;
import py.com.capital.CapitaCreditos.services.base.BsTipoComprobanteService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Objects;

/*
* 30 nov. 2023 - Elitebook
*/
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class BsTipoComprobanteController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(BsTipoComprobanteController.class);

	private BsTipoComprobante bsTipoComprobante, bsTipoComprobanteSelected;
	private LazyDataModel<BsTipoComprobante> lazyModel;
	private LazyDataModel<BsModulo> lazyModuloList;

	private BsModulo bsModuloSelected;
	private boolean esNuegoRegistro;

	private List<String> estadoList;

	private static final String DT_NAME = "dt-tipocomprobante";
	private static final String DT_DIALOG_NAME = "manageTipoComprobanteDialog";

	@Autowired
	private BsModuloService bsModuloServiceImpl;

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
		this.bsTipoComprobante = null;
		this.bsTipoComprobanteSelected = null;
		this.bsModuloSelected = null;
		this.esNuegoRegistro = true;

		this.lazyModel = null;
		this.lazyModuloList = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS Y SETTERS
	public BsTipoComprobante getBsTipoComprobante() {
		if (Objects.isNull(bsTipoComprobante)) {
			this.bsTipoComprobante = new BsTipoComprobante();
			this.bsTipoComprobante.setBsEmpresa(new BsEmpresa());
			this.bsTipoComprobante.setBsModulo(new BsModulo());
		}
		return bsTipoComprobante;
	}

	public void setBsTipoComprobante(BsTipoComprobante bsTipoComprobante) {
		this.bsTipoComprobante = bsTipoComprobante;
	}

	public BsTipoComprobante getBsTipoComprobanteSelected() {
		if (Objects.isNull(bsTipoComprobanteSelected)) {
			this.bsTipoComprobanteSelected = new BsTipoComprobante();
			this.bsTipoComprobanteSelected.setBsEmpresa(new BsEmpresa());
			this.bsTipoComprobanteSelected.setBsModulo(new BsModulo());
		}
		return bsTipoComprobanteSelected;
	}

	public void setBsTipoComprobanteSelected(BsTipoComprobante bsTipoComprobanteSelected) {
		if (!Objects.isNull(bsTipoComprobanteSelected)) {
			this.bsTipoComprobante = bsTipoComprobanteSelected;
			bsTipoComprobanteSelected = null;
			this.esNuegoRegistro = false;
		}
		this.bsTipoComprobanteSelected = bsTipoComprobanteSelected;
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

	public BsModuloService getBsModuloServiceImpl() {
		return bsModuloServiceImpl;
	}

	public void setBsModuloServiceImpl(BsModuloService bsModuloServiceImpl) {
		this.bsModuloServiceImpl = bsModuloServiceImpl;
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

	public BsModulo getBsModuloSelected() {
		if (Objects.isNull(bsModuloSelected)) {
			bsModuloSelected = new BsModulo();
		}
		return bsModuloSelected;
	}

	public void setBsModuloSelected(BsModulo bsModuloSelected) {
		if (!Objects.isNull(bsModuloSelected.getId())) {
			this.bsTipoComprobante.setBsModulo(bsModuloSelected);
			bsModuloSelected = null;
		}
		this.bsModuloSelected = bsModuloSelected;
	}

	// LAZY
	public LazyDataModel<BsTipoComprobante> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<BsTipoComprobante>(
					(List<BsTipoComprobante>) bsTipoComprobanteServiceImpl
							.buscarBsTipoComprobanteActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<BsTipoComprobante> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public LazyDataModel<BsModulo> getLazyModuloList() {
		if (Objects.isNull(lazyModuloList)) {
			lazyModuloList = new GenericLazyDataModel<BsModulo>(
					(List<BsModulo>) bsModuloServiceImpl.buscarModulosActivosLista());
		}
		return lazyModuloList;
	}

	public void setLazyModuloList(LazyDataModel<BsModulo> lazyModuloList) {
		if (Objects.isNull(lazyModuloList)) {
			lazyModuloList = new GenericLazyDataModel<BsModulo>(
					(List<BsModulo>) bsModuloServiceImpl.buscarModulosActivosLista());
		}
		this.lazyModuloList = lazyModuloList;
	}

	// METODOS
	public void guardar() {
		if (Objects.isNull(bsTipoComprobante.getBsModulo())
				|| Objects.isNull(bsTipoComprobante.getBsModulo().getId())) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar una Modulo.");
			return;
		}
		try {
			this.bsTipoComprobante.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
			this.bsTipoComprobante.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			if (!Objects.isNull(bsTipoComprobanteServiceImpl.save(this.bsTipoComprobante))) {
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
							"El tipo de comprobante ya existe.");
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
			if (!Objects.isNull(this.bsTipoComprobante)) {
				this.bsTipoComprobanteServiceImpl.deleteById(this.bsTipoComprobante.getId());
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
