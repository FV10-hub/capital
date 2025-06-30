package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsRol;
import py.com.capital.CapitaCreditos.repositories.base.BsRolRepository;
import py.com.capital.CapitaCreditos.services.base.BsRolService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

@Service
public class BsRolServiceImpl extends CommonServiceImpl<BsRol, BsRolRepository> implements BsRolService  {


    private final BsRolRepository repository;

    public BsRolServiceImpl(BsRolRepository repository) {
        super(repository);
        this.repository = repository;
    }

}
