package py.com.capital.CapitaCreditos.services.stock;

import py.com.capital.CapitaCreditos.entities.stock.StoAjusteInventarioCabecera;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface StoAjusteInventarioCabeceraService extends CommonService<StoAjusteInventarioCabecera> {

	List<StoAjusteInventarioCabecera> buscarTodosLista();

	Long calcularNroOperacionDisponible(Long idEmpresa);

	List<StoAjusteInventarioCabecera> buscarStoAjusteInventarioCabeceraActivosLista(Long idEmpresa);

}
