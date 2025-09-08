/**
 * 
 */
package py.com.capital.CapitaCreditos.services.base;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;

import java.util.List;

/**
 * 
 */
public interface BsPersonaService {

	Page<BsPersona> listarTodos(Pageable pageable);
	
	List<BsPersona> buscarTodosLista();
	
	List<BsPersona> personasSinFichaClientePorEmpresa(Long idEmpresa);
	
	List<BsPersona> personasSinFichaCobradorPorEmpresaNativo(Long idEmpresa);
	
	List<BsPersona> personasSinFichaVendedorPorEmpresaNativo(Long idEmpresa);

	List<BsPersona> personasSinFichaProveedoresPorEmpresaNativo(Long idEmpresa);
	List<BsPersona> personasSinFichaBancosPorEmpresaNativo(Long idEmpresa);
	
	BsPersona guardar(BsPersona obj);
	
	void eliminar(Long id);
}