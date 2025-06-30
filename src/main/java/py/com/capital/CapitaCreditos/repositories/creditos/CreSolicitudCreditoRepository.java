package py.com.capital.CapitaCreditos.repositories.creditos;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.creditos.CreSolicitudCredito;

import java.util.List;

/*
* 26 dic. 2023 - Elitebook
*/
public interface CreSolicitudCreditoRepository extends JpaRepository<CreSolicitudCredito, Long> {
	
	@Query("SELECT m FROM CreSolicitudCredito m")
	Page<CreSolicitudCredito> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM CreSolicitudCredito m")
	List<CreSolicitudCredito> buscarTodosLista();
	
	@Query("SELECT m FROM CreSolicitudCredito m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1")
	List<CreSolicitudCredito> buscarSolicitudActivosLista(Long idEmpresa);
	
	@Query("SELECT m FROM CreSolicitudCredito m where m.estado = 'ACTIVO' and m.indAutorizado = 'S' and m.indDesembolsado = 'N' and m.bsEmpresa.id = ?1")
	List<CreSolicitudCredito> buscarSolicitudAutorizadosLista(Long idEmpresa);

}
