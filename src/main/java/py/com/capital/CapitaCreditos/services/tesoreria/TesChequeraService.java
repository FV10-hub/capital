package py.com.capital.CapitaCreditos.services.tesoreria;

import py.com.capital.CapitaCreditos.entities.tesoreria.TesChequera;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface TesChequeraService extends CommonService<TesChequera> {

    /*
     * agregar aca los metodos personalizados
     * public Curso findCursoByAlumnoId(Long id);
     * */
    List<TesChequera> buscarTodosLista();

    List<TesChequera> buscarTesChequeraActivosLista(Long idEmpresa);

    public long asignarNumeroDesdeChequera(Long empresaId, Long bancoId);

    Optional<BigDecimal> sugerenciaProximo(Long empresaId, Long chequeraId);

    public boolean validarNumero(Long empresaId, Long chequeraId, long numero);

    Optional<TesChequera> findByBanco(Long empresaId, Long bancoId);


}
