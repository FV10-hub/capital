package py.com.capital.CapitaCreditos.services.impl.ventas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.ventas.VenCondicionVenta;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesPagoRepository;
import py.com.capital.CapitaCreditos.repositories.ventas.VenCondicionVentaRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.ventas.VenCondicionVentaService;

import java.util.List;

@Service
public class VenCondicionVentaServiceImpl 
extends CommonServiceImpl<VenCondicionVenta, VenCondicionVentaRepository> implements VenCondicionVentaService   {

	private final VenCondicionVentaRepository repository;

	public VenCondicionVentaServiceImpl(VenCondicionVentaRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<VenCondicionVenta> buscarVenCondicionVentaActivosLista(Long idEmpresa) {
		return repository.buscarVenCondicionVentaActivosLista(idEmpresa);
	}

	

}
