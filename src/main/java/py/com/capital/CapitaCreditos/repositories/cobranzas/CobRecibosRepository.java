package py.com.capital.CapitaCreditos.repositories.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobReciboCabecera;

import java.util.List;


/*
* 9 ene. 2024 - Elitebook
*/
public interface CobRecibosRepository extends PagingAndSortingRepository<CobReciboCabecera, Long> {
	@Query("SELECT m FROM CobReciboCabecera m")
	Page<CobReciboCabecera> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM CobReciboCabecera m")
	List<CobReciboCabecera> buscarTodosLista();

	@Query(value = "SELECT COALESCE(MAX(m.nro_recibo), 0) + 1 FROM cob_recibos_cabecera m where bs_empresa_id = ?1 and bs_talonario_id = ?2", nativeQuery = true)
	Long calcularNroReciboDisponible(Long idEmpresa, Long idTalonario);

	@Query("SELECT m FROM CobReciboCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<CobReciboCabecera> buscarCobReciboCabeceraActivosLista(Long idEmpresa);
	
	@Query("SELECT m FROM CobReciboCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.cobCliente.id = ?2")
	List<CobReciboCabecera> buscarCobReciboCabeceraPorClienteLista(Long idEmpresa, Long idCliente);
	
	@Query("SELECT m FROM CobReciboCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.cobCobrador.id = ?2")
	List<CobReciboCabecera> buscarCobReciboCabeceraPorCobradorLista(Long idEmpresa, Long idCobrador);
	
	@Query("SELECT m FROM CobReciboCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.bsTalonario.id = ?2 and m.nroRecibo = ?3")
	List<CobReciboCabecera> buscarCobReciboCabeceraPorNroReciboLista(Long idEmpresa, Long idTalonario, Long nroRecibo);
	
	
}
