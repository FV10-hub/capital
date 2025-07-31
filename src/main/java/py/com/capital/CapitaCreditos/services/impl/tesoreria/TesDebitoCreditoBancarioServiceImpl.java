package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDebitoCreditoBancario;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesDebitosCreditosBancariosRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesDebitoCreditoBancarioService;

import java.util.List;

/*
 * 18 ene. 2024 - Elitebook
 */
@Service
public class TesDebitoCreditoBancarioServiceImpl extends
        CommonServiceImpl<TesDebitoCreditoBancario, TesDebitosCreditosBancariosRepository>
        implements TesDebitoCreditoBancarioService {

    private final TesDebitosCreditosBancariosRepository repository;

    public TesDebitoCreditoBancarioServiceImpl(TesDebitosCreditosBancariosRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<TesDebitoCreditoBancario> buscarTesDebitoCreditoBancarioActivosLista(Long idEmpresa) {
        return this.repository.buscarTesDebitoCreditoBancarioActivosLista(idEmpresa);
    }

    @Override
    public Page<TesDebitoCreditoBancario> buscarTodos(Pageable pageable) {
        return this.repository.buscarTodos(pageable);
    }

    @Override
    public List<TesDebitoCreditoBancario> buscarTodosLista() {
        return this.repository.buscarTodosLista();
    }


}
