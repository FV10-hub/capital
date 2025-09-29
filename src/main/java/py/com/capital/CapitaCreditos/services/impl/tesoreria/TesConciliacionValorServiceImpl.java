package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.dtos.ValorConciliacionDto;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesConciliacionValor;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesConciliacionValorRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesConciliacionValorService;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Stream;

/*
 * 18 ene. 2024 - Elitebook
 */
@Service
public class TesConciliacionValorServiceImpl extends CommonServiceImpl<TesConciliacionValor, TesConciliacionValorRepository>
        implements TesConciliacionValorService {

    private final TesConciliacionValorRepository repository;

    public TesConciliacionValorServiceImpl(TesConciliacionValorRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public Page<TesConciliacionValor> buscarTodos(Pageable pageable) {
        return this.repository.buscarTodos(pageable);
    }

    @Override
    public List<TesConciliacionValor> buscarTodosLista() {
        return this.repository.buscarTodosLista();
    }

    @Override
    public List<TesConciliacionValor> buscarTesConciliacionValorActivosLista(Long idEmpresa) {
        return this.repository.buscarTesConciliacionValorActivosLista(idEmpresa);
    }

    @Override
    public List<TesConciliacionValor> buscarTesConciliacionValorPorEstado(Long idEmpresa, String estado) {
        return this.repository.buscarTesConciliacionValorPorEstado(idEmpresa, estado);
    }

    @Override
    public List<TesConciliacionValor> buscarTesConciliacionValorPorIds(Long idEmpresa, List<Long> ids) {
        return this.repository.buscarTesConciliacionValorPorIds(idEmpresa, ids);
    }

    @Override
    public List<TesConciliacionValor> buscarTesConciliacionPagosValorPorIds(Long idEmpresa, List<Long> ids) {
        return this.repository.buscarTesConciliacionPagosValorPorIds(idEmpresa, ids);
    }

    @Override
    public List<ValorConciliacionDto> buscarValoresConciliacion(Long empresaId, LocalDate desde, LocalDate hasta,
                                                                String conciliado,
                                                                Long personaJuridicaId) {
        List<ValorConciliacionDto> cobros = repository.buscarCobrosParaConciliacion(empresaId, desde, hasta,
                conciliado,
                personaJuridicaId);
        List<ValorConciliacionDto> pagos = repository.buscarPagosParaConciliacion(empresaId, desde, hasta,
                conciliado,
                personaJuridicaId);

        return Stream.concat(cobros.stream(), pagos.stream())
                .sorted(Comparator.comparing(ValorConciliacionDto::getFechaValor))
                .toList();
    }


}
