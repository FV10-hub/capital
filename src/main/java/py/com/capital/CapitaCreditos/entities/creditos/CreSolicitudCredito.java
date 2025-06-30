package py.com.capital.CapitaCreditos.entities.creditos;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.entities.ventas.VenVendedor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/*
* 26 dic. 2023 - Elitebook
*/
@Entity
@Table(name = "cre_solicitudes_creditos")
public class CreSolicitudCredito  extends Common implements Serializable {
	
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "fecha_solicitud")
	private LocalDate fechaSolicitud;
	
	@Column(name = "primer_vencimiento")
	private LocalDate primerVencimiento;
	
	@Column(name = "plazo")
    private int plazo;
	
	@Column(name = "monto_solicitado")
    private BigDecimal montoSolicitado;
	
	@Column(name = "monto_aprobado")
    private BigDecimal montoAprobado;
	
	@Column(name = "ind_autorizado")
    private String indAutorizado;
	
	@Column(name = "ind_desembolsado")
    private String indDesembolsado;
	
	@Transient
	private boolean indAutorizadoBoolean;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;
	
	@ManyToOne
	@JoinColumn(name = "cob_cliente_id", referencedColumnName = "id", nullable = false)
	private CobCliente cobCliente;
	
	@ManyToOne
	@JoinColumn(name = "ven_vendedor_id", referencedColumnName = "id", nullable = false)
	private VenVendedor venVendedor;
	
	@ManyToOne
	@JoinColumn(name = "cre_motivos_prestamos_id", referencedColumnName = "id", nullable = false)
	private CreMotivoPrestamo creMotivoPrestamo ;
	
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

	public LocalDate getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(LocalDate fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public LocalDate getPrimerVencimiento() {
		return primerVencimiento;
	}

	public void setPrimerVencimiento(LocalDate primerVencimiento) {
		this.primerVencimiento = primerVencimiento;
	}

	public int getPlazo() {
		return plazo;
	}

	public void setPlazo(int plazo) {
		this.plazo = plazo;
	}

	public BigDecimal getMontoSolicitado() {
		return montoSolicitado;
	}

	public void setMontoSolicitado(BigDecimal montoSolicitado) {
		this.montoSolicitado = montoSolicitado;
	}

	public BigDecimal getMontoAprobado() {
		return montoAprobado;
	}

	public void setMontoAprobado(BigDecimal montoAprobado) {
		this.montoAprobado = montoAprobado;
	}

	public String getIndDesembolsado() {
		return indDesembolsado;
	}

	public void setIndDesembolsado(String indDesembolsado) {
		this.indDesembolsado = indDesembolsado;
	}

	public boolean isIndAutorizadoBoolean() {
		if (indAutorizado != null) {
			indAutorizadoBoolean = indAutorizado.equals("S");
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

	public CobCliente getCobCliente() {
		return cobCliente;
	}

	public void setCobCliente(CobCliente cobCliente) {
		this.cobCliente = cobCliente;
	}

	public VenVendedor getVenVendedor() {
		return venVendedor;
	}

	public void setVenVendedor(VenVendedor venVendedor) {
		this.venVendedor = venVendedor;
	}

	public CreMotivoPrestamo getCreMotivoPrestamo() {
		return creMotivoPrestamo;
	}

	public void setCreMotivoPrestamo(CreMotivoPrestamo creMotivoPrestamo) {
		this.creMotivoPrestamo = creMotivoPrestamo;
	}

	public String getIndAutorizado() {
		return indAutorizado;
	}

	public void setIndAutorizado(String indAutorizado) {
		this.indAutorizado = indAutorizado;
	}
	
	
	
}

