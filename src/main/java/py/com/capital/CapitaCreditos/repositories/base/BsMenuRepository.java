/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsMenu;

import java.util.List;

/**
 * 
 */
public interface BsMenuRepository extends JpaRepository<BsMenu, Long> {
	
	@Query("SELECT m FROM BsMenu m JOIN m.bsModulo l")
	Page<BsMenu> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsMenu m LEFT JOIN FETCH m.bsModulo mo ORDER BY m.id DESC")
	List<BsMenu> buscarTodosLista();
	
	@Query("SELECT m FROM BsMenu m WHERE m.bsModulo.id = ?1")
	List<BsMenu> buscarMenuPorModuloLista(Long id);

}
