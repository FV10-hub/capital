package py.com.capital.CapitaCreditos.services.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.dtos.ValorConciliacionDto;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesConciliacionValor;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.time.LocalDate;
import java.util.List;

public interface TesConciliacionValorService extends CommonService<TesConciliacionValor> {

    Page<TesConciliacionValor> buscarTodos(Pageable pageable);

    List<TesConciliacionValor> buscarTodosLista();

    List<TesConciliacionValor> buscarTesConciliacionValorActivosLista(Long idEmpresa);

    List<TesConciliacionValor> buscarTesConciliacionValorPorEstado(Long idEmpresa, String estado);

    List<TesConciliacionValor> buscarTesConciliacionValorPorIds(Long idEmpresa, List<Long> ids);

    List<TesConciliacionValor> buscarTesConciliacionPagosValorPorIds(Long idEmpresa, List<Long> ids);

    List<ValorConciliacionDto> buscarValoresConciliacion(Long empresaId,
                                                         LocalDate desde,
                                                         LocalDate hasta,
                                                         String conciliado,
                                                         Long personaJuridicaId);

}
