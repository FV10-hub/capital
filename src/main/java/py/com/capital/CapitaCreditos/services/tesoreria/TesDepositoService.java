package py.com.capital.CapitaCreditos.services.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDeposito;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface TesDepositoService extends CommonService<TesDeposito> {

	Page<TesDeposito> buscarTodos(Pageable pageable);

	List<TesDeposito> buscarTodosLista();

	List<TesDeposito> buscarTesDepositoActivosLista(Long idEmpresa);

}
