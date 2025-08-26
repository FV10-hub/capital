/**
 *
 */
package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsAccessLog;
import py.com.capital.CapitaCreditos.repositories.base.BsAccessLogRepository;
import py.com.capital.CapitaCreditos.services.base.BsAccessLogService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/**
 *
 */
@Service
public class BsAccessLogServiceImpl
        extends CommonServiceImpl<BsAccessLog, BsAccessLogRepository> implements BsAccessLogService {

    private final BsAccessLogRepository repository;

    public BsAccessLogServiceImpl(BsAccessLogRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public Page<BsAccessLog> buscarTodos(Pageable pageable) {
        return repository.buscarTodos(pageable);
    }

    @Override
    public List<BsAccessLog> buscarTodosLista() {
        return repository.buscarTodosLista();
    }

    @Override
    public List<BsAccessLog> buscarActivosLista() {
        return repository.buscarActivosLista();
    }

}
