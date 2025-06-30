package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsTimbrado;
import py.com.capital.CapitaCreditos.repositories.base.BsTimbradoRepository;
import py.com.capital.CapitaCreditos.services.base.BsTimbradoService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
* 2 ene. 2024 - Elitebook
*/
@Service
public class BsTimbradoServiceImpl 
extends CommonServiceImpl<BsTimbrado, BsTimbradoRepository> implements BsTimbradoService {

	private final BsTimbradoRepository repository;

	public BsTimbradoServiceImpl(BsTimbradoRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<BsTimbrado> buscarBsTimbradoActivosLista(Long idEmpresa) {
		return this.repository.buscarBsTimbradoActivosLista(idEmpresa);
	}

}
