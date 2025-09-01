package py.com.capital.CapitaCreditos.presentation.controllers.stock.movimientos;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsIva;
import py.com.capital.CapitaCreditos.entities.stock.StoAjusteInventarioCabecera;
import py.com.capital.CapitaCreditos.entities.stock.StoAjusteInventarioDetalle;
import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.stock.StoAjusteInventarioCabeceraService;
import py.com.capital.CapitaCreditos.services.stock.StoArticuloService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Scope(ViewScope.SCOPE_VIEW)
public class StoAjusteInventarioCabeceraController {

    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */
    private static final Logger LOGGER = LogManager.getLogger(StoAjusteInventarioCabeceraController.class);

    StoAjusteInventarioCabecera stoAjusteInventarioCabecera, stoAjusteInventarioCabeceraSelected;
    private StoArticulo stoArticuloSelected;
    private StoAjusteInventarioDetalle detalle;
    private LazyDataModel<StoAjusteInventarioCabecera> lazyModel;
    private LazyDataModel<StoArticulo> lazyModelArticulos;

    private List<String> estadoList;
    private List<String> tipoAjusteList;
    private boolean esNuegoRegistro;
    private boolean esVisibleFormulario = true;

    private static final String DT_NAME = "dt-ajustes";

    // services
    @Autowired
    private StoAjusteInventarioCabeceraService stoAjusteInventarioCabeceraServiceImpl;

    @Autowired
    private StoArticuloService stoArticuloServiceImpl;

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
        this.stoAjusteInventarioCabecera = null;
        this.stoAjusteInventarioCabeceraSelected = null;
        this.detalle = null;
        this.stoArticuloSelected = null;
        this.lazyModel = null;
        this.lazyModelArticulos = null;

