package py.com.capital.CapitaCreditos.repositories.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobSaldo;

import java.math.BigDecimal;
import java.util.List;

/*
* 12 ene. 2024 - Elitebook
*/
public interface CobSaldoRepository extends JpaRepository<CobSaldo, Long>{
	
	@Query("SELECT m FROM CobSaldo m")
	Page<CobSaldo> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM CobSaldo m")
	List<CobSaldo> buscarTodosLista();
	
	@Query(value = "SELECT SUM(COALESCE(m.saldo_cuota, 0)) FROM cob_saldos m where bs_empresa_id = ?1 and cob_cliente_id = ?2 ", nativeQuery = true)
	BigDecimal calcularTotalSaldoAFecha(Long idEmpresa, Long idCliente);
	
	@Query("SELECT m FROM CobSaldo m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<CobSaldo> buscarCobSaldoActivosLista(Long idEmpresa);
	
	@Query("SELECT m FROM CobSaldo m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.cobCliente.id = ?2 ")
	List<CobSaldo> buscarSaldoPorClienteLista(Long idEmpresa, Long idCliente);
	
	@Query("SELECT m FROM CobSaldo m where m.estado = 'ACTIVO' and m.saldoCuota > 0 and m.bsEmpresa.id = ?1 and m.cobCliente.id = ?2 ")
	List<CobSaldo> buscarSaldoPorClienteMayorACeroLista(Long idEmpresa, Long idCliente);

	@Query("SELECT m FROM CobSaldo m where m.estado = 'ACTIVO' and m.saldoCuota > 0 and m.bsEmpresa.id = ?1 and m.cobCliente.id = ?2 and m.idComprobante = ?3 and m.tipoComprobante = ?4 ")
	List<CobSaldo> buscarSaldoPorIdComprobantePorTipoComprobantePorCliente(Long idEmpresa, Long idCliente, Long idComprobante, String tipoComprobante);

}
