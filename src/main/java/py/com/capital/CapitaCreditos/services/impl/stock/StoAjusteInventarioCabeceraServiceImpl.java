package py.com.capital.CapitaCreditos.services.impl.stock;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.stock.StoAjusteInventarioCabecera;
import py.com.capital.CapitaCreditos.repositories.stock.StoAjusteInventarioCabeceraRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.stock.StoAjusteInventarioCabeceraService;

import java.util.List;

/*
 * 9 ene. 2024 - Elitebook
 */
@Service
public class StoAjusteInventarioCabeceraServiceImpl extends CommonServiceImpl<StoAjusteInventarioCabecera, StoAjusteInventarioCabeceraRepository>
        implements StoAjusteInventarioCabeceraService {

    private final StoAjusteInventarioCabeceraRepository repository;

    public StoAjusteInventarioCabeceraServiceImpl(StoAjusteInventarioCabeceraRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<StoAjusteInventarioCabecera> buscarStoAjusteInventarioCabeceraActivosLista(Long idEmpresa) {
        return this.repository.buscarStoAjusteInventarioCabeceraActivosLista(idEmpresa);
    }

    @Override
    public List<StoAjusteInventarioCabecera> buscarTodosLista() {
        return this.repository.buscarTodosLista();
    }

    @Override
    public Long calcularNroOperacionDisponible(Long idEmpresa) {
        return this.repository.calcularNroOperacionDisponible(idEmpresa);
    }


}
