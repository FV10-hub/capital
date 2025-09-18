package py.com.capital.CapitaCreditos.services.impl.compras;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.compras.ComSaldo;
import py.com.capital.CapitaCreditos.repositories.compras.ComSaldoRepository;
import py.com.capital.CapitaCreditos.services.compras.ComSaldoService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.util.List;

/*
 * 12 ene. 2024 - Elitebook
 */
@Service
public class ComSaldoServiceImpl extends CommonServiceImpl<ComSaldo, ComSaldoRepository> implements ComSaldoService {

    private final ComSaldoRepository repository;

    public ComSaldoServiceImpl(ComSaldoRepository repository) {
        super(repository);
        this.repository = repository;
    }


    @Override
    public BigDecimal calcularTotalSaldoAFecha(Long idEmpresa, Long idCliente) {
        return BigDecimal.ONE;
    }

    @Override
    public List<ComSaldo> buscarComSaldoActivosLista(Long idEmpresa) {
        return this.repository.buscarComSaldoActivosLista(idEmpresa);
    }

    @Override
    public List<ComSaldo> buscarSaldoPorProveedorLista(Long idEmpresa, Long idProveedor) {
        return this.repository.buscarSaldoPorProveedorLista(idEmpresa, idProveedor);
    }

    @Override
    public List<ComSaldo> buscarSaldoPorProveedorMayorACeroLista(Long idEmpresa, Long idProveedor) {
        return this.repository.buscarSaldoPorProveedorMayorACeroLista(idEmpresa, idProveedor);
    }

    @Override
    public List<ComSaldo> buscarSaldosFiltrados(Long empresaId, Long proveedorId, String tipo) {
        return this.repository.buscarSaldosFiltrados(empresaId, proveedorId, tipo);
    }

    @Override
    @Transactional
    public int pagarSaldosPorIds(Long empresaId, Long proveedorId, List<Long> idsSaldo, String usuario, BigDecimal montoPagado) {
        return this.repository.pagarSaldosPorIds(empresaId, proveedorId, idsSaldo, usuario, montoPagado);
    }

    @Override
    @Transactional
    public int reestablecerSaldosPorIds(Long empresaId, Long proveedorId, List<Long> idsSaldo, String usuario, BigDecimal monto) {
        return this.repository.reestablecerSaldosPorIds(empresaId, proveedorId, idsSaldo, usuario, monto);
    }
}
