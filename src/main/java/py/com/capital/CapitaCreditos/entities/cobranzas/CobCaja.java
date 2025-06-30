package py.com.capital.CapitaCreditos.entities.cobranzas;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.time.LocalDateTime;

/*
* 28 dic. 2023 - Elitebook
*/
@Entity
@Table(name = "cob_cajas")
public class CobCaja extends Common implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "cod_caja")
    private String codCaja;
	
	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "bs_usuario_id")
	private BsUsuario bsUsuario;
	
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

	public String getCodCaja() {
		return codCaja;
	}

	public void setCodCaja(String codCaja) {
		this.codCaja = codCaja;
	}

	public BsUsuario getBsUsuario() {
		return bsUsuario;
	}

	public void setBsUsuario(BsUsuario bsUsuario) {
		this.bsUsuario = bsUsuario;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}
	

}

