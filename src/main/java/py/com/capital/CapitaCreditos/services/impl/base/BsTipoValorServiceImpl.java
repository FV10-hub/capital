package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.repositories.base.BsTipoValorRepository;
import py.com.capital.CapitaCreditos.services.base.BsTipoValorService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

@Service
public class BsTipoValorServiceImpl 
extends CommonServiceImpl<BsTipoValor, BsTipoValorRepository> implements BsTipoValorService   {

	private final BsTipoValorRepository repository;

	public BsTipoValorServiceImpl(BsTipoValorRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<BsTipoValor> buscarTipoValorActivosLista(Long idEmpresa) {
		return repository.buscarTipoValorActivosLista(idEmpresa);
	}

	@Override
	public BsTipoValor buscarTipoValorModuloTipo(Long idEmpresa, String codModulo, String codTipo) {
		return this.repository.buscarTipoValorModuloTipo(idEmpresa, codModulo, codTipo);
	}

}
