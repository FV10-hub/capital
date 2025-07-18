/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsIva;

import java.util.List;

/**
 * 
 */
public interface BsIvaRepository extends JpaRepository<BsIva, Long> {
	
	@Query("SELECT m FROM BsIva m")
	Page<BsIva> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsIva m")
	List<BsIva> buscarTodosLista();
	
	@Query("SELECT m FROM BsIva m where m.estado = 'ACTIVO'")
	List<BsIva> buscarIvaActivosLista();

}
