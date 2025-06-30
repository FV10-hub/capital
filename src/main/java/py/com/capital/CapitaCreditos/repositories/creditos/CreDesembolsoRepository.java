package py.com.capital.CapitaCreditos.repositories.creditos;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.creditos.CreDesembolsoCabecera;

import java.math.BigDecimal;
import java.util.List;

/*
* 4 ene. 2024 - Elitebook
*/
public interface CreDesembolsoRepository extends JpaRepository<CreDesembolsoCabecera, Long> {

	@Query("SELECT m FROM CreDesembolsoCabecera m")
	Page<CreDesembolsoCabecera> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM CreDesembolsoCabecera m")
	List<CreDesembolsoCabecera> buscarTodosLista();
	
	@Query(value = "SELECT COALESCE(MAX(m.nro_desembolso), 0) + 1 FROM cre_desembolso_cabecera m where bs_empresa_id = ?1", nativeQuery = true)
	BigDecimal calcularNroDesembolsoDisponible(Long idEmpresa);
	
	@Query("SELECT m FROM CreDesembolsoCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<CreDesembolsoCabecera> buscarCreDesembolsoCabeceraActivosLista(Long idEmpresa);
	
	@Query("SELECT m FROM CreDesembolsoCabecera m where m.estado = 'ACTIVO' and m.indDesembolsado = 'N' and m.bsEmpresa.id = ?1")
	List<CreDesembolsoCabecera> buscarCreDesembolsoAFacturarLista(Long idEmpresa);
	
	@Query("SELECT m FROM CreDesembolsoCabecera m where m.estado = 'ACTIVO' and m.indDesembolsado = 'S' and m.indFacturado = 'S' and m.bsEmpresa.id = ?1 and m.creSolicitudCredito.cobCliente.id = ?2")
	List<CreDesembolsoCabecera> buscarCreDesembolsoParaPagosTesoreriarLista(Long idEmpresa, Long idCliente);
	
}
