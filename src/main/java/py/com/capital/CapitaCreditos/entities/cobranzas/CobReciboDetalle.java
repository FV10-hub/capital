package py.com.capital.CapitaCreditos.entities.cobranzas;
/*
* 15 ene. 2024 - Elitebook
*/

import javax.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;


@Entity
@Table(name = "cob_recibos_detalle")
public class CobReciboDetalle implements Serializable{
	
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column()
	private Integer cantidad;

	@Column(name = "id_cuota_saldo")
	private Long idCuotaSaldo;

	@Column(name = "nro_orden")
	private Integer nroOrden;
	
	@Column(name = "dias_atraso")
	private Integer diasAtraso;
	
	@Column(name = "monto_pagado")
	private BigDecimal montoPagado;
	
	@ManyToOne
	@JoinColumn(name = "cob_saldo_id")
	private CobSaldo cobSaldo;
	
	@ManyToOne
	@JoinColumn(name = "cob_recibos_cabecera_id")
	private CobReciboCabecera cobReciboCabecera;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getCantidad() {
		return cantidad;
	}

	public void setCantidad(Integer cantidad) {
		this.cantidad = cantidad;
	}

	public Integer getNroOrden() {
		return nroOrden;
	}

	public void setNroOrden(Integer nroOrden) {
		this.nroOrden = nroOrden;
	}

	public Integer getDiasAtraso() {
		return diasAtraso;
	}

	public void setDiasAtraso(Integer diasAtraso) {
		this.diasAtraso = diasAtraso;
	}

	public BigDecimal getMontoPagado() {
		return montoPagado;
	}

	public void setMontoPagado(BigDecimal montoPagado) {
		this.montoPagado = montoPagado;
	}

	public CobSaldo getCobSaldo() {
		return cobSaldo;
	}

	public void setCobSaldo(CobSaldo cobSaldo) {
		this.cobSaldo = cobSaldo;
	}

	public CobReciboCabecera getCobReciboCabecera() {
		return cobReciboCabecera;
	}

	public void setCobReciboCabecera(CobReciboCabecera cobReciboCabecera) {
		this.cobReciboCabecera = cobReciboCabecera;
	}

	public Long getIdCuotaSaldo() {
		return idCuotaSaldo;
	}

	public void setIdCuotaSaldo(Long idCuotaSaldo) {
		this.idCuotaSaldo = idCuotaSaldo;
	}

	@Override
	public int hashCode() {
		return Objects.hash(cobReciboCabecera, cobSaldo, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		CobReciboDetalle other = (CobReciboDetalle) obj;
		return Objects.equals(cobReciboCabecera, other.cobReciboCabecera) && Objects.equals(cobSaldo, other.cobSaldo)
				&& Objects.equals(id, other.id);
	}
	
	

}

