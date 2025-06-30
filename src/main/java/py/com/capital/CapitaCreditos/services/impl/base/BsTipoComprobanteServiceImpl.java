package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsTipoComprobante;
import py.com.capital.CapitaCreditos.repositories.base.BsTipoComprobanteValorRepository;
import py.com.capital.CapitaCreditos.services.base.BsTipoComprobanteService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

@Service
public class BsTipoComprobanteServiceImpl 
extends CommonServiceImpl<BsTipoComprobante, BsTipoComprobanteValorRepository> implements BsTipoComprobanteService   {

	private final BsTipoComprobanteValorRepository repository;

	public BsTipoComprobanteServiceImpl(BsTipoComprobanteValorRepository repository) {
		super(repository);
		this.repository = repository;
	}

	@Override
	public List<BsTipoComprobante> buscarBsTipoComprobanteActivosLista(Long idEmpresa) {
		return repository.buscarBsTipoComprobanteActivosLista(idEmpresa);
	}

}
