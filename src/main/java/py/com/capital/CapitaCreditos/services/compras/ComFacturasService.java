package py.com.capital.CapitaCreditos.services.compras;

import py.com.capital.CapitaCreditos.entities.compras.ComFacturaCabecera;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/*
* 4 ene. 2024 - Elitebook
*/
public interface ComFacturasService extends CommonService<ComFacturaCabecera>{

	Long calcularNroFacturaDisponible(Long idEmpresa, Long idTalonario);

	List<ComFacturaCabecera> buscarComFacturaCabeceraActivosLista(Long idEmpresa);
	
}
