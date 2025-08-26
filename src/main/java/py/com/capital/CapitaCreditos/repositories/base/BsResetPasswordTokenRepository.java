/**
 * 
 */
package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
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

}
