package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesPagoCabecera;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesPagoRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesPagoService;

import java.util.List;

/*
 * 18 ene. 2024 - Elitebook
 */
@Service
public class TesPagoServiceImpl extends CommonServiceImpl<TesPagoCabecera, TesPagoRepository> implements TesPagoService {

    private final TesPagoRepository repository;

    public TesPagoServiceImpl(TesPagoRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<TesPagoCabecera> buscarTesPagoCabeceraActivosLista(Long idEmpresa) {
        return this.repository.buscarTesPagoCabeceraActivosLista(idEmpresa);
    }

    @Override
    public List<TesPagoCabecera> buscarTesPagoCabeceraPorBeneficiarioLista(Long idEmpresa, Long idBeneficiario) {
        return this.repository.buscarTesPagoCabeceraPorBeneficiarioLista(idEmpresa, idBeneficiario);
    }

    @Override
    public List<TesPagoCabecera> buscarTesPagoCabeceraPorTipoOperacionLista(Long idEmpresa, String tipoOperacion) {
        return this.repository.buscarTesPagoCabeceraPorTipoOperacionLista(idEmpresa, tipoOperacion);
    }

    @Override
    public Long calcularNroPagoDisponible(Long idEmpresa, Long idTalonario) {
        return this.repository.calcularNroPagoDisponible(idEmpresa, idTalonario);
    }

	/*@Override
	public TesPagoCabecera recuperarPagosConDetalle(Long idEmpresa, Long idPago) {
		return this.repository.recuperarPagosConDetalle(idEmpresa, idPago);
	}*/

}
