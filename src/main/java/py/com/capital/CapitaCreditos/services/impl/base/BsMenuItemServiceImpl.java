package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsMenuItem;
import py.com.capital.CapitaCreditos.repositories.base.BsIvaRepository;
import py.com.capital.CapitaCreditos.repositories.base.BsMenuItemRepository;
import py.com.capital.CapitaCreditos.services.base.BsMenuItemService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

@Service
public class BsMenuItemServiceImpl extends CommonServiceImpl<BsMenuItem, BsMenuItemRepository> implements BsMenuItemService   {

	private final BsMenuItemRepository repository;

	public BsMenuItemServiceImpl(BsMenuItemRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<BsMenuItem> findMenuAgrupado(Long idModulo) {
		return repository.findMenuAgrupado(idModulo);
	}

	@Override
	public List<BsMenuItem> findMenuItemAgrupado(Long idMenuItemAgrupador) {
		return repository.findMenuItemAgrupado(idMenuItemAgrupador);
	}
}
