package py.com.capital.CapitaCreditos.services.impl.cobranzas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;
import py.com.capital.CapitaCreditos.repositories.cobranzas.CobCobrosValoresRepository;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCobrosValoresService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.time.LocalDate;
import java.util.List;

/*
 * 12 ene. 2024 - Elitebook
 */
@Service
public class CobCobrosValoresServiceImpl extends CommonServiceImpl<CobCobrosValores, CobCobrosValoresRepository>
        implements CobCobrosValoresService {

    private final CobCobrosValoresRepository repository;

    public CobCobrosValoresServiceImpl(CobCobrosValoresRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<CobCobrosValores> buscarTodosLista() {
        return this.repository.buscarTodosLista();
    }

    @Override
    public List<CobCobrosValores> buscarCobCobrosValoresActivosLista(Long idEmpresa) {
        return this.repository.buscarCobCobrosValoresActivosLista(idEmpresa);
    }

    @Override
    public List<CobCobrosValores> buscarValoresPorTipoSinDepositarLista(Long idEmpresa, String tipoComprobante) {
        return this.repository.buscarValoresPorTipoSinDepositarLista(idEmpresa, tipoComprobante);
    }

    @Override
    public List<CobCobrosValores> buscarValoresPorComprobanteLista(Long idEmpresa, Long idComprobante,
                                                                   String tipoComprobante) {
        return this.repository.buscarValoresPorComprobanteLista(idEmpresa, idComprobante, tipoComprobante);
    }

    @Override
    public List<CobCobrosValores> buscarValoresDepositoLista(Long idEmpresa, Long idDeposito) {
        return this.repository.buscarValoresDepositoLista(idEmpresa, idDeposito);
    }

    @Override
    public List<CobCobrosValores> buscarValoresParaConciliarPorFechas(Long idEmpresa, LocalDate fechaDesde, LocalDate fechaHasta) {
        return this.repository.buscarValoresParaConciliarPorFechas(idEmpresa, fechaDesde, fechaHasta);
    }

    @Override
    public int marcarValoresComoConciliado(Long empresaId, Long tipoValorId, List<Long> idsSaldo, String usuario) {
        return this.repository.marcarValoresComoConciliado(empresaId, tipoValorId, idsSaldo,usuario);
    }

}
