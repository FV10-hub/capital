package py.com.capital.CapitaCreditos.services.ventas;

import py.com.capital.CapitaCreditos.entities.ventas.VenVendedor;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface VenVendedorService extends CommonService<VenVendedor> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<VenVendedor> buscarVenVendedorActivosLista(Long idEmpresa);
}
