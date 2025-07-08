package py.com.capital.CapitaCreditos.entities.compras;

import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 9 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "com_facturas_detalles")
public class ComFacturaDetalle extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column
	private Integer cantidad;
	
	@Column(name = "nro_orden")
	private Integer nroOrden;
	
	@Column(name = "precio_unitario")
	private BigDecimal precioUnitario;
	
	@Column(name = "monto_gravado")
	private BigDecimal montoGravado;
	
	@Column(name = "monto_exento")
	private BigDecimal montoExento;
	
	@Column(name = "monto_iva")
	private BigDecimal montoIva;
	
	@Column(name = "monto_linea")
	private BigDecimal montoLinea;
	
	@Column(name = "cod_iva")
	private String codIva;
	
	@ManyToOne
	@JoinColumn(name = "sto_articulo_id")
	private StoArticulo stoArticulo;
	
	@ManyToOne
	@JoinColumn(name = "com_facturas_cabecera_id")
	private ComFacturaCabecera comFacturaCabecera;
	
	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}

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

	public BigDecimal getPrecioUnitario() {
		return precioUnitario;
	}

	public void setPrecioUnitario(BigDecimal precioUnitario) {
		this.precioUnitario = precioUnitario;
	}

	public BigDecimal getMontoGravado() {
		return montoGravado;
	}

	public void setMontoGravado(BigDecimal montoGravado) {
		this.montoGravado = montoGravado;
	}

	public BigDecimal getMontoExento() {
		return montoExento;
	}

	public void setMontoExento(BigDecimal montoExento) {
		this.montoExento = montoExento;
	}

	public BigDecimal getMontoIva() {
		return montoIva;
	}

	public void setMontoIva(BigDecimal montoIva) {
		this.montoIva = montoIva;
	}

	public BigDecimal getMontoLinea() {
		return montoLinea;
	}

	public void setMontoLinea(BigDecimal montoLinea) {
		this.montoLinea = montoLinea;
	}

	public String getCodIva() {
		return codIva;
	}

	public void setCodIva(String codIva) {
		this.codIva = codIva;
	}

	public StoArticulo getStoArticulo() {
		return stoArticulo;
	}

	public void setStoArticulo(StoArticulo stoArticulo) {
		this.stoArticulo = stoArticulo;
	}

	public ComFacturaCabecera getComFacturaCabecera() {
		return comFacturaCabecera;
	}

	public void setComFacturaCabecera(ComFacturaCabecera comFacturaCabecera) {
		this.comFacturaCabecera = comFacturaCabecera;
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, stoArticulo, comFacturaCabecera);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ComFacturaDetalle other = (ComFacturaDetalle) obj;
		return Objects.equals(id, other.id) && Objects.equals(stoArticulo, other.stoArticulo)
				&& Objects.equals(comFacturaCabecera, other.comFacturaCabecera);
	}
	
	
	

}

