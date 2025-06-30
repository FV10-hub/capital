package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDeposito;
import py.com.capital.CapitaCreditos.repositories.stock.StoArticuloRepository;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesDepositoRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesDepositoService;

import java.util.List;

/*
* 18 ene. 2024 - Elitebook
*/
@Service
public class TesDepositoServiceImpl extends CommonServiceImpl<TesDeposito, TesDepositoRepository> implements TesDepositoService{

	private final TesDepositoRepository repository;

	public TesDepositoServiceImpl(TesDepositoRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<TesDeposito> buscarTesDepositoActivosLista(Long idEmpresa) {
		return this.repository.buscarTesDepositoActivosLista(idEmpresa);
	}

	@Override
	public Page<TesDeposito> buscarTodos(Pageable pageable) {
		return this.repository.buscarTodos(pageable);
	}

	@Override
	public List<TesDeposito> buscarTodosLista() {
		return this.repository.buscarTodosLista();
	}

	

}
