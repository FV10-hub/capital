package py.com.capital.CapitaCreditos.entities.cobranzas;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 28 dic. 2023 - Elitebook
*/
@Entity
@Table(name = "cob_habilitaciones_cajas", uniqueConstraints = @UniqueConstraint(name = "bs_empresas_unique_persona", columnNames = {
		"nro_habilitacion" }))
public class CobHabilitacionCaja extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_apertura")
	private LocalDateTime fechaApertura;

	@Column(name = "fecha_cierre")
	private LocalDateTime fechaCierre;

	@Column(name = "hora_apertura")
	private String horaApertura;

	@Column(name = "hora_cierre")
	private String horaCierre;

	@Column(name = "nro_habilitacion")
	private BigDecimal nroHabilitacion;

	@Column(name = "ind_cerrado")
	private String indCerrado;

	@Transient
	private boolean indCerradoBoolean;

	@ManyToOne
	@JoinColumn(name = "bs_usuario_id", referencedColumnName = "id", nullable = false)
	private BsUsuario bsUsuario;

	@ManyToOne
	@JoinColumn(name = "bs_cajas_id", referencedColumnName = "id", nullable = false)
	private CobCaja cobCaja;

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

	public LocalDateTime getFechaApertura() {
		return fechaApertura;
	}

	public void setFechaApertura(LocalDateTime fechaApertura) {
		this.fechaApertura = fechaApertura;
	}

	public LocalDateTime getFechaCierre() {
		return fechaCierre;
	}

	public void setFechaCierre(LocalDateTime fechaCierre) {
		this.fechaCierre = fechaCierre;
	}

	public String getHoraApertura() {
		return horaApertura;
	}

	public void setHoraApertura(String horaApertura) {
		this.horaApertura = horaApertura;
	}

	public String getHoraCierre() {
		return horaCierre;
	}

	public void setHoraCierre(String horaCierre) {
		this.horaCierre = horaCierre;
	}

	public BigDecimal getNroHabilitacion() {
		return nroHabilitacion;
	}

	public void setNroHabilitacion(BigDecimal nroHabilitacion) {
		this.nroHabilitacion = nroHabilitacion;
	}

	public BsUsuario getBsUsuario() {
		return bsUsuario;
	}

	public void setBsUsuario(BsUsuario bsUsuario) {
		this.bsUsuario = bsUsuario;
	}

	public CobCaja getCobCaja() {
		return cobCaja;
	}

	public void setCobCaja(CobCaja cobCaja) {
		this.cobCaja = cobCaja;
	}

	public String getIndCerrado() {
		return indCerrado;
	}

	public void setIndCerrado(String indCerrado) {
		this.indCerrado = indCerrado;
	}

	public boolean isIndCerradoBoolean() {
		if (indCerrado != null) {
			indCerradoBoolean = indCerrado.equals("S");
		}
		return indCerradoBoolean;
	}

	public void setIndCerradoBoolean(boolean indCerradoBoolean) {
		indCerrado = indCerradoBoolean ? "S" : "N";
		this.indCerradoBoolean = indCerradoBoolean;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsUsuario, cobCaja, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		CobHabilitacionCaja other = (CobHabilitacionCaja) obj;
		return Objects.equals(bsUsuario, other.bsUsuario) && Objects.equals(cobCaja, other.cobCaja)
				&& Objects.equals(id, other.id);
	}

}
