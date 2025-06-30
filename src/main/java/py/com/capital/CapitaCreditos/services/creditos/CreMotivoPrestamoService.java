package py.com.capital.CapitaCreditos.services.creditos;

import py.com.capital.CapitaCreditos.entities.creditos.CreMotivoPrestamo;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

/*
* 26 dic. 2023 - Elitebook
*/
public interface CreMotivoPrestamoService extends CommonService<CreMotivoPrestamo> {
	List<CreMotivoPrestamo> buscarCreMotivoPrestamoActivosLista();
}
