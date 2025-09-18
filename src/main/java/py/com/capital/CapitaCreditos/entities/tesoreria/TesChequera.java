package py.com.capital.CapitaCreditos.entities.tesoreria;

import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTipoComprobante;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.base.Common;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigInteger;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* SOLO PERMITO TENER UNA CHEQUERA ACTIVA POR BANCO BANCO
*/
@Entity
@Table(name = "tes_chequeras",
		uniqueConstraints = @UniqueConstraint(name="tes_chequeras_unq_activa",
				columnNames = {"bs_empresa_id","tes_banco_id","bs_tipo_valor_id","estado"}))
public class TesChequera extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_vigencia_desde")
	private LocalDate fechaVigenciaDesde;
	
	@Column(name = "fecha_vigencia_hasta")
	private LocalDate fechaVigenciaHasta;

	@Column(name = "nro_desde")
    private Long nroDesde;
	
	@Column(name = "nro_hasta")
    private Long nroHasta;

	@Column(name = "proximo_numero")
	private BigInteger proximoNumero;

	@ManyToOne
	@JoinColumn(name = "tes_banco_id", referencedColumnName = "id", nullable = false)
	private TesBanco tesBanco;

	@ManyToOne
	@JoinColumn(name = "bs_tipo_valor_id", referencedColumnName = "id", nullable = false)
	private BsTipoValor bsTipoValor;

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

	public LocalDate getFechaVigenciaDesde() {
		return fechaVigenciaDesde;
	}

	public void setFechaVigenciaDesde(LocalDate fechaVigenciaDesde) {
		this.fechaVigenciaDesde = fechaVigenciaDesde;
	}

	public LocalDate getFechaVigenciaHasta() {
		return fechaVigenciaHasta;
	}

	public void setFechaVigenciaHasta(LocalDate fechaVigenciaHasta) {
		this.fechaVigenciaHasta = fechaVigenciaHasta;
	}

	public Long getNroDesde() {
		return nroDesde;
	}

	public void setNroDesde(Long nroDesde) {
		this.nroDesde = nroDesde;
	}

	public Long getNroHasta() {
		return nroHasta;
	}

	public void setNroHasta(Long nroHasta) {
		this.nroHasta = nroHasta;
	}

	public BigInteger getProximoNumero() {
		return proximoNumero;
	}

	public void setProximoNumero(BigInteger proximoNumero) {
		this.proximoNumero = proximoNumero;
	}

	public TesBanco getTesBanco() {
		return tesBanco;
	}

	public void setTesBanco(TesBanco tesBanco) {
		this.tesBanco = tesBanco;
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
}

