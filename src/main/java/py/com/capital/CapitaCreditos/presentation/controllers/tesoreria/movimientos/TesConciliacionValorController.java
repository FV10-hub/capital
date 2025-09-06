package py.com.capital.CapitaCreditos.presentation.controllers.tesoreria.movimientos;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.primefaces.PrimeFaces;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesConciliacionValor;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.presentation.utils.Estado;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCobrosValoresService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesConciliacionValorService;

import javax.annotation.PostConstruct;
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
    private LazyDataModel<TesConciliacionValor> lazyModel;
    private List<CobCobrosValores> lazyModelValores;
    private LazyDataModel<TesBanco> lazyModelBanco;
    private List<CobCobrosValores> cobrosValoresList;

    private boolean esNuegoRegistro;
    private boolean esVisibleFormulario = true;

    private LocalDate fecDesde;
    private LocalDate fecHasta;
    private String indConsiliado;
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

    public String getIndConsiliado() {
        return indConsiliado;
    }

    public void setIndConsiliado(String indConsiliado) {
        this.indConsiliado = indConsiliado;
    }

    public void consultarValoresAConciliar(){
        this.lazyModelValores = this.cobCobrosValoresServiceImpl
                .buscarValoresParaConciliarPorFechas(
                        this.commonsUtilitiesController.getIdEmpresaLogueada(),
                        this.fecDesde,
                        this.fecHasta);
        this.esVisibleFormulario = true;
        var a = 0;
        PrimeFaces.current().ajax().update(":form:messages", ":form:manage-conciliacion", "form:" + DT_NAME);
    }
    public void guardar() {
        /*try {
            if (Objects.isNull(this.tesDeposito.getTesBanco())
                    || Objects.isNull(this.tesDeposito.getTesBanco().getId())) {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un banco.");
                return;
            }
            this.tesDeposito.setUsuarioModificacion(sessionBean.getUsuarioLogueado().getCodUsuario());
            this.tesDeposito.setBsEmpresa(sessionBean.getUsuarioLogueado().getBsEmpresa());

            TesDeposito depositoGuardado = this.tesDepositoServiceImpl.save(tesDeposito);
            if (!Objects.isNull(depositoGuardado)) {
                if (CollectionUtils.isNotEmpty(cobrosValoresList) && cobrosValoresList.size() > 0) {
                    this.cobrosValoresList = cobrosValoresList.stream().map(cobro -> {
                        cobro.setIndDepositadoBoolean(true);
                        cobro.setTesDeposito(depositoGuardado);
                        cobro.setFechaDeposito(depositoGuardado.getFechaDeposito());
                        return cobro;
                    }).collect(Collectors.toList());
                    this.cobCobrosValoresServiceImpl.saveAll(cobrosValoresList);
                }
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se guardo correctamente.");
            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
            }

            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            e.printStackTrace(System.err);

            Throwable cause = e.getCause();
            while (cause != null) {
                if (cause instanceof ConstraintViolationException) {
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "El DEPOSITO ya fue creado.");
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
*/
    }

    public void delete() {
        /*try {
            if (!Objects.isNull(this.tesDeposito)) {
                this.tesDepositoServiceImpl.deleteById(this.tesDeposito.getId());
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
                        "El registro se elimino correctamente.");

            } else {
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
            }
            this.cleanFields();
            PrimeFaces.current().ajax().update("form:messages", "form:" + DT_NAME);
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error al Guardar", e);
            e.printStackTrace(System.err);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    e.getMessage().substring(0, e.getMessage().length()) + "...");
        }
*/
    }

}