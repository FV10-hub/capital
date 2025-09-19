package py.com.capital.CapitaCreditos.services.impl.creditos;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import py.com.capital.CapitaCreditos.entities.creditos.CreDesembolsoCabecera;
import py.com.capital.CapitaCreditos.repositories.creditos.CreDesembolsoRepository;
import py.com.capital.CapitaCreditos.services.creditos.CreDesembolsoService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.math.BigDecimal;
import java.util.List;

/*
 * 4 ene. 2024 - Elitebook
 */
@Service
public class CreDesembolsoServiceImpl
        extends CommonServiceImpl<CreDesembolsoCabecera, CreDesembolsoRepository> implements CreDesembolsoService {

    private final CreDesembolsoRepository repository;

    public CreDesembolsoServiceImpl(CreDesembolsoRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public BigDecimal calcularNroDesembolsoDisponible(Long idEmpresa) {
        return this.repository.calcularNroDesembolsoDisponible(idEmpresa);
    }

    @Override
    public List<CreDesembolsoCabecera> buscarCreDesembolsoCabeceraActivosLista(Long idEmpresa) {
        return this.repository.buscarCreDesembolsoCabeceraActivosLista(idEmpresa);
    }

    @Override
    public List<CreDesembolsoCabecera> buscarCreDesembolsoAFacturarLista(Long idEmpresa) {
        return this.repository.buscarCreDesembolsoAFacturarLista(idEmpresa);
    }

    @Override
    public List<CreDesembolsoCabecera> buscarCreDesembolsoParaPagosTesoreriarLista(Long idEmpresa, Long idCliente) {
        return this.repository.buscarCreDesembolsoParaPagosTesoreriarLista(idEmpresa, idCliente);
    }

    @Override
    @Transactional
    public int marcarContratoImpresa(Long empresaId, Long desembolsoId) {
        return this.repository.marcarContratoImpresa(empresaId, desembolsoId);
    }

    @Override
    @Transactional
    public int marcarPagareImpresa(Long empresaId, Long desembolsoId) {
        return this.repository.marcarPagareImpresa(empresaId, desembolsoId);
    }


}
