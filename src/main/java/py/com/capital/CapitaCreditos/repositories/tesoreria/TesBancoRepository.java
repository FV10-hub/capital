package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;

import java.util.List;


public interface TesBancoRepository extends JpaRepository<TesBanco, Long> {
	
	@Query("SELECT m FROM TesBanco m")
	Page<TesBanco> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM TesBanco m")
	List<TesBanco> buscarTodosLista();
	
	@Query("SELECT m FROM TesBanco m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<TesBanco> buscarTesBancoActivosLista(Long idEmpresa);

	@Query("SELECT m FROM TesBanco m where m.estado = 'ACTIVO' and m.bsMoneda.id = ?1")
	List<TesBanco> buscarTesBancoActivosPorMonedaLista(Long idMoneda);
	
}
