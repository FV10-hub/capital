package py.com.capital.CapitaCreditos.presentation.filters;

import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Objects;

/*
 * 27 nov. 2023 - Elitebook
 * Clase que implementa el filtro para verificar la sesion del usuario.
 */
//anotacion para configurar pero siempre debe ir implementado la interfaz filter
@Component
@WebFilter
public class LoginFilter implements Filter {

    private static final String LOGIN_PAGE = "/faces/pages/login.xhtml";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // TODO Auto-generated method stub

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String ctx = ((HttpServletRequest) request).getContextPath();
        String uri = ((HttpServletRequest) request).getRequestURI().substring(ctx.length());

        // Permitir login y recursos estaticos
        if (isPublic(uri) || isResource(uri)) {
            chain.doFilter(req, res);
            return;
        }

        // no crea sesion si no existe
        HttpSession session = req.getSession(false);
        Object sessionBean = (session != null) ? session.getAttribute("sessionBean") : null;
        Object usuario = null;

        if (sessionBean != null) {
            try {
                // Ajustá el método si SessionBean cambia
                usuario = sessionBean.getClass().getMethod("getUsuarioLogueado").invoke(sessionBean);
            } catch (Exception ignore) {
            }
        }
        // 3) Si no hay sesión o usuario -> redirigir a login
        if (session == null || sessionBean == null || Objects.isNull(usuario)) {
            // Construí la URL de login con retorno opcional
            String returnTo = req.getRequestURI() + (req.getQueryString() != null ? "?" + req.getQueryString() : "");
            String loginUrl = ctx + LOGIN_PAGE + "?redirect=" + URLEncoder.encode(returnTo, StandardCharsets.UTF_8.name());

            // Caso AJAX (PrimeFaces/JSF): partial redirect
            if ("partial/ajax".equals(req.getHeader("Faces-Request"))) {
                res.setContentType("text/xml");
                res.setCharacterEncoding("UTF-8");
                String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                        + "<partial-response><redirect url=\"" + loginUrl + "\"/></partial-response>";
                res.getWriter().write(xml);
                return;
            }

            // Caso normal
            res.sendRedirect(loginUrl);
            return;
        }

        chain.doFilter(req, res);


    }

    private boolean isPublic(String uri) {
        // Evitar bucle al login y permitir home/error
        return uri.equals("/")
                || uri.startsWith("/login.xhtml")
                || uri.startsWith("/faces/login.xhtml")
                || uri.startsWith("/faces/pages/login.xhtml")
                || uri.startsWith("/index.xhtml")
                || uri.startsWith("/error");
    }

    private boolean isResource(String uri) {
        // Recursos JSF/PrimeFaces y estáticos
        return uri.startsWith("/javax.faces.resource/")
                || uri.startsWith("/resources/")
                || uri.matches(".+\\.(css|js|png|jpg|jpeg|gif|svg|ico|woff2?)$");
    }

    @Override
    public void destroy() {
        // TODO Auto-generated method stub

    }

}
