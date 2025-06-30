package py.com.capital.CapitaCreditos.services.cobranzas;

import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface CobClienteService extends CommonService<CobCliente> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	List<CobCliente> buscarClienteActivosLista(Long idEmpresa);
}
