package py.com.capital.CapitaCreditos.entities.compras;

import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.entities.base.Common;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/*
* 9 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "com_facturas_cabecera", uniqueConstraints = @UniqueConstraint(name = "com_fact_cab_unique_nroFact_des", columnNames = {
		"tipo_factura", "nro_factura_completo","com_proveedor_id","bs_empresa_id" }))
public class ComFacturaCabecera extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_factura")
	private LocalDate fechaFactura;

	@Column(name = "observacion")
	private String observacion;

	// DESEMBOLSO, NCR(nota de credito) O FACTURA NORMAL
	@Column(name = "tipo_factura")
	private String tipoFactura;

	@Column(name = "nro_factura_completo")
	private String nroFacturaCompleto;

	@Column(name = "ind_pagado")
	private String indPagado;

	@Column(name = "monto_total_gravada")
	private BigDecimal montoTotalGravada;

	@Column(name = "monto_total_exenta")
	private BigDecimal montoTotalExenta;

	@Column(name = "monto_total_iva")
	private BigDecimal montoTotalIva;

	@Column(name = "monto_total_factura")
	private BigDecimal montoTotalFactura;

	@ManyToOne
	@JoinColumn(name = "com_proveedor_id", referencedColumnName = "id", nullable = false)
	private ComProveedor comProveedor;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;


	@OneToMany(mappedBy = "comFacturaCabecera", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private List<ComFacturaDetalle> comFacturaDetalleList;

	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}

	public ComFacturaCabecera() {
		this.comFacturaDetalleList = new ArrayList<ComFacturaDetalle>();
		this.montoTotalGravada = BigDecimal.ZERO;
		this.montoTotalExenta = BigDecimal.ZERO;
		this.montoTotalIva = BigDecimal.ZERO;
		this.montoTotalFactura = BigDecimal.ZERO;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public LocalDate getFechaFactura() {
		return fechaFactura;
	}

	public void setFechaFactura(LocalDate fechaFactura) {
		this.fechaFactura = fechaFactura;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public String getTipoFactura() {
		return tipoFactura;
	}

	public void setTipoFactura(String tipoFactura) {
		this.tipoFactura = tipoFactura;
	}

	public String getNroFacturaCompleto() {
		return nroFacturaCompleto;
	}

	public void setNroFacturaCompleto(String nroFacturaCompleto) {
		this.nroFacturaCompleto = nroFacturaCompleto;
	}

	public BigDecimal getMontoTotalGravada() {
		return montoTotalGravada;
	}

	public void setMontoTotalGravada(BigDecimal montoTotalGravada) {
		this.montoTotalGravada = montoTotalGravada;
	}

	public BigDecimal getMontoTotalExenta() {
		return montoTotalExenta;
	}

	public void setMontoTotalExenta(BigDecimal montoTotalExenta) {
		this.montoTotalExenta = montoTotalExenta;
	}

	public BigDecimal getMontoTotalIva() {
		return montoTotalIva;
	}

	public void setMontoTotalIva(BigDecimal montoTotalIva) {
		this.montoTotalIva = montoTotalIva;
	}

	public BigDecimal getMontoTotalFactura() {
		return montoTotalFactura;
	}

	public void setMontoTotalFactura(BigDecimal montoTotalFactura) {
		this.montoTotalFactura = montoTotalFactura;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public List<ComFacturaDetalle> getComFacturaDetalleList() {
		return comFacturaDetalleList;
	}

	public void setComFacturaDetalleList(List<ComFacturaDetalle> comFacturaDetalleList) {
		this.comFacturaDetalleList = comFacturaDetalleList;
	}

	public String getIndPagado() {
		return indPagado;
	}

	public void setIndPagado(String indPagado) {
		this.indPagado = indPagado;
	}

	public ComProveedor getComProveedor() {
		return comProveedor;
	}

	public void setComProveedor(ComProveedor comProveedor) {
		this.comProveedor = comProveedor;
	}

	public void addDetalle(ComFacturaDetalle detalle) {
		if (!Objects.isNull(detalle)) {
			this.comFacturaDetalleList.add(calcularTotalLinea(detalle));
		}
	}

	private ComFacturaDetalle calcularTotalLinea(ComFacturaDetalle detalle) {
		var gravada = BigDecimal.ZERO;
		var iva = BigDecimal.ZERO;
		var exenta = BigDecimal.ZERO;
		var totalLinea = detalle.getMontoLinea();
		switch (detalle.getCodIva()) {
		case "IVA10":
			gravada = totalLinea.divide(BigDecimal.valueOf(1.1), 2, RoundingMode.HALF_UP);
			iva = totalLinea.subtract(gravada);
			break;
		case "IVA5":
			gravada = totalLinea.divide(BigDecimal.valueOf(1.05), 2, RoundingMode.HALF_UP);
			iva = totalLinea.subtract(gravada);
			break;
		case "EXE":
			exenta = totalLinea;
			gravada = BigDecimal.ZERO;
			iva = BigDecimal.ZERO;
			break;
		default:
			break;
		}
		detalle.setMontoGravado(gravada);
		detalle.setMontoExento(exenta);
		detalle.setMontoIva(iva);
		detalle.setMontoLinea(totalLinea);
		return detalle;
	}

	public void calcularTotales() {
		if (!Objects.isNull(this.comFacturaDetalleList)) {
			this.comFacturaDetalleList.forEach(detalle -> {
				this.montoTotalGravada = this.montoTotalGravada.add(detalle.getMontoGravado());
				this.montoTotalExenta = this.montoTotalExenta.add(detalle.getMontoExento());
				this.montoTotalIva = this.montoTotalIva.add(detalle.getMontoIva());
			});
			this.montoTotalFactura = this.montoTotalFactura.add(this.montoTotalGravada).add(this.montoTotalExenta)
					.add(this.montoTotalIva);

		}
	}

	public void setCabeceraADetalle() {
		if (!Objects.isNull(this.comFacturaDetalleList)) {
			this.comFacturaDetalleList.forEach(detalle -> {
				detalle.setComFacturaCabecera(this);
			});
		}
	}

}
