package py.com.capital.CapitaCreditos.entities.tesoreria;
/*
* 15 ene. 2024 - Elitebook
*/

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;


@Entity
@Table(name = "tes_pago_comprobante_detalle")
public class TesPagoComprobanteDetalle implements Serializable{
	
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "id_cuota_saldo")
	private Long idCuotaSaldo;
	
	//DESEMBOLSO O PAGO PROVEEDOR
	@Column(name = "tipo_comprobante")
	private String tipoComprobante;
	
	@Column(name = "nro_orden")
	private Integer nroOrden;
	
	@Column(name = "monto_pagado")
	private BigDecimal montoPagado;
	
	@ManyToOne
	@JoinColumn(name = "tes_pagos_cabecera_id")
	private TesPagoCabecera tesPagoCabecera;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdCuotaSaldo() {
		return idCuotaSaldo;
	}

	public void setIdCuotaSaldo(Long idCuotaSaldo) {
		this.idCuotaSaldo = idCuotaSaldo;
	}

	public String getTipoComprobante() {
		return tipoComprobante;
	}

	public void setTipoComprobante(String tipoComprobante) {
		this.tipoComprobante = tipoComprobante;
	}

	public Integer getNroOrden() {
		return nroOrden;
	}

	public void setNroOrden(Integer nroOrden) {
		this.nroOrden = nroOrden;
	}

	public BigDecimal getMontoPagado() {
		return montoPagado;
	}

	public void setMontoPagado(BigDecimal montoPagado) {
		this.montoPagado = montoPagado;
	}

	public TesPagoCabecera getTesPagoCabecera() {
		return tesPagoCabecera;
	}

	public void setTesPagoCabecera(TesPagoCabecera tesPagoCabecera) {
		this.tesPagoCabecera = tesPagoCabecera;
	}

	
}

