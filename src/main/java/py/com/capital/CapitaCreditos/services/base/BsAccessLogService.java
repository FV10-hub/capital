/**
 * 
 */
package py.com.capital.CapitaCreditos.services.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.base.BsAccessLog;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/**
 * 
 */
public interface BsAccessLogService extends CommonService<BsAccessLog>  {
	
	Page<BsAccessLog> buscarTodos(Pageable pageable);
	
	List<BsAccessLog> buscarTodosLista();
	
	List<BsAccessLog> buscarActivosLista();

	int deleteOldBatch(int retentionDays, int batch);
	
}