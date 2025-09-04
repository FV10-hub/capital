package py.com.capital.CapitaCreditos.services.client;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import py.com.capital.CapitaCreditos.entities.ParametrosReporte;

import javax.ws.rs.core.Response;

/*
* 14 dic. 2023 - Elitebook
*/
public interface ReportesServiceClient {
	ResponseEntity<Resource> generarReporte(ParametrosReporte params);
}
