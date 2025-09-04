package py.com.capital.CapitaCreditos.services.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;

import java.util.Collections;


/*
 * 13 dic. 2023 - Elitebook
 */
@Service
public class ReportesServiceClientImpl implements ReportesServiceClient {

    @Value("${app.base.url.ws.reportes}")
    String urlReportesWS;

    private final RestTemplate restTemplate;

    public ReportesServiceClientImpl(RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.build();
    }

    @Override
        public ResponseEntity<Resource> generarReporte(ParametrosReporte params) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(org.springframework.http.MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_OCTET_STREAM));

        HttpEntity<ParametrosReporte> request = new HttpEntity<>(params, headers);

        return restTemplate.exchange(
                urlReportesWS,
                HttpMethod.POST,
                request,
                Resource.class
        );
    }


    /*
     * public static void main(String[] args) { // Ejemplo de uso
     * ReportesJerseyClient jerseyClient = new
     * ReportesJerseyClient("http://localhost:8080/api"); // Cambia la URL según tu
     * configuración Map<String, Object> parameters = new HashMap<>();
     * parameters.put("param1", "value1"); parameters.put("param2", "value2");
     *
     * Response response = jerseyClient.generarReporte("reportName", parameters);
     *
     * // Aquí puedes manejar la respuesta según tus necesidades if
     * (response.getStatus() == Response.Status.OK.getStatusCode()) { // Procesar la
     * respuesta exitosa System.out.println("Éxito: " +
     * response.readEntity(String.class)); } else { // Manejar errores
     * System.out.println("Error: " + response.readEntity(String.class)); }
     *
     * // Importante cerrar el cliente al final jerseyClient.close(); }
     */

}
