package py.com.capital.CapitaCreditos.services.tesoreria;

import py.com.capital.CapitaCreditos.entities.tesoreria.TesBancoSaldoHistorico;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface TesBancoSaldoHistoricoSaldoHistoricoService extends CommonService<TesBancoSaldoHistorico> {

    List<TesBancoSaldoHistorico> buscarTesBancoSaldoHistoricoActivosLista(Long idEmpresa);

    BigDecimal calcularIngresosPorBanco(Long bancoId,
                                        Long empresaId,
                                        LocalDate fecha);

    BigDecimal calcularEgresosPorBanco(Long bancoId,
                                       Long empresaId,
                                       LocalDate fecha);

    BigDecimal obtenerSaldoFinalDia(Long bancoId,
                                    Long empresaId,
                                    LocalDate fecha);

    void registrarSaldoDiario(Long empresaId, LocalDate fecha);
}
