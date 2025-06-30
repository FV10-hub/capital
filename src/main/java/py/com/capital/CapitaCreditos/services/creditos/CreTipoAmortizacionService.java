package py.com.capital.CapitaCreditos.services.creditos;

import py.com.capital.CapitaCreditos.entities.creditos.CreTipoAmortizacion;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/*
* 26 dic. 2023 - Elitebook
*/
public interface CreTipoAmortizacionService extends CommonService<CreTipoAmortizacion>{
	List<CreTipoAmortizacion> buscarCreTipoAmortizacionActivosLista();
}
