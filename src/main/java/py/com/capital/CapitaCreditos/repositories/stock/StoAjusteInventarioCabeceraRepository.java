package py.com.capital.CapitaCreditos.repositories.stock;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.stock.StoAjusteInventarioCabecera;

import java.util.List;

public interface StoAjusteInventarioCabeceraRepository extends JpaRepository<StoAjusteInventarioCabecera, Long> {
	
	@Query("SELECT m FROM StoAjusteInventarioCabecera m")
	Page<StoAjusteInventarioCabecera> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM StoAjusteInventarioCabecera m")
	List<StoAjusteInventarioCabecera> buscarTodosLista();

	@Query(value = "SELECT COALESCE(MAX(m.nro_operacion), 0) + 1 FROM sto_ajuste_inventarios_cabecera m where bs_empresa_id = ?1", nativeQuery = true)
	Long calcularNroOperacionDisponible(Long idEmpresa);

	@Query("SELECT m FROM StoAjusteInventarioCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<StoAjusteInventarioCabecera> buscarStoAjusteInventarioCabeceraActivosLista(Long idEmpresa);
	
}
