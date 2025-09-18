package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesChequera;

import javax.persistence.LockModeType;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * fvazquez
 */
public interface TesChequeraRepository extends JpaRepository<TesChequera, Long> {

    @Query("SELECT m FROM TesChequera m")
    Page<TesChequera> buscarTodos(Pageable pageable);

    @Query("SELECT m FROM TesChequera m")
    List<TesChequera> buscarTodosLista();

    @Query("SELECT m FROM TesChequera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
    List<TesChequera> buscarTesChequeraActivosLista(Long idEmpresa);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""
              SELECT c
              FROM TesChequera c
              JOIN FETCH c.tesBanco b
              WHERE c.id = :chequeraId
                AND c.bsEmpresa.id = :empresaId
                AND c.estado = 'ACTIVO'
            """)
    Optional<TesChequera> findForUpdate(@Param("empresaId") Long empresaId,
                                        @Param("chequeraId") Long chequeraId);

    // Para sugerir en UI (solo lectura, sin lock)
    @Query("""
              SELECT c.proximoNumero
              FROM TesChequera c
              WHERE c.id = :chequeraId AND c.bsEmpresa.id = :empresaId
            """)
    Optional<BigDecimal> sugerenciaProximo(@Param("empresaId") Long empresaId,
                                     @Param("chequeraId") Long chequeraId);


}
