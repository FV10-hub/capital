package py.com.capital.CapitaCreditos.repositories.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;

import java.time.LocalDate;
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
	
	@Query("SELECT m FROM CobCobrosValores m where m.estado = 'ACTIVO' and m.indDepositado = 'N' and m.bsEmpresa.id = ?1 and m.idComprobante = ?2 and m.tipoComprobante = ?3 ")
	List<CobCobrosValores> buscarValoresPorComprobanteLista(Long idEmpresa,Long idComprobante, String tipoComprobante);
	
	@Query("SELECT m FROM CobCobrosValores m where m.estado = 'ACTIVO' and m.indDepositado = 'S' and m.bsEmpresa.id = ?1 and m.tesDeposito.id = ?2 ")
	List<CobCobrosValores> buscarValoresDepositoLista(Long idEmpresa,Long idDeposito);

	@Query("SELECT m FROM CobCobrosValores m WHERE m.estado = 'ACTIVO' AND m.indDepositado = 'S' AND m.bsEmpresa.id = ?1 AND m.fechaValor >= ?2 AND m.fechaValor <= ?3  AND m.indConciliado = ?4")
	List<CobCobrosValores> buscarValoresParaConciliarPorFechas(Long idEmpresa, LocalDate fechaDesde, LocalDate fechaHasta, String conciliado);

	@Modifying(clearAutomatically = true, flushAutomatically = true)
	@Query("""
                UPDATE CobCobrosValores s
                   SET s.indConciliado = 'S',
                       s.usuarioModificacion = :usuario,
                       s.fechaActualizacion = now()
                 WHERE s.bsEmpresa.id = :empresaId
                   AND s.id IN :idsSaldo
                   AND s.indConciliado = 'N'
            """)
	int marcarValoresComoConciliado(@Param("empresaId") Long empresaId,
									@Param("idsSaldo") List<Long> idsSaldo,
									@Param("usuario") String usuario);

	@Modifying(clearAutomatically = true, flushAutomatically = true)
	@Query("""
       UPDATE CobCobrosValores s
          SET s.indConciliado = 'N',
              s.usuarioModificacion = :usuario,
              s.fechaActualizacion = now()
        WHERE s.bsEmpresa.id = :empresaId
          AND s.id IN :idsSaldo
          AND s.indConciliado = 'S'
       """)
	int revertirValoresConciliados(@Param("empresaId") Long empresaId,
								   @Param("idsSaldo") List<Long> idsSaldo,
								   @Param("usuario") String usuario);

}
