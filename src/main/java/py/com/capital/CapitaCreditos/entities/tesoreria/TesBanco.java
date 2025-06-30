package py.com.capital.CapitaCreditos.entities.tesoreria;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 1 dic. 2023 - Elitebook
*/
@Entity
@Table(name = "tes_bancos", uniqueConstraints = @UniqueConstraint(name = "tes_bancos_unique_persona_empresa", columnNames = {
		"cod_banco", "bs_moneda_id", "bs_empresa_id", "bs_persona_id" }))
public class TesBanco extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cod_banco")
	private String codBnaco;

	@Column(name = "saldo_cuenta")
	private BigDecimal SaldoCuenta;

	@OneToOne()
	@JoinColumn(name = "bs_persona_id")
	private BsPersona bsPersona;

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

	public String getCodBnaco() {
		return codBnaco;
	}

	public void setCodBnaco(String codBnaco) {
		this.codBnaco = codBnaco;
	}

	public BigDecimal getSaldoCuenta() {
		return SaldoCuenta;
	}

	public void setSaldoCuenta(BigDecimal saldoCuenta) {
		SaldoCuenta = saldoCuenta;
	}

	public BsPersona getBsPersona() {
		return bsPersona;
	}

	public void setBsPersona(BsPersona bsPersona) {
		this.bsPersona = bsPersona;
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
	public int hashCode() {
		return Objects.hash(bsEmpresa, bsMoneda, bsPersona);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		TesBanco other = (TesBanco) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(bsMoneda, other.bsMoneda)
				&& Objects.equals(bsPersona, other.bsPersona);
	}

}
