package py.com.capital.CapitaCreditos.services.impl.cobranzas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.repositories.base.BsUsuarioRepository;
import py.com.capital.CapitaCreditos.repositories.cobranzas.CobHabilitacionCajaRepository;
import py.com.capital.CapitaCreditos.services.cobranzas.CobHabilitacionCajaService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.math.BigDecimal;
import java.util.List;

/*
* 28 dic. 2023 - Elitebook
*/
@Service
public class CobHabilitacionCajaServiceImpl extends CommonServiceImpl<CobHabilitacionCaja, CobHabilitacionCajaRepository> implements CobHabilitacionCajaService {

	private final CobHabilitacionCajaRepository repository;

	public CobHabilitacionCajaServiceImpl(CobHabilitacionCajaRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public BigDecimal calcularNroHabilitacionDisponible() {
		return this.repository.calcularNroHabilitacionDisponible();
	}

	@Override
	public List<CobHabilitacionCaja> buscarCobHabilitacionCajaActivosLista(Long idEmpresa) {
		return this.repository.buscarCobHabilitacionCajaActivosLista(idEmpresa);
	}

	@Override
	public String validaHabilitacionAbierta(Long idUsuario, Long idCaja) {
		return this.repository.validaHabilitacionAbierta(idUsuario, idCaja);
	}

	@Override
	public CobHabilitacionCaja retornarHabilitacionAbierta(Long idEmpresa, Long idUsuario, Long idCaja) {
		return this.repository.retornarHabilitacionAbierta(idEmpresa, idUsuario, idCaja);
	}

	

}
