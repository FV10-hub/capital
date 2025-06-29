package py.com.capital.CapitaCreditos.entities.creditos;

import jakarta.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.stock.StoArticulo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 4 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "cre_desembolso_detalle")
public class CreDesembolsoDetalle extends Common implements Serializable {
	
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column
	private Integer cantidad;
	
	@Column(name = "nro_cuota")
	private Integer nroCuota;
	
	@Column(name = "fecha_vencimiento")
	private LocalDate fechaVencimiento;
	
	@Column(name = "monto_capital")
    private BigDecimal montoCapital;
	
	@Column(name = "monto_interes")
    private BigDecimal montoInteres;
	
	@Column(name = "monto_iva")
    private BigDecimal montoIva;
	
	@Column(name = "monto_cuota")
    private BigDecimal montoCuota;
	
	@ManyToOne
	@JoinColumn(name = "sto_articulo_id")
	private StoArticulo stoArticulo;
	
	@ManyToOne
	@JoinColumn(name = "cre_desembolso_cabecera_id")
	private CreDesembolsoCabecera creDesembolsoCabecera;
	
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

	public Integer getCantidad() {
		return cantidad;
	}

	public void setCantidad(Integer cantidad) {
		this.cantidad = cantidad;
	}

	public Integer getNroCuota() {
		return nroCuota;
	}

	public void setNroCuota(Integer nroCuota) {
		this.nroCuota = nroCuota;
	}

	public BigDecimal getMontoCapital() {
		return montoCapital;
	}

	public void setMontoCapital(BigDecimal montoCapital) {
		this.montoCapital = montoCapital;
	}

	public BigDecimal getMontoInteres() {
		return montoInteres;
	}

	public void setMontoInteres(BigDecimal montoInteres) {
		this.montoInteres = montoInteres;
	}

	public BigDecimal getMontoIva() {
		return montoIva;
	}

	public void setMontoIva(BigDecimal montoIva) {
		this.montoIva = montoIva;
	}

	public BigDecimal getMontoCuota() {
		return montoCuota;
	}

	public void setMontoCuota(BigDecimal montoCuota) {
		this.montoCuota = montoCuota;
	}

	public StoArticulo getStoArticulo() {
		return stoArticulo;
	}

	public void setStoArticulo(StoArticulo stoArticulo) {
		this.stoArticulo = stoArticulo;
	}

	public CreDesembolsoCabecera getCreDesembolsoCabecera() {
		return creDesembolsoCabecera;
	}

	public void setCreDesembolsoCabecera(CreDesembolsoCabecera creDesembolsoCabecera) {
		this.creDesembolsoCabecera = creDesembolsoCabecera;
	}

	public LocalDate getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(LocalDate fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	@Override
	public int hashCode() {
		return Objects.hash(creDesembolsoCabecera, id, nroCuota, stoArticulo);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		CreDesembolsoDetalle other = (CreDesembolsoDetalle) obj;
		return Objects.equals(creDesembolsoCabecera, other.creDesembolsoCabecera) && Objects.equals(id, other.id)
				&& Objects.equals(nroCuota, other.nroCuota) && Objects.equals(stoArticulo, other.stoArticulo);
	}
	
	

}

