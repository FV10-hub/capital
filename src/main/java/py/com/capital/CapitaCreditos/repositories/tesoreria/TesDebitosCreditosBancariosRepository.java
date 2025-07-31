package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDebitoCreditoBancario;

import java.util.List;

public interface TesDebitosCreditosBancariosRepository extends JpaRepository<TesDebitoCreditoBancario, Long> {
	
	@Query("SELECT m FROM TesDebitoCreditoBancario m")
	Page<TesDebitoCreditoBancario> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM TesDebitoCreditoBancario m")
	List<TesDebitoCreditoBancario> buscarTodosLista();

	@Query("SELECT m FROM TesDebitoCreditoBancario m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<TesDebitoCreditoBancario> buscarTesDebitoCreditoBancarioActivosLista(Long idEmpresa);
	
}
