package py.com.capital.CapitaCreditos.services.cobranzas;

import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrador;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface CobCobradorService extends CommonService<CobCobrador> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<CobCobrador> buscarCobradorActivosLista(Long idEmpresa);
}
