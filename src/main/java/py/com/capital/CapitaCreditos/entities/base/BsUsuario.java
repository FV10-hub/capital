package py.com.capital.CapitaCreditos.entities.base;

import javax.persistence.*;
import org.jasypt.util.password.StrongPasswordEncryptor;

import java.time.Duration;
import java.time.LocalDateTime;

/**
 * Aug 25, 2023 fvazquez
 * 
 */
@Entity
@Table(name = "bs_usuario",uniqueConstraints =
@UniqueConstraint(name= "bs_usuario_unique_cod_pers_empresa" ,columnNames = {"cod_usuario","id_bs_persona","bs_empresa_id"}))
public class BsUsuario extends Common {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cod_usuario")
	private String codUsuario;

	@Column(name = "password")
	private String password;

	@Column(name = "intentos_fallidos")
	private Integer intentosFallidos = 0;

	@Column(name = "bloqueado_hasta")
	private LocalDateTime bloqueadoHasta;

	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "id_bs_persona")
	private BsPersona bsPersona;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "id_bs_rol")
	private BsRol rol;

	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = true)
	private BsEmpresa bsEmpresa;

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

	public String getCodUsuario() {
		return codUsuario;
	}

	public void setCodUsuario(String codUsuario) {
		this.codUsuario = codUsuario;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public BsPersona getBsPersona() {
		return bsPersona;
	}

	public void setBsPersona(BsPersona bsPersona) {
		this.bsPersona = bsPersona;
	}

	public BsRol getRol() {
		return rol;
	}

	public void setRol(BsRol rol) {
		this.rol = rol;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	/*public void encryptPassword() {
		StrongPasswordEncryptor passwordEncryptor = new StrongPasswordEncryptor();
		this.password = passwordEncryptor.encryptPassword(this.password);
	}*/

	public Integer getIntentosFallidos() {
		return intentosFallidos;
	}

	public void setIntentosFallidos(Integer intentosFallidos) {
		this.intentosFallidos = intentosFallidos;
	}

	public LocalDateTime getBloqueadoHasta() {
		return bloqueadoHasta;
	}

	public void setBloqueadoHasta(LocalDateTime bloqueadoHasta) {
		this.bloqueadoHasta = bloqueadoHasta;
	}

	// Método para verificar la contraseña al hacer login
	/*public boolean checkPassword(String inputPassword) {
		StrongPasswordEncryptor passwordEncryptor = new StrongPasswordEncryptor();
		return passwordEncryptor.checkPassword(inputPassword, this.password);
	}*/

	public boolean estaBloqueado() {
		return bloqueadoHasta != null && LocalDateTime.now().isBefore(bloqueadoHasta);
	}

	public void registrarFallo(int maxIntentos, Duration lockDuration) {
		this.intentosFallidos += 1;
		if (this.intentosFallidos >= maxIntentos) {
			this.bloqueadoHasta = LocalDateTime.now().plus(lockDuration);
			this.intentosFallidos = 0;
		}
	}

	public void registrarExito() {
		this.intentosFallidos = 0;
		this.bloqueadoHasta = null;
	}

	public String getPersonaNombreCompleto() {
		return bsPersona != null ? bsPersona.getNombreCompleto() : null;
	}

}
