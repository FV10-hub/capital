package py.com.capital.CapitaCreditos.job;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonsUtilitiesController;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoSaldoHistoricoSaldoHistoricoService;

import java.time.LocalDate;

@Component
public class BancoSaldoHistoricoJob {
    private static final Logger LOGGER = LogManager.getLogger(BancoSaldoHistoricoJob.class);

    private final TesBancoSaldoHistoricoSaldoHistoricoService historicoService;


    public BancoSaldoHistoricoJob(TesBancoSaldoHistoricoSaldoHistoricoService historicoService) {
        this.historicoService = historicoService;
    }

    @Scheduled(cron = "0 0 18 * * *") // cada día a las 18:00
    public void registrarSaldosDiarios() {
        try {
            //TODO: le puse el id empresa en duro por que debo ver como acceder a este nivel la empresa
            historicoService.registrarSaldoDiario(1L, LocalDate.now());
        } catch (Exception e) {
            LOGGER.error("Error al registrar saldos históricos", e);
        }
    }
}
