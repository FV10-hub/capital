package py.com.capital.CapitaCreditos.presentation.controllers.base;

import javax.faces.application.FacesMessage;
import javax.faces.view.ViewScoped;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.presentation.session.MenuBean;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.services.LoginService;

import java.io.IOException;
import java.io.Serializable;
import java.util.Objects;

/**
 * Este controlador se va encargar de manejar el flujo de inicio de sesion
 **/
@Component
@ViewScoped
public class LoginController implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(LoginController.class);
	
	// atributos
	private String username;
	private String password;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	private LoginService loginServiceImpl;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	private SessionBean sessionBean;

	
	  @Autowired 
	  private MenuBean menuBean;
	 
	// metodos
	public void login() {
		BsUsuario usuarioConsultado = this.loginServiceImpl.consultarUsuarioLogin(this.username, this.password);
		if (!Objects.isNull(usuarioConsultado)) {
			try {
				this.sessionBean.setUsuarioLogueado(usuarioConsultado);
				this.menuBean.setUsuarioLogueado(usuarioConsultado);
				LOGGER.warn("WARN");
				LOGGER.info("INFO");
				LOGGER.error("error");
				CommonUtils.redireccionar("/pages/commons/dashboard.xhtml");
			} catch (IOException e) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_FATAL, "¡ERROR!",
						"Formato incorrecto en cual se ingresa a la pantalla deseada.");
			}
		} else {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡UPS!",
					"El usuario y/o contraseña son incorrectos");
		}

	}
	
	public void loginEncrypt() {
	    try {
	        BsUsuario usuarioConsultado = this.loginServiceImpl.findByUsuario(this.username.toLowerCase());

	        if (usuarioConsultado != null && usuarioConsultado.checkPassword(this.password)) {
	            this.sessionBean.setUsuarioLogueado(usuarioConsultado);
	            this.menuBean.setUsuarioLogueado(usuarioConsultado);
	            
	            try {
	                CommonUtils.redireccionar("/pages/commons/dashboard.xhtml");
	            } catch (IOException e) {
	                LOGGER.error("Error al redirigir a la página de inicio", e);
	                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_FATAL, "¡ERROR!",
	                        "Formato incorrecto al intentar redirigir a la pantalla deseada.");
	            }
	        } else {
	            LOGGER.warn("Intento de inicio de sesión fallido para el usuario: {}", this.username);
	            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡UPS!",
	                    "El usuario y/o contraseña son incorrectos");
	        }
	    } catch (Exception e) {
	        LOGGER.error("Error al intentar encontrar al usuario", e);
	        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_FATAL, "¡ERROR!",
	                "Error al intentar encontrar al usuario. Por favor, inténtelo de nuevo.");
	    }
	}


	// getters y setters
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * @return the loginServiceImpl
	 */
	public LoginService getLoginServiceImpl() {
		return loginServiceImpl;
	}

	/**
	 * @param loginServiceImpl the loginServiceImpl to set
	 */
	public void setLoginServiceImpl(LoginService loginServiceImpl) {
		this.loginServiceImpl = loginServiceImpl;
	}

	/**
	 * @return the sessionBean
	 */
	public SessionBean getSessionBean() {
		return sessionBean;
	}

	/**
	 * @param sessionBean the sessionBean to set
	 */
	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	public MenuBean getMenuBean() {
		return menuBean;
	}

	public void setMenuBean(MenuBean menuBean) {
		this.menuBean = menuBean;
	}
	
	

}
