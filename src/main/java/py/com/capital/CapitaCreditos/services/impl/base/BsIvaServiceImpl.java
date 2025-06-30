/**
 * 
 */
package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsIva;
import py.com.capital.CapitaCreditos.repositories.base.BsEmpresaRepository;
import py.com.capital.CapitaCreditos.repositories.base.BsIvaRepository;
import py.com.capital.CapitaCreditos.services.base.BsIvaService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/**
 * 
 */
@Service
public class BsIvaServiceImpl 
extends CommonServiceImpl<BsIva, BsIvaRepository> implements BsIvaService {

	private final BsIvaRepository repository;

	public BsIvaServiceImpl(BsIvaRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public Page<BsIva> buscarTodos(Pageable pageable) {
		return repository.buscarTodos(pageable);
	}

	@Override
	public List<BsIva> buscarTodosLista() {
		return repository.buscarTodosLista();
	}

	@Override
	public List<BsIva> buscarIvaActivosLista() {
		return repository.buscarIvaActivosLista();
	}

}
