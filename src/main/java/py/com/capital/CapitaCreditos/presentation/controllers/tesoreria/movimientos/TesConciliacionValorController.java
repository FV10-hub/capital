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
import py.com.capital.CapitaCreditos.dtos.ValorConciliacionDto;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesConciliacionValor;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesPagoValores;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsPersonaService;
import py.com.capital.CapitaCreditos.services.base.BsTipoValorService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCobrosValoresService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesConciliacionValorService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesPagoService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
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

    private BsPersona bsPersonaJuridica;
    private LazyDataModel<TesConciliacionValor> lazyModel;
    private List<CobCobrosValores> lazyModelValores;
    private LazyDataModel<TesBanco> lazyModelBanco;

    private LazyDataModel<BsPersona> lazyPersonaList;
    private List<CobCobrosValores> cobrosValoresList;

    private List<TesConciliacionValor> conciliacionValorList;

    private List<Long> idsCobrosSeleccionados = new ArrayList<>();
    private List<Long> idsPagosSeleccionados = new ArrayList<>();

    private List<ValorConciliacionDto> valorConciliacionDtoList;
    private List<ValorConciliacionDto> valorConciliacionDtoListSelected;

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
    private TesPagoService tesPagoServiceImpl;

    @Autowired
    private TesBancoService tesBancoServiceImpl;

    /**
     * Propiedad de la logica de negocio inyectada con JSF y Spring.
     */
    @Autowired
    private SessionBean sessionBean;

    @Autowired
    private CommonsUtilitiesController commonsUtilitiesController;

    @Autowired
    private BsPersonaService bsPersonaServiceImpl;

    @Autowired
    private BsTipoValorService bsTipoValorServiceImpl;

    @PostConstruct
    public void init() {
        this.cleanFields();

    }

    public void cleanFields() {
        this.tesConciliacionValor = null;
        this.tesConciliacionValorSelected = null;
        this.cobCobrosValoresSelected = null;
        this.bsPersonaJuridica = null;

        this.lazyModel = null;
        this.lazyModelValores = null;
        this.lazyModelBanco = null;
        this.lazyPersonaList = null;
        this.valorConciliacionDtoList = null;
        this.valorConciliacionDtoListSelected = null;

        this.esNuegoRegistro = true;
        this.esVisibleFormulario = !esVisibleFormulario;
        this.cobrosValoresList = new ArrayList<>();
        this.conciliacionValorList = new ArrayList<>();
        this.montoTotalConciliado = BigDecimal.ZERO;
        this.idsCobrosSeleccionados = new ArrayList<>();
        this.idsPagosSeleccionados = new ArrayList<>();

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

    public BsPersona getBsPersonaJuridica() {
        if (Objects.isNull(bsPersonaJuridica)) {
            this.bsPersonaJuridica = new BsPersona();
            this.bsPersonaJuridica.setEstado(Estado.ACTIVO.getEstado());
            this.bsPersonaJuridica.setTipoPersona("JURIDICA");
            this.bsPersonaJuridica.setEsBanco(false);
            this.bsPersonaJuridica.setTipoDocumento("CI");
        }
        return bsPersonaJuridica;
    }

    public void setBsPersonaJuridica(BsPersona bsPersonaJuridica) {
        this.bsPersonaJuridica = bsPersonaJuridica;
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

    public List<ValorConciliacionDto> getValorConciliacionDtoList() {
        return valorConciliacionDtoList;
    }

    public void setValorConciliacionDtoList(List<ValorConciliacionDto> valorConciliacionDtoList) {
        this.valorConciliacionDtoList = valorConciliacionDtoList;
    }

    public List<ValorConciliacionDto> getValorConciliacionDtoListSelected() {
        if (Objects.isNull(valorConciliacionDtoListSelected)) {
            valorConciliacionDtoListSelected = new ArrayList<>();
        }
        return valorConciliacionDtoListSelected;
    }

    public void setValorConciliacionDtoListSelected(List<ValorConciliacionDto> valorConciliacionDtoListSelected) {
        this.valorConciliacionDtoListSelected = valorConciliacionDtoListSelected;
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

    public LazyDataModel<BsPersona> getLazyPersonaList() {
        if (Objects.isNull(lazyPersonaList)) {
            lazyPersonaList = new GenericLazyDataModel<BsPersona>(bsPersonaServiceImpl
                    .buscarTodosLista()
                    .stream()
                    .filter(bsPersona -> bsPersona.getEsBanco())
                    .collect(Collectors.toList()));
        }
        return lazyPersonaList;
    }

    public void setLazyPersonaList(LazyDataModel<BsPersona> lazyPersonaList) {
        this.lazyPersonaList = lazyPersonaList;
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

    public TesPagoService getTesPagoServiceImpl() {
        return tesPagoServiceImpl;
    }

    public void setTesPagoServiceImpl(TesPagoService tesPagoServiceImpl) {
        this.tesPagoServiceImpl = tesPagoServiceImpl;
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

    public BsPersonaService getBsPersonaServiceImpl() {
        return bsPersonaServiceImpl;
    }

    public void setBsPersonaServiceImpl(BsPersonaService bsPersonaServiceImpl) {
        this.bsPersonaServiceImpl = bsPersonaServiceImpl;
    }

    public BsTipoValorService getBsTipoValorServiceImpl() {
        return bsTipoValorServiceImpl;
    }

    public void setBsTipoValorServiceImpl(BsTipoValorService bsTipoValorServiceImpl) {
        this.bsTipoValorServiceImpl = bsTipoValorServiceImpl;
    }

    public void consultarValoresAConciliar() {
        this.valorConciliacionDtoList = this.tesConciliacionValorServiceImpl.buscarValoresConciliacion(
                this.commonsUtilitiesController.getIdEmpresaLogueada(),
                this.fecDesde,
                this.fecHasta,
                indConciliado,
                this.bsPersonaJuridica.getId()
        );
        this.esVisibleFormulario = true;
        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion", "form:" + DT_NAME);
    }

    public void limpiarDetalle() {
        this.cobrosValoresList = new ArrayList<>();
        this.montoTotalConciliado = BigDecimal.ZERO;
        this.esVisibleFormulario = false;
        this.idsCobrosSeleccionados = new ArrayList<>();
        this.idsPagosSeleccionados = new ArrayList<>();
        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion", "form:" + DT_NAME);
    }

    public void onRowSelect(SelectEvent<ValorConciliacionDto> event) {
        ValorConciliacionDto seleccionado = event.getObject();
        if (seleccionado == null || seleccionado.getId() == null) {
            return;
        }

        TesConciliacionValor item = new TesConciliacionValor();
        item.setObservacion("CONCILIADO");
        item.setUsuarioModificacion(this.commonsUtilitiesController.getCodUsuarioLogueada());
        item.setNroValor(seleccionado.getNroValor());
        item.setMontoValor(seleccionado.getMontoValor());
        item.setFechaValor(seleccionado.getFechaValor());
        item.setIndConciliado("S");
        item.setBsEmpresa(this.commonsUtilitiesController.getCajaUsuarioLogueado().getBsEmpresa());
        BsTipoValor tipoValor = new BsTipoValor();
        if ("INGRESOS".equalsIgnoreCase(seleccionado.getTipoRegistro())) {
            tipoValor = getTipoValorFromOperacion("COB", seleccionado.getTipoValor());
            if (Objects.isNull(tipoValor)){
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡ERROR!",
                        "No se encontro el tipo de valor con estos parametros para el Modulo.");
                PrimeFaces.current().ajax().update(":form:messages");
                return;
            }
            CobCobrosValores cobro = new CobCobrosValores();
            cobro.setId(seleccionado.getId());
            item.setCobCobrosValores(cobro);
            item.setTipoOperacion("INGRESOS");
            item.setBsTipoValor(tipoValor);
            this.idsCobrosSeleccionados.add(seleccionado.getId());
        } else if ("EGRESOS".equalsIgnoreCase(seleccionado.getTipoRegistro())) {
            tipoValor = getTipoValorFromOperacion("TES", seleccionado.getTipoValor());
            if (Objects.isNull(tipoValor)){
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡ERROR!",
                        "No se encontro el tipo de valor con estos parametros para el Modulo.");
                PrimeFaces.current().ajax().update(":form:messages");
                return;
            }
            TesPagoValores pago = new TesPagoValores();
            pago.setId(seleccionado.getId());
            item.setTesPagoValores(pago);
            item.setTipoOperacion("EGRESOS");
            item.setBsTipoValor(tipoValor);
            this.idsPagosSeleccionados.add(seleccionado.getId());
        }

        this.conciliacionValorList.add(item);
        if (seleccionado.getMontoValor() != null) {
            montoTotalConciliado = montoTotalConciliado.add(seleccionado.getMontoValor());
        }
        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion",
                "form:" + DT_NAME, ":form:btnGuardar", ":form:btnLimpiar", ":form:btnEliminar");
    }

    private BsTipoValor getTipoValorFromOperacion(String codModulo, String tipoValor) {
        return this.bsTipoValorServiceImpl
                .buscarTipoValorModuloTipo(
                        this.commonsUtilitiesController.getIdEmpresaLogueada(),
                        codModulo,
                        tipoValor);
    }


    public void onRowUnselect(UnselectEvent<ValorConciliacionDto> event) {
        ValorConciliacionDto seleccionado = event.getObject();
        if (seleccionado == null || seleccionado.getId() == null) {
            return;
        }

        this.conciliacionValorList.removeIf(item ->
                ("INGRESOS".equalsIgnoreCase(seleccionado.getTipoRegistro()) &&
                        item.getCobCobrosValores() != null &&
                        seleccionado.getId().equals(item.getCobCobrosValores().getId()))
                        || ("EGRESOS".equalsIgnoreCase(seleccionado.getTipoRegistro()) &&
                        item.getTesPagoValores() != null &&
                        seleccionado.getId().equals(item.getTesPagoValores().getId()))
        );
        if (seleccionado.getMontoValor() != null) {
            montoTotalConciliado = montoTotalConciliado.subtract(seleccionado.getMontoValor());
        }

        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion",
                "form:" + DT_NAME, ":form:btnGuardar", ":form:btnLimpiar", ":form:btnEliminar");
    }


    public void guardar() {
        try {
            if (CollectionUtils.isNotEmpty(conciliacionValorList) && conciliacionValorList.size() > 0) {
                if (CollectionUtils.isNotEmpty(this.tesConciliacionValorServiceImpl.saveAll(conciliacionValorList))) {
                    int actualizadosCobros = 0;
                    int actualizadosPagos = 0;

                    if (CollectionUtils.isNotEmpty(idsCobrosSeleccionados)) {
                        actualizadosCobros = this.cobCobrosValoresServiceImpl.marcarValoresComoConciliado(
                                this.commonsUtilitiesController.getIdEmpresaLogueada(),
                                this.idsCobrosSeleccionados,
                                this.commonsUtilitiesController.getCodUsuarioLogueada()
                        );
                    }

                    if (CollectionUtils.isNotEmpty(idsPagosSeleccionados)) {
                        actualizadosPagos = this.tesPagoServiceImpl.marcarPagosComoConciliado(
                                this.commonsUtilitiesController.getIdEmpresaLogueada(),
                                this.idsPagosSeleccionados,
                                this.commonsUtilitiesController.getCodUsuarioLogueada()
                        );
                    }
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                            "El registro se guardo correctamente.");

                }
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debes seleccionar por lo menos un registro a conciliar.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update(":form", "form:messages", "form:" + DT_NAME);
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
            if (!"S".equalsIgnoreCase(this.indConciliado)) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                        "Debes seleccionar por lo menos un registro conciliado.");
                return;
            }
            boolean huboCambios = false;

            // Procesar ingresos
            if (CollectionUtils.isNotEmpty(idsCobrosSeleccionados)) {
                huboCambios |= eliminarConciliacionesCobros(idsCobrosSeleccionados);
            }

            // Procesar egresos
            if (CollectionUtils.isNotEmpty(idsPagosSeleccionados)) {
                huboCambios |= eliminarConciliacionesPagos(idsPagosSeleccionados);
            }

            if (huboCambios) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "Las conciliaciones se revirtieron correctamente.");
            }

            this.cleanFields();
            PrimeFaces.current().ajax().update(":form", "form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            e.printStackTrace(System.err);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    e.getMessage().substring(0, e.getMessage().length()) + "...");
        }

    }

    private boolean eliminarConciliacionesCobros(List<Long> ids) {
        List<TesConciliacionValor> conciliaciones =
                tesConciliacionValorServiceImpl.buscarTesConciliacionValorPorIds(
                        commonsUtilitiesController.getIdEmpresaLogueada(), ids);

        if (CollectionUtils.isEmpty(conciliaciones)) {
            return false;
        }

        boolean eliminados = CollectionUtils.isNotEmpty(tesConciliacionValorServiceImpl.deleteAll(conciliaciones));

        if (eliminados) {
            cobCobrosValoresServiceImpl.revertirValoresConciliados(
                    commonsUtilitiesController.getIdEmpresaLogueada(),
                    ids,
                    commonsUtilitiesController.getCodUsuarioLogueada()
            );
            LOGGER.info("Se revirtieron conciliaciones de cobros: {}", ids.size());
        }
        return eliminados;
    }

    private boolean eliminarConciliacionesPagos(List<Long> ids) {
        List<TesConciliacionValor> conciliaciones =
                tesConciliacionValorServiceImpl.buscarTesConciliacionPagosValorPorIds(
                        commonsUtilitiesController.getIdEmpresaLogueada(), ids);

        if (CollectionUtils.isEmpty(conciliaciones)) {
            return false;
        }

        boolean eliminados = CollectionUtils.isNotEmpty(tesConciliacionValorServiceImpl.deleteAll(conciliaciones));

        if (eliminados) {
            tesPagoServiceImpl.revertirPagosConciliados(
                    commonsUtilitiesController.getIdEmpresaLogueada(),
                    ids,
                    commonsUtilitiesController.getCodUsuarioLogueada()
            );
            LOGGER.info("Se revirtieron conciliaciones de pagos: {}", ids.size());
        }
        return eliminados;
    }


}