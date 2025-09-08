package py.com.capital.CapitaCreditos.entities.cobranzas;

import javax.persistence.*;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsPersona;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 1 dic. 2023 - Elitebook
*/
@Entity
@Table(name = "cob_cobradores", uniqueConstraints = @UniqueConstraint(name= "cob_cobradores_unique_persona_empresa" ,
columnNames = {"cod_cobrador", "bs_empresa_id", "id_bs_persona"}))
@DynamicInsert
public class CobCobrador extends Common implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "cod_cobrador", insertable = false, updatable = false)
	@Generated(GenerationTime.INSERT) //esta conf. va de la mano con DynamicInsert para que no se mande si esta null
    private String codCobrador;
	
	@OneToOne()
	@JoinColumn(name = "id_bs_persona")
	private BsPersona bsPersona;
	
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

	public CobCobrador() {
		super();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodCobrador() {
		return codCobrador;
	}

	public void setCodCobrador(String codCobrador) {
		this.codCobrador = codCobrador;
	}

	public BsPersona getBsPersona() {
		return bsPersona;
	}

	public void setBsPersona(BsPersona bsPersona) {
		this.bsPersona = bsPersona;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, bsPersona, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		CobCobrador other = (CobCobrador) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(bsPersona, other.bsPersona)
				&& Objects.equals(id, other.id);
	}

	
	
	
}

