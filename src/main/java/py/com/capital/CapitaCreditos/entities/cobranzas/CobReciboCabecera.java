package py.com.capital.CapitaCreditos.entities.cobranzas;
/*
* 15 ene. 2024 - Elitebook
*/

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.entities.base.Common;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;


@Entity
@Table(name = "cob_recibos_cabecera", 
uniqueConstraints = 
@UniqueConstraint(name = 
"cob_recibos_cabecera_uniques", columnNames = {
"nro_recibo_completo", "bs_talonario_id", "bs_empresa_id" }))
public class CobReciboCabecera extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_recibo")
	private LocalDate fechaRecibo;
	
	@Column(name = "observacion")
	private String observacion;
	
	@Column(name = "nro_recibo")
	private Long nroRecibo;
	
	@Column(name = "nro_recibo_completo")
	private String nroReciboCompleto;
	
	@Column(name = "ind_impreso")
	private String indImpreso;

	@Transient
	private boolean indImpresoBoolean;

	@Column(name = "ind_cobrado")
	private String indCobrado;
	
	@Column(name = "monto_total_recibo")
	private BigDecimal montoTotalRecibo;
	
	@ManyToOne
	@JoinColumn(name = "cob_cliente_id", referencedColumnName = "id", nullable = false)
	private CobCliente cobCliente;
	
	@ManyToOne
	@JoinColumn(name = "cob_cobrador_id", referencedColumnName = "id", nullable = false)
	private CobCobrador cobCobrador;
	
	@OneToOne
	@JoinColumn(name = "cob_habilitacion_id", referencedColumnName = "id", nullable = false)
	private CobHabilitacionCaja cobHabilitacionCaja;
	
	@OneToOne
	@JoinColumn(name = "bs_talonario_id", referencedColumnName = "id", nullable = true)
	private BsTalonario bsTalonario;
	
	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;
	
	@OneToMany(mappedBy = "cobReciboCabecera", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private List<CobReciboDetalle> cobReciboDetalleList;
	
	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}

	public CobReciboCabecera() {
		this.cobReciboDetalleList = new ArrayList<>();
		this.montoTotalRecibo = BigDecimal.ZERO;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public LocalDate getFechaRecibo() {
		return fechaRecibo;
	}

	public void setFechaRecibo(LocalDate fechaRecibo) {
		this.fechaRecibo = fechaRecibo;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public Long getNroRecibo() {
		return nroRecibo;
	}

	public void setNroRecibo(Long nroRecibo) {
		this.nroRecibo = nroRecibo;
	}

	public String getIndImpreso() {
		return indImpreso;
	}

	public void setIndImpreso(String indImpreso) {
		this.indImpreso = indImpreso;
	}

	public boolean isIndImpresoBoolean() {
		if (!Objects.isNull(indImpreso)) {
			indImpresoBoolean = "S".equalsIgnoreCase(indImpreso);
		}
		return indImpresoBoolean;
	}

	public void setIndImpresoBoolean(boolean indImpresoBoolean) {
		indImpreso = indImpresoBoolean ? "S" : "N";
		this.indImpresoBoolean = indImpresoBoolean;
	}

	public BigDecimal getMontoTotalRecibo() {
		return montoTotalRecibo;
	}

	public void setMontoTotalRecibo(BigDecimal montoTotalRecibo) {
		this.montoTotalRecibo = montoTotalRecibo;
	}

	public CobCliente getCobCliente() {
		return cobCliente;
	}

	public void setCobCliente(CobCliente cobCliente) {
		this.cobCliente = cobCliente;
	}

	public CobCobrador getCobCobrador() {
		return cobCobrador;
	}

	public void setCobCobrador(CobCobrador cobCobrador) {
		this.cobCobrador = cobCobrador;
	}

	public CobHabilitacionCaja getCobHabilitacionCaja() {
		return cobHabilitacionCaja;
	}

	public void setCobHabilitacionCaja(CobHabilitacionCaja cobHabilitacionCaja) {
		this.cobHabilitacionCaja = cobHabilitacionCaja;
	}

	public BsTalonario getBsTalonario() {
		return bsTalonario;
	}

	public void setBsTalonario(BsTalonario bsTalonario) {
		this.bsTalonario = bsTalonario;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public List<CobReciboDetalle> getCobReciboDetalleList() {
		return cobReciboDetalleList;
	}

	public void setCobReciboDetalleList(List<CobReciboDetalle> cobReciboDetalleList) {
		this.cobReciboDetalleList = cobReciboDetalleList;
	}
	
	public String getNroReciboCompleto() {
		return nroReciboCompleto;
	}

	public void setNroReciboCompleto(String nroReciboCompleto) {
		this.nroReciboCompleto = nroReciboCompleto;
	}

	public String getIndCobrado() {
		return indCobrado;
	}

	public void setIndCobrado(String indCobrado) {
		this.indCobrado = indCobrado;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, bsTalonario, cobCliente, cobCobrador, cobHabilitacionCaja, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		CobReciboCabecera other = (CobReciboCabecera) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(bsTalonario, other.bsTalonario)
				&& Objects.equals(cobCliente, other.cobCliente) && Objects.equals(cobCobrador, other.cobCobrador)
				&& Objects.equals(cobHabilitacionCaja, other.cobHabilitacionCaja) && Objects.equals(id, other.id);
	}
	
	public void addDetalle(CobReciboDetalle detalle) {
		if (!Objects.isNull(detalle)) {
			this.cobReciboDetalleList.add(detalle);
		}
	}
	
	public void setCabeceraADetalle() {
		if (!Objects.isNull(this.cobReciboDetalleList)) {
			this.cobReciboDetalleList.forEach(detalle -> {
				detalle.setCobReciboCabecera(this);
			});
		}
	}

	public void calcularTotales() {
		if (!Objects.isNull(this.cobReciboDetalleList)) {
			this.cobReciboDetalleList.forEach(detalle -> {
				this.montoTotalRecibo = this.montoTotalRecibo.add(detalle.getMontoPagado());
			});
		}
	}
	
}

