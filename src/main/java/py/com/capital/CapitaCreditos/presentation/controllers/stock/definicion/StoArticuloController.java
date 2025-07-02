package py.com.capital.CapitaCreditos.presentation.controllers.stock.definicion;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsIva;
import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsIvaService;
import py.com.capital.CapitaCreditos.services.stock.StoArticuloService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.view.ViewScoped;
import javax.inject.Named;
import java.util.List;
import java.util.Objects;

/*
* 12 dic. 2023 - Elitebook
*/
@Named
@ViewScoped
public class StoArticuloController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(StoArticuloController.class);

	private StoArticulo stoArticulo, stoArticuloSelected;
	private LazyDataModel<StoArticulo> lazyModel;
	private List<BsIva> lazyIvaList;

	private BsIva bsIvaSelected;
	private boolean esNuegoRegistro;

	private List<String> estadoList;

	private static final String DT_NAME = "dt-articulo";
	private static final String DT_DIALOG_NAME = "manageArticuloDialog";

	@Autowired
	private StoArticuloService stoArticuloServiceImpl;

	@Autowired
	private BsIvaService bsIvaServiceImpl;

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
		this.stoArticulo = null;
		this.stoArticuloSelected = null;
		this.bsIvaSelected = null;
		this.esNuegoRegistro = true;

		this.lazyModel = null;
		this.lazyIvaList = null;

		this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado());
	}

	// GETTERS Y SETTERS
	public StoArticulo getStoArticulo() {
		if (Objects.isNull(stoArticulo)) {
			this.stoArticulo = new StoArticulo();
			this.stoArticulo.setEstado(Estado.ACTIVO.getEstado());
			;
			this.stoArticulo.setIndInventariableAux(false);
			this.stoArticulo.setBsEmpresa(new BsEmpresa());
			this.stoArticulo.setBsIva(new BsIva());
		}
		return stoArticulo;
	}

	public void setStoArticulo(StoArticulo stoArticulo) {
		this.stoArticulo = stoArticulo;
	}

	public StoArticulo getStoArticuloSelected() {
		if (Objects.isNull(stoArticuloSelected)) {
			this.stoArticuloSelected = new StoArticulo();
			this.stoArticuloSelected.setBsEmpresa(new BsEmpresa());
			this.stoArticuloSelected.setBsIva(new BsIva());
		}
		return stoArticuloSelected;
	}

	public void setStoArticuloSelected(StoArticulo stoArticuloSelected) {
		if (!Objects.isNull(stoArticuloSelected)) {
			this.stoArticulo = stoArticuloSelected;
			stoArticuloSelected = null;
			this.esNuegoRegistro = false;
		}
		this.stoArticuloSelected = stoArticuloSelected;
	}

	public LazyDataModel<StoArticulo> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<StoArticulo>((List<StoArticulo>) stoArticuloServiceImpl
					.buscarStoArticuloActivosLista(sessionBean.getUsuarioLogueado().getBsEmpresa().getId()));
		}
		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<StoArticulo> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public List<BsIva> getLazyIvaList() {
		if (Objects.isNull(lazyIvaList)) {
			lazyIvaList = bsIvaServiceImpl.buscarIvaActivosLista();
		}
		return lazyIvaList;
	}

	public void setLazyIvaList(List<BsIva> lazyIvaList) {
		this.lazyIvaList = lazyIvaList;
	}

	public BsIva getBsIvaSelected() {
		if (Objects.isNull(bsIvaSelected)) {
			this.bsIvaSelected = new BsIva();
		}
		return bsIvaSelected;
	}

	public void setBsIvaSelected(BsIva bsIvaSelected) {
		if (!Objects.isNull(bsIvaSelected.getId())) {
			this.stoArticulo.setBsIva(bsIvaSelected);
			this.bsIvaSelected = null;
		}
		this.bsIvaSelected = bsIvaSelected;
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

	public BsIvaService getBsIvaServiceImpl() {
		return bsIvaServiceImpl;
	}

	public void setBsIvaServiceImpl(BsIvaService bsIvaServiceImpl) {
		this.bsIvaServiceImpl = bsIvaServiceImpl;
	}

	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	public StoArticuloService getStoArticuloServiceImpl() {
		return stoArticuloServiceImpl;
	}

	public void setStoArticuloServiceImpl(StoArticuloService stoArticuloServiceImpl) {
		this.stoArticuloServiceImpl = stoArticuloServiceImpl;
	}

	// METODOS
	public void guardar() {
		if (Objects.isNull(stoArticulo.getBsIva()) || Objects.isNull(stoArticulo.getBsIva().getId())) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un Tipo de Impuesto.");
			return;
		}
		try {
			this.stoArticulo.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
			this.stoArticulo.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
			if (!Objects.isNull(stoArticuloServiceImpl.save(this.stoArticulo))) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se guardo correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
			}
			this.cleanFields();
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", System.err);
			// e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");
		}
		PrimeFaces.current().executeScript("PF('" + DT_DIALOG_NAME + "').hide()");
		PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);

	}

	public void delete() {
		try {
			if (!Objects.isNull(this.stoArticulo)) {
				this.stoArticuloServiceImpl.deleteById(this.stoArticulo.getId());
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
