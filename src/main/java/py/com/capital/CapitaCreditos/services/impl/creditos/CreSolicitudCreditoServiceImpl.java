package py.com.capital.CapitaCreditos.services.impl.creditos;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.creditos.CreSolicitudCredito;
import py.com.capital.CapitaCreditos.repositories.compras.ComProveedorRepository;
import py.com.capital.CapitaCreditos.repositories.creditos.CreSolicitudCreditoRepository;
import py.com.capital.CapitaCreditos.services.creditos.CreSolicitudCreditoService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
* 26 dic. 2023 - Elitebook
*/
@Service
public class CreSolicitudCreditoServiceImpl 
extends CommonServiceImpl<CreSolicitudCredito, CreSolicitudCreditoRepository> implements CreSolicitudCreditoService {

	private final CreSolicitudCreditoRepository repository;

	public CreSolicitudCreditoServiceImpl(CreSolicitudCreditoRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<CreSolicitudCredito> buscarSolicitudActivosLista(Long idEmpresa) {
		return this.repository.buscarSolicitudActivosLista(idEmpresa);
	}

	@Override
	public List<CreSolicitudCredito> buscarSolicitudAutorizadosLista(Long idEmpresa) {
		return this.repository.buscarSolicitudAutorizadosLista(idEmpresa);
	}

}
