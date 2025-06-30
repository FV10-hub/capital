package py.com.capital.CapitaCreditos.entities.cobranzas;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/*
* 12 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "cob_saldos", uniqueConstraints = @UniqueConstraint(name = "cob_saldos_unique_persona_empresa", columnNames = {
		"bs_empresa_id", "cob_cliente_id", "id_comprobante","tipo_comprobante", "nro_cuota" }))
public class CobSaldo extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "id_comprobante")
	private Long idComprobate;

	// DESEMBOLSO, NCR(nota de credito) O FACTURA NORMAL
	@Column(name = "tipo_comprobante")
	private String tipoComprobante;
	
	@Column(name = "nro_comprobante_completo")
	private String nroComprobanteCompleto;
	
	@Column(name = "id_cuota")
	private Long idCuota;
	
	@Column(name = "nro_cuota")
	private Integer nroCuota;
	
	@Column(name = "monto_cuota")
    private BigDecimal montoCuota;
	
	@Column(name = "saldo_cuota")
    private BigDecimal saldoCuota;
	
	@Column(name = "fecha_vencimiento")
	private LocalDate fechaVencimiento;
	
	@ManyToOne
	@JoinColumn(name = "cob_cliente_id", referencedColumnName = "id", nullable = false)
	private CobCliente cobCliente;
	
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

	public Long getIdComprobate() {
		return idComprobate;
	}

	public void setIdComprobate(Long idComprobate) {
		this.idComprobate = idComprobate;
	}

	public String getTipoComprobante() {
		return tipoComprobante;
	}

	public void setTipoComprobante(String tipoComprobante) {
		this.tipoComprobante = tipoComprobante;
	}

	public String getNroComprobanteCompleto() {
		return nroComprobanteCompleto;
	}

	public void setNroComprobanteCompleto(String nroComprobanteCompleto) {
		this.nroComprobanteCompleto = nroComprobanteCompleto;
	}

	public Long getIdCuota() {
		return idCuota;
	}

	public void setIdCuota(Long idCuota) {
		this.idCuota = idCuota;
	}

	public Integer getNroCuota() {
		return nroCuota;
	}

	public void setNroCuota(Integer nroCuota) {
		this.nroCuota = nroCuota;
	}

	public BigDecimal getMontoCuota() {
		return montoCuota;
	}

	public void setMontoCuota(BigDecimal montoCuota) {
		this.montoCuota = montoCuota;
	}

	public BigDecimal getSaldoCuota() {
		return saldoCuota;
	}

	public void setSaldoCuota(BigDecimal saldoCuota) {
		this.saldoCuota = saldoCuota;
	}

	public LocalDate getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(LocalDate fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public CobCliente getCobCliente() {
		return cobCliente;
	}

	public void setCobCliente(CobCliente cobCliente) {
		this.cobCliente = cobCliente;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	
}
