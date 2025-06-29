package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import py.com.capital.CapitaCreditos.entities.MenuDto;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;

import java.util.List;

public interface BsUsuarioRepository extends PagingAndSortingRepository<BsUsuario, Long> {

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
	
	
}
