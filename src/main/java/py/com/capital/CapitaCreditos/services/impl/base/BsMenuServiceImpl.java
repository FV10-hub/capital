/**
 * 
 */
package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsMenu;
import py.com.capital.CapitaCreditos.repositories.base.BsMenuRepository;
import py.com.capital.CapitaCreditos.services.base.BsMenuService;

import java.util.List;

/**
 * 
 */
@Service
public class BsMenuServiceImpl implements BsMenuService {
	
	@Autowired
	private BsMenuRepository bsMenuRepositoryImpl;

	@Override
	public Page<BsMenu> listarTodos(Pageable pageable) {
		Page<BsMenu> page =  this.bsMenuRepositoryImpl.buscarTodos(pageable);
		return page;
	}

	@Override
	public List<BsMenu> buscarTodosLista() {
		return bsMenuRepositoryImpl.buscarTodosLista();
	}

	@Override
	public BsMenu guardar(BsMenu obj) {
		return this.bsMenuRepositoryImpl.save(obj);
	}

	@Override
	public void eliminar(Long id) {
		this.bsMenuRepositoryImpl.deleteById(id);
	}

	@Override
	public List<BsMenu> buscarMenuPorModuloLista(Long id) {
		return this.bsMenuRepositoryImpl.buscarMenuPorModuloLista(id);
	}

}
