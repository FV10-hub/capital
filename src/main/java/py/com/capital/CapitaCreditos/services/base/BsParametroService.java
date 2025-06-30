package py.com.capital.CapitaCreditos.services.base;

import py.com.capital.CapitaCreditos.entities.base.BsParametro;
import py.com.capital.CapitaCreditos.services.CommonService;

public interface BsParametroService extends CommonService<BsParametro> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	String buscarParametro(String param, Long empresaId, Long moduloId);
}
