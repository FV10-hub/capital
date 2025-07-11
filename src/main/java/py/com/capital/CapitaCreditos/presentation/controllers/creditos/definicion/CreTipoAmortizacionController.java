package py.com.capital.CapitaCreditos.presentation.controllers.creditos.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.creditos.CreTipoAmortizacion;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.creditos.CreTipoAmortizacionService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Objects;

/*
* 27 dic. 2023 - Elitebook
*/
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class CreTipoAmortizacionController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(CreTipoAmortizacionController.class);

	private CreTipoAmortizacion creTipoAmortizacion, creTipoAmortizacionSelected;
	private LazyDataModel<CreTipoAmortizacion> lazyModel;
	private List<String> estadoList;
	private boolean esNuegoRegistro;

	@Autowired
	private CreTipoAmortizacionService creTipoAmortizacionServiceImpl;

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
		this.creTipoAmortizacion = null;
		this.creTipoAmortizacionSelected = null;
		this.lazyModel = null;
		this.esNuegoRegistro = true;
		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS & SETTERS
	public CreTipoAmortizacion getCreTipoAmortizacion() {
		if (Objects.isNull(creTipoAmortizacion)) {
			this.creTipoAmortizacion = new CreTipoAmortizacion();
			this.creTipoAmortizacion.setEstado(Estado.ACTIVO.getEstado());
		}
		return creTipoAmortizacion;
	}

	public void setCreTipoAmortizacion(CreTipoAmortizacion creTipoAmortizacion) {
		this.creTipoAmortizacion = creTipoAmortizacion;
	}

	public CreTipoAmortizacion getCreTipoAmortizacionSelected() {
		if (Objects.isNull(creTipoAmortizacionSelected)) {
			this.creTipoAmortizacionSelected = new CreTipoAmortizacion();
			this.creTipoAmortizacionSelected.setEstado(Estado.ACTIVO.getEstado());
		}
		return creTipoAmortizacionSelected;
	}

	public void setCreTipoAmortizacionSelected(CreTipoAmortizacion creTipoAmortizacionSelected) {
		if (!Objects.isNull(creTipoAmortizacionSelected)) {
			this.creTipoAmortizacion = creTipoAmortizacionSelected;
			this.esNuegoRegistro = false;
		}
		this.creTipoAmortizacionSelected = creTipoAmortizacionSelected;
	}

	public LazyDataModel<CreTipoAmortizacion> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<CreTipoAmortizacion>(
					creTipoAmortizacionServiceImpl.buscarCreTipoAmortizacionActivosLista());
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<CreTipoAmortizacion> lazyModel) {
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

	public CreTipoAmortizacionService getCreTipoAmortizacionServiceImpl() {
		return creTipoAmortizacionServiceImpl;
	}

	public void setCreTipoAmortizacionServiceImpl(CreTipoAmortizacionService creTipoAmortizacionServiceImpl) {
		this.creTipoAmortizacionServiceImpl = creTipoAmortizacionServiceImpl;
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
			this.creTipoAmortizacion.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			if (!Objects.isNull(creTipoAmortizacionServiceImpl.save(this.creTipoAmortizacion))) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se guardo correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().executeScript("PF('manageTipoAmortizacionDialog').hide()");
			PrimeFaces.current().ajax().update("form:messages", "form:dt-tipoAmortizacion");
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", System.err);
			// e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");
		}

	}

	public void delete() {
		try {
			if (!Objects.isNull(this.creTipoAmortizacionSelected)) {
				this.creTipoAmortizacionServiceImpl.deleteById(this.creTipoAmortizacionSelected.getId());
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se elimino correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:dt-tipoAmortizacion");
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", System.err);
			// e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");
		}

	}

}
