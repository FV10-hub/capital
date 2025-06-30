/**
 * 
 */
package py.com.capital.CapitaCreditos.services.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.base.BsMenu;

import java.util.List;

/**
 * 
 */
public interface BsMenuService {

	Page<BsMenu> listarTodos(Pageable pageable);
	
	List<BsMenu> buscarTodosLista();
	
	List<BsMenu>  buscarMenuPorModuloLista(Long id);
	
	BsMenu guardar(BsMenu obj);
	
	void eliminar(Long id);
}