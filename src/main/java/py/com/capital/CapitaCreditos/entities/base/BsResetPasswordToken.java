package py.com.capital.CapitaCreditos.entities.base;

import javax.persistence.*;
import java.time.LocalDateTime;

/*
* 24 nov. 2023 - Elitebook
*/
@Entity
@Table(name = "bs_reset_password_token")
public class BsResetPasswordToken extends Common {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cod_usuario")
	private String codUsuario;

	@Column(name = "token")
    private String token;

	@Column(name = "validated")
	private String validated;

	@Column(name = "expires_at")
	private LocalDateTime expiredAt;

    public BsResetPasswordToken() {
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

	public String getCodUsuario() {
		return codUsuario;
	}

	public void setCodUsuario(String codUsuario) {
		this.codUsuario = codUsuario;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getValidated() {
		return validated;
	}

	public void setValidated(String validated) {
		this.validated = validated;
	}

	public LocalDateTime getExpiredAt() {
		return expiredAt;
	}

	public void setExpiredAt(LocalDateTime expiredAt) {
		this.expiredAt = expiredAt;
	}
}
