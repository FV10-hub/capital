package py.com.capital.CapitaCreditos.services.impl.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobArqueosCajas;
import py.com.capital.CapitaCreditos.repositories.cobranzas.CobArqueosCajaRepository;
import py.com.capital.CapitaCreditos.services.cobranzas.CobArqueosCajaService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

@Service
public class CobArqueosCajaServiceImpl extends CommonServiceImpl<CobArqueosCajas, CobArqueosCajaRepository>
        implements CobArqueosCajaService {

    private final CobArqueosCajaRepository repository;

    protected CobArqueosCajaServiceImpl(CobArqueosCajaRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public Page<CobArqueosCajas> buscarTodos(Pageable pageable) {
        return this.repository.buscarTodos(pageable);
    }

    @Override
    public List<CobArqueosCajas> buscarTodosLista() {
        return this.repository.buscarTodosLista();
    }

    @Override
    public List<CobArqueosCajas> buscarCobArqueosCajasActivosLista(Long idEmpresa, Long idHabilitacion) {
        return this.repository.buscarCobArqueosCajasActivosLista(idEmpresa, idHabilitacion);
    }
}
