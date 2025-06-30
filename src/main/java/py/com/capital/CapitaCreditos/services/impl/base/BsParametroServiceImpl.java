package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsParametro;
import py.com.capital.CapitaCreditos.repositories.base.BsIvaRepository;
import py.com.capital.CapitaCreditos.repositories.base.BsParametroRepository;
import py.com.capital.CapitaCreditos.services.base.BsParametroService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

@Service
public class BsParametroServiceImpl 
extends CommonServiceImpl<BsParametro, BsParametroRepository> implements BsParametroService   {

	private final BsParametroRepository repository;

	public BsParametroServiceImpl(BsParametroRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public String buscarParametro(String param, Long empresaId, Long moduloId) {
		return this.repository.buscarParametro(param, empresaId, moduloId);
	}

}
