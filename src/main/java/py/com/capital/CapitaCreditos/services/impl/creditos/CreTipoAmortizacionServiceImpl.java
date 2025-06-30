package py.com.capital.CapitaCreditos.services.impl.creditos;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.creditos.CreTipoAmortizacion;
import py.com.capital.CapitaCreditos.repositories.creditos.CreTipoAmortizacionRepository;
import py.com.capital.CapitaCreditos.services.creditos.CreTipoAmortizacionService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
 * 26 dic. 2023 - Elitebook
 */
@Service
public class CreTipoAmortizacionServiceImpl extends CommonServiceImpl<CreTipoAmortizacion, CreTipoAmortizacionRepository> implements CreTipoAmortizacionService {

    private final CreTipoAmortizacionRepository repository;

    public CreTipoAmortizacionServiceImpl(CreTipoAmortizacionRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<CreTipoAmortizacion> buscarCreTipoAmortizacionActivosLista() {
        return this.repository.buscarCreTipoAmortizacionActivosLista();
    }

}
