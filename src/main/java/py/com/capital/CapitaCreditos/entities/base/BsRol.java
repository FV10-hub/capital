package py.com.capital.CapitaCreditos.entities.base;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Aug 25, 2023 fvazquez
 * 
 */
@Entity
@Table(name = "bs_rol", uniqueConstraints = @UniqueConstraint(name= "bs_rol_unique_nombre" ,columnNames = {"nombre"}))
public class BsRol extends Common {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "nombre", length = 45, nullable = false)
	private String nombre;
	
	@OneToMany(mappedBy = "rol", fetch = FetchType.EAGER)
    private Set<BsUsuario> bsUsuariosSet;
	
	@OneToMany(mappedBy = "rol", fetch = FetchType.EAGER)
    private Set<BsPermisoRol> bsPermisoRol;
	
	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
		this.bsUsuariosSet = new HashSet<BsUsuario>();
		this.bsPermisoRol = new HashSet<BsPermisoRol>();
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Set<BsUsuario> getBsUsuariosSet() {
		return bsUsuariosSet;
	}

	public void setBsUsuariosSet(Set<BsUsuario> bsUsuariosSet) {
		this.bsUsuariosSet = bsUsuariosSet;
	}



}
