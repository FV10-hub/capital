package py.com.capital.CapitaCreditos.services.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobArqueosCajas;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface CobArqueosCajaService extends CommonService<CobArqueosCajas> {
    Page<CobArqueosCajas> buscarTodos(Pageable pageable);

    List<CobArqueosCajas> buscarTodosLista();

    List<CobArqueosCajas> buscarCobArqueosCajasActivosLista(Long idEmpresa, Long idHabilitacion);
}
