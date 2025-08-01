package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesConciliacionValor;

import java.util.List;

public interface TesConciliacionValorRepository extends JpaRepository<TesConciliacionValor, Long> {
	
	@Query("SELECT m FROM TesConciliacionValor m")
	Page<TesConciliacionValor> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM TesConciliacionValor m")
	List<TesConciliacionValor> buscarTodosLista();

	@Query("SELECT m FROM TesConciliacionValor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<TesConciliacionValor> buscarTesConciliacionValorActivosLista(Long idEmpresa);

	//TODO: N o S son los estados para conciliado
	@Query("SELECT m FROM TesConciliacionValor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.indConsiliado = ?2")
	List<TesConciliacionValor> buscarTesConciliacionValorPorEstado(Long idEmpresa, String estado);
	
}
