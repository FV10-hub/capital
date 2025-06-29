package py.com.capital.CapitaCreditos.entities.ventas;

import jakarta.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 12 dic. 2023 - Elitebook
*/
@Entity
@Table(name = "ven_condicion_ventas")
public class VenCondicionVenta extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cod_condicion")
	private String codCondicion;

	@Column(name = "descripcion")
	private String descripcion;

	@Column(name = "plazo")
	private BigDecimal plazo;

	@Column(name = "intervalo")
	private BigDecimal intervalo;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;

	@PrePersist
	private void preInsert() {
		// this.setEstado("ACTIVO");
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

	public String getCodCondicion() {
		return codCondicion;
	}

	public void setCodCondicion(String codCondicion) {
		this.codCondicion = codCondicion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public BigDecimal getPlazo() {
		return plazo;
	}

	public void setPlazo(BigDecimal plazo) {
		this.plazo = plazo;
	}

	public BigDecimal getIntervalo() {
		return intervalo;
	}

	public void setIntervalo(BigDecimal intervalo) {
		this.intervalo = intervalo;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, codCondicion, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		VenCondicionVenta other = (VenCondicionVenta) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(codCondicion, other.codCondicion)
				&& Objects.equals(id, other.id);
	}

}
