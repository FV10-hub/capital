package py.com.capital.CapitaCreditos.repositories.creditos;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.creditos.CreMotivoPrestamo;

import java.util.List;

/*
* 26 dic. 2023 - Elitebook
*/
public interface CreMotivoPrestamoRepository extends JpaRepository<CreMotivoPrestamo, Long> {
	@Query("SELECT m FROM CreMotivoPrestamo m")
	Page<CreMotivoPrestamo> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM CreMotivoPrestamo m")
	List<CreMotivoPrestamo> buscarTodosLista();
	
	@Query("SELECT m FROM CreMotivoPrestamo m where m.estado = 'ACTIVO'")
	List<CreMotivoPrestamo> buscarCreMotivoPrestamoActivosLista();
}
