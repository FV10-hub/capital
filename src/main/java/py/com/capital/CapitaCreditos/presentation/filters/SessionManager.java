package py.com.capital.CapitaCreditos.presentation.filters;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.util.HashMap;
import java.util.Map;

/*
* 27 nov. 2023 - Elitebook
*/
public class SessionManager implements HttpSessionListener, ServletContextListener {
	private static int totalActiveSessions;

	private static ServletContext ctx;
	private Map<String, HttpSession> mSession;

	public static int getTotalActiveSession() {
		return totalActiveSessions;
	}

	@Override
	public void sessionCreated(HttpSessionEvent arg0) {
		totalActiveSessions++;
		HttpSession hSession = arg0.getSession();
		mSession.put(hSession.getId(), hSession);
		ctx.setAttribute("_OPENSESSION", mSession);
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent arg0) {
		totalActiveSessions--;
		HttpSession hSession = mSession.get(arg0.getSession().getId());
		mSession.remove(hSession.getId());
		hSession.invalidate();
		ctx.setAttribute("_OPENSESSION", mSession);
	}

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		ctx = sce.getServletContext();
		mSession = new HashMap<>();
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// TODO Auto-generated method stub
	}
}
