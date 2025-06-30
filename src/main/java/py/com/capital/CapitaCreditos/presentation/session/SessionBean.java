/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.session;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.services.base.BsUsuarioService;

import javax.annotation.PostConstruct;
import javax.faces.bean.SessionScoped;
import java.io.IOException;
import java.util.Objects;

/**
 * @author DevPredator
 * Clase que mantendra la informacion en la sesion del usuario.
 */
@Component
@SessionScoped
public class SessionBean {
	/**
	 * Objeto persona que se mantendra en la sesion.
	 */
	private BsUsuario usuarioLogueado;
	private String newPassword;
	
	@Autowired
	private BsUsuarioService bsUsuarioServiceImpl;
		
	@PostConstruct
	public void init() {
		this.newPassword ="";
	}

	public BsUsuario getUsuarioLogueado() {
		return usuarioLogueado;
	}

	public void setUsuarioLogueado(BsUsuario usuarioLogueado) {
		this.usuarioLogueado = usuarioLogueado;
	}
	
	public void updatePasswordUserLogged() {
		if (this.newPassword != null && this.newPassword.length() < 6) {
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_FATAL, "¡ERROR!",
					"La contraseña no puede ser nula y debe contener mas de 6 caracteres.");
			return;
		}
		try {
			this.usuarioLogueado.setPassword(newPassword);
			this.usuarioLogueado.encryptPassword();
			if (!Objects.isNull(bsUsuarioServiceImpl.save(this.usuarioLogueado))) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se guardo correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
			}
			this.newPassword = "";
			FacesContext.getCurrentInstance().getExternalContext().invalidateSession();
			CommonUtils.redireccionar("/login.xhtml");
		} catch (Exception e) {
			e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", e.getMessage().substring(0, e.getMessage().length())+"...");
		}
		
	}
	
	public void goToBsUsuario() {
		try {
			CommonUtils.redireccionar("/pages/cliente/base/definicion/BsUsuario.xhtml");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public BsUsuarioService getBsUsuarioServiceImpl() {
		return bsUsuarioServiceImpl;
	}

	public void setBsUsuarioServiceImpl(BsUsuarioService bsUsuarioServiceImpl) {
		this.bsUsuarioServiceImpl = bsUsuarioServiceImpl;
	}

}
