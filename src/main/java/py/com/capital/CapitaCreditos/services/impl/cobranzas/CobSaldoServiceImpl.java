package py.com.capital.CapitaCreditos.services.impl.cobranzas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobSaldo;
import py.com.capital.CapitaCreditos.repositories.cobranzas.CobSaldoRepository;
import py.com.capital.CapitaCreditos.services.cobranzas.CobSaldoService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.math.BigDecimal;
import java.util.List;

/*
* 12 ene. 2024 - Elitebook
*/
@Service
public class CobSaldoServiceImpl extends CommonServiceImpl<CobSaldo, CobSaldoRepository> implements CobSaldoService {

	private final CobSaldoRepository repository;

	public CobSaldoServiceImpl(CobSaldoRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public BigDecimal calcularTotalSaldoAFecha(Long idEmpresa, Long idCliente) {
		return this.repository.calcularTotalSaldoAFecha(idEmpresa, idCliente);
	}

	@Override
	public List<CobSaldo> buscarCobSaldoActivosLista(Long idEmpresa) {
		return this.repository.buscarCobSaldoActivosLista(idEmpresa);
	}

	@Override
	public List<CobSaldo> buscarSaldoPorClienteLista(Long idEmpresa, Long idCliente) {
		return this.repository.buscarSaldoPorClienteLista(idEmpresa, idCliente);
	}

	@Override
	public List<CobSaldo> buscarSaldoPorClienteMayorACeroLista(Long idEmpresa, Long idCliente) {
		return this.repository.buscarSaldoPorClienteMayorACeroLista(idEmpresa, idCliente);
	}

	@Override
	public List<CobSaldo> buscarSaldoPorIdComprobantePorTipoComprobantePorCliente(Long idEmpresa, Long idCliente, Long idComprobante, String tipoComprobante) {
		return this.repository.buscarSaldoPorIdComprobantePorTipoComprobantePorCliente(idEmpresa,idCliente,idComprobante,tipoComprobante);
	}

}
