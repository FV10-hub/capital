package py.com.capital.CapitaCreditos.entities.base;

import javax.persistence.*;

import java.io.Serializable;
import java.time.LocalDateTime;

/*
* 29 nov. 2023 - Elitebook
*/
@Entity
@Table(name = "bs_tipo_valor",uniqueConstraints =
@UniqueConstraint(name= "bs_tipo_valor_unique_cod_modulo" ,columnNames = {"cod_tipo","id_bs_modulo"}))
public class BsTipoValor extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cod_tipo")
	private String codTipo;

	@Column(name = "descripcion")
	private String descripcion;

	// solo para ejemplo
	@Column(name = "usa_efectivo")
	private String usaEfectivo;

	@ManyToOne(optional = false)
	@JoinColumn(name = "id_bs_modulo")
	private BsModulo bsModulo;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;

	// solo para ejemplo de uso buleano
	@Transient
	private boolean usaDineroAux;

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

	public String getCodTipo() {
		return codTipo;
	}

	public void setCodTipo(String codTipo) {
		this.codTipo = codTipo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getUsaEfectivo() {
		return usaEfectivo;
	}

	public void setUsaEfectivo(String usaEfectivo) {
		this.usaEfectivo = usaEfectivo;
	}

	public BsModulo getBsModulo() {
		return bsModulo;
	}

	public void setBsModulo(BsModulo bsModulo) {
		this.bsModulo = bsModulo;
	}

	public boolean isUsaDineroAux() {
		// esto solo es para usar elementos chekbox en el html
		if (usaEfectivo != null) {
			usaDineroAux = usaEfectivo.equals("S");
		}
		return usaDineroAux;
	}

	public void setUsaDineroAux(boolean usaDineroAux) {
		usaEfectivo = usaDineroAux ? "S" : "N";
		this.usaDineroAux = usaDineroAux;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

}
