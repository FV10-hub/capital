package py.com.capital.CapitaCreditos.entities.tesoreria;
/*
* 15 ene. 2024 - Elitebook
*/

import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;


@Entity
@Table(name = "tes_debitos_creditos_bancarios")
public class TesDebitoCreditoBancario extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_debito")
	private LocalDate fechaDebito;
	
	@Column(name = "observacion")
	private String observacion;
	
	@Column(name = "monto_total_entrada")
	private BigDecimal montoTotalEntrada;


	@Column(name = "monto_total_salida")
	private BigDecimal montoTotalSalida;

	@ManyToOne
	@JoinColumn(name = "tes_banco_id_saliente", referencedColumnName = "id", nullable = false)
	private TesBanco tesBancoSaliente;

	@ManyToOne
	@JoinColumn(name = "tes_banco_id_entrante", referencedColumnName = "id", nullable = false)
	private TesBanco tesBancoEntrante;
	
	@OneToOne
	@JoinColumn(name = "cob_habilitacion_id", referencedColumnName = "id", nullable = false)
	private CobHabilitacionCaja cobHabilitacionCaja;

	@OneToOne()
	@JoinColumn(name = "bs_moneda_id")
	private BsMoneda bsMoneda;
	
	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;
	
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

	public LocalDate getFechaDebito() {
		return fechaDebito;
	}

	public void setFechaDebito(LocalDate fechaDebito) {
		this.fechaDebito = fechaDebito;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public BigDecimal getMontoTotalEntrada() {
		return montoTotalEntrada;
	}

	public void setMontoTotalEntrada(BigDecimal montoTotalEntrada) {
		this.montoTotalEntrada = montoTotalEntrada;
	}

	public BigDecimal getMontoTotalSalida() {
		return montoTotalSalida;
	}

	public void setMontoTotalSalida(BigDecimal montoTotalSalida) {
		this.montoTotalSalida = montoTotalSalida;
	}

	public TesBanco getTesBancoSaliente() {
		return tesBancoSaliente;
	}

	public void setTesBancoSaliente(TesBanco tesBancoSaliente) {
		this.tesBancoSaliente = tesBancoSaliente;
	}

	public TesBanco getTesBancoEntrante() {
		return tesBancoEntrante;
	}

	public void setTesBancoEntrante(TesBanco tesBancoEntrante) {
		this.tesBancoEntrante = tesBancoEntrante;
	}

	public CobHabilitacionCaja getCobHabilitacionCaja() {
		return cobHabilitacionCaja;
	}

	public void setCobHabilitacionCaja(CobHabilitacionCaja cobHabilitacionCaja) {
		this.cobHabilitacionCaja = cobHabilitacionCaja;
	}

	public BsMoneda getBsMoneda() {
		return bsMoneda;
	}

	public void setBsMoneda(BsMoneda bsMoneda) {
		this.bsMoneda = bsMoneda;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		TesDebitoCreditoBancario that = (TesDebitoCreditoBancario) o;
		return Objects.equals(id, that.id) && Objects.equals(tesBancoSaliente, that.tesBancoSaliente) && Objects.equals(tesBancoEntrante, that.tesBancoEntrante) && Objects.equals(bsMoneda, that.bsMoneda) && Objects.equals(bsEmpresa, that.bsEmpresa);
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, tesBancoSaliente, tesBancoEntrante, bsMoneda, bsEmpresa);
	}
}

