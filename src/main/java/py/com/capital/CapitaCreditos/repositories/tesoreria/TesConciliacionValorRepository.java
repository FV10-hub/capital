package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.dtos.ValorConciliacionDto;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesConciliacionValor;

import java.time.LocalDate;
import java.util.List;

public interface TesConciliacionValorRepository extends JpaRepository<TesConciliacionValor, Long> {

    @Query("SELECT m FROM TesConciliacionValor m")
    Page<TesConciliacionValor> buscarTodos(Pageable pageable);

    @Query("SELECT m FROM TesConciliacionValor m")
    List<TesConciliacionValor> buscarTodosLista();

    @Query("SELECT m FROM TesConciliacionValor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
    List<TesConciliacionValor> buscarTesConciliacionValorActivosLista(Long idEmpresa);

    //TODO: N o S son los estados para conciliado
    @Query("SELECT m FROM TesConciliacionValor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.indConciliado = ?2")
    List<TesConciliacionValor> buscarTesConciliacionValorPorEstado(Long idEmpresa, String estado);

    @Query("SELECT m FROM TesConciliacionValor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 AND m.cobCobrosValores.id IN ?2")
    List<TesConciliacionValor> buscarTesConciliacionValorPorIds(Long idEmpresa, List<Long> ids);

    @Query("SELECT m FROM TesConciliacionValor m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 AND m.tesPagoValores.id IN ?2")
    List<TesConciliacionValor> buscarTesConciliacionPagosValorPorIds(Long idEmpresa, List<Long> ids);


    @Query("SELECT new py.com.capital.CapitaCreditos.dtos.ValorConciliacionDto(" +
            "m.id, 'INGRESOS', m.bsTipoValor.codTipo, m.nroComprobanteCompleto, m.tipoComprobante, " +
            "m.nroValor, m.fechaValor, m.fechaVencimiento, m.montoValor) " +
            "FROM CobCobrosValores m " +
            "WHERE m.estado = 'ACTIVO' " +
            "AND m.indDepositado = 'S' " +
            "AND m.bsEmpresa.id = :empresaId " +
            "AND m.fechaValor BETWEEN :desde AND :hasta " +
            "AND m.indConciliado = :conciliado " +
            "AND ( (m.bsPersonaJuridica.id = :personaJuridicaId) OR (m.bsTipoValor.codTipo = 'EFE') )")
    List<ValorConciliacionDto> buscarCobrosParaConciliacion(@Param("empresaId") Long empresaId,
                                                            @Param("desde") LocalDate desde,
                                                            @Param("hasta") LocalDate hasta,
                                                            @Param("conciliado") String conciliado,
                                                            @Param("personaJuridicaId") Long personaJuridicaId);

    @Query("SELECT new py.com.capital.CapitaCreditos.dtos.ValorConciliacionDto(" +
            "p.id, 'EGRESOS', p.bsTipoValor.codTipo, '', p.tipoOperacion, " +
            "p.nroValor, p.fechaValor, p.fechaVencimiento, p.montoValor) " +
            "FROM TesPagoValores p " +
            "WHERE p.bsEmpresa.id = :empresaId " +
            "AND p.fechaValor BETWEEN :desde AND :hasta " +
            "AND p.indConciliado = :conciliado " +
            "AND p.tesBanco.bsMoneda.codMoneda = 'GS' " + //TODO: en duro la moneda ver mas adelante
            "AND ( (p.tesBanco.bsPersona.id = :personaJuridicaId) OR (p.bsTipoValor.codTipo = 'EFE') )")
    List<ValorConciliacionDto> buscarPagosParaConciliacion(@Param("empresaId") Long empresaId,
                                                           @Param("desde") LocalDate desde,
                                                           @Param("hasta") LocalDate hasta,
                                                           @Param("conciliado") String conciliado,
                                                           @Param("personaJuridicaId") Long personaJuridicaId);


}
