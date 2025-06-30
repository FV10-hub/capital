package py.com.capital.CapitaCreditos.entities.base;

import javax.persistence.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Aug 25, 2023 fvazquez
 * 
 */
@Entity
@Table(name = "bs_persona", uniqueConstraints = @UniqueConstraint(name= "bs_persona_unique_documento" ,columnNames = {"documento"}))
public class BsPersona extends Common {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "nombre", length = 100, nullable = false)
	private String nombre;

	@Column(name = "primer_apellido", length = 100, nullable = false)
	private String primerApellido;

	@Column(name = "segundo_apellido", length = 45)
	private String segundoApellido;

	@Column(name = "nombre_completo", length = 100)
	private String nombreCompleto;

	@Column(name = "imagen", length = 100)
	private String imagen;

	@Column(name = "email", length = 50)
	private String email;

	@Column(name = "fec_nacimiento")
	private LocalDate fecNacimiento;

	@Column(name = "documento", length = 50)
	private String documento;

	public BsPersona() {

	}

	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}

	// GETTERS & SETTERS
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

	public String getPrimerApellido() {
		return primerApellido;
	}

	public void setPrimerApellido(String primerApellido) {
		this.primerApellido = primerApellido;
	}

	public String getSegundoApellido() {
		return segundoApellido;
	}

	public void setSegundoApellido(String segundoApellido) {
		this.segundoApellido = segundoApellido;
	}

	public String getImagen() {
		return imagen;
	}

	public void setImagen(String imagen) {
		this.imagen = imagen;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public LocalDate getFecNacimiento() {
		return fecNacimiento;
	}

	public void setFecNacimiento(LocalDate fecNacimiento) {
		this.fecNacimiento = fecNacimiento;
	}

	public String getDocumento() {
		return documento;
	}

	public void setDocumento(String documento) {
		this.documento = documento;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	@Override
	public int hashCode() {
		return Objects.hash(email, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BsPersona other = (BsPersona) obj;
		return Objects.equals(email, other.email) && Objects.equals(id, other.id);
	}

}
