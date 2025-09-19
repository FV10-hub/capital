package py.com.capital.CapitaCreditos.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.dtos.SqlUpdateBuilder;
import py.com.capital.CapitaCreditos.repositories.base.UtilsRepository;

/*
 * 25 ene. 2024 - Elitebook
 */
@Service
public class UtilsService {

    private final UtilsRepository repository;

    @Autowired
    public UtilsService(UtilsRepository repository) {
        this.repository = repository;
    }

    public boolean actualizarRegistro(String nombreTabla, String camposValores, String condicionWhere) {
        return repository.updateRecord(nombreTabla, camposValores, condicionWhere);
    }

    public boolean updateDinamico(SqlUpdateBuilder sqlUpdateBuilder) {
        return this.repository.updateDinamico(sqlUpdateBuilder);
    }

}
