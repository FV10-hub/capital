package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsTimbrado;

import java.util.List;

/**
 * fvazquez
 */
public interface BsTimbradoRepository extends JpaRepository<BsTimbrado, Long> {
	
	@Query("SELECT m FROM BsTimbrado m")
	Page<BsTimbrado> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsTimbrado m")
	List<BsTimbrado> buscarTodosLista();
	
	@Query("SELECT m FROM BsTimbrado m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<BsTimbrado> buscarBsTimbradoActivosLista(Long idEmpresa);

}
