package py.com.capital.CapitaCreditos.entities.creditos;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.converter.SiNoBooleanConverter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/*
* 4 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "cre_desembolso_cabecera", uniqueConstraints = @UniqueConstraint(name = "cre_desembolso_cab_unique_nroDesem_sol", columnNames = {
		"cre_solicitud_credito_id" }))
public class CreDesembolsoCabecera extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_desembolso")
	private LocalDate fechaDesembolso;

	@Column(name = "taza_mora")
	private BigDecimal tazaMora;

	@Column(name = "taza_anual")
	private BigDecimal tazaAnual;

	@Column(name = "nro_desembolso")
	private BigDecimal nroDesembolso;

	@Column(name = "ind_desembolsado")
	private String indDesembolsado;
	
	@Column(name = "ind_facturado")
	private String indFacturado;

	@Transient
	private boolean indDesembolsadoBoolean;

	@Column(name = "monto_total_capital")
	private BigDecimal montoTotalCapital;

	@Column(name = "monto_total_interes")
	private BigDecimal montoTotalInteres;

	@Column(name = "monto_total_iva")
	private BigDecimal montoTotalIva;

	@Column(name = "monto_total_credito")
	private BigDecimal montoTotalCredito;

	@Convert(converter = SiNoBooleanConverter.class)
	@Column(name = "ind_pagare_impreso", nullable = true, length = 1)
	private Boolean indPagareImpreso;

	@Convert(converter = SiNoBooleanConverter.class)
	@Column(name = "ind_contrato_impreso", nullable = true, length = 1)
	private Boolean indContratoImpreso;

	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "cre_solicitud_credito_id", referencedColumnName = "id", nullable = false)
	private CreSolicitudCredito creSolicitudCredito;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;

	@OneToOne
	@JoinColumn(name = "cre_tipo_amortizacion_id", referencedColumnName = "id", nullable = true)
	private CreTipoAmortizacion creTipoAmortizacion;

	@OneToOne
	@JoinColumn(name = "bs_talonario_id", referencedColumnName = "id", nullable = true)
	private BsTalonario bsTalonario;

	@OneToMany(mappedBy = "creDesembolsoCabecera", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private List<CreDesembolsoDetalle> creDesembolsoDetalleList;

	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}

	public CreDesembolsoCabecera() {
		this.creDesembolsoDetalleList = new ArrayList<CreDesembolsoDetalle>();
		this.montoTotalCapital = BigDecimal.ZERO;
		this.montoTotalInteres = BigDecimal.ZERO;
		this.montoTotalIva = BigDecimal.ZERO;
		this.montoTotalCredito = BigDecimal.ZERO;
	}

	public List<CreDesembolsoDetalle> getCreDesembolsoDetalleList() {
		return creDesembolsoDetalleList;
	}

	public void setCreDesembolsoDetalleList(List<CreDesembolsoDetalle> creDesembolsoDetalleList) {
		this.creDesembolsoDetalleList = creDesembolsoDetalleList;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public LocalDate getFechaDesembolso() {
		return fechaDesembolso;
	}

	public void setFechaDesembolso(LocalDate fechaDesembolso) {
		this.fechaDesembolso = fechaDesembolso;
	}

	public BigDecimal getTazaMora() {
		return tazaMora;
	}

	public void setTazaMora(BigDecimal tazaMora) {
		this.tazaMora = tazaMora;
	}

	public BigDecimal getTazaAnual() {
		return tazaAnual;
	}

	public void setTazaAnual(BigDecimal tazaAnual) {
		this.tazaAnual = tazaAnual;
	}

	public BigDecimal getNroDesembolso() {
		return nroDesembolso;
	}

	public void setNroDesembolso(BigDecimal nroDesembolso) {
		this.nroDesembolso = nroDesembolso;
	}

	public String getIndDesembolsado() {
		return indDesembolsado;
	}

	public void setIndDesembolsado(String indDesembolsado) {
		this.indDesembolsado = indDesembolsado;
	}

	public boolean isIndDesembolsadoBoolean() {
		if (!Objects.isNull(indDesembolsado)) {
			indDesembolsadoBoolean = indDesembolsado.equalsIgnoreCase("S");
		}
		return indDesembolsadoBoolean;
	}

	public void setIndDesembolsadoBoolean(boolean indDesembolsadoBoolean) {
		indDesembolsado = indDesembolsadoBoolean ? "S" : "N";
		this.indDesembolsadoBoolean = indDesembolsadoBoolean;
	}

	public CreSolicitudCredito getCreSolicitudCredito() {
		return creSolicitudCredito;
	}

	public void setCreSolicitudCredito(CreSolicitudCredito creSolicitudCredito) {
		this.creSolicitudCredito = creSolicitudCredito;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public CreTipoAmortizacion getCreTipoAmortizacion() {
		return creTipoAmortizacion;
	}

	public void setCreTipoAmortizacion(CreTipoAmortizacion creTipoAmortizacion) {
		this.creTipoAmortizacion = creTipoAmortizacion;
	}

	public BsTalonario getBsTalonario() {
		return bsTalonario;
	}

	public void setBsTalonario(BsTalonario bsTalonario) {
		this.bsTalonario = bsTalonario;
	}

	public BigDecimal getMontoTotalCapital() {
		return montoTotalCapital;
	}

	public void setMontoTotalCapital(BigDecimal montoTotalCapital) {
		this.montoTotalCapital = montoTotalCapital;
	}

	public BigDecimal getMontoTotalInteres() {
		return montoTotalInteres;
	}

	public void setMontoTotalInteres(BigDecimal montoTotalInteres) {
		this.montoTotalInteres = montoTotalInteres;
	}

	public BigDecimal getMontoTotalIva() {
		return montoTotalIva;
	}

	public void setMontoTotalIva(BigDecimal montoTotalIva) {
		this.montoTotalIva = montoTotalIva;
	}

	public BigDecimal getMontoTotalCredito() {
		return montoTotalCredito;
	}

	public void setMontoTotalCredito(BigDecimal montoTotalCredito) {
		this.montoTotalCredito = montoTotalCredito;
	}

	public String getIndFacturado() {
		return indFacturado;
	}

	public void setIndFacturado(String indFacturado) {
		this.indFacturado = indFacturado;
	}

	public Boolean getIndPagareImpreso() {
		return indPagareImpreso;
	}

	public void setIndPagareImpreso(Boolean indPagareImpreso) {
		this.indPagareImpreso = indPagareImpreso;
	}

	public Boolean getIndContratoImpreso() {
		return indContratoImpreso;
	}

	public void setIndContratoImpreso(Boolean indContratoImpreso) {
		this.indContratoImpreso = indContratoImpreso;
	}

	public void addDetalle(CreDesembolsoDetalle detalle) {
		if (!Objects.isNull(detalle)) {
			this.creDesembolsoDetalleList.add(detalle);
		}
	}

	public void calcularTotales() {
		if (!Objects.isNull(this.creDesembolsoDetalleList)) {
			this.creDesembolsoDetalleList.forEach(detalle -> {
				this.montoTotalCapital = this.montoTotalCapital.add(detalle.getMontoCapital());
				this.montoTotalInteres = this.montoTotalInteres.add(detalle.getMontoInteres());
				this.montoTotalIva = this.montoTotalIva.add(detalle.getMontoIva());
			});
			this.montoTotalCredito = this.montoTotalCredito.add(this.montoTotalCapital).add(this.montoTotalInteres)
					.add(this.montoTotalIva);

		}
	}

	public void setCabeceraADetalle() {
		if (!Objects.isNull(this.creDesembolsoDetalleList)) {
			this.creDesembolsoDetalleList.forEach(detalle -> {
				detalle.setCreDesembolsoCabecera(this);
			});
		}
	}

}
