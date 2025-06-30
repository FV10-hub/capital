package py.com.capital.CapitaCreditos.repositories.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;

import java.util.List;

/*
* 17 ene. 2024 - Elitebook
*/
public interface CobCobrosValoresRepository extends JpaRepository<CobCobrosValores, Long>{
	
	@Query("SELECT m FROM CobCobrosValores m")
	Page<CobCobrosValores> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM CobCobrosValores m")
	List<CobCobrosValores> buscarTodosLista();
	
	@Query("SELECT m FROM CobCobrosValores m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<CobCobrosValores> buscarCobCobrosValoresActivosLista(Long idEmpresa);
	
	@Query("SELECT m FROM CobCobrosValores m where m.estado = 'ACTIVO' and m.indDepositado = 'N' and m.bsEmpresa.id = ?1 and m.tipoComprobante = ?2 ")
	List<CobCobrosValores> buscarValoresPorTipoSinDepositarLista(Long idEmpresa, String tipoComprobante);
	
	@Query("SELECT m FROM CobCobrosValores m where m.estado = 'ACTIVO' and m.indDepositado = 'N' and m.bsEmpresa.id = ?1 and m.idComprobate = ?2 and m.tipoComprobante = ?3 ")
	List<CobCobrosValores> buscarValoresPorComprobanteLista(Long idEmpresa,Long idComprobante, String tipoComprobante);
	
	@Query("SELECT m FROM CobCobrosValores m where m.estado = 'ACTIVO' and m.indDepositado = 'S' and m.bsEmpresa.id = ?1 and m.tesDeposito.id = ?2 ")
	List<CobCobrosValores> buscarValoresDepositoLista(Long idEmpresa,Long idDeposito);

}
