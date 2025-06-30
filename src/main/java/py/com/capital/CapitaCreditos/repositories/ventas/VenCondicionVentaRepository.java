package py.com.capital.CapitaCreditos.repositories.ventas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.ventas.VenCondicionVenta;

import java.util.List;

public interface VenCondicionVentaRepository extends JpaRepository<VenCondicionVenta, Long> {
	
	@Query("SELECT m FROM VenCondicionVenta m")
	Page<VenCondicionVenta> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM VenCondicionVenta m")
	List<VenCondicionVenta> buscarTodosLista();
	
	@Query("SELECT m FROM VenCondicionVenta m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<VenCondicionVenta> buscarVenCondicionVentaActivosLista(Long idEmpresa);
	
	
}
