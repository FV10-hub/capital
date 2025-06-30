package py.com.capital.CapitaCreditos.services.client;

import py.com.capital.CapitaCreditos.entities.ParametrosReporte;

import jakarta.ws.rs.core.Response;

/*
* 14 dic. 2023 - Elitebook
*/
public interface ReportesServiceClient {
	Response generarReporte(ParametrosReporte params);
}
