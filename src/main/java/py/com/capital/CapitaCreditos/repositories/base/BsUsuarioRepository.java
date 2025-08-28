package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.MenuDto;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;

import java.util.List;
import java.util.Optional;

public interface BsUsuarioRepository extends JpaRepository<BsUsuario, Long> {

	@Query("SELECT p FROM BsUsuario p WHERE p.codUsuario = ?1 AND p.password = ?2")
	BsUsuario findByUsuarioAndPassword(String codUsuario, String password);
	
	@Query("SELECT p FROM BsUsuario p WHERE p.codUsuario = ?1")
	BsUsuario findByUsuario(String codUsuario);
	
	@Query(value = "SELECT new py.com.capital.CapitaCreditos.entities.MenuDto(mi, per, u) " 
			+ "FROM BsUsuario u "
			+ "JOIN u.rol rol " 
			+ "JOIN rol.bsPermisoRol per " 
			+ "JOIN per.bsMenu men " 
			+ "JOIN men.bsMenuItem mi "
			+ "where u.id = ?1 ")
			//+ "ORDER BY men.nroOrden ASC")
	List<MenuDto> findMenuByUser(Long idUsuario);

	//usa los métodos derivados de SpringJPA entre entidades
	// Buscar usuario por email de la persona (case-insensitive)
	Optional<BsUsuario> findByBsPersonaEmailIgnoreCase(String email);

	// ¿Existe un usuario con ese email?
	boolean existsByBsPersonaEmailIgnoreCase(String email);
	
	
}
