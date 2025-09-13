package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesConciliacionValor;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesConciliacionValorRepository;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesDepositoRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesConciliacionValorService;
import py.com.capital.CapitaCreditos.services.tesoreria.TesDepositoService;

import java.util.List;

/*
* 18 ene. 2024 - Elitebook
*/
@Service
public class TesConciliacionValorServiceImpl extends CommonServiceImpl<TesConciliacionValor, TesConciliacionValorRepository>
		implements TesConciliacionValorService {

	private final TesConciliacionValorRepository repository;

	public TesConciliacionValorServiceImpl(TesConciliacionValorRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public Page<TesConciliacionValor> buscarTodos(Pageable pageable) {
		return this.repository.buscarTodos(pageable);
	}

	@Override
	public List<TesConciliacionValor> buscarTodosLista() {
		return this.repository.buscarTodosLista();
	}

	@Override
	public List<TesConciliacionValor> buscarTesConciliacionValorActivosLista(Long idEmpresa) {
		return this.repository.buscarTesConciliacionValorActivosLista(idEmpresa);
	}

	@Override
	public List<TesConciliacionValor> buscarTesConciliacionValorPorEstado(Long idEmpresa, String estado) {
		return this.repository.buscarTesConciliacionValorPorEstado(idEmpresa, estado);
	}

	@Override
	public List<TesConciliacionValor> buscarTesConciliacionValorPorIds(Long idEmpresa, List<Long> ids) {
		return this.repository.buscarTesConciliacionValorPorIds(idEmpresa, ids);
	}


}
