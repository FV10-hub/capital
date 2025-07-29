package py.com.capital.CapitaCreditos.repositories.compras;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.compras.ComSaldo;

import java.util.List;

/*
* 12 ene. 2024 - Elitebook
*/
public interface ComSaldoRepository extends JpaRepository<ComSaldo, Long>{
	
	@Query("SELECT m FROM ComSaldo m")
	Page<ComSaldo> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM ComSaldo m")
	List<ComSaldo> buscarTodosLista();

	@Query("SELECT m FROM ComSaldo m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<ComSaldo> buscarComSaldoActivosLista(Long idEmpresa);
	
	@Query("SELECT m FROM ComSaldo m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.comProveedor.id = ?2 ")
	List<ComSaldo> buscarSaldoPorProveedorLista(Long idEmpresa, Long idProveedor);
	
	@Query("SELECT m FROM ComSaldo m where m.estado = 'ACTIVO' and m.saldoCuota > 0 and m.bsEmpresa.id = ?1 and m.comProveedor.id = ?2 ")
	List<ComSaldo> buscarSaldoPorProveedorMayorACeroLista(Long idEmpresa, Long idProveedor);

}
