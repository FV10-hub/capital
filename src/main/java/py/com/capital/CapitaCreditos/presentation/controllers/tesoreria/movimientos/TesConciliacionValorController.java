package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.movimientos;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.PrimeFaces;
import org.primefaces.event.SelectEvent;
import org.primefaces.event.UnselectEvent;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesConciliacionValor;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCobrosValoresService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesConciliacionValorService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Scope(ViewScope.SCOPE_VIEW)
public class TesConciliacionValorController {

    /**
     * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
     * en un archivo externo.
     */
    private static final Logger LOGGER = LogManager.getLogger(TesConciliacionValorController.class);

    private TesConciliacionValor tesConciliacionValor, tesConciliacionValorSelected;
    private CobCobrosValores cobCobrosValoresSelected;
    private LazyDataModel<TesConciliacionValor> lazyModel;
    private List<CobCobrosValores> lazyModelValores;
    private LazyDataModel<TesBanco> lazyModelBanco;
    private List<CobCobrosValores> cobrosValoresList;

    private List<TesConciliacionValor> conciliacionValorList;

    private List<Long> idList = new ArrayList<>();

    private boolean esNuegoRegistro;
    private boolean esVisibleFormulario = true;

    private LocalDate fecDesde;
    private LocalDate fecHasta;
    private String indConciliado;
    private static final String DT_NAME = "dt-conciliacion";

    public BigDecimal montoTotalConciliado = BigDecimal.ZERO;

    // services
    @Autowired
    private TesConciliacionValorService tesConciliacionValorServiceImpl;

    @Autowired
    private CobCobrosValoresService cobCobrosValoresServiceImpl;

    @Autowired
    private TesBancoService tesBancoServiceImpl;

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
        this.tesConciliacionValor = null;
        this.tesConciliacionValorSelected = null;
        this.cobCobrosValoresSelected = null;

        this.lazyModel = null;
        this.lazyModelValores = null;
        this.lazyModelBanco = null;

