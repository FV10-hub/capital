package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.repositories.base.BsIvaRepository;
import py.com.capital.CapitaCreditos.repositories.base.BsTalonarioRepository;
import py.com.capital.CapitaCreditos.services.base.BsTalonarioService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
* 2 ene. 2024 - Elitebook
*/
@Service
public class BsTalonarioServiceImpl 
extends CommonServiceImpl<BsTalonario, BsTalonarioRepository> implements BsTalonarioService {


	private final BsTalonarioRepository repository;

	public BsTalonarioServiceImpl(BsTalonarioRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<BsTalonario> buscarBsTalonarioActivosLista(Long idEmpresa) {
		return this.repository.buscarBsTalonarioActivosLista(idEmpresa);
	}

	@Override
	public List<BsTalonario> buscarBsTalonarioPorModuloLista(Long idEmpresa, Long idModulo) {
		return this.repository.buscarBsTalonarioPorModuloLista(idEmpresa, idModulo);
	}

}
