package py.com.capital.CapitaCreditos.services.impl.compras;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.compras.ComFacturaCabecera;
import py.com.capital.CapitaCreditos.repositories.compras.ComFacturasRepository;
import py.com.capital.CapitaCreditos.services.compras.ComFacturasService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
 * 9 ene. 2024 - Elitebook
 */
@Service
public class ComFacturasServiceImpl extends CommonServiceImpl<ComFacturaCabecera, ComFacturasRepository>
        implements ComFacturasService {

    private final ComFacturasRepository repository;

    public ComFacturasServiceImpl(ComFacturasRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public Long calcularNroFacturaDisponible(Long idEmpresa, Long idTalonario) {
        return this.repository.calcularNroFacturaDisponible(idEmpresa, idTalonario);
    }

    @Override
    public List<ComFacturaCabecera> buscarComFacturaCabeceraActivosLista(Long idEmpresa) {
        return this.repository.buscarComFacturaCabeceraActivosLista(idEmpresa);
    }

}
