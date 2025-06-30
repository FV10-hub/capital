package py.com.capital.CapitaCreditos.services.cobranzas;

import py.com.capital.CapitaCreditos.entities.cobranzas.CobReciboCabecera;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/*
* 15 ene. 2024 - Elitebook
*/
public interface CobRecibosService extends CommonService<CobReciboCabecera>{
	
	Long calcularNroReciboDisponible(Long idEmpresa, Long idTalonario);

	List<CobReciboCabecera> buscarCobReciboCabeceraActivosLista(Long idEmpresa);
	
	List<CobReciboCabecera> buscarCobReciboCabeceraPorClienteLista(Long idEmpresa, Long idCliente);
	
	List<CobReciboCabecera> buscarCobReciboCabeceraPorCobradorLista(Long idEmpresa, Long idCobrador);
	
	List<CobReciboCabecera> buscarCobReciboCabeceraPorNroReciboLista(Long idEmpresa, Long idTalonario, Long nroRecibo);

}
