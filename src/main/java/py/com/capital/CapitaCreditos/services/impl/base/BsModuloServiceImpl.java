/**
 * 
 */
package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsModulo;
import py.com.capital.CapitaCreditos.repositories.base.BsModuloRepository;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;

import java.util.List;

/**
 * 
 */
@Service
public class BsModuloServiceImpl implements BsModuloService {
	
	@Autowired
	private BsModuloRepository bsModuloRepositoryImpl;

	@Override
	public Page<BsModulo> listarTodos(Pageable pageable) {
		Page<BsModulo> page =  this.bsModuloRepositoryImpl.buscarTodos(pageable);
		return page;
	}

	@Override
	public List<BsModulo> buscarTodosLista() {
		return bsModuloRepositoryImpl.buscarTodosLista();
	}

	@Override
	public BsModulo guardar(BsModulo obj) {
		return this.bsModuloRepositoryImpl.save(obj);
	}

	@Override
	public void eliminar(Long id) {
		this.bsModuloRepositoryImpl.deleteById(id);
	}

	@Override
	public List<BsModulo> buscarModulosActivosLista() {
		return this.bsModuloRepositoryImpl.buscarModulosActivosLista();
	}

	@Override
	public BsModulo findByCodigo(String codigo) {
		return this.bsModuloRepositoryImpl.findByCodigo(codigo);
	}



}
