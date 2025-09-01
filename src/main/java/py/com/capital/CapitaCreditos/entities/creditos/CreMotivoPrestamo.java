package py.com.capital.CapitaCreditos.entities.creditos;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 26 dic. 2023 - Elitebook
*/
@Entity
@Table(name = "cre_motivos_prestamos",uniqueConstraints =
@UniqueConstraint(name= "cre_motivos_prestamos_unique_codigo" ,columnNames = {"cod_motivo"}))
public class CreMotivoPrestamo extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "cod_motivo")
    private String codMotivo;
	
	@Column(name = "descripcion")
    private String descripcion;
	
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

	public String getCodMotivo() {
		return codMotivo;
	}

	public void setCodMotivo(String codMotivo) {
		this.codMotivo = codMotivo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	@Override
	public int hashCode() {
		return Objects.hash(codMotivo, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		CreMotivoPrestamo other = (CreMotivoPrestamo) obj;
		return Objects.equals(codMotivo, other.codMotivo) && Objects.equals(id, other.id);
	}
	
	

}

