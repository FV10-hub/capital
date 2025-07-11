package py.com.capital.CapitaCreditos.presentation.utils;

import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.primefaces.model.DefaultStreamedContent;
import org.primefaces.model.StreamedContent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.services.client.ReportesServiceClient;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/*
* 15 dic. 2023 - Elitebook
*/
@Component
public class GenerarReporte {
	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(GenerarReporte.class);

	//@Autowired
	private ReportesServiceClient reportesServiceClientImpl;

	public void descargarReporte(ParametrosReporte params) {
		/*
		 * params.setCodModulo("BASE"); params.setFormato("PDF");
		 * params.setReporte("StoArticulos"); params.setParametros(new
		 * ArrayList<String>()); params.setValores(new ArrayList<Object>());
		 */

		// Llama al servicio y obtén la respuesta
		Response response = this.reportesServiceClientImpl.generarReporte(params);

		if (response.getStatus() == 200) {

			configureResponseForDownload(response);

			// Obtiene el contexto externo de JSF
			ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();

			// Obtiene el flujo de entrada del cuerpo de la respuesta
			InputStream inputStream = (InputStream) response.getEntity();

			// Obtener el valor del encabezado Content-Type
			String contentType = response.getHeaderString("Content-Type");
			System.out.println("Content-Type: " + contentType);

			// Obtener el valor del encabezado Content-Disposition
			String contentDisposition = response.getHeaderString("Content-Disposition");
			System.out.println("Content-Disposition: " + contentDisposition);

			// Configura las cabeceras de la respuesta JSF para la descarga
			externalContext.responseReset();
			externalContext.setResponseContentType(contentType);
			externalContext.setResponseContentLength(response.getLength());
			externalContext.setResponseHeader("Content-Disposition", contentDisposition);

			// Obtén el flujo de salida de la respuesta
			OutputStream outputStream;
			try {
				outputStream = externalContext.getResponseOutputStream();
				byte[] buffer = new byte[1024];
				int length;
				while ((length = inputStream.read(buffer)) > 0) {
					outputStream.write(buffer, 0, length);
				}

				inputStream.close();
				outputStream.flush();
				outputStream.close();
				FacesContext.getCurrentInstance().responseComplete();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				LOGGER.error("Ocurrio un error al procesar el flujo de bytes", e.getMessage());
			}

			// Copia los bytes del flujo de entrada al flujo de salida

			FacesContext.getCurrentInstance().responseComplete();
		} else {
			System.out.println("LA RESPUESTA FUE::::::: " + response);
			System.out.println("Error en la solicitud: " + response.getStatus());
			LOGGER.error("Error en la solicitud: " + response.getStatus());
		}
	}

	private void configureResponseForDownload(Response response) {
		// Configura la respuesta del servicio para la descarga
		FacesContext facesContext = FacesContext.getCurrentInstance();
		HttpServletResponse servletResponse = (HttpServletResponse) facesContext.getExternalContext().getResponse();

		// Obtiene los encabezados de la respuesta del servicio
		MultivaluedMap<String, Object> headers = response.getHeaders();

		// Configura los encabezados de la respuesta del servicio en la respuesta del
		// servlet
		for (Map.Entry<String, List<Object>> entry : headers.entrySet()) {
			String headerName = entry.getKey();
			List<Object> headerValues = entry.getValue();
			for (Object headerValue : headerValues) {
				servletResponse.addHeader(headerName, headerValue.toString());
			}
		}

		// Establece el código de estado de la respuesta del servicio en la respuesta
		// del servlet
		servletResponse.setStatus(response.getStatus());
	}

	public StreamedContent getFileToDownload(ParametrosReporte params) {

		Response response = this.reportesServiceClientImpl.generarReporte(params);
		if (response.getStatus() == 200) {
			configureResponseForDownload(response);
			// Obtiene el contexto externo de JSF
			ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();

			// Lógica para generar el archivo y obtener el InputStream
			InputStream inputStream = (InputStream) response.getEntity();

			// Obtener el valor del encabezado Content-Type
			String contentType = response.getHeaderString("Content-Type");

			// Obtener el valor del encabezado Content-Disposition
			String contentDisposition = response.getHeaderString("Content-Disposition");
			String filename = extractFilename(contentDisposition);

			// Configura el StreamedContent
			return DefaultStreamedContent
					.builder()
					.name(filename)
					.contentType(contentType)
					.stream(() -> inputStream).build();

		}
		return null;

	}
	
	private static String extractFilename(String contentDisposition) {
        Pattern pattern = Pattern.compile("filename=\"(.*?)\"");
        Matcher matcher = pattern.matcher(contentDisposition);

        if (matcher.find()) {
            return matcher.group(1);
        }

        return null; 
    }

}