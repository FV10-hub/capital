package py.com.capital.CapitaCreditos.repositories.tesoreria;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesPagoCabecera;

import java.util.List;

public interface TesPagoRepository extends JpaRepository<TesPagoCabecera, Long> {
	
	@Query("SELECT m FROM TesPagoCabecera m")
	Page<TesPagoCabecera> buscarTodos(Pageable pageable);

	@Query("SELECT m FROM TesPagoCabecera m")
	List<TesPagoCabecera> buscarTodosLista();
	
	@Query(value = "SELECT COALESCE(MAX(m.nro_pago), 0) + 1 FROM tes_pagos_cabecera m where m.bs_empresa_id = ?1 and m.bs_talonario_id = ?2", nativeQuery = true)
	Long calcularNroPagoDisponible(Long idEmpresa, Long idTalonario);

	@Query("SELECT m FROM TesPagoCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 ORDER BY m.id DESC ")
	List<TesPagoCabecera> buscarTesPagoCabeceraActivosLista(Long idEmpresa);
	
	@Query("SELECT m FROM TesPagoCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.idBeneficiario = ?2")
	List<TesPagoCabecera> buscarTesPagoCabeceraPorBeneficiarioLista(Long idEmpresa, Long idBeneficiario);
	
	@Query("SELECT m FROM TesPagoCabecera m where m.estado = 'ACTIVO' and m.bsEmpresa.id = ?1 and m.tipoOperacion = ?2")
	List<TesPagoCabecera> buscarTesPagoCabeceraPorTipoOperacionLista(Long idEmpresa, String tipoOperacion);
	
	/*@Query("SELECT DISTINCT tc FROM TesPagoCabecera tc "
	        + "LEFT JOIN FETCH tc.tesPagoComprobanteDetallesList detalles "
	        + "LEFT JOIN FETCH tc.tesPagoValoresList valores "
	        + "WHERE tc.bsEmpresa.id = ?1 and tc.id = ?2 ")
	TesPagoCabecera recuperarPagosConDetalle(Long idEmpresa, Long idPago);*/


	
}
