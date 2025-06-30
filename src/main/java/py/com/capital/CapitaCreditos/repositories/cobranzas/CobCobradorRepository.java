package py.com.capital.CapitaCreditos.repositories.cobranzas;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrador;

import java.util.List;

public interface CobCobradorRepository extends JpaRepository<CobCobrador, Long> {
	
	@Query("SELECT m FROM CobCobrador m")
	Page<CobCobrador> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM CobCobrador m")
	List<CobCobrador> buscarTodosLista();
	
	@Query("SELECT m FROM CobCobrador m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<CobCobrador> buscarCobradorActivosLista(Long idEmpresa);
	
	
}
