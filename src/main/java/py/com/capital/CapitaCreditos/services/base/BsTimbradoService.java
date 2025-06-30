package py.com.capital.CapitaCreditos.services.base;

import py.com.capital.CapitaCreditos.entities.base.BsTimbrado;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface BsTimbradoService extends CommonService<BsTimbrado> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<BsTimbrado> buscarBsTimbradoActivosLista(Long idEmpresa);
}
