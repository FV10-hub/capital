/**
 * 
 */
package py.com.capital.CapitaCreditos.services.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.base.BsPermisoRol;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/**
 * 
 */
public interface BsPermisoRolService  extends CommonService<BsPermisoRol> {

	Page<BsPermisoRol> listarTodos(Pageable pageable);
	
	List<BsPermisoRol> buscarTodosLista();

	List<BsPermisoRol> buscarPorRol(Long rolId);
	
}