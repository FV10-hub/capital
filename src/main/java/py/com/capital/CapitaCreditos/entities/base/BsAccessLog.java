package py.com.capital.CapitaCreditos.entities.base;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 24 nov. 2023 - Elitebook
*/
@Entity
@Table(name = "bs_access_log")
public class BsAccessLog extends Common {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cod_usuario")
	private String codUsuario;

	@Column(name = "ip_address")
    private String ipAddress;

	@Column(name = "success")
	private String success;

    public BsAccessLog() {
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

	public String getIpAddress() {
		return ipAddress;
	}

	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}

	public String getSuccess() {
		return success;
	}

	public void setSuccess(String success) {
		this.success = success;
	}
}
