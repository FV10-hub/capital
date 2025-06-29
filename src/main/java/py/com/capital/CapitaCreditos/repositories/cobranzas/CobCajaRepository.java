package py.com.capital.CapitaCreditos.repositories.cobranzas;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCaja;

import java.util.List;

/*
* 28 dic. 2023 - Elitebook
*/
public interface CobCajaRepository extends PagingAndSortingRepository<CobCaja, Long> {
	@Query("SELECT m FROM CobCaja m where m.estado = 'ACTIVO'")
	List<CobCaja> buscarTodosActivoLista();
	
	@Query("SELECT m FROM CobCaja m where m.bsUsuario.id = ?1")
	CobCaja usuarioTieneCaja(Long idUsuario);
}
