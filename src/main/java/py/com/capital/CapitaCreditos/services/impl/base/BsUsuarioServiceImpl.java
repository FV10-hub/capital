package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.repositories.base.BsUsuarioRepository;
import py.com.capital.CapitaCreditos.services.base.BsUsuarioService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

@Service
public class BsUsuarioServiceImpl 
extends CommonServiceImpl<BsUsuario, BsUsuarioRepository> implements BsUsuarioService   {

    private final BsUsuarioRepository repository;
    private final PasswordEncoder encoder;

    public BsUsuarioServiceImpl(BsUsuarioRepository repository, PasswordEncoder encoder) {
        super(repository);
        this.repository = repository;
        this.encoder = encoder;
    }


    @Override
    public BsUsuario guardarConEncriptacionDePassword(BsUsuario usuario) {
        String passPlano = usuario.getPassword();
        usuario.setPassword(encoder.encode(passPlano));
        return repository.save(usuario);
    }
}
