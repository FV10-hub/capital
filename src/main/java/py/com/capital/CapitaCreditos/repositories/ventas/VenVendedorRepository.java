package py.com.capital.CapitaCreditos.repositories.ventas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.ventas.VenVendedor;

import java.util.List;

public interface VenVendedorRepository extends JpaRepository<VenVendedor, Long> {
	
	@Query("SELECT m FROM VenVendedor m")
	Page<VenVendedor> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM VenVendedor m")
	List<VenVendedor> buscarTodosLista();
	
	@Query("SELECT m FROM VenVendedor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 ORDER BY m.id DESC ")
	List<VenVendedor> buscarVenVendedorActivosLista(Long idEmpresa);
	
	
}
