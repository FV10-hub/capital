package py.com.capital.CapitaCreditos.repositories.compras;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.compras.ComFacturaCabecera;

import java.util.List;

/*
* 9 ene. 2024 - Elitebook
*/
public interface ComFacturasRepository extends JpaRepository<ComFacturaCabecera, Long> {
	@Query("SELECT m FROM ComFacturaCabecera m")
	Page<ComFacturaCabecera> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM ComFacturaCabecera m")
	List<ComFacturaCabecera> buscarTodosLista();

	@Query(value = "SELECT COALESCE(MAX(m.nro_factura), 0) + 1 FROM com_facturas_cabecera m where bs_empresa_id = ?1 and bs_talonario_id = ?2", nativeQuery = true)
	Long calcularNroFacturaDisponible(Long idEmpresa, Long idTalonario);

	@Query("SELECT m FROM ComFacturaCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<ComFacturaCabecera> buscarComFacturaCabeceraActivosLista(Long idEmpresa);
}
