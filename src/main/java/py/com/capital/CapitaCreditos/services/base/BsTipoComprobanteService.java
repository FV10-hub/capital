package py.com.capital.CapitaCreditos.services.base;

import py.com.capital.CapitaCreditos.entities.base.BsTipoComprobante;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface BsTipoComprobanteService extends CommonService<BsTipoComprobante> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<BsTipoComprobante> buscarBsTipoComprobanteActivosLista(Long idEmpresa);
}
