/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;

import java.util.List;

/**
 * 
 */
public interface BsEmpresaRepository extends JpaRepository<BsEmpresa, Long> {
	
	@Query("SELECT m FROM BsEmpresa m")
	Page<BsEmpresa> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsEmpresa m")
	List<BsEmpresa> buscarTodosLista();
	
	@Query("SELECT m FROM BsEmpresa m where m.estado = 'ACTIVO'")
	List<BsEmpresa> buscarEmpresaActivosLista();

}
