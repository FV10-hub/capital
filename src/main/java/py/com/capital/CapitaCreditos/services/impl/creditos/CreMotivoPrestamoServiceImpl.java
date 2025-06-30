package py.com.capital.CapitaCreditos.services.impl.creditos;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.creditos.CreMotivoPrestamo;
import py.com.capital.CapitaCreditos.repositories.compras.ComProveedorRepository;
import py.com.capital.CapitaCreditos.repositories.creditos.CreMotivoPrestamoRepository;
import py.com.capital.CapitaCreditos.services.creditos.CreMotivoPrestamoService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
* 26 dic. 2023 - Elitebook
*/
@Service
public class CreMotivoPrestamoServiceImpl extends CommonServiceImpl<CreMotivoPrestamo, CreMotivoPrestamoRepository> implements CreMotivoPrestamoService{

	private final CreMotivoPrestamoRepository repository;

	public CreMotivoPrestamoServiceImpl(CreMotivoPrestamoRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<CreMotivoPrestamo> buscarCreMotivoPrestamoActivosLista() {
		return this.repository.buscarCreMotivoPrestamoActivosLista();
	}

}
