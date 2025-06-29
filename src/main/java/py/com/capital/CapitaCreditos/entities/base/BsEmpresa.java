package py.com.capital.CapitaCreditos.entities.base;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.Objects;

/*
* 24 nov. 2023 - Elitebook
*/
@Entity
@Table(name = "bs_empresas", uniqueConstraints = @UniqueConstraint(name= "bs_empresas_unique_persona" ,columnNames = {"bs_personas_id"}))
public class BsEmpresa  extends Common {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "nombre_fantasia")
	private String nombreFantasia;
    
	@Column(name = "direc_empresa")
    private String direcEmpresa;
	
	@ManyToOne
	@JoinColumn(name = "bs_personas_id", referencedColumnName = "id",nullable = false)
    private BsPersona bsPersona;

    public BsEmpresa() {
    }
	
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

	public String getNombreFantasia() {
		return nombreFantasia;
	}

	public void setNombreFantasia(String nombreFantasia) {
		this.nombreFantasia = nombreFantasia;
	}

	public String getDirecEmpresa() {
		return direcEmpresa;
	}

	public void setDirecEmpresa(String direcEmpresa) {
		this.direcEmpresa = direcEmpresa;
	}

	public BsPersona getBsPersona() {
		return bsPersona;
	}

	public void setBsPersona(BsPersona bsPersona) {
		this.bsPersona = bsPersona;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsPersona, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BsEmpresa other = (BsEmpresa) obj;
		return Objects.equals(bsPersona, other.bsPersona) && Objects.equals(id, other.id);
	}
	
	

}
