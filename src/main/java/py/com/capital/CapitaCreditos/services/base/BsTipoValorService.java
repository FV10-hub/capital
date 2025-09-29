package py.com.capital.CapitaCreditos.services.base;

import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface BsTipoValorService extends CommonService<BsTipoValor> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<BsTipoValor> buscarTipoValorActivosLista(Long idEmpresa);

	BsTipoValor buscarTipoValorModuloTipo(Long idEmpresa, String codModulo, String codTipo);
}
