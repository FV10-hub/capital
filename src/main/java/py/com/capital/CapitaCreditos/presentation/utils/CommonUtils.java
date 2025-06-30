package py.com.capital.CapitaCreditos.presentation.utils;

import jakarta.faces.application.FacesMessage;
import jakarta.faces.application.FacesMessage.Severity;
import jakarta.faces.context.ExternalContext;
import jakarta.faces.context.FacesContext;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.IOException;

/**
 * @author fvazquez Clase generada para crear funciones globales o comunes
 *         entre clases del proyecto.
 */
public class CommonUtils {
	/**
	 * Metodo que permite mostrar un mensaje al usuario.
	 * 
	 * @param severity {@link Severity} objeto que indica el tipo de mensaje a
	 *                 mostrar.
	 * @param summary  {@link String} titulo del mensaje.
	 * @param detail   {@link String} detalle del mensaje.
	 */
	public static void mostrarMensaje(Severity severity, String summary, String detail) {
		FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(severity, summary, detail));
	}

	/**
	 * Metodo que permite redireccionar entre pantallas del aplicativo.
	 * 
	 * @param url {@link String} direccion o pantalla a cambiar.
	 * @throws IOException {@link IOException} excepcion en caso de error al
	 *                     encontrar la pagina.
	 */
	public static void redireccionar(String url) throws IOException {
		ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
		String contextPath = externalContext.getRequestContextPath();
		externalContext.redirect(contextPath + url);
		//FacesContext.getCurrentInstance().getPartialViewContext().getRenderIds().add("form");
		//PrimeFaces.current().ajax().update("form");
	}

	public static final Object getPropertyValueViaReflection(Object o, String field)
			throws ReflectiveOperationException, IllegalArgumentException, IntrospectionException {
		return new PropertyDescriptor(field, o.getClass()).getReadMethod().invoke(o);
	}
}