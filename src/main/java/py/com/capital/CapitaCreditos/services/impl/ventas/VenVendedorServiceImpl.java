package py.com.capital.CapitaCreditos.services.impl.ventas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.ventas.VenVendedor;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesPagoRepository;
import py.com.capital.CapitaCreditos.repositories.ventas.VenVendedorRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.ventas.VenVendedorService;

import java.util.List;

@Service
public class VenVendedorServiceImpl 
extends CommonServiceImpl<VenVendedor, VenVendedorRepository> implements VenVendedorService   {

	private final VenVendedorRepository repository;

	public VenVendedorServiceImpl(VenVendedorRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<VenVendedor> buscarVenVendedorActivosLista(Long idEmpresa) {
		return repository.buscarVenVendedorActivosLista(idEmpresa);
	}

	

}
