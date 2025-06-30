package py.com.capital.CapitaCreditos.services.ventas;

import py.com.capital.CapitaCreditos.entities.ventas.VenCondicionVenta;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface VenCondicionVentaService extends CommonService<VenCondicionVenta> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<VenCondicionVenta> buscarVenCondicionVentaActivosLista(Long idEmpresa);
}
