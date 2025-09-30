package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBancoSaldoHistorico;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;


public interface TesBancoSaldoHistoricoSaldoHistoricoRepository extends JpaRepository<TesBancoSaldoHistorico, Long> {

    @Query("SELECT m FROM TesBancoSaldoHistorico m")
    Page<TesBancoSaldoHistorico> buscarTodos(Pageable pageable);

    @Query("SELECT m FROM TesBancoSaldoHistorico m")
    List<TesBancoSaldoHistorico> buscarTodosLista();

    @Query("SELECT m FROM TesBancoSaldoHistorico m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 ORDER BY m.id DESC ")
    List<TesBancoSaldoHistorico> buscarTesBancoSaldoHistoricoActivosLista(Long idEmpresa);

    @Query(value = """
                SELECT COALESCE(SUM(cv.monto_cuota), 0)
                FROM cob_cobros_valores cv
                JOIN tes_depositos d ON d.id = cv.tes_deposito_id
                WHERE d.tes_banco_id = :bancoId
                  AND cv.bs_empresa_id = :empresaId
                  AND cv.fecha_valor = :fecha
            """, nativeQuery = true)
    BigDecimal calcularIngresosPorBanco(@Param("bancoId") Long bancoId,
                                        @Param("empresaId") Long empresaId,
                                        @Param("fecha") LocalDate fecha);

    @Query(value = """
                SELECT COALESCE(SUM(pv.monto_cuota), 0)
                FROM tes_pagos_valores pv
                WHERE pv.tes_banco_id = :bancoId
                  AND pv.bs_empresa_id = :empresaId
                  AND pv.fecha_valor = :fecha
            """, nativeQuery = true)
    BigDecimal calcularEgresosPorBanco(@Param("bancoId") Long bancoId,
                                       @Param("empresaId") Long empresaId,
                                       @Param("fecha") LocalDate fecha);

    @Query("""
                SELECT h.saldoFinal
                FROM TesBancoSaldoHistorico h
                WHERE h.bsEmpresa.id = :empresaId
                  AND h.tesBanco.id = :bancoId
                  AND h.fechaSaldo = :fecha
            """)
    BigDecimal obtenerSaldoFinalDia(@Param("empresaId") Long empresaId,
                                    @Param("bancoId") Long bancoId,
                                    @Param("fecha") LocalDate fecha);


}
