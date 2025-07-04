package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;

import java.util.List;


public interface BsPersonaRepository extends JpaRepository<BsPersona, Long> {

	BsPersona findByNombre(String nombre);
	
	@Query("SELECT m FROM BsPersona m")
	Page<BsPersona> buscarTodos(Pageable pageable);
	
	@Query("SELECT m FROM BsPersona m")
	List<BsPersona> buscarTodosLista();
	
	@Query("SELECT p "
			+ "FROM BsPersona p "
			+ "LEFT JOIN CobCliente c ON p.id = c.bsPersona.id AND c.bsEmpresa.id = ?1 "
			+ "WHERE c.bsPersona.id IS NULL")
	List<BsPersona> personasSinFichaClientePorEmpresa(Long idEmpresa);
	
	@Query(value = "SELECT p.* FROM bs_persona p "
			+ "LEFT JOIN cob_cobradores c ON p.id = c.id_bs_persona AND c.bs_empresa_id = ?1 "
			+ "WHERE c.id_bs_persona IS NULL", nativeQuery = true)
	List<BsPersona> personasSinFichaCobradorPorEmpresaNativo(Long idEmpresa);
	
	@Query(value = "SELECT p.* FROM bs_persona p "
			+ "LEFT JOIN ven_vendedores c ON p.id = c.id_bs_persona AND c.bs_empresa_id = ?1 "
			+ "WHERE c.id_bs_persona IS NULL", nativeQuery = true)
	List<BsPersona> personasSinFichaVendedorPorEmpresaNativo(Long idEmpresa);
	
	
}
