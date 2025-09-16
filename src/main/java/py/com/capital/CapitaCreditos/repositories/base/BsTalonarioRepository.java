package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;

import javax.persistence.LockModeType;
import java.util.List;
import java.util.Optional;

/**
 * fvazquez
 */
public interface BsTalonarioRepository extends JpaRepository<BsTalonario, Long> {

	@Query("SELECT m FROM BsTalonario m")
	Page<BsTalonario> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM BsTalonario m")
	List<BsTalonario> buscarTodosLista();

	@Query("SELECT m FROM BsTalonario m where m.estado = 'ACTIVO' and m.bsTimbrado.bsEmpresa.id = ?1")
	List<BsTalonario> buscarBsTalonarioActivosLista(Long idEmpresa);

	@Query("SELECT m FROM BsTalonario m where m.estado = 'ACTIVO' and m.bsTimbrado.bsEmpresa.id = ?1 and m.bsTipoComprobante.bsModulo.id = ?2")
	List<BsTalonario> buscarBsTalonarioPorModuloLista(Long idEmpresa, Long idModulo);

	@Lock(LockModeType.PESSIMISTIC_WRITE)
	@Query("""
        SELECT t FROM BsTalonario t
        JOIN FETCH t.bsTimbrado tim
        WHERE t.id = :talonarioId
          AND tim.bsEmpresa.id = :empresaId
    """)
    Optional<BsTalonario> findForUpdate(@Param("talonarioId") Long talonarioId,
                                        @Param("empresaId") Long empresaId);

}
