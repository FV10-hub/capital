/**
 *
 */
package py.com.capital.CapitaCreditos.services.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.base.BsResetPasswordToken;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/**
 *
 */
public interface BsResetPasswordTokenService extends CommonService<BsResetPasswordToken> {

    Page<BsResetPasswordToken> buscarTodos(Pageable pageable);

    List<BsResetPasswordToken> buscarTodosLista();

    List<BsResetPasswordToken> buscarActivosLista();

    int marcarUsado(Long id);

    int purgeCaducados();

}