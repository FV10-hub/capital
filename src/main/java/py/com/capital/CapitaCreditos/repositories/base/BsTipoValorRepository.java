package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;

import java.util.List;

/**
 * fvazquez
 */
public interface BsTipoValorRepository extends JpaRepository<BsTipoValor, Long> {
	
	@Query("SELECT m FROM BsTipoValor m")
	Page<BsTipoValor> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsTipoValor m")
	List<BsTipoValor> buscarTodosLista();
	
	@Query("SELECT m FROM BsTipoValor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<BsTipoValor> buscarTipoValorActivosLista(Long idEmpresa);

}
