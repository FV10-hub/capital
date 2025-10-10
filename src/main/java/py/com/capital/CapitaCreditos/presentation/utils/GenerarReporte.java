package py.com.capital.CapitaCreditos.presentation.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;
import py.com.capital.CapitaCreditos.services.client.ReportesServiceClient;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

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

    @Autowired
    private ReportesServiceClient reportesServiceClient;

    @Value("${app.autoImpresion}")
    private boolean autoImpresion;

    public boolean procesarReporte(ParametrosReporte params) {
        if (autoImpresion) {
            impresionDirecta(params);
            return true;
        }
        descargarReporte(params);
        return true;
    }

    private void descargarReporte(ParametrosReporte params) {
        try {
            // Llama al servicio y obtén la respuesta con Spring RestTemplate
            ResponseEntity<Resource> response = this.reportesServiceClient.generarReporte(params);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                // Configura las cabeceras de la respuesta JSF
                ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
                //descomentar si hay error de que no termino la descarga externalContext.responseReset();

                String contentType = response.getHeaders().getContentType().toString();
                String contentDisposition = response.getHeaders()
                        .getFirst("Content-Disposition");

                externalContext.setResponseContentType(contentType);
                externalContext.setResponseHeader("Content-Disposition", contentDisposition);

                // Transfiere el stream del Resource
                InputStream inputStream = response.getBody().getInputStream();
                OutputStream outputStream = externalContext.getResponseOutputStream();

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }

                inputStream.close();
                outputStream.flush();
                outputStream.close();

                FacesContext.getCurrentInstance().responseComplete();
            } else {
                LOGGER.error("Error en la solicitud: " + response.getStatusCode());
                CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Error al generar el reporte");
            }
        } catch (IOException e) {
            LOGGER.error("Ocurrió un error al procesar el flujo de bytes", e);
            CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Error interno al descargar el reporte");
        }
    }

    private void impresionDirecta(ParametrosReporte params) {
        try {
            ResponseEntity<String> response = this.reportesServiceClient.impresionDirecta(params);

            if (response.getStatusCode().is2xxSuccessful()) {
                System.out.println(response.getBody());
            } else {
                System.out.println("No se impimio: "+response.getBody());
            }
        } catch (Exception e) {
            LOGGER.error("Ocurrio un error en la impresion directa ", e);
        }
    }


    public String openAndPrintReportWithJS(ParametrosReporte params) {
        return this.reportesServiceClient.openAndPrintReportWithJS(params);
    }

    public String downloadReportWithJS(ParametrosReporte params, String fileName) {
        return this.reportesServiceClient.downloadReportWithJS(params, fileName);
    }

}