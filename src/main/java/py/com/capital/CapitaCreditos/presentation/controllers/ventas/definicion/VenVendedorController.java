package py.com.capital.CapitaCreditos.presentation.controllers.ventas.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.ventas.VenVendedor;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsPersonaService;
import py.com.capital.CapitaCreditos.services.ventas.VenVendedorService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Objects;

/*
* 12 dic. 2023 - Elitebook
*/
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class VenVendedorController {
	
	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(VenVendedorController.class);

	private VenVendedor venVendedor, venVendedorSelected;
	private LazyDataModel<VenVendedor> lazyModel;
	private LazyDataModel<BsPersona> lazyPersonaList;

	private BsPersona bsPersonaSelected;
	private boolean esNuegoRegistro;

	private List<String> estadoList;

	private static final String DT_NAME = "dt-vendedor";
	private static final String DT_DIALOG_NAME = "manageVendedorDialog";
	
	@Autowired
	private VenVendedorService venVendedorServiceImpl;

	@Autowired
	private BsPersonaService bsPersonaServiceImpl;
	
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
		this.venVendedor = null;
		this.venVendedorSelected = null;
		this.bsPersonaSelected = null;
		this.esNuegoRegistro = true;

		this.lazyModel = null;
		this.lazyPersonaList = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS Y SETTERS
	public VenVendedor getVenVendedor() {
		if (Objects.isNull(venVendedor)) {
			this.venVendedor = new VenVendedor();
			this.venVendedor.setEstado(Estado.ACTIVO.getEstado());
			this.venVendedor.setBsEmpresa(new BsEmpresa());
			this.venVendedor.setBsPersona(new BsPersona());
		}
		return venVendedor;
	}

	public void setVenVendedor(VenVendedor venVendedor) {
		this.venVendedor = venVendedor;
	}

	public VenVendedor getVenVendedorSelected() {
		if (Objects.isNull(venVendedorSelected)) {
			this.venVendedorSelected = new VenVendedor();
			this.venVendedorSelected.setBsEmpresa(new BsEmpresa());
			this.venVendedorSelected.setBsPersona(new BsPersona());
		}
		return venVendedorSelected;
	}

	public void setVenVendedorSelected(VenVendedor venVendedorSelected) {
		if (!Objects.isNull(venVendedorSelected)) {
			this.venVendedor = venVendedorSelected;
			venVendedorSelected = null;
			this.esNuegoRegistro = false;
		}
		this.venVendedorSelected = venVendedorSelected;
	}

	public LazyDataModel<VenVendedor> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<VenVendedor>((List<VenVendedor>) venVendedorServiceImpl
					.buscarVenVendedorActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<VenVendedor> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public LazyDataModel<BsPersona> getLazyPersonaList() {
		if (Objects.isNull(lazyPersonaList)) {
			lazyPersonaList = new GenericLazyDataModel<BsPersona>(bsPersonaServiceImpl
					.personasSinFichaVendedorPorEmpresaNativo(this.sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyPersonaList;
	}

	public void setLazyPersonaList(LazyDataModel<BsPersona> lazyPersonaList) {
		this.lazyPersonaList = lazyPersonaList;
	}

	public BsPersona getBsPersonaSelected() {
		if (Objects.isNull(bsPersonaSelected)) {
			bsPersonaSelected = new BsPersona();
		}
		return bsPersonaSelected;
	}

	public void setBsPersonaSelected(BsPersona bsPersonaSelected) {
		if (!Objects.isNull(bsPersonaSelected.getId())) {
			this.venVendedor.setBsPersona(bsPersonaSelected);
			bsPersonaSelected = null;
		}
		this.bsPersonaSelected = bsPersonaSelected;
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

	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	public VenVendedorService getVenVendedorServiceImpl() {
		return venVendedorServiceImpl;
	}

	public void setVenVendedorServiceImpl(VenVendedorService venVendedorServiceImpl) {
		this.venVendedorServiceImpl = venVendedorServiceImpl;
	}
	
	// METODOS
		public void guardar() {
			if (Objects.isNull(venVendedor.getBsPersona()) || Objects.isNull(venVendedor.getBsPersona().getId())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar una Persona.");
				return;
			}
			try {
				this.venVendedor.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
				this.venVendedor.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
				//this.venVendedor.setCodVendedor(this.venVendedor.getBsPersona().getDocumento());
				if (!Objects.isNull(venVendedorServiceImpl.save(this.venVendedor))) {
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
							"El registro se guardo correctamente.");
				} else {
					CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
				}
				this.cleanFields();
			} catch (Exception e) {
				LOGGER.error("Ocurrio un error al Guardar", System.err);
				e.printStackTrace(System.err);

				Throwable cause = e.getCause();
				while (cause != null) {
					if (cause instanceof ConstraintViolationException) {
						CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
								"El codigo para este vendedor ya existe.");
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
			PrimeFaces.current().executeScript("PF('" + DT_DIALOG_NAME + "').hide()");
			PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);

		}

		public void delete() {
			try {
				if (!Objects.isNull(this.venVendedor)) {
					this.venVendedorServiceImpl.deleteById(this.venVendedor.getId());
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
