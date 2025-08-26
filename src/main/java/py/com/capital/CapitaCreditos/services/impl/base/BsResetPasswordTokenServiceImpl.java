/**
 *
 */
package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsResetPasswordToken;
import py.com.capital.CapitaCreditos.repositories.base.BsResetPasswordTokenRepository;
import py.com.capital.CapitaCreditos.services.base.BsResetPasswordTokenService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/**
 *
 */
@Service
public class BsResetPasswordTokenServiceImpl
        extends CommonServiceImpl<BsResetPasswordToken, BsResetPasswordTokenRepository> implements BsResetPasswordTokenService {

    private final BsResetPasswordTokenRepository repository;

    public BsResetPasswordTokenServiceImpl(BsResetPasswordTokenRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public Page<BsResetPasswordToken> buscarTodos(Pageable pageable) {
        return repository.buscarTodos(pageable);
    }

    @Override
    public List<BsResetPasswordToken> buscarTodosLista() {
        return repository.buscarTodosLista();
    }

    @Override
    public List<BsResetPasswordToken> buscarActivosLista() {
        return repository.buscarActivosLista();
    }

}
