package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.repositories.base.BsUsuarioRepository;
import py.com.capital.CapitaCreditos.services.base.BsUsuarioService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

@Service
public class BsUsuarioServiceImpl 
extends CommonServiceImpl<BsUsuario, BsUsuarioRepository> implements BsUsuarioService   {

    private final BsUsuarioRepository repository;

    public BsUsuarioServiceImpl(BsUsuarioRepository repository) {
        super(repository);
        this.repository = repository;
    }

}
