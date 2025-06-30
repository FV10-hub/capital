package py.com.capital.CapitaCreditos.entities.tesoreria;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/*
* 12 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "tes_pagos_valores", uniqueConstraints = @UniqueConstraint(name = "tes_pagos_valores_uniques", columnNames = {
		"nro_valor", "bs_tipo_valor_id", "bs_empresa_id", "tes_banco_id"
}))
public class TesPagoValores extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	// DESEMBOLSO O PAGO PROVEEDOR
	@Column(name = "tipo_operacion")
	private String tipoOperacion;

	@Column(name = "nro_orden")
	private Integer nroOrden;

	@Column(name = "monto_cuota")
	private BigDecimal montoValor;

	@Column(name = "nro_valor")
	private String nroValor;

	@Column(name = "fecha_valor")
	private LocalDate fechaValor;

	@Column(name = "fecha_vencimiento")
	private LocalDate fechaVencimiento;

	@Column(name = "ind_entregado")
	private String indEntregado;

	@Transient
	private boolean indEntregadoBoolean;

	@Column(name = "fecha_entrega")
	private LocalDate fechaEntrega;

	@ManyToOne
	@JoinColumn(name = "tes_pagos_cabecera_id")
	private TesPagoCabecera tesPagoCabecera;

	@ManyToOne
	@JoinColumn(name = "bs_tipo_valor_id", referencedColumnName = "id", nullable = false)
	private BsTipoValor bsTipoValor;

	@ManyToOne
	@JoinColumn(name = "tes_banco_id", referencedColumnName = "id", nullable = false)
	private TesBanco tesBanco;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;

	@PrePersist
	private void preInsert() {
		this.setEstado("ACTIVO");
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

	public String getTipoOperacion() {
		return tipoOperacion;
	}

	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}

	public Integer getNroOrden() {
		return nroOrden;
	}

	public void setNroOrden(Integer nroOrden) {
		this.nroOrden = nroOrden;
	}

	public BigDecimal getMontoValor() {
		return montoValor;
	}

	public void setMontoValor(BigDecimal montoValor) {
		this.montoValor = montoValor;
	}

	public String getNroValor() {
		return nroValor;
	}

	public void setNroValor(String nroValor) {
		this.nroValor = nroValor;
	}

	public LocalDate getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(LocalDate fechaValor) {
		this.fechaValor = fechaValor;
	}

	public LocalDate getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(LocalDate fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public String getIndEntregado() {
		return indEntregado;
	}

	public void setIndEntregado(String indEntregado) {
		this.indEntregado = indEntregado;
	}

	public boolean isIndEntregadoBoolean() {
		return indEntregadoBoolean;
	}

	public void setIndEntregadoBoolean(boolean indEntregadoBoolean) {
		this.indEntregadoBoolean = indEntregadoBoolean;
	}

	public LocalDate getFechaEntrega() {
		return fechaEntrega;
	}

	public void setFechaEntrega(LocalDate fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}

	public TesPagoCabecera getTesPagoCabecera() {
		return tesPagoCabecera;
	}

	public void setTesPagoCabecera(TesPagoCabecera tesPagoCabecera) {
		this.tesPagoCabecera = tesPagoCabecera;
	}

	public BsTipoValor getBsTipoValor() {
		return bsTipoValor;
	}

	public void setBsTipoValor(BsTipoValor bsTipoValor) {
		this.bsTipoValor = bsTipoValor;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public TesBanco getTesBanco() {
		return tesBanco;
	}

	public void setTesBanco(TesBanco tesBanco) {
		this.tesBanco = tesBanco;
	}

	

	
}
