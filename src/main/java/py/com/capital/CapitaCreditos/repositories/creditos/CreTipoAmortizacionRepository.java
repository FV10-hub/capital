package py.com.capital.CapitaCreditos.repositories.creditos;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.creditos.CreTipoAmortizacion;

import java.util.List;


/*
* 26 dic. 2023 - Elitebook
*/
public interface CreTipoAmortizacionRepository extends JpaRepository<CreTipoAmortizacion, Long> {
	@Query("SELECT m FROM CreTipoAmortizacion m")
	Page<CreTipoAmortizacion> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM CreTipoAmortizacion m")
	List<CreTipoAmortizacion> buscarTodosLista();
	
	@Query("SELECT m FROM CreTipoAmortizacion m where m.estado = 'ACTIVO'")
	List<CreTipoAmortizacion> buscarCreTipoAmortizacionActivosLista();
}
