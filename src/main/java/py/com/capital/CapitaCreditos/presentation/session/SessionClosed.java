/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.session;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.view.ViewScoped;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;

import java.io.IOException;

/**
 * @author DevPredator Clase que permite cerrar la sesion del usuario y
 *         redireccionar a la pantalla del login.
 */
@Component
@ViewScoped
public class SessionClosed {

	/**
	 * Metodo que permite cerrar la sesion del usuario.
	 */
	public void cerrarSesion() {
		try {
			ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
			HttpServletResponse response = (HttpServletResponse) externalContext.getResponse();
			externalContext.invalidateSession();
			
			// Controlar la caché del navegador
			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);
			CommonUtils.redireccionar("/login.xhtml");
		} catch (IOException e) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡Ups!",
					"Hubo un problema al tratar de regresar al login, favor de intentar más tarde.");
			e.printStackTrace();
		}
	}
}
