package py.com.capital.CapitaCreditos.presentation.controllers.cobranzas.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCaja;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCajaService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Objects;

/*
* 28 dic. 2023 - Elitebook
*/
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class CobCajaController {
	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(CobCajaController.class);

	private CobCaja cobCaja, cobCajaSelected;
	private LazyDataModel<CobCaja> lazyModel;
	private List<String> estadoList;
	private static final String DT_NAME = "dt-caja";
	private static final String DT_DIALOG_NAME = "manageCajasDialog";
	private boolean esNuegoRegistro;

	@Autowired
	private CobCajaService cobCajaServiceImpl;

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
		this.cobCaja = null;
		this.cobCajaSelected = null;
		this.lazyModel = null;
		this.esNuegoRegistro = true;
		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS & SETTERS
	public CobCaja getCobCaja() {
		if (Objects.isNull(cobCaja)) {
			this.cobCaja = new CobCaja();
			this.cobCaja.setEstado(Estado.ACTIVO.getEstado());
			this.cobCaja.setCodCaja(sessionBean.getUsuarioLogueado().getCodUsuario().toUpperCase());
			this.cobCaja.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
			this.cobCaja.setBsUsuario(sessionBean.getUsuarioLogueado());
		}
		return cobCaja;
	}

	public void setCobCaja(CobCaja cobCaja) {
		this.cobCaja = cobCaja;
	}

	public CobCaja getCobCajaSelected() {
		if (Objects.isNull(cobCajaSelected)) {
			this.cobCajaSelected = new CobCaja();
			this.cobCajaSelected.setBsUsuario(new BsUsuario());
			this.cobCajaSelected.getBsUsuario().setBsPersona(new BsPersona());
			this.cobCajaSelected.setBsEmpresa(new BsEmpresa());
		}
		return cobCajaSelected;
	}

	public void setCobCajaSelected(CobCaja cobCajaSelected) {
		if (!Objects.isNull(cobCajaSelected)) {
			this.cobCaja = cobCajaSelected;
			this.esNuegoRegistro = false;
		}
		this.cobCajaSelected = cobCajaSelected;
	}

	public LazyDataModel<CobCaja> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<CobCaja>(this.cobCajaServiceImpl.buscarTodosActivoLista());
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<CobCaja> lazyModel) {
		this.lazyModel = lazyModel;
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

	public CobCajaService getCobCajaServiceImpl() {
		return cobCajaServiceImpl;
	}

	public void setCobCajaServiceImpl(CobCajaService cobCajaServiceImpl) {
		this.cobCajaServiceImpl = cobCajaServiceImpl;
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
			this.cobCaja.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());

			if (!Objects.isNull(cobCajaServiceImpl.save(cobCaja))) {
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
							"La Caja para este usuario ya existe.");
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
			if (!Objects.isNull(this.cobCajaSelected)) {
				this.cobCajaServiceImpl.deleteById(this.cobCajaSelected.getId());
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
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		}

	}

}
