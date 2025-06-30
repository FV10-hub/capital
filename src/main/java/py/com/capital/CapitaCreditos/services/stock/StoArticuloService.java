package py.com.capital.CapitaCreditos.services.stock;

import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.util.List;

public interface StoArticuloService extends CommonService<StoArticulo> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<StoArticulo> buscarStoArticuloActivosLista(Long idEmpresa);
	
	StoArticulo buscarArticuloPorCodigo(String param, Long empresaId);
	
	BigDecimal retornaExistenciaArticulo(Long idArticulo,Long idEmpresa);
}
