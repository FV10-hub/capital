package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesChequera;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesChequeraRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesChequeraService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class TesChequeraServiceImpl extends CommonServiceImpl<TesChequera, TesChequeraRepository> implements TesChequeraService {

    private final TesChequeraRepository repository;

    public TesChequeraServiceImpl(TesChequeraRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<TesChequera> buscarTodosLista() {
        return this.repository.buscarTodosLista();
    }

    @Override
    public List<TesChequera> buscarTesChequeraActivosLista(Long idEmpresa) {
        return this.repository.buscarTesChequeraActivosLista(idEmpresa);
    }

    @Override
    public Optional<TesChequera> findForUpdate(Long empresaId, Long chequeraId) {
        return this.repository.findForUpdate(empresaId, chequeraId);
    }

    @Override
    public Optional<BigDecimal> sugerenciaProximo(Long empresaId, Long chequeraId) {
        return this.repository.sugerenciaProximo(empresaId, chequeraId);
    }
}
