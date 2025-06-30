/**
 * 
 */
package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.repositories.base.BsPersonaRepository;
import py.com.capital.CapitaCreditos.services.base.BsPersonaService;

import java.util.List;

/**
 * 
 */
@Service
public class BsPersonaServiceImpl implements BsPersonaService {
	
	@Autowired
	private BsPersonaRepository bsPersonaRepositoryImpl;

	@Override
	public Page<BsPersona> listarTodos(Pageable pageable) {
		return this.bsPersonaRepositoryImpl.buscarTodos(pageable);
	}

	@Override
	public List<BsPersona> buscarTodosLista() {
		return this.bsPersonaRepositoryImpl.buscarTodosLista();
	}

	@Override
	public BsPersona guardar(BsPersona obj) {
		return this.bsPersonaRepositoryImpl.save(obj);
	}

	@Override
	public void eliminar(Long id) {
		this.bsPersonaRepositoryImpl.deleteById(id);
		
	}

	@Override
	public List<BsPersona> personasSinFichaClientePorEmpresa(Long idEmpresa) {
		return this.bsPersonaRepositoryImpl.personasSinFichaClientePorEmpresa(idEmpresa);
	}

	@Override
	public List<BsPersona> personasSinFichaCobradorPorEmpresaNativo(Long idEmpresa) {
		return this.bsPersonaRepositoryImpl.personasSinFichaCobradorPorEmpresaNativo(idEmpresa);
	}

	@Override
	public List<BsPersona> personasSinFichaVendedorPorEmpresaNativo(Long idEmpresa) {
		return this.bsPersonaRepositoryImpl.personasSinFichaVendedorPorEmpresaNativo(idEmpresa);
	}



}
