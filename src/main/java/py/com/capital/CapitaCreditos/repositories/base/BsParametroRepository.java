/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsParametro;

import java.util.List;

/**
 * 
 */
public interface BsParametroRepository extends JpaRepository<BsParametro, Long> {

	@Query("SELECT m FROM BsParametro m")
	Page<BsParametro> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM BsParametro m")
	List<BsParametro> buscarTodosLista();

	@Query("SELECT m.valor FROM BsParametro m where m.estado = 'ACTIVO' and m.parametro = ?1 and m.bsEmpresa.id = ?2 and m.bsModulo.id = ?3")
	String buscarParametro(String param, Long empresaId, Long moduloId);

	@Query("SELECT m FROM BsParametro m where m.estado = 'ACTIVO'")
	List<BsParametro> buscarParametroActivosLista();

}
