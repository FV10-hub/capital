package py.com.capital.CapitaCreditos.repositories.ventas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.ventas.VenFacturaCabecera;

import java.util.List;

/*
* 9 ene. 2024 - Elitebook
*/
public interface VenFacturasRepository extends JpaRepository<VenFacturaCabecera, Long> {
	@Query("SELECT m FROM VenFacturaCabecera m")
	Page<VenFacturaCabecera> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM VenFacturaCabecera m")
	List<VenFacturaCabecera> buscarTodosLista();

	@Query(value = "SELECT COALESCE(MAX(m.nro_factura), 0) + 1 FROM ven_facturas_cabecera m where bs_empresa_id = ?1 and bs_talonario_id = ?2", nativeQuery = true)
	Long calcularNroFacturaDisponible(Long idEmpresa, Long idTalonario);

	@Query("SELECT m FROM VenFacturaCabecera m where m.estado in ('ACTIVO','ANULADO') and m.bsEmpresa.id = ?1")
	List<VenFacturaCabecera> buscarVenFacturaCabeceraActivosLista(Long idEmpresa);
}
