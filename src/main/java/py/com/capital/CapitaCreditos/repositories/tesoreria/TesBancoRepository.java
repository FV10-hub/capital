package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;

import java.math.BigDecimal;
import java.util.List;


public interface TesBancoRepository extends JpaRepository<TesBanco, Long> {

    @Query("SELECT m FROM TesBanco m")
    Page<TesBanco> buscarTodos(Pageable pageable);

    @Query("SELECT m FROM TesBanco m")
    List<TesBanco> buscarTodosLista();

    @Query("SELECT m FROM TesBanco m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 ORDER BY m.id DESC ")
    List<TesBanco> buscarTesBancoActivosLista(Long idEmpresa);

    @Query("SELECT m FROM TesBanco m where m.estado = 'ACTIVO' and m.bsMoneda.id = ?1")
    List<TesBanco> buscarTesBancoActivosPorMonedaLista(Long idMoneda);

    @Query(value = """
            SELECT EXISTS (
              SELECT 1
              FROM public.tes_bancos b
              WHERE b.id = :bancoId
                AND b.bs_empresa_id = :empresaId
                AND b.saldo_cuenta >= :monto
            )
            """, nativeQuery = true)
    boolean tieneSaldoSuficiente(@Param("empresaId") Long empresaId,
                                 @Param("bancoId") Long bancoId,
                                 @Param("monto") BigDecimal monto);

}
