package py.com.capital.CapitaCreditos.services.base;

import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.services.CommonService;

public interface BsUsuarioService extends CommonService<BsUsuario> {

	BsUsuario guardarConEncriptacionDePassword(BsUsuario usuario);

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
}
