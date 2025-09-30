package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBancoSaldoHistorico;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesBancoRepository;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesBancoSaldoHistoricoSaldoHistoricoRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoSaldoHistoricoSaldoHistoricoService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
public class TesBancoSaldoHistoricoSaldoHistoricoServiceImpl extends CommonServiceImpl<TesBancoSaldoHistorico, TesBancoSaldoHistoricoSaldoHistoricoRepository>
        implements TesBancoSaldoHistoricoSaldoHistoricoService {

    private final TesBancoSaldoHistoricoSaldoHistoricoRepository repository;
    private final TesBancoRepository bancoRepository;

    public TesBancoSaldoHistoricoSaldoHistoricoServiceImpl(TesBancoSaldoHistoricoSaldoHistoricoRepository repository, TesBancoRepository bancoRepository) {
        super(repository);
        this.repository = repository;
        this.bancoRepository = bancoRepository;
    }

    @Override
    public List<TesBancoSaldoHistorico> buscarTesBancoSaldoHistoricoActivosLista(Long idEmpresa) {
        return this.repository.buscarTesBancoSaldoHistoricoActivosLista(idEmpresa);
    }

    @Override
    public BigDecimal calcularIngresosPorBanco(Long bancoId, Long empresaId, LocalDate fecha) {
        return this.repository.calcularIngresosPorBanco(bancoId, empresaId, fecha);
    }

    @Override
    public BigDecimal calcularEgresosPorBanco(Long bancoId, Long empresaId, LocalDate fecha) {
        return this.repository.calcularEgresosPorBanco(bancoId, empresaId, fecha);
    }

    @Override
    public BigDecimal obtenerSaldoFinalDia(Long bancoId, Long empresaId, LocalDate fecha) {
        return this.repository.obtenerSaldoFinalDia(bancoId, empresaId, fecha);
    }

    @Transactional
    @Override
    public void registrarSaldoDiario(Long empresaId, LocalDate fecha) {
        List<TesBanco> bancos = bancoRepository.buscarTesBancoActivosLista(empresaId);

        for (TesBanco banco : bancos) {
            // saldo anterior
            LocalDate ayer = fecha.minusDays(1);
            BigDecimal saldoInicial = this.obtenerSaldoFinalDia(empresaId, banco.getId(), ayer);
            if (saldoInicial == null) {
                saldoInicial = banco.getSaldoCuenta(); // primer día
            }

            // ingresos y egresos
            BigDecimal ingresos = this.calcularIngresosPorBanco(banco.getId(), empresaId, fecha);
            BigDecimal egresos = this.calcularEgresosPorBanco(banco.getId(), empresaId, fecha);

            // saldo final
            BigDecimal saldoFinal = saldoInicial.add(ingresos).subtract(egresos);

            // guardar histórico
            TesBancoSaldoHistorico registro = new TesBancoSaldoHistorico();
            registro.setTesBanco(banco);
            registro.setBsEmpresa(banco.getBsEmpresa());
            //registro.setBsMoneda(banco.getBsMoneda());
            registro.setFechaSaldo(fecha);
            registro.setSaldoInicial(saldoInicial);
            registro.setIngresos(ingresos);
            registro.setEgresos(egresos);
            registro.setSaldoFinal(saldoFinal);
            registro.setEstado("ACTIVO");

            repository.save(registro);
        }
    }
}

