package py.com.capital.CapitaCreditos.services.compras;

import py.com.capital.CapitaCreditos.entities.compras.ComProveedor;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface ComProveedorService extends CommonService<ComProveedor> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<ComProveedor> buscarComProveedorActivosLista(Long idEmpresa);
}
