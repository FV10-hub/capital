package py.com.capital.CapitaCreditos.presentation.controllers.cobranzas.definicion;

import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.view.ViewScoped;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrador;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsPersonaService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCobradorService;

import java.util.List;
import java.util.Objects;

/*
* 30 nov. 2023 - Elitebook
*/
@Component
@ViewScoped
public class CobCobradorController {
	
	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(CobCobradorController.class);

	private CobCobrador cobCobrador, cobCobradorSelected;
	private LazyDataModel<CobCobrador> lazyModel;
	private LazyDataModel<BsPersona> lazyPersonaList;
	
	private BsPersona bsPersonaSelected;
	private boolean esNuegoRegistro;
	
	private List<String> estadoList;

	private static final String DT_NAME = "dt-cobrador";
	private static final String DT_DIALOG_NAME = "manageCobradorDialog";
		
	@Autowired
	private BsPersonaService bsPersonaServiceImpl;

	@Autowired
	private CobCobradorService cobCobradorServiceImpl;
	
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
		this.cobCobrador = null;
		this.cobCobradorSelected = null;
		this.bsPersonaSelected = null;
		this.esNuegoRegistro = true;

		this.lazyModel = null;
		this.lazyPersonaList = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	//GETTERS Y SETTERS
	public CobCobrador getCobCobrador() {
		if (Objects.isNull(cobCobrador)) {
			this.cobCobrador = new CobCobrador();
			this.cobCobrador.setBsEmpresa(new BsEmpresa());
			this.cobCobrador.setBsPersona(new BsPersona());
		}
		return cobCobrador;
	}

	public void setCobCobrador(CobCobrador cobCobrador) {
		this.cobCobrador = cobCobrador;
	}

	public CobCobrador getCobCobradorSelected() {
		if (Objects.isNull(cobCobradorSelected)) {
			this.cobCobradorSelected = new CobCobrador();
			this.cobCobradorSelected.setBsEmpresa(new BsEmpresa());
			this.cobCobradorSelected.setBsPersona(new BsPersona());
		}
		return cobCobradorSelected;
	}

	public void setCobCobradorSelected(CobCobrador cobCobradorSelected) {
		if (!Objects.isNull(cobCobradorSelected)) {
			this.cobCobrador = cobCobradorSelected;
			cobCobradorSelected = null;
			this.esNuegoRegistro = false;
		}
		this.cobCobradorSelected = cobCobradorSelected;
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

	public CobCobradorService getCobCobradorServiceImpl() {
		return cobCobradorServiceImpl;
	}

	public void setCobCobradorServiceImpl(CobCobradorService cobCobradorServiceImpl) {
		this.cobCobradorServiceImpl = cobCobradorServiceImpl;
	}
	
	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}
	
	public BsPersona getBsPersonaSelected() {
		if(Objects.isNull(bsPersonaSelected)) {
			bsPersonaSelected = new BsPersona();
		}
		return bsPersonaSelected;
	}

	public void setBsPersonaSelected(BsPersona bsPersonaSelected) {
		if (!Objects.isNull(bsPersonaSelected.getId())) {
			this.cobCobrador.setBsPersona(bsPersonaSelected);
			bsPersonaSelected = null;
		}
		
		this.bsPersonaSelected = bsPersonaSelected;
	}

	

	//LAZY
	public LazyDataModel<CobCobrador> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<CobCobrador>((List<CobCobrador>) 
					cobCobradorServiceImpl.buscarCobradorActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<CobCobrador> lazyModel) {
		this.lazyModel = lazyModel;
	}


	public LazyDataModel<BsPersona> getLazyPersonaList() {
		if (Objects.isNull(lazyPersonaList)) {
			lazyPersonaList = new GenericLazyDataModel<BsPersona>(bsPersonaServiceImpl
					.personasSinFichaCobradorPorEmpresaNativo(this.sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyPersonaList;
	}

	public void setLazyPersonaList(LazyDataModel<BsPersona> lazyPersonaList) {
		this.lazyPersonaList = lazyPersonaList;
	}
	

	//METODOS
		public void guardar() {
			if(Objects.isNull(cobCobrador.getBsPersona()) || Objects.isNull(cobCobrador.getBsPersona().getId())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar una Persona.");
				return;
			}
			try {
				this.cobCobrador.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
				this.cobCobrador.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
				if (!Objects.isNull(cobCobradorServiceImpl.save(this.cobCobrador))) {
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
								"El cobrador para esta persona ya existe.");
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
				if (!Objects.isNull(this.cobCobrador)) {
					this.cobCobradorServiceImpl.deleteById(this.cobCobrador.getId());
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
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", e.getMessage().substring(0, e.getMessage().length())+"...");
			}

		}
	
	
	
}
