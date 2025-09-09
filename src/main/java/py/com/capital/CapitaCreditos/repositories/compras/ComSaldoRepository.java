package py.com.capital.CapitaCreditos.repositories.compras;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.compras.ComSaldo;

import java.math.BigDecimal;
import java.util.List;

/*
 * 12 ene. 2024 - Elitebook
 */
public interface ComSaldoRepository extends JpaRepository<ComSaldo, Long> {

    @Query("SELECT m FROM ComSaldo m")
    Page<ComSaldo> buscarTodos(Pageable pageable);

    @Query("SELECT m FROM ComSaldo m")
    List<ComSaldo> buscarTodosLista();

    @Query("SELECT m FROM ComSaldo m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
    List<ComSaldo> buscarComSaldoActivosLista(Long idEmpresa);

    @Query("SELECT m FROM ComSaldo m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.comProveedor.id = ?2 ")
    List<ComSaldo> buscarSaldoPorProveedorLista(Long idEmpresa, Long idProveedor);

    @Query("SELECT m FROM ComSaldo m where m.estado = 'ACTIVO' and m.saldoCuota > 0 and m.bsEmpresa.id = ?1 and m.comProveedor.id = ?2 ")
    List<ComSaldo> buscarSaldoPorProveedorMayorACeroLista(Long idEmpresa, Long idProveedor);

    @Query("""
            SELECT m
            FROM ComSaldo m
            WHERE m.estado = 'ACTIVO'
            AND m.bsEmpresa.id = :empresaId
            AND (:proveedorId IS NULL OR m.comProveedor.id = :proveedorId)
            AND m.saldoCuota > 0
            AND (:tipo IS NULL OR LOWER(m.tipoComprobante) = LOWER(:tipo))
            ORDER BY m.fechaVencimiento ASC
            """)
    List<ComSaldo> buscarSaldosFiltrados(
            @Param("empresaId") Long empresaId,
            @Param("proveedorId") Long proveedorId,
            @Param("tipo") String tipo
    );

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("""
                UPDATE ComSaldo s
                   SET s.saldoCuota = :montoPagado,
                       s.usuarioModificacion = :usuario
                 WHERE s.bsEmpresa.id = :empresaId
                   AND s.comProveedor.id = :proveedorId
                   AND s.id IN :idsSaldo
                   AND s.tipoComprobante = 'FACTURA'
                   AND s.saldoCuota > 0
            """)
    int pagarSaldosPorIds(@Param("empresaId") Long empresaId,
                          @Param("proveedorId") Long proveedorId,
                          @Param("idsSaldo") List<Long> idsSaldo,
                          @Param("usuario") String usuario,
                          @Param("montoPagado") BigDecimal montoPagado);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("""
                UPDATE ComSaldo s
                   SET s.saldoCuota = :monto,
                       s.estado = 'ACTIVO',
                       s.usuarioModificacion = :usuario
                 WHERE s.bsEmpresa.id = :empresaId
                   AND s.comProveedor.id = :proveedorId
                   AND s.id IN :idsSaldo
                   AND s.tipoComprobante = 'FACTURA'
                   AND s.saldoCuota = 0
            """)
    int reestablecerSaldosPorIds(@Param("empresaId") Long empresaId,
                          @Param("proveedorId") Long proveedorId,
                          @Param("idsSaldo") List<Long> idsSaldo,
                          @Param("usuario") String usuario,
                          @Param("monto") BigDecimal monto);
}