        this.esNuegoRegistro = true;
        this.esVisibleFormulario = !esVisibleFormulario;
        this.cobrosValoresList = new ArrayList<>();
        this.conciliacionValorList = new ArrayList<>();

    }

    public TesConciliacionValor getTesConciliacionValor() {
        if (Objects.isNull(tesConciliacionValor)) {
            this.tesConciliacionValor = new TesConciliacionValor();
            this.tesConciliacionValor.setBsEmpresa(new BsEmpresa());
            this.tesConciliacionValor.setBsTipoValor(new BsTipoValor());
            this.tesConciliacionValor.setCobCobrosValores(new CobCobrosValores());
            this.tesConciliacionValor.setEstado(Estado.ACTIVO.getEstado());
        }
        return tesConciliacionValor;
    }

    public void setTesConciliacionValor(TesConciliacionValor tesConciliacionValor) {
        this.tesConciliacionValor = tesConciliacionValor;
    }

    public TesConciliacionValor getTesConciliacionValorSelected() {
        if (Objects.isNull(tesConciliacionValorSelected)) {
            this.tesConciliacionValorSelected = new TesConciliacionValor();
            this.tesConciliacionValorSelected.setBsEmpresa(new BsEmpresa());
            this.tesConciliacionValorSelected.setBsTipoValor(new BsTipoValor());
            this.tesConciliacionValorSelected.setCobCobrosValores(new CobCobrosValores());
            this.tesConciliacionValorSelected.setEstado(Estado.ACTIVO.getEstado());
        }
        return tesConciliacionValorSelected;
    }

    public void setTesConciliacionValorSelected(TesConciliacionValor tesConciliacionValorSelected) {
        if (!Objects.isNull(tesConciliacionValorSelected)) {
            this.cobrosValoresList = this.cobCobrosValoresServiceImpl.buscarValoresDepositoLista(
                    this.commonsUtilitiesController.getIdEmpresaLogueada(), tesConciliacionValorSelected.getId());
            this.cobrosValoresList.sort(Comparator.comparing(CobCobrosValores::getNroOrden));
            tesConciliacionValor = tesConciliacionValorSelected;
            tesConciliacionValorSelected = null;
            this.esNuegoRegistro = false;
            this.esVisibleFormulario = true;
        }
        this.tesConciliacionValorSelected = tesConciliacionValorSelected;
    }

    public CobCobrosValores getCobCobrosValoresSelected() {
        if (Objects.isNull(cobCobrosValoresSelected)) {
            cobCobrosValoresSelected = new CobCobrosValores();
            cobCobrosValoresSelected.setFechaValor(LocalDate.now());
            cobCobrosValoresSelected.setFechaVencimiento(LocalDate.now());
            cobCobrosValoresSelected.setIndDepositadoBoolean(false);
            cobCobrosValoresSelected.setNroValor("0");
            cobCobrosValoresSelected.setMontoValor(BigDecimal.ZERO);
            cobCobrosValoresSelected.setBsEmpresa(new BsEmpresa());
            cobCobrosValoresSelected.setBsTipoValor(new BsTipoValor());

        }
        return cobCobrosValoresSelected;
    }

    public void setCobCobrosValoresSelected(CobCobrosValores cobCobrosValoresSelected) {
        this.cobCobrosValoresSelected = cobCobrosValoresSelected;
    }

    public LazyDataModel<TesConciliacionValor> getLazyModel() {
        if (Objects.isNull(lazyModel)) {
            lazyModel = new GenericLazyDataModel<TesConciliacionValor>(this.tesConciliacionValorServiceImpl
                    .buscarTesConciliacionValorActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
        }
        return lazyModel;
    }

    public void setLazyModel(LazyDataModel<TesConciliacionValor> lazyModel) {
        this.lazyModel = lazyModel;
    }

    public List<CobCobrosValores> getLazyModelValores() {
        if (Objects.isNull(lazyModelValores)) {
            List<CobCobrosValores> listaFiltrada = this.cobCobrosValoresServiceImpl
                    .buscarCobCobrosValoresActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()).stream()
                    .filter(valor -> valor.getIndDepositado().equalsIgnoreCase("S"))
                    .sorted(Comparator.comparing(CobCobrosValores::getFechaValor)).collect(Collectors.toList());
            lazyModelValores = listaFiltrada;
        }
        return lazyModelValores;
    }

    public void setLazyModelValores(List<CobCobrosValores> lazyModelValores) {
        this.lazyModelValores = lazyModelValores;
    }

    public LazyDataModel<TesBanco> getLazyModelBanco() {
        if (Objects.isNull(lazyModelBanco)) {
            lazyModelBanco = new GenericLazyDataModel<TesBanco>((List<TesBanco>) tesBancoServiceImpl
                    .buscarTesBancoActivosLista(this.commonsUtilitiesController.getIdEmpresaLogueada()));
        }
        return lazyModelBanco;
    }

    public void setLazyModelBanco(LazyDataModel<TesBanco> lazyModelBanco) {
        this.lazyModelBanco = lazyModelBanco;
    }

    public CobCobrosValoresService getCobCobrosValoresServiceImpl() {
        return cobCobrosValoresServiceImpl;
    }

    public void setCobCobrosValoresServiceImpl(CobCobrosValoresService cobCobrosValoresServiceImpl) {
        this.cobCobrosValoresServiceImpl = cobCobrosValoresServiceImpl;
    }

    public List<CobCobrosValores> getCobrosValoresList() {
        return cobrosValoresList;
    }

    public void setCobrosValoresList(List<CobCobrosValores> cobrosValoresList) {
        this.cobrosValoresList = cobrosValoresList;
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

    public BigDecimal getMontoTotalConciliado() {
        return montoTotalConciliado;
    }

    public void setMontoTotalConciliado(BigDecimal montoTotalConciliado) {
        this.montoTotalConciliado = montoTotalConciliado;
    }

    public TesConciliacionValorService getTesConciliacionValorServiceImpl() {
        return tesConciliacionValorServiceImpl;
    }

    public void setTesConciliacionValorServiceImpl(TesConciliacionValorService tesConciliacionValorServiceImpl) {
        this.tesConciliacionValorServiceImpl = tesConciliacionValorServiceImpl;
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

    public TesBancoService getTesBancoServiceImpl() {
        return tesBancoServiceImpl;
    }

    public void setTesBancoServiceImpl(TesBancoService tesBancoServiceImpl) {
        this.tesBancoServiceImpl = tesBancoServiceImpl;
    }

    public LocalDate getFecDesde() {
        if (Objects.isNull(fecDesde))
            fecDesde = LocalDate.now();
        return fecDesde;
    }

    public void setFecDesde(LocalDate fecDesde) {
        this.fecDesde = fecDesde;
    }

    public LocalDate getFecHasta() {
        if (Objects.isNull(fecHasta))
            fecHasta = LocalDate.now();
        return fecHasta;
    }

    public void setFecHasta(LocalDate fecHasta) {
        this.fecHasta = fecHasta;
    }

    public String getIndConciliado() {
        return indConciliado;
    }

    public void setIndConciliado(String indConciliado) {
        this.indConciliado = indConciliado;
    }

    public void consultarValoresAConciliar() {
        this.lazyModelValores = this.cobCobrosValoresServiceImpl
                .buscarValoresParaConciliarPorFechas(
                        this.commonsUtilitiesController.getIdEmpresaLogueada(),
                        this.fecDesde,
                        this.fecHasta,
                        indConciliado);
        this.esVisibleFormulario = true;
        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion", "form:" + DT_NAME);
    }

    public void limpiarDetalle() {
        this.cobrosValoresList = new ArrayList<>();
        this.montoTotalConciliado = BigDecimal.ZERO;
        this.esVisibleFormulario = false;
        this.idList = new ArrayList<>();
        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion", "form:" + DT_NAME);
    }

    public void calcularTotalesDetalle() {
        this.montoTotalConciliado = BigDecimal.ZERO;
        // IDs ya presentes en la lista (evita duplicados)
        Set<Long> idsYaAgregados = this.conciliacionValorList.stream()
                .map(cv -> cv.getCobCobrosValores())
                .filter(Objects::nonNull)
                .map(cv -> cv.getId())
                .filter(Objects::nonNull)
                .collect(Collectors.toCollection(LinkedHashSet::new));

        for (CobCobrosValores valor : this.cobrosValoresList) {
            if (valor == null || valor.getId() == null) {
                continue;
            }

            // si ya existe, saltar
            if (!idsYaAgregados.add(valor.getId())) {
                continue;
            }

            TesConciliacionValor item = getTesConciliacionValorSelected();
            item.setObservacion("CONCILIADO");
            item.setUsuarioModificacion(this.commonsUtilitiesController.getCodUsuarioLogueada());
            item.setNroValor(valor.getNroValor());
            item.setMontoValor(valor.getMontoValor());
            item.setFechaValor(valor.getFechaValor());
            item.setIndConciliadoBoolean(true);
            item.setBsTipoValor(valor.getBsTipoValor());
            item.setBsEmpresa(this.commonsUtilitiesController.getCajaUsuarioLogueado().getBsEmpresa());
            item.setCobCobrosValores(valor);

            this.conciliacionValorList.add(item);

            // si mantenés una lista de IDs, no dupliques:
            if (this.idList != null && !this.idList.contains(valor.getId())) {
                this.idList.add(valor.getId());
            }

            if (valor.getMontoValor() != null) {
                montoTotalConciliado = montoTotalConciliado.add(valor.getMontoValor());
            }
        }

        this.tesConciliacionValorSelected = null;
    }

    public void onRowSelect(SelectEvent<CobCobrosValores> event) {
        this.cobCobrosValoresSelected = event.getObject();
        this.calcularTotalesDetalle();
        this.cobCobrosValoresSelected = null;
        getCobCobrosValoresSelected();
        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion", "form:" + DT_NAME,
                ":form:btnGuardar", ":form:btnLimpiar", ":form:btnEliminar");
    }

    public void onRowUnselect(UnselectEvent<CobCobrosValores> event) {
        this.cobCobrosValoresSelected = event.getObject();
        this.calcularTotalesDetalle();
        this.cobCobrosValoresSelected = null;
        getCobCobrosValoresSelected();
        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion", "form:" + DT_NAME,
                ":form:btnGuardar", ":form:btnLimpiar", ":form:btnEliminar");
    }

    public void guardar() {
        try {
            if (CollectionUtils.isNotEmpty(conciliacionValorList) && conciliacionValorList.size() > 0) {
                if (CollectionUtils.isNotEmpty(this.tesConciliacionValorServiceImpl.saveAll(conciliacionValorList))) {
                    var valores_actualizados = this.cobCobrosValoresServiceImpl.marcarValoresComoConciliado(
                            this.commonsUtilitiesController.getIdEmpresaLogueada(),
                            this.idList,
                            this.commonsUtilitiesController.getCodUsuarioLogueada()
                    );
                    if (valores_actualizados > 0) {
                        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                                "El registro se guardo correctamente.");
                    }
                }
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debes seleccionar por lo menos un registro a conciliar.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update(":form","form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            // e.printStackTrace(System.err);
            String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);

            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        }

    }

    public void delete() {
        try {
            if (this.indConciliado.equalsIgnoreCase("S")) {
                List<TesConciliacionValor> conciliacionesAEliminar;
                if (CollectionUtils.isNotEmpty(idList) && idList.size() > 0) {
                    conciliacionesAEliminar = this.tesConciliacionValorServiceImpl.buscarTesConciliacionValorPorIds(
                            this.commonsUtilitiesController.getIdEmpresaLogueada(),
                            this.idList
                    );
                    if (CollectionUtils.isNotEmpty(this.tesConciliacionValorServiceImpl.deleteAll(conciliacionesAEliminar))) {

                        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                                "Las conciliaciones se revirtieron correctamente.");
                    }
                }

            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debes seleccionar por lo menos un registro conciliado.");
            }

            this.cleanFields();
            PrimeFaces.current().ajax().update(":form","form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            e.printStackTrace(System.err);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    e.getMessage().substring(0, e.getMessage().length()) + "...");
        }

    }

}