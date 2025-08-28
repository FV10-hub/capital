package py.com.capital.CapitaCreditos.services.base;

import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.services.CommonService;

public interface BsUsuarioService extends CommonService<BsUsuario> {

	BsUsuario guardarConEncriptacionDePassword(BsUsuario usuario);

	public boolean validatePassword(String inputPassword, String userSavedPassword);

	BsUsuario buscarPorEmail(String email);

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
}
