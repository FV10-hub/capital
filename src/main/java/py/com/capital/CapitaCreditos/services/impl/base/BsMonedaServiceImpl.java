package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.repositories.base.BsIvaRepository;
import py.com.capital.CapitaCreditos.repositories.base.BsMonedaRepository;
import py.com.capital.CapitaCreditos.services.base.BsMonedaService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

@Service
public class BsMonedaServiceImpl 
extends CommonServiceImpl<BsMoneda, BsMonedaRepository> implements BsMonedaService   {

    private final BsMonedaRepository repository;

    public BsMonedaServiceImpl(BsMonedaRepository repository) {
        super(repository);
        this.repository = repository;
    }

}
