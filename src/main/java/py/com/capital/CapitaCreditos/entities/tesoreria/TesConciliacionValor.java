package py.com.capital.CapitaCreditos.entities.tesoreria;

import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCobrosValores;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 12 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "tes_conciliaciones_valores", uniqueConstraints =
@UniqueConstraint(name = "cob_cobros_valores_uniques", columnNames = {
		"bs_empresa_id", "bs_tipo_valor_id", "cob_cobros_valores_id" }))
public class TesConciliacionValor extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "observacion")
	private String observacion;

	@Column(name = "nro_valor")
	private String nroValor;

	@Column(name = "monto_valor")
    private BigDecimal montoValor;

	@Column(name = "fecha_valor")
	private LocalDate fechaValor;

	@Column(name = "ind_conciliado")
	private String indConciliado;

	@Transient
	private boolean indConciliadoBoolean;

	@ManyToOne
	@JoinColumn(name = "bs_tipo_valor_id", referencedColumnName = "id", nullable = false)
	private BsTipoValor bsTipoValor;

	@ManyToOne
	@JoinColumn(name = "cob_cobros_valores_id", referencedColumnName = "id", nullable = false)
	private CobCobrosValores cobCobrosValores;
	
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

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public String getNroValor() {
		return nroValor;
	}

	public void setNroValor(String nroValor) {
		this.nroValor = nroValor;
	}

	public BigDecimal getMontoValor() {
		return montoValor;
	}

	public void setMontoValor(BigDecimal montoValor) {
		this.montoValor = montoValor;
	}

	public LocalDate getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(LocalDate fechaValor) {
		this.fechaValor = fechaValor;
	}

	public String getIndConciliado() {
		return indConciliado;
	}

	public void setIndConciliado(String indConciliado) {
		this.indConciliado = indConciliado;
	}

	public boolean isIndConciliadoBoolean() {
		if (!Objects.isNull(indConciliado)) {
			indConciliadoBoolean = indConciliado.equalsIgnoreCase("S");
		}
		return indConciliadoBoolean;
	}

	public void setIndConciliadoBoolean(boolean indConciliadoBoolean) {
		indConciliado = indConciliadoBoolean ? "S" : "N";
		this.indConciliadoBoolean = indConciliadoBoolean;
	}

	public BsTipoValor getBsTipoValor() {
		return bsTipoValor;
	}

	public void setBsTipoValor(BsTipoValor bsTipoValor) {
		this.bsTipoValor = bsTipoValor;
	}

	public CobCobrosValores getCobCobrosValores() {
		return cobCobrosValores;
	}

	public void setCobCobrosValores(CobCobrosValores cobCobrosValores) {
		this.cobCobrosValores = cobCobrosValores;
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
		TesConciliacionValor that = (TesConciliacionValor) o;
		return bsTipoValor.equals(that.bsTipoValor) && cobCobrosValores.equals(that.cobCobrosValores) && bsEmpresa.equals(that.bsEmpresa);
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsTipoValor, cobCobrosValores, bsEmpresa);
	}
}
