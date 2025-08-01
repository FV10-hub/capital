/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;

import java.util.List;

/**
 * 
 */
public interface BsMonedaRepository extends JpaRepository<BsMoneda, Long> {
	
	@Query("SELECT m FROM BsMoneda m")
	Page<BsMoneda> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsMoneda m")
	List<BsMoneda> buscarTodosLista();
	
	@Query("SELECT m FROM BsMoneda m where m.estado = 'ACTIVO'")
	List<BsMoneda> buscarMonedaActivosLista();

}
