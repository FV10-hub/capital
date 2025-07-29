package py.com.capital.CapitaCreditos.services.compras;

import py.com.capital.CapitaCreditos.entities.cobranzas.CobSaldo;
import py.com.capital.CapitaCreditos.entities.compras.ComSaldo;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.util.List;

/*
* 12 ene. 2024 - Elitebook
*/
public interface ComSaldoService extends CommonService<ComSaldo>{
	
	BigDecimal calcularTotalSaldoAFecha(Long idEmpresa, Long idCliente);

	List<ComSaldo> buscarComSaldoActivosLista(Long idEmpresa);

	List<ComSaldo> buscarSaldoPorProveedorLista(Long idEmpresa, Long idProveedor);

	List<ComSaldo> buscarSaldoPorProveedorMayorACeroLista(Long idEmpresa, Long idProveedor);

}
