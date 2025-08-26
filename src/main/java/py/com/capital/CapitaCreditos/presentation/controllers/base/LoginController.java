package py.com.capital.CapitaCreditos.presentation.controllers.base;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.primefaces.PrimeFaces;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsAccessLog;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.presentation.session.MenuBean;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.services.LoginService;
import py.com.capital.CapitaCreditos.services.base.BsAccessLogService;
import py.com.capital.CapitaCreditos.services.base.BsUsuarioService;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.Serializable;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Este controlador se va encargar de manejar el flujo de inicio de sesion
 **/
@Component
@Scope("session")
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

    @Autowired
    private BsAccessLogService bsAccessLogServiceImpl;

    @Autowired
    private BsUsuarioService bsUsuarioServiceImpl;


    @Value("${security.login.max-attempts}")
    private int maxAttempts;

    @Value("${security.login.lock-duration}")
    private Duration lockDuration;

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
                CommonUtils.redireccionar("/faces/pages/commons/dashboard.xhtml");
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
        String ip = obtenerIpCliente();
        BsAccessLog accessLog = new BsAccessLog();
        try {
            BsUsuario usuarioConsultado = this.loginServiceImpl.findByUsuario(this.username.toLowerCase());

            if (usuarioConsultado != null) {
                if (usuarioConsultado.estaBloqueado()) {
                    Duration bloqueadoHasta = Duration.between(LocalDateTime.now(), usuarioConsultado.getBloqueadoHasta());
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "Cuenta bloqueada",
                            "Intentá nuevamente en " + formatearBloqueadoHasta(bloqueadoHasta));
                    return;
                }
                if (usuarioConsultado.checkPassword(this.password)) {
                    this.sessionBean.setUsuarioLogueado(usuarioConsultado);
                    this.menuBean.setUsuarioLogueado(usuarioConsultado);
                    //registra log
                    accessLog.setCodUsuario(this.username.toLowerCase());
                    accessLog.setUsuarioModificacion(this.username.toLowerCase());
                    accessLog.setIpAddress(ip);
                    accessLog.setSuccess("S");
                    this.bsAccessLogServiceImpl.save(accessLog);
                    //actualiza intentos
                    usuarioConsultado.registrarExito();
                    this.bsUsuarioServiceImpl.save(usuarioConsultado);

                    // CONSTRUIMOS LA URL DE REDIRECCIÓN
                    String contextPath = FacesContext.getCurrentInstance().getExternalContext().getRequestContextPath();
                    String url = contextPath + "/faces/pages/commons/dashboard.xhtml";

                    // ORDENAMOS AL NAVEGADOR QUE REDIRIJA
                    PrimeFaces.current().executeScript("window.location.href = '" + url + "';");
                } else {
                    //registra log
                    accessLog.setCodUsuario(this.username.toLowerCase());
                    accessLog.setUsuarioModificacion(this.username.toLowerCase());
                    accessLog.setIpAddress(ip);
                    accessLog.setSuccess("N");
                    this.bsAccessLogServiceImpl.save(accessLog);
                    //actualiza intentos
                    usuarioConsultado.registrarFallo(maxAttempts, lockDuration);
                    this.bsUsuarioServiceImpl.save(usuarioConsultado);
                    LOGGER.warn("Intento de inicio de sesión fallido password: {}", this.username);
                    CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡UPS!",
                            "Las credenciales incorrectos intente de nuevo, tiene " + (maxAttempts - usuarioConsultado.getIntentosFallidos()) + " intentos ");
                }


            } else {
                LOGGER.warn("Intento de inicio de sesión fallido para el usuario: {}", this.username);
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡UPS!",
                        "El usuario y/o contraseña son incorrectos");
            }
        } catch (Exception e) {
            accessLog.setCodUsuario(this.username.toLowerCase());
            accessLog.setIpAddress(ip);
            accessLog.setSuccess("N");
            this.bsAccessLogServiceImpl.save(accessLog);
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

    public BsAccessLogService getBsAccessLogServiceImpl() {
        return bsAccessLogServiceImpl;
    }

    public void setBsAccessLogServiceImpl(BsAccessLogService bsAccessLogServiceImpl) {
        this.bsAccessLogServiceImpl = bsAccessLogServiceImpl;
    }

    private String obtenerIpCliente() {
        HttpServletRequest req = (HttpServletRequest) FacesContext.getCurrentInstance()
                .getExternalContext().getRequest();
        String ip = req.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty()) {
            // tomar el primero si viene una lista
            ip = ip.split(",")[0].trim();
        } else {
            ip = req.getRemoteAddr();
        }
        return ip;
    }

    private String formatearBloqueadoHasta(Duration d) {
        long m = d.toMinutes();
        long s = d.minusMinutes(m).getSeconds();
        return m + "m " + s + "s";
    }


}
