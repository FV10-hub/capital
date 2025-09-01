package py.com.capital.CapitaCreditos.entities.base;
/**
* Aug 30, 2023-5:34:18 PM-fvazquez
**/

import javax.persistence.*;

import java.time.LocalDateTime;


@Entity
@Table(name = "bs_permiso_rol",uniqueConstraints =
@UniqueConstraint(name= "bs_permiso_rol_unique_codigo" ,columnNames = {"id_bs_rol","id_bs_menu"}))
public class BsPermisoRol extends Common {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "descripcion")
    private String descripcion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_bs_rol")
	private BsRol rol;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_bs_menu")
	private BsMenu bsMenu;
	
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

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public BsRol getRol() {
		return rol;
	}

	public void setRol(BsRol rol) {
		this.rol = rol;
	}

	public BsMenu getBsMenu() {
		return bsMenu;
	}

	public void setBsMenu(BsMenu bsMenu) {
		this.bsMenu = bsMenu;
	}
	
	

}
