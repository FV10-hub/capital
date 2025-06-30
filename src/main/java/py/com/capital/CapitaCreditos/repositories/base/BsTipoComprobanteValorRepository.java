package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsTipoComprobante;

import java.util.List;

/**
 * fvazquez
 */
public interface BsTipoComprobanteValorRepository extends JpaRepository<BsTipoComprobante, Long> {
	
	@Query("SELECT m FROM BsTipoComprobante m")
	Page<BsTipoComprobante> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsTipoComprobante m")
	List<BsTipoComprobante> buscarTodosLista();
	
	@Query("SELECT m FROM BsTipoComprobante m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<BsTipoComprobante> buscarBsTipoComprobanteActivosLista(Long idEmpresa);

}
