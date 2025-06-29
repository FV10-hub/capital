package py.com.capital.CapitaCreditos.repositories.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;

import java.util.List;

public interface CobClienteRepository extends PagingAndSortingRepository<CobCliente, Long> {
	
	@Query("SELECT m FROM CobCliente m")
	Page<CobCliente> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM CobCliente m")
	List<CobCliente> buscarTodosLista();
	
	@Query("SELECT m FROM CobCliente m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<CobCliente> buscarClienteActivosLista(Long idEmpresa);
	
	
}
