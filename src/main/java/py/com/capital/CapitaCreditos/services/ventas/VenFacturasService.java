package py.com.capital.CapitaCreditos.services.ventas;

import py.com.capital.CapitaCreditos.entities.ventas.VenFacturaCabecera;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/*
* 4 ene. 2024 - Elitebook
*/
public interface VenFacturasService extends CommonService<VenFacturaCabecera>{

	Long calcularNroFacturaDisponible(Long idEmpresa, Long idTalonario);

	List<VenFacturaCabecera> buscarVenFacturaCabeceraActivosLista(Long idEmpresa);
	
}
