package py.com.capital.CapitaCreditos.services.cobranzas;

import py.com.capital.CapitaCreditos.entities.cobranzas.CobCaja;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface CobCajaService extends CommonService<CobCaja> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<CobCaja> buscarTodosActivoLista();
	CobCaja usuarioTieneCaja(Long idUsuario);
}
