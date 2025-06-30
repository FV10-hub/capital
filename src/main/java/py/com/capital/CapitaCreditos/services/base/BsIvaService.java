/**
 * 
 */
package py.com.capital.CapitaCreditos.services.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.base.BsIva;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/**
 * 
 */
public interface BsIvaService extends CommonService<BsIva>  {
	
	Page<BsIva> buscarTodos(Pageable pageable);
	
	List<BsIva> buscarTodosLista();
	
	List<BsIva> buscarIvaActivosLista();
	
}