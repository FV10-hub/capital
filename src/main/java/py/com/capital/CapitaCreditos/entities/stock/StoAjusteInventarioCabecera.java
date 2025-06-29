package py.com.capital.CapitaCreditos.entities.stock;

import jakarta.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/*
* 12 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "sto_ajuste_inventarios_cabecera", 
uniqueConstraints = 
@UniqueConstraint(name = 
"sto_ajuste_inventarios_cabecera_uniques", columnNames = {
"nro_operacion", "tipo_operacion" }))
public class StoAjusteInventarioCabecera extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_operacion")
	private LocalDate fechaOperacion;

	@Column(name = "observacion")
	private String observacion;

	// ENTRADA O SALIDA
	@Column(name = "tipo_operacion")
	private String tipoOperacion;
	
	@Column(name = "nro_operacion")
	private Long nroOperacion;
	
	@Column(name = "ind_autorizado")
	private String indAutorizado;

	@Transient
	private boolean indAutorizadoBoolean;
	
	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;
	
	@OneToMany(mappedBy = "stoAjusteInventarioCabecera", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private List<StoAjusteInventarioDetalle> stoAjusteInventarioDetalleList;
	
	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}

	public StoAjusteInventarioCabecera() {
		this.stoAjusteInventarioDetalleList = new ArrayList<>();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public LocalDate getFechaOperacion() {
		return fechaOperacion;
	}

	public void setFechaOperacion(LocalDate fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public String getTipoOperacion() {
		return tipoOperacion;
	}

	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}

	public Long getNroOperacion() {
		return nroOperacion;
	}

	public void setNroOperacion(Long nroOperacion) {
		this.nroOperacion = nroOperacion;
	}

	public String getIndAutorizado() {
		return indAutorizado;
	}

	public void setIndAutorizado(String indAutorizado) {
		this.indAutorizado = indAutorizado;
	}

	public boolean isIndAutorizadoBoolean() {
		if (!Objects.isNull(indAutorizado)) {
			indAutorizadoBoolean = "S".equalsIgnoreCase(indAutorizado);
		}
		return indAutorizadoBoolean;
	}

	public void setIndAutorizadoBoolean(boolean indAutorizadoBoolean) {
		indAutorizado = indAutorizadoBoolean ? "S" : "N";
		this.indAutorizadoBoolean = indAutorizadoBoolean;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public List<StoAjusteInventarioDetalle> getStoAjusteInventarioDetalleList() {
		return stoAjusteInventarioDetalleList;
	}

	public void setStoAjusteInventarioDetalleList(List<StoAjusteInventarioDetalle> stoAjusteInventarioDetalleList) {
		this.stoAjusteInventarioDetalleList = stoAjusteInventarioDetalleList;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, nroOperacion, tipoOperacion);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		StoAjusteInventarioCabecera other = (StoAjusteInventarioCabecera) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(nroOperacion, other.nroOperacion)
				&& Objects.equals(tipoOperacion, other.tipoOperacion);
	}
	
	public void addDetalle(StoAjusteInventarioDetalle detalle) {
		if (!Objects.isNull(detalle)) {
			this.stoAjusteInventarioDetalleList.add(detalle);
		}
	}

	public void setCabeceraADetalle() {
		if (!Objects.isNull(this.stoAjusteInventarioDetalleList)) {
			this.stoAjusteInventarioDetalleList.forEach(detalle -> {
				detalle.setStoAjusteInventarioCabecera(this);
			});
		}
	}
	
	

}

