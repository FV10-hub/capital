package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesBancoRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesBancoService;

import java.util.List;

/*
* 12 ene. 2024 - Elitebook
*/
@Service
public class TesBancoServiceImpl extends CommonServiceImpl<TesBanco, TesBancoRepository> implements TesBancoService{

	private final TesBancoRepository tesBancoRepository;

	public TesBancoServiceImpl(TesBancoRepository repository) {
		super(repository);
		this.tesBancoRepository = repository;
	}

	@Override
	public List<TesBanco> buscarTesBancoActivosLista(Long idEmpresa) {
		return this.repository.buscarTesBancoActivosLista(idEmpresa);
	}

}
