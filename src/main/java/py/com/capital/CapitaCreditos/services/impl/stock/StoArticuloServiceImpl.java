package py.com.capital.CapitaCreditos.services.impl.stock;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;
import py.com.capital.CapitaCreditos.repositories.stock.StoArticuloRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.stock.StoArticuloService;

import java.math.BigDecimal;
import java.util.List;

@Service
public class StoArticuloServiceImpl
        extends CommonServiceImpl<StoArticulo, StoArticuloRepository> implements StoArticuloService {

    private final StoArticuloRepository repository;

    public StoArticuloServiceImpl(StoArticuloRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<StoArticulo> buscarStoArticuloActivosLista(Long idEmpresa) {
        return repository.buscarStoArticuloActivosLista(idEmpresa);
    }

    @Override
    public StoArticulo buscarArticuloPorCodigo(String param, Long empresaId) {
        return this.repository.buscarArticuloPorCodigo(param, empresaId);
    }

    @Override
    public BigDecimal retornaExistenciaArticulo(Long idArticulo, Long idEmpresa) {
        return this.repository.retornaExistenciaArticulo(idArticulo, idEmpresa);
    }


}
