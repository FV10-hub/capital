package py.com.capital.CapitaCreditos.entities.base;

import javax.persistence.*;

import java.io.Serializable;
import java.math.BigInteger;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 2 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "bs_timbrados")
public class BsTimbrado extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "nro_timbrado")
    private BigInteger nroTimbrado;
	
	@Column(name = "fecha_vigencia_desde")
	private LocalDate fechaVigenciaDesde;
	
	@Column(name = "fecha_vigencia_hasta")
	private LocalDate fechaVigenciaHasta;
	
	@Column(name = "cod_establecimiento")
    private String codEstablecimiento;
	
	@Column(name = "cod_expedicion")
    private String codExpedicion;
	
	@Column(name = "nro_desde")
    private BigInteger nroDesde;
	
	@Column(name = "nro_hasta")
    private BigInteger nroHasta;
	
	@Column(name = "ind_autoimpresor")
    private String indAutoimpresor;
	
	@Transient
	private boolean indAutoimpresorBoolean;
	
	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;
	
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

	public BigInteger getNroTimbrado() {
		return nroTimbrado;
	}

	public void setNroTimbrado(BigInteger nroTimbrado) {
		this.nroTimbrado = nroTimbrado;
	}

	public LocalDate getFechaVigenciaDesde() {
		return fechaVigenciaDesde;
	}

	public void setFechaVigenciaDesde(LocalDate fechaVigenciaDesde) {
		this.fechaVigenciaDesde = fechaVigenciaDesde;
	}

	public LocalDate getFechaVigenciaHasta() {
		return fechaVigenciaHasta;
	}

	public void setFechaVigenciaHasta(LocalDate fechaVigenciaHasta) {
		this.fechaVigenciaHasta = fechaVigenciaHasta;
	}

	public String getCodEstablecimiento() {
		return codEstablecimiento;
	}

	public void setCodEstablecimiento(String codEstablecimiento) {
		this.codEstablecimiento = codEstablecimiento;
	}

	public String getCodExpedicion() {
		return codExpedicion;
	}

	public void setCodExpedicion(String codExpedicion) {
		this.codExpedicion = codExpedicion;
	}

	public BigInteger getNroDesde() {
		return nroDesde;
	}

	public void setNroDesde(BigInteger nroDesde) {
		this.nroDesde = nroDesde;
	}

	public BigInteger getNroHasta() {
		return nroHasta;
	}

	public void setNroHasta(BigInteger nroHasta) {
		this.nroHasta = nroHasta;
	}

	public String getIndAutoimpresor() {
		return indAutoimpresor;
	}

	public void setIndAutoimpresor(String indAutoimpresor) {
		this.indAutoimpresor = indAutoimpresor;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public boolean isIndAutoimpresorBoolean() {
		if (indAutoimpresor != null) {
			indAutoimpresorBoolean = indAutoimpresor.equals("S");
		}
		return indAutoimpresorBoolean;
	}

	public void setIndAutoimpresorBoolean(boolean indAutoimpresorBoolean) {
		indAutoimpresor = indAutoimpresorBoolean ? "S" : "N";
		this.indAutoimpresorBoolean = indAutoimpresorBoolean;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, id, nroTimbrado);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BsTimbrado other = (BsTimbrado) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(id, other.id)
				&& Objects.equals(nroTimbrado, other.nroTimbrado);
	}
	
	

}

