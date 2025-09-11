package py.com.capital.CapitaCreditos.services.cobranzas;

import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.time.LocalDate;
import java.util.List;

/*
 * 17 ene. 2024 - Elitebook
 */
public interface CobCobrosValoresService extends CommonService<CobCobrosValores> {

    List<CobCobrosValores> buscarTodosLista();

    List<CobCobrosValores> buscarCobCobrosValoresActivosLista(Long idEmpresa);

    List<CobCobrosValores> buscarValoresPorTipoSinDepositarLista(Long idEmpresa, String tipoComprobante);

    List<CobCobrosValores> buscarValoresPorComprobanteLista(Long idEmpresa, Long idComprobante, String tipoComprobante);

    List<CobCobrosValores> buscarValoresDepositoLista(Long idEmpresa, Long idDeposito);

    List<CobCobrosValores> buscarValoresParaConciliarPorFechas(Long idEmpresa, LocalDate fechaDesde, LocalDate fechaHasta);

    int marcarValoresComoConciliado(Long empresaId,
                                    Long tipoValorId,
                                    List<Long> idsSaldo,
                                    String usuario);
}
