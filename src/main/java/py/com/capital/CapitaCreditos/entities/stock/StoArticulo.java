package py.com.capital.CapitaCreditos.entities.stock;

import jakarta.persistence.*;
import org.apache.commons.lang3.BooleanUtils;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsIva;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 12 dic. 2023 - Elitebook
*/
@Entity
@Table(name = "sto_articulos")
public class StoArticulo extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cod_articulo")
	private String codArticulo;

	@Column(name = "descripcion")
	private String descripcion;

	@Column(name = "precio_unitario")
	private BigDecimal precioUnitario;

	@Column(name = "ind_inventariable")
	private String indInventariable;

	@Transient
	private boolean indInventariableAux;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;

	@ManyToOne
	@JoinColumn(name = "bs_iva_id", referencedColumnName = "id", nullable = false)
	private BsIva bsIva;

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

	public String getCodArticulo() {
		return codArticulo;
	}

	public void setCodArticulo(String codArticulo) {
		this.codArticulo = codArticulo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public BigDecimal getPrecioUnitario() {
		return precioUnitario;
	}

	public void setPrecioUnitario(BigDecimal precioUnitario) {
		this.precioUnitario = precioUnitario;
	}

	public String getIndInventariable() {
		return indInventariable;
	}

	public void setIndInventariable(String indInventariable) {
		this.indInventariable = indInventariable;
	}

	public boolean isIndInventariableAux() {
		if (!Objects.isNull(this.indInventariable)) {
			indInventariableAux = BooleanUtils.isTrue("S".equals(this.indInventariable));
		}
		return indInventariableAux;
	}

	public void setIndInventariableAux(boolean indInventariableAux) {
		indInventariable = indInventariableAux ? "S" : "N";
		this.indInventariableAux = indInventariableAux;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public BsIva getBsIva() {
		return bsIva;
	}

	public void setBsIva(BsIva bsIva) {
		this.bsIva = bsIva;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, bsIva, codArticulo, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		StoArticulo other = (StoArticulo) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(bsIva, other.bsIva)
				&& Objects.equals(codArticulo, other.codArticulo) && Objects.equals(id, other.id);
	}

}
