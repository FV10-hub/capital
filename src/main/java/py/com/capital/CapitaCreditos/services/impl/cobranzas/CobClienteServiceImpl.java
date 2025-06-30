package py.com.capital.CapitaCreditos.services.impl.cobranzas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.repositories.cobranzas.CobClienteRepository;
import py.com.capital.CapitaCreditos.services.cobranzas.CobClienteService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

@Service
public class CobClienteServiceImpl 
extends CommonServiceImpl<CobCliente, CobClienteRepository> implements CobClienteService   {

	private final CobClienteRepository repository;

	public CobClienteServiceImpl(CobClienteRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<CobCliente> buscarClienteActivosLista(Long idEmpresa) {
		return repository.buscarClienteActivosLista(idEmpresa);
	}

	

}
