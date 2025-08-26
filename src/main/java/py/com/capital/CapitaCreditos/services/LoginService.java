/**
 * 
 */
package py.com.capital.CapitaCreditos.services;

import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.entities.MenuDto;

import java.util.List;

/**
 * @author favzquez
 * Interface que realiza la logica de negocio para el inicio de sesion de la persona.
 */
public interface LoginService {
	/**
	 * Metodo que permite consultar un usuario que trata de ingresar a sesion en la tienda musical.
	 * @param usuario {@link String} usuario capturado por la persona.
	 * @param password {@link String} contraseña capturada por la persona.
	 * @return {@link Persona} usuario encontrado en la base de datos.
	 */
	BsUsuario consultarUsuarioLogin(String usuario, String password);
	
	BsUsuario findByUsuario(String codUsuario);
	
	List<MenuDto> consultarMenuPorUsuario(Long id);

}
