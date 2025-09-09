package py.com.capital.CapitaCreditos.services.compras;

import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.compras.ComSaldo;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.util.List;

/*
 * 12 ene. 2024 - Elitebook
 */
public interface ComSaldoService extends CommonService<ComSaldo> {

    BigDecimal calcularTotalSaldoAFecha(Long idEmpresa, Long idCliente);

    List<ComSaldo> buscarComSaldoActivosLista(Long idEmpresa);

    List<ComSaldo> buscarSaldoPorProveedorLista(Long idEmpresa, Long idProveedor);

    List<ComSaldo> buscarSaldoPorProveedorMayorACeroLista(Long idEmpresa, Long idProveedor);

    List<ComSaldo> buscarSaldosFiltrados(
            Long empresaId,
            Long proveedorId,
            String tipo
    );

    int pagarSaldosPorIds(Long empresaId,
                          Long proveedorId,
                          List<Long> idsSaldo,
                          String usuario,
                          BigDecimal montoPagado);

    int reestablecerSaldosPorIds(Long empresaId,
                          Long proveedorId,
                          List<Long> idsSaldo,
                          String usuario,
                          BigDecimal monto);

}
