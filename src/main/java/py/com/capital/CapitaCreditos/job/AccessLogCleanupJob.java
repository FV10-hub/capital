package py.com.capital.CapitaCreditos.job;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.services.base.BsAccessLogService;

@Component
public class AccessLogCleanupJob {

    private static final Logger LOGGER = LogManager.getLogger(AccessLogCleanupJob.class);

    private final BsAccessLogService bsAccessLogServiceImpl;
    private final int retentionDays;
    private final int batchSize;

    public AccessLogCleanupJob(BsAccessLogService bsAccessLogServiceImpl,
                               @Value("${app.accesslog.retention-days}") int retentionDays,
                               @Value("${app.accesslog.cleanup.batch-size}") int batchSize) {
        this.bsAccessLogServiceImpl = bsAccessLogServiceImpl;
        this.retentionDays = retentionDays;
        this.batchSize = batchSize;
    }

    @Scheduled(cron = "${app.accesslog.cleanup.cron}")
    public void cleanup() {
        int total = 0;
        int deleted;
        do {
            deleted = bsAccessLogServiceImpl.deleteOldBatch(retentionDays, batchSize);
            total += deleted;
        } while (deleted == batchSize);

        if (total > 0) {
            LOGGER.info("AccessLog cleanup borró registros: " + total);
        }
    }
}
