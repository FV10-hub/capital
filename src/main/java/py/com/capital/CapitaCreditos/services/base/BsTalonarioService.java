package py.com.capital.CapitaCreditos.services.base;

import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface BsTalonarioService extends CommonService<BsTalonario> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<BsTalonario> buscarBsTalonarioActivosLista(Long idEmpresa);
	
	List<BsTalonario> buscarBsTalonarioPorModuloLista(Long idEmpresa, Long idModulo);

	public long asignarNumeroDesdeTalonario(Long empresaId, Long talonarioId, String usuario);

	public boolean validarNumero(Long empresaId, Long talonarioId, long numero);
}
