package py.com.capital.CapitaCreditos.services.impl.cobranzas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobReciboCabecera;
import py.com.capital.CapitaCreditos.repositories.cobranzas.CobRecibosRepository;
import py.com.capital.CapitaCreditos.services.cobranzas.CobRecibosService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
* 15 ene. 2024 - Elitebook
*/
@Service
public class CobRecibosServiceImpl extends CommonServiceImpl<CobReciboCabecera, CobRecibosRepository> implements CobRecibosService{

	private final CobRecibosRepository repository;

	public CobRecibosServiceImpl(CobRecibosRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public Long calcularNroReciboDisponible(Long idEmpresa, Long idTalonario) {
		return this.repository.calcularNroReciboDisponible(idEmpresa, idTalonario);
	}

	@Override
	public List<CobReciboCabecera> buscarCobReciboCabeceraActivosLista(Long idEmpresa) {
		return this.repository.buscarCobReciboCabeceraActivosLista(idEmpresa);
	}

	@Override
	public List<CobReciboCabecera> buscarCobReciboCabeceraPorClienteLista(Long idEmpresa, Long idCliente) {
		return this.repository.buscarCobReciboCabeceraPorClienteLista(idEmpresa, idCliente);
	}

	@Override
	public List<CobReciboCabecera> buscarCobReciboCabeceraPorCobradorLista(Long idEmpresa, Long idCobrador) {
		return this.repository.buscarCobReciboCabeceraPorCobradorLista(idEmpresa, idCobrador);
	}

	@Override
	public List<CobReciboCabecera> buscarCobReciboCabeceraPorNroReciboLista(Long idEmpresa, Long idTalonario,
			Long nroRecibo) {
		return this.repository.buscarCobReciboCabeceraPorNroReciboLista(idEmpresa, idTalonario, nroRecibo);
	}

}
