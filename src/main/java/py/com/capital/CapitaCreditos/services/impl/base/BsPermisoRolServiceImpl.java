package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsPermisoRol;
import py.com.capital.CapitaCreditos.repositories.base.BsPermisoRolRepository;
import py.com.capital.CapitaCreditos.services.base.BsPermisoRolService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import java.util.List;

@Service
public class BsPermisoRolServiceImpl extends CommonServiceImpl<BsPermisoRol, BsPermisoRolRepository> implements BsPermisoRolService {


    private final BsPermisoRolRepository repository;

    public BsPermisoRolServiceImpl(BsPermisoRolRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public Page<BsPermisoRol> listarTodos(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public List<BsPermisoRol> buscarTodosLista() {
        return repository.buscarTodosLista();
    }

    @Override
    public List<BsPermisoRol> buscarPorRol(Long rolId) {
        return this.repository.buscarPorRol(rolId);
    }

}
