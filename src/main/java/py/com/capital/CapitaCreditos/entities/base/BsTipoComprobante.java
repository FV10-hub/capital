package py.com.capital.CapitaCreditos.entities.base;

import jakarta.persistence.*;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 29 nov. 2023 - Elitebook
*/
@Entity
@Table(name = "bs_tipo_comprobantes")
public class BsTipoComprobante extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cod_tip_comprobante")
	private String codTipoComprobante;

	@Column(name = "descripcion")
	private String descripcion;

	@Column(name = "ind_saldo")
	private String indSaldo;

	@Column(name = "ind_stock")
	private String indStock;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;

	@ManyToOne
	@JoinColumn(name = "bs_modulo_id", referencedColumnName = "id", nullable = false)
	private BsModulo bsModulo;

	@Transient
	private boolean indStockAux;
	
	@Transient
	private boolean indSaldoAux;

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

	public String getCodTipoComprobante() {
		return codTipoComprobante;
	}

	public void setCodTipoComprobante(String codTipoComprobante) {
		this.codTipoComprobante = codTipoComprobante;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getIndSaldo() {
		return indSaldo;
	}

	public void setIndSaldo(String indSaldo) {
		this.indSaldo = indSaldo;
	}

	public String getIndStock() {
		return indStock;
	}

	public void setIndStock(String indStock) {
		this.indStock = indStock;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public BsModulo getBsModulo() {
		return bsModulo;
	}

	public void setBsModulo(BsModulo bsModulo) {
		this.bsModulo = bsModulo;
	}

	public boolean isIndStockAux() {
		if (indStock != null) {
			indStockAux = indStock.equals("S");
		}
		return indStockAux;
	}

	public void setIndStockAux(boolean indStockAux) {
		indStock = indStockAux ? "S" : "N";
		this.indStockAux = indStockAux;
	}

	public boolean isIndSaldoAux() {
		if (indSaldo != null) {
			indSaldoAux = indSaldo.equals("S");
		}
		return indSaldoAux;
	}

	public void setIndSaldoAux(boolean indSaldoAux) {
		indSaldo = indSaldoAux ? "S" : "N";
		this.indSaldoAux = indSaldoAux;
	}

	public BsTipoComprobante() {
		super();
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, bsModulo, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BsTipoComprobante other = (BsTipoComprobante) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(bsModulo, other.bsModulo)
				&& Objects.equals(id, other.id);
	}

}
