package py.com.capital.CapitaCreditos.services.cobranzas;

import py.com.capital.CapitaCreditos.entities.cobranzas.CobSaldo;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.util.List;

/*
* 12 ene. 2024 - Elitebook
*/
public interface CobSaldoService extends CommonService<CobSaldo>{
	
	BigDecimal calcularTotalSaldoAFecha(Long idEmpresa, Long idCliente);
	
	List<CobSaldo> buscarCobSaldoActivosLista(Long idEmpresa);
	
	List<CobSaldo> buscarSaldoPorClienteLista(Long idEmpresa, Long idCliente);
	
	List<CobSaldo> buscarSaldoPorClienteMayorACeroLista(Long idEmpresa, Long idCliente);

}
