/**
 *
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.base.BsResetPasswordToken;

import java.util.List;

/**
 *
 */
public interface BsResetPasswordTokenRepository extends JpaRepository<BsResetPasswordToken, Long> {

    @Query("SELECT m FROM BsResetPasswordToken m")
    Page<BsResetPasswordToken> buscarTodos(Pageable pageable);

    @Query("SELECT m FROM BsResetPasswordToken m")
    List<BsResetPasswordToken> buscarTodosLista();

    @Query("SELECT m FROM BsResetPasswordToken m where m.estado = 'ACTIVO'")
    List<BsResetPasswordToken> buscarActivosLista();

    @Modifying
    @Query("update BsResetPasswordToken t set t.validated = 'S' where t.id = :id")
    int marcarUsado(@Param("id") Long id);

    @Modifying
    @Query("delete from BsResetPasswordToken t where t.validated = 'S' or t.expiredAt < CURRENT_TIMESTAMP")
    int purgeCaducados();

    @Query("""
                select t
                from BsResetPasswordToken t
                where t.codUsuario = :codUsuario
                  and t.validated = 'N'
                  and t.expiredAt > CURRENT_TIMESTAMP
                order by t.expiredAt desc
            """)
    List<BsResetPasswordToken> findValidTokens(@Param("codUsuario") String codUsuario);


}
