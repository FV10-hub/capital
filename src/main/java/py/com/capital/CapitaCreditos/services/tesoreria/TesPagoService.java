package py.com.capital.CapitaCreditos.services.tesoreria;

import org.springframework.data.repository.query.Param;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesPagoCabecera;
import py.com.capital.CapitaCreditos.services.CommonService;

import java.util.List;

public interface TesPagoService extends CommonService<TesPagoCabecera> {
	
	Long calcularNroPagoDisponible(Long idEmpresa, Long idTalonario);

	List<TesPagoCabecera> buscarTesPagoCabeceraActivosLista(Long idEmpresa);
	
	List<TesPagoCabecera> buscarTesPagoCabeceraPorBeneficiarioLista(Long idEmpresa, Long idBeneficiario);
	
	List<TesPagoCabecera> buscarTesPagoCabeceraPorTipoOperacionLista(Long idEmpresa, String tipoOperacion);
	
	//TesPagoCabecera recuperarPagosConDetalle(Long idEmpresa, Long idPago);

	int marcarPagosComoConciliado(Long empresaId,
									List<Long> idsSaldo,
									String usuario);

	int revertirPagosConciliados(Long empresaId,
								 List<Long> idsPago,
								 String usuario);

}
