package py.com.capital.CapitaCreditos.services.tesoreria;

import py.com.capital.CapitaCreditos.entities.tesoreria.TesBanco;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.util.List;

public interface TesBancoService extends CommonService<TesBanco> {

    /*
     * agregar aca los metodos personalizados
     * public Curso findCursoByAlumnoId(Long id);
     * */
    List<TesBanco> buscarTesBancoActivosLista(Long idEmpresa);

    List<TesBanco> buscarTesBancoActivosPorMonedaLista(Long idMoneda);

    boolean tieneSaldoSuficiente(Long empresaId,
                                 Long bancoId,
                                 BigDecimal monto);
}
