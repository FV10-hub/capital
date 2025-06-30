package py.com.capital.CapitaCreditos.services.impl.cobranzas;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCaja;
import py.com.capital.CapitaCreditos.repositories.cobranzas.CobCajaRepository;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCajaService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

/*
* 28 dic. 2023 - Elitebook
*/
@Service
public class CobCajaServiceImpl extends CommonServiceImpl<CobCaja,CobCajaRepository> implements CobCajaService{

	private final CobCajaRepository repository;

	public CobCajaServiceImpl(CobCajaRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<CobCaja> buscarTodosActivoLista() {
		return this.repository.buscarTodosActivoLista();
	}

	@Override
	public CobCaja usuarioTieneCaja(Long idUsuario) {
		return this.repository.usuarioTieneCaja(idUsuario);
	}

}
