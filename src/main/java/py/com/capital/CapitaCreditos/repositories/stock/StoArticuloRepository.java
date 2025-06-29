package py.com.capital.CapitaCreditos.repositories.stock;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;

import java.math.BigDecimal;
import java.util.List;

public interface StoArticuloRepository extends PagingAndSortingRepository<StoArticulo, Long> {
	
	@Query("SELECT m FROM StoArticulo m")
	Page<StoArticulo> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM StoArticulo m")
	List<StoArticulo> buscarTodosLista();
	
	@Query("SELECT m FROM StoArticulo m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<StoArticulo> buscarStoArticuloActivosLista(Long idEmpresa);
	
	@Query("SELECT m FROM StoArticulo m where m.estado = 'ACTIVO' and m.codArticulo = ?1 and m.bsEmpresa.id = ?2")
	StoArticulo buscarArticuloPorCodigo(String param, Long empresaId);
	
	@Query(value = "SELECT sae.existencia "
			+ "FROM sto_articulos_existencias sae "
			+ "JOIN sto_articulos sa ON sae.sto_articulo_id = sa.id "
			+ "WHERE sa.id = ?1 "
			+ "AND sa.bs_empresa_id = ?2", nativeQuery = true)
	BigDecimal retornaExistenciaArticulo(Long idArticulo,Long idEmpresa);
	
}
