package py.com.capital.CapitaCreditos.presentation.controllers.creditos.definicion;

import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.view.ViewScoped;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.creditos.CreMotivoPrestamo;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.creditos.CreMotivoPrestamoService;

import java.util.List;
import java.util.Objects;

/*
* 27 dic. 2023 - Elitebook
*/
@Component
@ViewScoped
public class CreMotivoPrestamoController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(CreMotivoPrestamoController.class);

	private CreMotivoPrestamo creMotivoPrestamo, creMotivoPrestamoSelected;
	private LazyDataModel<CreMotivoPrestamo> lazyModel;
	private List<String> estadoList;
	private boolean esNuegoRegistro;
	
	private static final String DT_NAME = "dt-motivo";
	private static final String DT_DIALOG_NAME = "manageMotidoPrestamoDialog";

	@Autowired
	private CreMotivoPrestamoService creMotivoPrestamoServiceImpl;

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
		this.creMotivoPrestamo = null;
		this.creMotivoPrestamoSelected = null;
		this.lazyModel = null;
		this.esNuegoRegistro = true;
		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS & SETTERS
	public CreMotivoPrestamo getCreMotivoPrestamo() {
		if (Objects.isNull(creMotivoPrestamo)) {
			this.creMotivoPrestamo = new CreMotivoPrestamo();
			this.creMotivoPrestamo.setEstado(Estado.ACTIVO.getEstado());
		}
		return creMotivoPrestamo;
	}

	public void setCreMotivoPrestamo(CreMotivoPrestamo creMotivoPrestamo) {
		this.creMotivoPrestamo = creMotivoPrestamo;
	}

	public CreMotivoPrestamo getCreMotivoPrestamoSelected() {
		if (Objects.isNull(creMotivoPrestamoSelected)) {
			this.creMotivoPrestamoSelected = new CreMotivoPrestamo();
			this.creMotivoPrestamoSelected.setEstado(Estado.ACTIVO.getEstado());
		}
		return creMotivoPrestamoSelected;
	}

	public void setCreMotivoPrestamoSelected(CreMotivoPrestamo creMotivoPrestamoSelected) {
		if (!Objects.isNull(creMotivoPrestamoSelected)) {
			this.creMotivoPrestamo = creMotivoPrestamoSelected;
			this.esNuegoRegistro = false;
		}
		this.creMotivoPrestamoSelected = creMotivoPrestamoSelected;
	}

	public LazyDataModel<CreMotivoPrestamo> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<CreMotivoPrestamo>(
					creMotivoPrestamoServiceImpl.buscarCreMotivoPrestamoActivosLista());
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<CreMotivoPrestamo> lazyModel) {
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

	public CreMotivoPrestamoService getCreMotivoPrestamoServiceImpl() {
		return creMotivoPrestamoServiceImpl;
	}

	public void setCreMotivoPrestamoServiceImpl(CreMotivoPrestamoService creMotivoPrestamoServiceImpl) {
		this.creMotivoPrestamoServiceImpl = creMotivoPrestamoServiceImpl;
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
			this.creMotivoPrestamo.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			if (!Objects.isNull(creMotivoPrestamoServiceImpl.save(this.creMotivoPrestamo))) {
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
			// e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");
		}

	}

	public void delete() {
		try {
			if (!Objects.isNull(this.creMotivoPrestamoSelected)) {
				this.creMotivoPrestamoServiceImpl.deleteById(this.creMotivoPrestamoSelected.getId());
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se elimino correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", System.err);
			// e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");
		}

	}

}
