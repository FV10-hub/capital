package py.com.capital.CapitaCreditos.services.impl.cobranzas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrador;
import py.com.capital.CapitaCreditos.repositories.cobranzas.CobCobradorRepository;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCobradorService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

@Service
public class CobCobradorServiceImpl 
extends CommonServiceImpl<CobCobrador, CobCobradorRepository> implements CobCobradorService   {

	private final CobCobradorRepository repository;

	public CobCobradorServiceImpl(CobCobradorRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<CobCobrador> buscarCobradorActivosLista(Long idEmpresa) {
		return repository.buscarCobradorActivosLista(idEmpresa);
	}

	

}
