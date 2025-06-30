/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsPermisoRol;

import java.util.List;

/**
 * 
 */
public interface BsPermisoRolRepository extends JpaRepository<BsPermisoRol, Long> {
	
	@Query("SELECT m FROM BsPermisoRol m")
	Page<BsPermisoRol> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsPermisoRol m LEFT JOIN FETCH m.rol r LEFT JOIN FETCH m.bsMenu me ")
	List<BsPermisoRol> buscarTodosLista();
	
}
