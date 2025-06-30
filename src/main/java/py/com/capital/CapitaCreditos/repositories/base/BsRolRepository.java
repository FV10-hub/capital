/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsRol;

import java.util.List;

/**
 * 
 */
public interface BsRolRepository extends JpaRepository<BsRol, Long> {
	
	@Query("SELECT m FROM BsRol m")
	Page<BsRol> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsRol m")
	List<BsRol> buscarTodosLista();

}
