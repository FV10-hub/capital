package py.com.capital.CapitaCreditos.services.impl.base;

import org.springframework.stereotype.Service;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.entities.base.BsTimbrado;
import py.com.capital.CapitaCreditos.repositories.base.BsTalonarioRepository;
import py.com.capital.CapitaCreditos.services.base.BsTalonarioService;
import py.com.capital.CapitaCreditos.services.impl.CommonServiceImpl;

import javax.transaction.Transactional;
import java.math.BigInteger;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/*
 * 2 ene. 2024 - Elitebook
 */
@Service
public class BsTalonarioServiceImpl
        extends CommonServiceImpl<BsTalonario, BsTalonarioRepository> implements BsTalonarioService {


    private final BsTalonarioRepository repository;

    public BsTalonarioServiceImpl(BsTalonarioRepository repository) {
        super(repository);
        this.repository = repository;
    }

    @Override
    public List<BsTalonario> buscarBsTalonarioActivosLista(Long idEmpresa) {
        return this.repository.buscarBsTalonarioActivosLista(idEmpresa);
    }

    @Override
    public List<BsTalonario> buscarBsTalonarioPorModuloLista(Long idEmpresa, Long idModulo) {
        return this.repository.buscarBsTalonarioPorModuloLista(idEmpresa, idModulo);
    }

    @Override
    @Transactional
    public long asignarNumeroDesdeTalonario(Long empresaId, Long talonarioId, String usuario) {
        BsTalonario tal = this.repository.findForUpdate(talonarioId, empresaId)
                .orElseThrow(() -> new IllegalStateException("Talonario no encontrado"));

        BsTimbrado tim = tal.getBsTimbrado();

        // Validar vigencia de fechas
        LocalDate hoy = LocalDate.now();
        if (tim.getFechaVigenciaDesde() != null && hoy.isBefore(tim.getFechaVigenciaDesde())) {
            throw new IllegalStateException("Timbrado aún no vigente");
        }
        if (tim.getFechaVigenciaHasta() != null && hoy.isAfter(tim.getFechaVigenciaHasta())) {
            throw new IllegalStateException("Timbrado vencido");
        }

        // Tomar next y validar rango
        long desde = tim.getNroDesde().longValueExact();
        long hasta = tim.getNroHasta().longValueExact();

        long next = tal.getProximoNumero() == null
                ? desde
                : tal.getProximoNumero().longValueExact();

        if (next < desde) next = desde;
        if (next > hasta) throw new IllegalStateException("Talonario agotado");

        long asignado = next;
        // suma el valor y hace el commit
        // uso el talonario
        tal.setProximoNumero(BigInteger.valueOf(next + 1));
        tal.setUsuarioModificacion(usuario);
        tal.setFechaActualizacion(LocalDateTime.now());

        // Commit persiste el avance; si hay rollback, no se consume número
        return asignado;

    }

    @Override
    @Transactional
    public boolean validarNumero(Long empresaId, Long talonarioId, long numero) {
        BsTalonario tal = this.repository.findForUpdate(talonarioId, empresaId)
                .orElseThrow(() -> new IllegalStateException("Talonario no encontrado"));
        BsTimbrado tim = tal.getBsTimbrado();

        long desde = tim.getNroDesde().longValueExact();
        long hasta = tim.getNroHasta().longValueExact();

        if (numero < desde || numero > hasta) {
            //throw new IllegalArgumentException("Número fuera de rango (" + desde + "–" + hasta + ")");
            return false;
        }
        return true;
    }

}
