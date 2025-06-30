/**
 * 
 */
package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.repositories.base.BsEmpresaRepository;
import py.com.capital.CapitaCreditos.services.base.BsEmpresaService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

/**
 * 
 */
@Service
public class BsEmpresaServiceImpl 
extends CommonServiceImpl<BsEmpresa, BsEmpresaRepository> implements BsEmpresaService {

    private final BsEmpresaRepository repository;

    public BsEmpresaServiceImpl(BsEmpresaRepository repository) {
        super(repository);
        this.repository = repository;
    }
}
