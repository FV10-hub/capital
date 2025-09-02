package py.com.capital.CapitaCreditos.entities.base;
/**
* Aug 30, 2023-5:34:18 PM-fvazquez
**/

import py.com.capital.CapitaCreditos.entities.converter.SiNoBooleanConverter;

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

	@Convert(converter = SiNoBooleanConverter.class)
	@Column(name = "puede_crear", nullable = false, length = 1)
	private Boolean puedeCrear;

	@Convert(converter = SiNoBooleanConverter.class)
	@Column(name = "puede_editar", nullable = false, length = 1)
	private Boolean puedeEditar;

	@Convert(converter = SiNoBooleanConverter.class)
	@Column(name = "puede_eliminar", nullable = false, length = 1)
	private Boolean puedeEliminar;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_bs_rol")
	private BsRol rol;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_bs_menu")
	private BsMenu bsMenu;
	
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

	public Boolean getPuedeCrear() {
		return puedeCrear;
	}

	public void setPuedeCrear(Boolean puedeCrear) {
		this.puedeCrear = puedeCrear;
	}

	public Boolean getPuedeEditar() {
		return puedeEditar;
	}

	public void setPuedeEditar(Boolean puedeEditar) {
		this.puedeEditar = puedeEditar;
	}

	public Boolean getPuedeEliminar() {
		return puedeEliminar;
	}

	public void setPuedeEliminar(Boolean puedeEliminar) {
		this.puedeEliminar = puedeEliminar;
	}
}
