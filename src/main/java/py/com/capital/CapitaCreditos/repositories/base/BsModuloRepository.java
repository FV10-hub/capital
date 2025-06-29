/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import py.com.capital.CapitaCreditos.entities.base.BsModulo;

import java.util.List;

/**
 * 
 */
public interface BsModuloRepository extends PagingAndSortingRepository<BsModulo, Long> {
	
	@Query("SELECT m FROM BsModulo m")
	Page<BsModulo> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsModulo m")
	List<BsModulo> buscarTodosLista();
	
	@Query("SELECT m FROM BsModulo m where m.estado = 'ACTIVO' ORDER BY m.nroOrden ASC")
	List<BsModulo> buscarModulosActivosLista();

	@Query("SELECT m FROM BsModulo m where m.estado = 'ACTIVO' and m.codigo = ?1 ORDER BY m.nroOrden ASC")
	BsModulo findByCodigo(String codigo);

}
