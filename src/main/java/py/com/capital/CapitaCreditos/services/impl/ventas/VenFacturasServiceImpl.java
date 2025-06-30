package py.com.capital.CapitaCreditos.services.impl.ventas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.ventas.VenFacturaCabecera;
import py.com.capital.CapitaCreditos.repositories.ventas.VenFacturasRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.ventas.VenFacturasService;

import java.util.List;

/*
 * 9 ene. 2024 - Elitebook
 */
@Service
public class VenFacturasServiceImpl extends CommonServiceImpl<VenFacturaCabecera, VenFacturasRepository>
        implements VenFacturasService {

    private final VenFacturasRepository repository;

    public VenFacturasServiceImpl(VenFacturasRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public Long calcularNroFacturaDisponible(Long idEmpresa, Long idTalonario) {
        return this.repository.calcularNroFacturaDisponible(idEmpresa, idTalonario);
    }

    @Override
    public List<VenFacturaCabecera> buscarVenFacturaCabeceraActivosLista(Long idEmpresa) {
        return this.repository.buscarVenFacturaCabeceraActivosLista(idEmpresa);
    }

}
