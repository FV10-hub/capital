package py.com.capital.CapitaCreditos.services.creditos;

import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.creditos.CreDesembolsoCabecera;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.util.List;

/*
* 4 ene. 2024 - Elitebook
*/
public interface CreDesembolsoService extends CommonService<CreDesembolsoCabecera>{

	BigDecimal calcularNroDesembolsoDisponible(Long idEmpresa);
	
	List<CreDesembolsoCabecera> buscarCreDesembolsoCabeceraActivosLista(Long idEmpresa);
	
	List<CreDesembolsoCabecera> buscarCreDesembolsoAFacturarLista(Long idEmpresa);
	
	List<CreDesembolsoCabecera> buscarCreDesembolsoParaPagosTesoreriarLista(Long idEmpresa, Long idCliente);

	int marcarContratoImpresa(Long empresaId, Long desembolsoId);

	int marcarPagareImpresa(Long empresaId, Long desembolsoId);
	
}
