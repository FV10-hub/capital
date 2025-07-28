package py.com.capital.CapitaCreditos.repositories.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobArqueosCajas;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobArqueosCajas;

import java.math.BigDecimal;
import java.util.List;

/*
* 28 dic. 2023 - Elitebook
*/
public interface CobArqueosCajaRepository extends JpaRepository<CobArqueosCajas, Long> {
	@Query("SELECT m FROM CobArqueosCajas m")
	Page<CobArqueosCajas> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM CobArqueosCajas m")
	List<CobArqueosCajas> buscarTodosLista();


	@Query("SELECT m FROM CobArqueosCajas m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.cobHabilitacionCaja.id = ?2")
	List<CobArqueosCajas> buscarCobArqueosCajasActivosLista(Long idEmpresa, Long idHabilitacion);
}
