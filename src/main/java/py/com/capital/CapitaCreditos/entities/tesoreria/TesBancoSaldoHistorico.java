package py.com.capital.CapitaCreditos.entities.tesoreria;

import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.base.Common;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/*
 * 1 dic. 2023 - Elitebook
 */
@Entity
@Table(
        name = "tes_bancos_saldos_historicos",
        uniqueConstraints = @UniqueConstraint(
                name = "tes_bancos_saldos_historicos_uk",
                columnNames = {"tes_banco_id", "fecha_saldo"}
        )
)
public class TesBancoSaldoHistorico extends Common implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

	@Column(name = "fecha_saldo", nullable = false)
	private LocalDate fechaSaldo;

	@Column(name = "saldo_inicial", precision = 19, scale = 2, nullable = false)
	private BigDecimal saldoInicial = BigDecimal.ZERO;

	@Column(name = "ingresos", precision = 19, scale = 2, nullable = false)
	private BigDecimal ingresos = BigDecimal.ZERO;

	@Column(name = "egresos", precision = 19, scale = 2, nullable = false)
	private BigDecimal egresos = BigDecimal.ZERO;

	@Column(name = "saldo_final", precision = 19, scale = 2, nullable = false)
	private BigDecimal saldoFinal = BigDecimal.ZERO;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "tes_banco_id", nullable = false)
	private TesBanco tesBanco;

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

	public LocalDate getFechaSaldo() {
		return fechaSaldo;
	}

	public void setFechaSaldo(LocalDate fechaSaldo) {
		this.fechaSaldo = fechaSaldo;
	}

	public BigDecimal getSaldoInicial() {
		return saldoInicial;
	}

	public void setSaldoInicial(BigDecimal saldoInicial) {
		this.saldoInicial = saldoInicial;
	}

	public BigDecimal getIngresos() {
		return ingresos;
	}

	public void setIngresos(BigDecimal ingresos) {
		this.ingresos = ingresos;
	}

	public BigDecimal getEgresos() {
		return egresos;
	}

	public void setEgresos(BigDecimal egresos) {
		this.egresos = egresos;
	}

	public BigDecimal getSaldoFinal() {
		return saldoFinal;
	}

	public void setSaldoFinal(BigDecimal saldoFinal) {
		this.saldoFinal = saldoFinal;
	}

	public TesBanco getTesBanco() {
		return tesBanco;
	}

	public void setTesBanco(TesBanco tesBanco) {
		this.tesBanco = tesBanco;
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
		TesBancoSaldoHistorico that = (TesBancoSaldoHistorico) o;
		return Objects.equals(id, that.id) && tesBanco.equals(that.tesBanco) && bsEmpresa.equals(that.bsEmpresa);
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, tesBanco, bsEmpresa);
	}
}
