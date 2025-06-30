/**
 * 
 */
package py.com.capital.CapitaCreditos.services.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.base.BsModulo;

import java.util.List;

/**
 * 
 */
public interface BsModuloService {

	Page<BsModulo> listarTodos(Pageable pageable);
	
	List<BsModulo> buscarTodosLista();
	
	List<BsModulo> buscarModulosActivosLista();
	
	BsModulo findByCodigo(String codigo);
	
	BsModulo guardar(BsModulo obj);
	
	void eliminar(Long id);
}