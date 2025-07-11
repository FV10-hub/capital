package py.com.capital.CapitaCreditos.presentation.controllers.cobranzas.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCaja;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCajaService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobHabilitacionCajaService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Objects;

/*
* 28 dic. 2023 - Elitebook
*/
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class CobHabilitacionCajaController {
	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(CobHabilitacionCajaController.class);

	private CobHabilitacionCaja cobHabilitacionCaja, cobHabilitacionCajaSelected;
	private CobCaja cobCajaSelected;
	private LazyDataModel<CobHabilitacionCaja> lazyModel;
	private List<String> estadoList;
	private static final String DT_NAME = "dt-habilitacion";
	private static final String DT_DIALOG_NAME = "manageHabilitacionDialog";
	private boolean esNuegoRegistro;
	private boolean tieneHabilitacionAbiertaRendered;
	DateTimeFormatter horaFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

	@Autowired
	private CobHabilitacionCajaService cobHabilitacionCajaServiceImpl;

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
		this.cobCajaSelected = this.cobCajaServiceImpl.usuarioTieneCaja(this.sessionBean.getUsuarioLogueado().getId());
		this.validarCajaDelUsuario(this.cobCajaSelected);
		if (!Objects.isNull(this.cobCajaSelected)) {
			this.validarHabilitacion();
		}

		this.cobHabilitacionCaja = null;
		this.cobHabilitacionCajaSelected = null;
		this.lazyModel = null;
		this.esNuegoRegistro = true;
		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS & SETTERS
	public CobHabilitacionCaja getCobHabilitacionCaja() {

		if (Objects.isNull(cobHabilitacionCaja)) {
			this.cobHabilitacionCaja = new CobHabilitacionCaja();
			this.cobHabilitacionCaja.setFechaApertura(LocalDateTime.now());
			this.cobHabilitacionCaja.setFechaCierre(null);
			this.cobHabilitacionCaja.setHoraApertura(LocalDateTime.now().format(horaFormatter));
			this.cobHabilitacionCaja.setHoraCierre(null);
			this.cobHabilitacionCaja.setCobCaja(this.cobCajaSelected);
			this.cobHabilitacionCaja.setIndCerradoBoolean(false);
			this.cobHabilitacionCaja.setEstado(Estado.ACTIVO.getEstado());
			this.cobHabilitacionCaja.setBsUsuario(sessionBean.getUsuarioLogueado());
		}
		return cobHabilitacionCaja;
	}

	public void setCobHabilitacionCaja(CobHabilitacionCaja cobHabilitacionCaja) {
		this.cobHabilitacionCaja = cobHabilitacionCaja;
	}

	public CobHabilitacionCaja getCobHabilitacionCajaSelected() {
		if (Objects.isNull(cobHabilitacionCajaSelected)) {
			this.cobHabilitacionCajaSelected = new CobHabilitacionCaja();
			this.cobHabilitacionCajaSelected.setFechaApertura(LocalDateTime.now());
			this.cobHabilitacionCajaSelected.setFechaCierre(LocalDateTime.now());
			this.cobHabilitacionCajaSelected.setHoraApertura(LocalDateTime.now().format(horaFormatter));
			this.cobHabilitacionCajaSelected.setHoraCierre(LocalDateTime.now().format(horaFormatter));
			this.cobHabilitacionCajaSelected.setCobCaja(new CobCaja());
			this.cobHabilitacionCajaSelected.setIndCerradoBoolean(false);
			this.cobHabilitacionCajaSelected.setEstado(Estado.ACTIVO.getEstado());
			this.cobHabilitacionCajaSelected.setBsUsuario(sessionBean.getUsuarioLogueado());
		}
		return cobHabilitacionCajaSelected;
	}

	public void setCobHabilitacionCajaSelected(CobHabilitacionCaja cobHabilitacionCajaSelected) {
		if (!Objects.isNull(cobHabilitacionCajaSelected)) {
			this.cobHabilitacionCaja = cobHabilitacionCajaSelected;
			cobHabilitacionCajaSelected = null;
			this.esNuegoRegistro = false;
		}
		this.cobHabilitacionCajaSelected = cobHabilitacionCajaSelected;
	}

	public LazyDataModel<CobHabilitacionCaja> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<CobHabilitacionCaja>(this.cobHabilitacionCajaServiceImpl
					.buscarCobHabilitacionCajaActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<CobHabilitacionCaja> lazyModel) {
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

	public CobHabilitacionCajaService getCobHabilitacionCajaServiceImpl() {
		return cobHabilitacionCajaServiceImpl;
	}

	public void setCobHabilitacionCajaServiceImpl(CobHabilitacionCajaService cobHabilitacionCajaServiceImpl) {
		this.cobHabilitacionCajaServiceImpl = cobHabilitacionCajaServiceImpl;
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

	public boolean isTieneHabilitacionAbiertaRendered() {
		return tieneHabilitacionAbiertaRendered;
	}

	public void setTieneHabilitacionAbiertaRendered(boolean tieneHabilitacionAbiertaRendered) {
		this.tieneHabilitacionAbiertaRendered = tieneHabilitacionAbiertaRendered;
	}

	// METODOS
	public void validarCajaDelUsuario(CobCaja caja) {
		if (Objects.isNull(caja)) {
			PrimeFaces.current().executeScript("PF('dlgNoTieneCaja').show()");
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
			return;
		}
	}

	public void validarHabilitacion() {
		String valor = this.cobHabilitacionCajaServiceImpl
				.validaHabilitacionAbierta(this.sessionBean.getUsuarioLogueado().getId(), this.cobCajaSelected.getId());
		this.tieneHabilitacionAbiertaRendered = valor.equalsIgnoreCase("S");
		PrimeFaces.current().ajax().update("form:messages", "form:btnNuevo");
		return;

	}

	public void redireccionarACajas() {
		try {
			PrimeFaces.current().executeScript("PF('dlgNoTieneCaja').hide()");
			CommonUtils.redireccionar("/pages/cliente/cobranzas/definicion/CobCaja.xhtml");
		} catch (IOException e) {
			e.printStackTrace();
			LOGGER.error("Ocurrio un error al Guardar", System.err);
		}
	}

	public void setFechaYHoraCierre() {
		if (this.cobHabilitacionCaja.isIndCerradoBoolean()) {
			this.cobHabilitacionCaja.setFechaCierre(LocalDateTime.now());
			this.cobHabilitacionCaja.setHoraCierre(LocalDateTime.now().format(horaFormatter));
		} else {
			this.cobHabilitacionCaja.setFechaCierre(null);
			this.cobHabilitacionCaja.setHoraCierre(null);
		}

	}

	public void guardar() {
		// FALTA REVISAR POR UQE CREA EN VEZ DE EDITAR
		try {
			if (Objects.isNull(this.cobHabilitacionCaja.getId())) {
				this.cobHabilitacionCaja
						.setNroHabilitacion(cobHabilitacionCajaServiceImpl.calcularNroHabilitacionDisponible());
			}

			this.cobHabilitacionCaja.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			this.setFechaYHoraCierre();
			if (!Objects.isNull(cobHabilitacionCajaServiceImpl.save(this.cobHabilitacionCaja))) {
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
							"El nro. Habilitacion ya existe.");
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
			if (!Objects.isNull(this.cobHabilitacionCaja)) {
				this.cobHabilitacionCajaServiceImpl.deleteById(this.cobHabilitacionCaja.getId());
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
