package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDeposito;

import java.util.List;

public interface TesDepositoRepository extends PagingAndSortingRepository<TesDeposito, Long> {
	
	@Query("SELECT m FROM TesDeposito m")
	Page<TesDeposito> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM TesDeposito m")
	List<TesDeposito> buscarTodosLista();

	@Query("SELECT m FROM TesDeposito m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<TesDeposito> buscarTesDepositoActivosLista(Long idEmpresa);
	
}
