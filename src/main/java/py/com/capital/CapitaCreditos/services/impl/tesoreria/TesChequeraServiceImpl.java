package py.com.capital.CapitaCreditos.services.impl.tesoreria;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesChequera;
import py.com.capital.CapitaCreditos.repositories.tesoreria.TesChequeraRepository;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;
import py.com.capital.CapitaCreditos.services.tesoreria.TesChequeraService;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class TesChequeraServiceImpl extends CommonServiceImpl<TesChequera, TesChequeraRepository> implements TesChequeraService {

    private final TesChequeraRepository repository;

    public TesChequeraServiceImpl(TesChequeraRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<TesChequera> buscarTodosLista() {
        return this.repository.buscarTodosLista();
    }

    @Override
    public List<TesChequera> buscarTesChequeraActivosLista(Long idEmpresa) {
        return this.repository.buscarTesChequeraActivosLista(idEmpresa);
    }

    @Override
    @Transactional
    public Optional<BigDecimal> sugerenciaProximo(Long empresaId, Long chequeraId) {
        return this.repository.sugerenciaProximo(empresaId, chequeraId);
    }

    @Override
    @Transactional
    public long asignarNumeroDesdeChequera(Long empresaId, Long bancoId) {
        TesChequera chequera = this.repository.findByBancoForUpdate(empresaId, bancoId)
                .orElseThrow(() -> new IllegalStateException("Chequera no encontrado"));

        // Validar vigencia de fechas
        LocalDate hoy = LocalDate.now();
        if (chequera.getFechaVigenciaDesde() != null && hoy.isBefore(chequera.getFechaVigenciaDesde())) {
            throw new IllegalStateException("Chequera aún no vigente");
        }
        if (chequera.getFechaVigenciaHasta() != null && hoy.isAfter(chequera.getFechaVigenciaHasta())) {
            throw new IllegalStateException("Chequera vencido");
        }

        // Tomar next y validar rango
        long desde = chequera.getNroDesde();
        long hasta = chequera.getNroHasta();

        long next = chequera.getProximoNumero() == null
                ? desde
                : chequera.getProximoNumero().longValueExact();

        if (next < desde) next = desde;
        if (next > hasta) throw new IllegalStateException("Chequera agotada");

        long asignado = next;
        // suma el valor y hace el commit
        chequera.setProximoNumero(BigInteger.valueOf(next + 1));
        chequera.setFechaActualizacion(LocalDateTime.now());

        return asignado;

    }

    @Override
    @Transactional
    public boolean validarNumero(Long empresaId, Long chequeraId, long numero) {
        TesChequera chequera = this.repository.findByIdAndEmpresa(empresaId, chequeraId)
                .orElseThrow(() -> new IllegalStateException("Chequera no encontrado"));

        long desde = chequera.getNroDesde();
        long hasta = chequera.getNroHasta();

        if (numero < desde || numero > hasta) {
            //throw new IllegalArgumentException("Número fuera de rango (" + desde + "–" + hasta + ")");
            return false;
        }
        return true;
    }

    @Override
    public Optional<TesChequera> findByBanco(Long empresaId, Long bancoId) {
        return this.repository.findByBanco(empresaId, bancoId);
    }

}
