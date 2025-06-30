package py.com.capital.CapitaCreditos.services.cobranzas;

import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.math.BigDecimal;
import java.util.List;

public interface CobHabilitacionCajaService extends CommonService<CobHabilitacionCaja> {

	/*
	 * agregar aca los metodos personalizados
	 * public Curso findCursoByAlumnoId(Long id);
	 * */
	BigDecimal calcularNroHabilitacionDisponible();
	
	String validaHabilitacionAbierta(Long idUsuario, Long idCaja);
	
	List<CobHabilitacionCaja> buscarCobHabilitacionCajaActivosLista(Long idEmpresa);

	CobHabilitacionCaja retornarHabilitacionAbierta(Long idEmpresa, Long idUsuario, Long idCaja);
	
}
