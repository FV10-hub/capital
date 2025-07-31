package py.com.capital.CapitaCreditos.services.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDebitoCreditoBancario;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface TesDebitoCreditoBancarioService extends CommonService<TesDebitoCreditoBancario> {

	Page<TesDebitoCreditoBancario> buscarTodos(Pageable pageable);

	List<TesDebitoCreditoBancario> buscarTodosLista();

	List<TesDebitoCreditoBancario> buscarTesDebitoCreditoBancarioActivosLista(Long idEmpresa);

}
