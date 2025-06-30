package py.com.capital.CapitaCreditos.services.impl.compras;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.compras.ComProveedor;
import py.com.capital.CapitaCreditos.repositories.compras.ComProveedorRepository;
import py.com.capital.CapitaCreditos.services.compras.ComProveedorService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
* 12 ene. 2024 - Elitebook
*/
@Service
public class ComProveedorServiceImpl extends CommonServiceImpl<ComProveedor, ComProveedorRepository> implements ComProveedorService {

	private final ComProveedorRepository repository;

	public ComProveedorServiceImpl(ComProveedorRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<ComProveedor> buscarComProveedorActivosLista(Long idEmpresa) {
		return this.repository.buscarComProveedorActivosLista(idEmpresa);
	}

}