        this.esNuegoRegistro = true;
        this.esVisibleFormulario = !esVisibleFormulario;
        this.estadoList = List.of(Estado.ACTIVO.getEstado(), Estado.INACTIVO.getEstado(), "ANULADO");
        this.tipoAjusteList = List.of("ENTRADA", "SALIDA");

    }

    public StoAjusteInventarioCabecera getStoAjusteInventarioCabecera() {
        if (Objects.isNull(stoAjusteInventarioCabecera)) {
            this.stoAjusteInventarioCabecera = new StoAjusteInventarioCabecera();
            this.stoAjusteInventarioCabecera.setTipoOperacion("ENTRADA");
            this.stoAjusteInventarioCabecera.setBsEmpresa(new BsEmpresa());
            this.stoAjusteInventarioCabecera.setEstado(Estado.ACTIVO.getEstado());
            this.stoAjusteInventarioCabecera.setFechaOperacion(LocalDate.now());
        }
        return stoAjusteInventarioCabecera;
    }

    public void setStoAjusteInventarioCabecera(StoAjusteInventarioCabecera stoAjusteInventarioCabecera) {
        this.stoAjusteInventarioCabecera = stoAjusteInventarioCabecera;
    }

    public StoAjusteInventarioCabecera getStoAjusteInventarioCabeceraSelected() {
        if (Objects.isNull(stoAjusteInventarioCabeceraSelected)) {
            this.stoAjusteInventarioCabeceraSelected = new StoAjusteInventarioCabecera();
            this.stoAjusteInventarioCabeceraSelected.setBsEmpresa(new BsEmpresa());
            this.stoAjusteInventarioCabeceraSelected.setEstado(Estado.ACTIVO.getEstado());
            this.stoAjusteInventarioCabeceraSelected.setFechaOperacion(LocalDate.now());
        }
        return stoAjusteInventarioCabeceraSelected;
    }

    public void setStoAjusteInventarioCabeceraSelected(
            StoAjusteInventarioCabecera stoAjusteInventarioCabeceraSelected) {
        if (!Objects.isNull(stoAjusteInventarioCabeceraSelected)) {
            stoAjusteInventarioCabeceraSelected.getStoAjusteInventarioDetalleList()
                    .sort(Comparator.comparing(StoAjusteInventarioDetalle::getNroOrden));
            stoAjusteInventarioCabecera = stoAjusteInventarioCabeceraSelected;
            stoAjusteInventarioCabeceraSelected = null;
            this.esNuegoRegistro = false;
            this.esVisibleFormulario = true;
        }
        this.stoAjusteInventarioCabeceraSelected = stoAjusteInventarioCabeceraSelected;
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
            BigDecimal existencia = this.stoArticuloServiceImpl.retornaExistenciaArticulo(stoArticuloSelected.getId(),
					this.commonsUtilitiesController.getIdEmpresaLogueada());
            detalle.setCantidadSistema(existencia.intValue());
            detalle.setCantidadFisica(existencia.intValue());
            detalle.setStoArticulo(stoArticuloSelected);
        }
        this.stoArticuloSelected = stoArticuloSelected;
    }

    public StoAjusteInventarioDetalle getDetalle() {
        if (Objects.isNull(detalle)) {
            detalle = new StoAjusteInventarioDetalle();
            detalle.setStoArticulo(new StoArticulo());
            detalle.setStoAjusteInventarioCabecera(new StoAjusteInventarioCabecera());
        }
        return detalle;
    }

    public void setDetalle(StoAjusteInventarioDetalle detalle) {
        this.detalle = detalle;
    }

    public LazyDataModel<StoAjusteInventarioCabecera> getLazyModel() {
    	if (Objects.isNull(lazyModel)) {
    		lazyModel = new GenericLazyDataModel<StoAjusteInventarioCabecera>(
    				this.stoAjusteInventarioCabeceraServiceImpl.buscarStoAjusteInventarioCabeceraActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
		}
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<StoAjusteInventarioCabecera> lazyModel) {
        this.lazyModel = lazyModel;
    }

    public LazyDataModel<StoArticulo> getLazyModelArticulos() {
    	if (Objects.isNull(lazyModelArticulos)) {
			List<StoArticulo> listaFiltrada = (List<StoArticulo>) stoArticuloServiceImpl
					.buscarStoArticuloActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()).stream()
					.filter(articulo -> "S".equals(articulo.getIndInventariable())).collect(Collectors.toList());
			lazyModelArticulos = new GenericLazyDataModel<StoArticulo>(listaFiltrada);
		}
    	
        return lazyModelArticulos;
    }

    public void setLazyModelArticulos(LazyDataModel<StoArticulo> lazyModelArticulos) {
        this.lazyModelArticulos = lazyModelArticulos;
    }

    public List<String> getEstadoList() {
        return estadoList;
    }

    public void setEstadoList(List<String> estadoList) {
        this.estadoList = estadoList;
    }

    public List<String> getTipoAjusteList() {
        return tipoAjusteList;
    }

    public void setTipoAjusteList(List<String> tipoAjusteList) {
        this.tipoAjusteList = tipoAjusteList;
    }

    public boolean isEsNuegoRegistro() {
        return esNuegoRegistro;
    }

    public void setEsNuegoRegistro(boolean esNuegoRegistro) {
        this.esNuegoRegistro = esNuegoRegistro;
    }

    public boolean isEsVisibleFormulario() {
        return esVisibleFormulario;
    }

    public void setEsVisibleFormulario(boolean esVisibleFormulario) {
        this.esVisibleFormulario = esVisibleFormulario;
    }

    public StoAjusteInventarioCabeceraService getStoAjusteInventarioCabeceraServiceImpl() {
        return stoAjusteInventarioCabeceraServiceImpl;
    }

    public void setStoAjusteInventarioCabeceraServiceImpl(
            StoAjusteInventarioCabeceraService stoAjusteInventarioCabeceraServiceImpl) {
        this.stoAjusteInventarioCabeceraServiceImpl = stoAjusteInventarioCabeceraServiceImpl;
    }

    public StoArticuloService getStoArticuloServiceImpl() {
        return stoArticuloServiceImpl;
    }

    public void setStoArticuloServiceImpl(StoArticuloService stoArticuloServiceImpl) {
        this.stoArticuloServiceImpl = stoArticuloServiceImpl;
    }

    public SessionBean getSessionBean() {
        return sessionBean;
    }

    public void setSessionBean(SessionBean sessionBean) {
        this.sessionBean = sessionBean;
    }

    public CommonsUtilitiesController getCommonsUtilitiesController() {
        return commonsUtilitiesController;
    }

    public void setCommonsUtilitiesController(CommonsUtilitiesController commonsUtilitiesController) {
        this.commonsUtilitiesController = commonsUtilitiesController;
    }

    public void abrirDialogoAddDetalle() {
        detalle = new StoAjusteInventarioDetalle();
        detalle.setStoAjusteInventarioCabecera(new StoAjusteInventarioCabecera());
        detalle.setStoArticulo(new StoArticulo());
    }

    public void eliminaDetalle() {
        stoAjusteInventarioCabecera.getStoAjusteInventarioDetalleList().removeIf(det -> det.equals(detalle));
        this.detalle = null;
        PrimeFaces.current().ajax().update(":form:dt-detalle");
    }

    public void limpiarDetalle() {
        stoAjusteInventarioCabecera.setStoAjusteInventarioDetalleList(new ArrayList<>());
        PrimeFaces.current().ajax().update(":form:btnLimpiar");
    }

    public void cargaDetalle() {
    	Optional<StoAjusteInventarioDetalle> existente = stoAjusteInventarioCabecera.getStoAjusteInventarioDetalleList()
    			.stream()
    			.filter(det -> det.getStoArticulo().getId() == detalle.getStoArticulo().getId())
    			.findFirst();
        if(!existente.isPresent()) {
        	if (CollectionUtils.isEmpty(stoAjusteInventarioCabecera.getStoAjusteInventarioDetalleList())) {
                detalle.setNroOrden(1);
            } else {
                Optional<Integer> maxNroOrden = stoAjusteInventarioCabecera.getStoAjusteInventarioDetalleList()
                        .stream()
                        .map(StoAjusteInventarioDetalle::getNroOrden)
                        .max(Integer::compareTo);
                if (maxNroOrden.isPresent()) {
                    detalle.setNroOrden(maxNroOrden.get() + 1);
                } else {
                    detalle.setNroOrden(1);
                }
            }
        	this.stoAjusteInventarioCabecera.addDetalle(detalle);
        }else {
        	detalle.setNroOrden(existente.get().getNroOrden());
        	int indice = stoAjusteInventarioCabecera.getStoAjusteInventarioDetalleList().indexOf(existente.get());
        	stoAjusteInventarioCabecera.getStoAjusteInventarioDetalleList().set(indice, detalle);
        }
        this.stoAjusteInventarioCabecera.setCabeceraADetalle();
        detalle = null;
        PrimeFaces.current().ajax().update(":form:dt-detalle", ":form:btnGuardar");
    }

    public void guardar() {
        try {
            this.stoAjusteInventarioCabecera.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            this.stoAjusteInventarioCabecera.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());
            if (Objects.isNull(this.stoAjusteInventarioCabecera.getId())) {
            	this.stoAjusteInventarioCabecera.setNroOperacion(this.stoAjusteInventarioCabeceraServiceImpl.calcularNroOperacionDisponible(
						commonsUtilitiesController.getIdEmpresaLogueada()));
            }
            if (!Objects.isNull(this.stoAjusteInventarioCabeceraServiceImpl.save(stoAjusteInventarioCabecera))) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se guardo correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
            }
           
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", System.err);
            e.printStackTrace(System.err);

            Throwable cause = e.getCause();
            while (cause != null) {
                if (cause instanceof ConstraintViolationException) {
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                            "El numero de ajuste ya existe.");
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
            if (Objects.isNull("S".equalsIgnoreCase(this.stoAjusteInventarioCabecera.getIndAutorizado()))) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Ya fue Autorizado.");
                return;
            }
            if (!Objects.isNull(this.stoAjusteInventarioCabecera)) {
                this.stoAjusteInventarioCabeceraServiceImpl.deleteById(this.stoAjusteInventarioCabecera.getId());
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se elimino correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", System.err);
            e.printStackTrace(System.err);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    e.getMessage().substring(0, e.getMessage().length()) + "...");
        }

    }

}