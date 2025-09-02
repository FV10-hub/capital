/**
 *
 */
package py.com.capital.CapitaCreditos.presentation.session;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import py.com.capital.CapitaCreditos.entities.base.BsMenu;
import py.com.capital.CapitaCreditos.entities.base.BsPermisoRol;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.services.base.BsPermisoRolService;
import py.com.capital.CapitaCreditos.services.base.BsUsuarioService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * @author DevPredator
 * Clase que mantendra la informacion en la sesion del usuario.
 */
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class SessionBean {
    /**
     * Objeto persona que se mantendra en la sesion.
     */
    private BsUsuario usuarioLogueado;
    private String newPassword;

    private List<BsPermisoRol> permisosDelUsuario = new ArrayList<>();

    @Autowired
    private BsUsuarioService bsUsuarioServiceImpl;

    @Autowired
    private BsPermisoRolService bsPermisoRolServiceImpl;

    @PostConstruct
    public void init() {
        this.newPassword = "";
    }

    public BsUsuario getUsuarioLogueado() {
        return usuarioLogueado;
    }

    public void setUsuarioLogueado(BsUsuario usuarioLogueado) {
        this.cargarPermisos();
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
            //this.usuarioLogueado.encryptPassword();
            if (!Objects.isNull(bsUsuarioServiceImpl.guardarConEncriptacionDePassword(this.usuarioLogueado))) {
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
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", e.getMessage().substring(0, e.getMessage().length()) + "...");
        }

    }

    public void cargarPermisos() {
        if (usuarioLogueado != null && usuarioLogueado.getRol() != null) {
            this.permisosDelUsuario = bsPermisoRolServiceImpl.buscarPorRol(usuarioLogueado.getRol().getId());
        }
    }

	public boolean tienePermiso(String nombrePagina, String tipoPermiso) {
		if (permisosDelUsuario == null || permisosDelUsuario.isEmpty()) return false;

		for (BsPermisoRol permiso : permisosDelUsuario) {
			BsMenu menu = permiso.getBsMenu();
			if (menu != null && menu.getUrl() != null && menu.getUrl().endsWith(nombrePagina)) {
				switch (tipoPermiso.toUpperCase()) {
					case "CREAR": return Boolean.TRUE.equals(permiso.getPuedeCrear());
					case "EDITAR": return Boolean.TRUE.equals(permiso.getPuedeEditar());
					case "ELIMINAR": return Boolean.TRUE.equals(permiso.getPuedeEliminar());
					case "VER": return true;
					default: return false;
				}
			}
		}
		return false;
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
