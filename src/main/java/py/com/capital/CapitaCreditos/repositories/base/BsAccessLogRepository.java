/**
 *
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.base.BsAccessLog;

import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 *
 */
public interface BsAccessLogRepository extends JpaRepository<BsAccessLog, Long> {

    @Query("SELECT m FROM BsAccessLog m")
    Page<BsAccessLog> buscarTodos(Pageable pageable);

    @Query("SELECT m FROM BsAccessLog m")
    List<BsAccessLog> buscarTodosLista();

    @Query("SELECT m FROM BsAccessLog m where m.estado = 'ACTIVO'")
    List<BsAccessLog> buscarActivosLista();

    @Modifying
    @Transactional
    @Query(value = """
		DELETE FROM bs_access_log
		  WHERE id IN (
			SELECT id
			FROM bs_access_log
			WHERE fecha_creacion < now() - make_interval(days => :retentionDays)
			ORDER BY fecha_creacion
			LIMIT :batch
		  )
        """, nativeQuery = true)
    int deleteOldBatch(@Param("retentionDays") int retentionDays,
                       @Param("batch") int batch);

}
