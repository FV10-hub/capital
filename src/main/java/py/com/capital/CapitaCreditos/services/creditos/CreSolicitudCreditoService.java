package py.com.capital.CapitaCreditos.services.creditos;

import py.com.capital.CapitaCreditos.entities.creditos.CreSolicitudCredito;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/*
* 26 dic. 2023 - Elitebook
*/
public interface CreSolicitudCreditoService  extends CommonService<CreSolicitudCredito>{
	List<CreSolicitudCredito> buscarSolicitudActivosLista(Long idEmpresa);
	List<CreSolicitudCredito> buscarSolicitudAutorizadosLista(Long idEmpresa);
}
