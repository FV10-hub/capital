package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import py.com.capital.CapitaCreditos.entities.base.BsMenuItem;

import java.util.List;

public interface BsMenuItemRepository extends PagingAndSortingRepository<BsMenuItem, Long> {
	
	@Query(value = "SELECT m FROM BsMenuItem m where m.tipoMenu IN ('DEFINICION','MOVIMIENTOS','REPORTES') AND m.bsModulo.id = ?1")
	List<BsMenuItem> findMenuAgrupado(Long idModulo);
	
	@Query(value = "SELECT m FROM BsMenuItem m where m.idMenuItem = ?1 ORDER BY m.bsMenu.nroOrden asc")
	List<BsMenuItem> findMenuItemAgrupado(Long idMenuItemAgrupador);
	
	
}
