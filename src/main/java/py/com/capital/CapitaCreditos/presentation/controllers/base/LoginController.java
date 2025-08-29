package py.com.capital.CapitaCreditos.presentation.controllers.base;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.primefaces.PrimeFaces;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.dtos.EmaiRequest;
import py.com.capital.CapitaCreditos.dtos.EmailAdjunto;
import py.com.capital.CapitaCreditos.entities.base.BsAccessLog;
import py.com.capital.CapitaCreditos.entities.base.BsResetPasswordToken;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.presentation.session.MenuBean;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.services.LoginService;
import py.com.capital.CapitaCreditos.services.base.BsAccessLogService;
import py.com.capital.CapitaCreditos.services.base.BsResetPasswordTokenService;
import py.com.capital.CapitaCreditos.services.base.BsUsuarioService;
import py.com.capital.CapitaCreditos.services.impl.EmailServiceImpl;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.Serializable;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;

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

    private String correoParaRecuperacion;

    private Boolean campoVerificacionVisible = false;

    private String token;

    /**
     * Propiedad de la logica de negocio inyectada con JSF y Spring.
     */
    @Autowired
    private LoginService loginServiceImpl;

    @Autowired
    private BsAccessLogService bsAccessLogServiceImpl;

    @Autowired
    private BsResetPasswordTokenService bsResetPasswordTokenServiceImpl;

    @Autowired
    private BsUsuarioService bsUsuarioServiceImpl;

    @Autowired
    private EmailServiceImpl emailService;


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

    public BsUsuarioService getBsUsuarioServiceImpl() {
        return bsUsuarioServiceImpl;
    }

    public void setBsUsuarioServiceImpl(BsUsuarioService bsUsuarioServiceImpl) {
        this.bsUsuarioServiceImpl = bsUsuarioServiceImpl;
    }

    public Boolean getCampoVerificacionVisible() {
        return campoVerificacionVisible;
    }

    public void setCampoVerificacionVisible(Boolean campoVerificacionVisible) {
        this.campoVerificacionVisible = campoVerificacionVisible;
    }

    public String getCorreoParaRecuperacion() {
        return correoParaRecuperacion;
    }

    public void setCorreoParaRecuperacion(String correoParaRecuperacion) {
        this.correoParaRecuperacion = correoParaRecuperacion;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }


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
                if (bsUsuarioServiceImpl.validatePassword(this.password, usuarioConsultado.getPassword())) {
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

    public void prepararReset() {
        this.campoVerificacionVisible = false;
        this.correoParaRecuperacion = null;
        this.token = null;
    }

    public void procesarCambioPassword() {
        BsUsuario bsUsuario = bsUsuarioServiceImpl.buscarPorEmail(this.correoParaRecuperacion);
        if (Objects.isNull(bsUsuario)) {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
                    "El correo " + this.correoParaRecuperacion + " no corresponde a ningun usuario");
            return;
        }
        this.enviarEmail(bsUsuario);

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

    private boolean enviarEmail(BsUsuario bsUsuario) {
        String hash = generarCodigo();
        Map<String, Object> modelo = new HashMap<>();
        modelo.put("nombreEmpresa", "CapitalSys");
        modelo.put("nombreUsuario", bsUsuario.getBsPersona().getNombreCompleto());
        modelo.put("codigo", hash);

        boolean envioExitoso = emailService.sendEmail(generarRequest(bsUsuario.getBsPersona().getEmail(), modelo), "email-template.html");
        if (!envioExitoso) {
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "NO SE ENVIO",
                    "Algo salio mal contacte con el Administrador: " + this.correoParaRecuperacion);
            this.campoVerificacionVisible = false;
            return false;
        }
        CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "ENVIADO",
                "Revisa el codigo que llego a tu correo: " + this.correoParaRecuperacion);
        this.campoVerificacionVisible = true;
        this.guardarToken(bsUsuario.getCodUsuario(), hash);
        return true;
    }

    private String generarCodigo() {
        SecureRandom secureRandom = new SecureRandom();
        int numero = 100000 + secureRandom.nextInt(900000);
        return String.valueOf(numero);
    }

    private void guardarToken(String codUsuario, String hash) {
        BsResetPasswordToken resetPasswordToken = new BsResetPasswordToken();
        resetPasswordToken.setCodUsuario(codUsuario);
        resetPasswordToken.setToken(hash);
        resetPasswordToken.setValidated("N");
        resetPasswordToken.setExpiredAt(LocalDateTime.now().plus(lockDuration));
        this.bsResetPasswordTokenServiceImpl.save(resetPasswordToken);
    }

    private EmaiRequest generarRequest(String email, Map<String, Object> modelo) {
        //TODO: aca arma los adjuntos
        List<EmailAdjunto> adjuntosDePrueba = new ArrayList<>();
        try {
            adjuntosDePrueba = emailService.prepararAdjuntos("D:\\Tesis_2025");
        } catch (Exception e) {
            LOGGER.error(String.format("Error al armar los archivos adjuntos: %s archivo: %s", e.getMessage()));
        }
        EmaiRequest emaiRequest = new EmaiRequest(
                new String[]{(email)},
                "Reseta tu Password",
                Collections.emptyList(),//no enviamos ningun adjunto
                modelo);
        return emaiRequest;
    }

}
