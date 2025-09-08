package py.com.capital.CapitaCreditos.repositories.compras;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.compras.ComProveedor;

import java.util.List;


public interface ComProveedorRepository extends JpaRepository<ComProveedor, Long> {
	
	@Query("SELECT m FROM ComProveedor m")
	Page<ComProveedor> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM ComProveedor m")
	List<ComProveedor> buscarTodosLista();
	
	@Query("SELECT m FROM ComProveedor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 ORDER BY m.id DESC ")
	List<ComProveedor> buscarComProveedorActivosLista(Long idEmpresa);
	
	
}
