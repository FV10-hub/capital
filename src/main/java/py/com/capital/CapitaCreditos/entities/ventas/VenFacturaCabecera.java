package py.com.capital.CapitaCreditos.entities.ventas;

import javax.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCliente;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/*
* 9 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "ven_facturas_cabecera", uniqueConstraints = @UniqueConstraint(name = "ven_fact_cab_unique_nroFact_des", columnNames = {
		"id_comprobante", "tipo_factura", "nro_factura_completo" }))
public class VenFacturaCabecera extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_factura")
	private LocalDate fechaFactura;

	@Column(name = "observacion")
	private String observacion;

	// DESEMBOLSO, NCR(nota de credito) O FACTURA NORMAL
	@Column(name = "tipo_factura")
	private String tipoFactura;

	@Column(name = "id_comprobante")
	private Long idComprobate;

	@Column(name = "nro_factura")
	private Long nroFactura;

	@Column(name = "nro_factura_completo")
	private String nroFacturaCompleto;

	@Column(name = "ind_impreso")
	private String indImpreso;

	@Transient
	private boolean indImpresoBoolean;

	@Column(name = "ind_cobrado")
	private String indCobrado;

	@Column(name = "monto_total_gravada")
	private BigDecimal montoTotalGravada;

	@Column(name = "monto_total_exenta")
	private BigDecimal montoTotalExenta;

	@Column(name = "monto_total_iva")
	private BigDecimal montoTotalIva;

	@Column(name = "monto_total_factura")
	private BigDecimal montoTotalFactura;

	@ManyToOne
	@JoinColumn(name = "cob_cliente_id", referencedColumnName = "id", nullable = false)
	private CobCliente cobCliente;

	@ManyToOne
	@JoinColumn(name = "ven_vendedor_id", referencedColumnName = "id", nullable = false)
	private VenVendedor venVendedor;

	@ManyToOne
	@JoinColumn(name = "bs_talonario_id", referencedColumnName = "id", nullable = false)
	private BsTalonario bsTalonario;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;
	
	@ManyToOne
	@JoinColumn(name = "ven_condicion_venta_id", referencedColumnName = "id", nullable = false)
	private VenCondicionVenta venCondicionVenta;
	
	@OneToOne
	@JoinColumn(name = "cob_habilitacion_caja_id", referencedColumnName = "id", nullable = false)
	private CobHabilitacionCaja cobHabilitacionCaja;

	@OneToMany(mappedBy = "venFacturaCabecera", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private List<VenFacturaDetalle> venFacturaDetalleList;

	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}

	public VenFacturaCabecera() {
		this.venFacturaDetalleList = new ArrayList<VenFacturaDetalle>();
		this.montoTotalGravada = BigDecimal.ZERO;
		this.montoTotalExenta = BigDecimal.ZERO;
		this.montoTotalIva = BigDecimal.ZERO;
		this.montoTotalFactura = BigDecimal.ZERO;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public LocalDate getFechaFactura() {
		return fechaFactura;
	}

	public void setFechaFactura(LocalDate fechaFactura) {
		this.fechaFactura = fechaFactura;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public String getTipoFactura() {
		return tipoFactura;
	}

	public void setTipoFactura(String tipoFactura) {
		this.tipoFactura = tipoFactura;
	}

	public Long getIdComprobate() {
		return idComprobate;
	}

	public void setIdComprobate(Long idComprobate) {
		this.idComprobate = idComprobate;
	}

	public Long getNroFactura() {
		return nroFactura;
	}

	public void setNroFactura(Long nroFactura) {
		this.nroFactura = nroFactura;
	}

	public String getNroFacturaCompleto() {
		return nroFacturaCompleto;
	}

	public void setNroFacturaCompleto(String nroFacturaCompleto) {
		this.nroFacturaCompleto = nroFacturaCompleto;
	}

	public BigDecimal getMontoTotalGravada() {
		return montoTotalGravada;
	}

	public void setMontoTotalGravada(BigDecimal montoTotalGravada) {
		this.montoTotalGravada = montoTotalGravada;
	}

	public BigDecimal getMontoTotalExenta() {
		return montoTotalExenta;
	}

	public void setMontoTotalExenta(BigDecimal montoTotalExenta) {
		this.montoTotalExenta = montoTotalExenta;
	}

	public BigDecimal getMontoTotalIva() {
		return montoTotalIva;
	}

	public void setMontoTotalIva(BigDecimal montoTotalIva) {
		this.montoTotalIva = montoTotalIva;
	}

	public BigDecimal getMontoTotalFactura() {
		return montoTotalFactura;
	}

	public void setMontoTotalFactura(BigDecimal montoTotalFactura) {
		this.montoTotalFactura = montoTotalFactura;
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

	public List<VenFacturaDetalle> getVenFacturaDetalleList() {
		return venFacturaDetalleList;
	}

	public void setVenFacturaDetalleList(List<VenFacturaDetalle> venFacturaDetalleList) {
		this.venFacturaDetalleList = venFacturaDetalleList;
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

	public VenCondicionVenta getVenCondicionVenta() {
		return venCondicionVenta;
	}

	public void setVenCondicionVenta(VenCondicionVenta venCondicionVenta) {
		this.venCondicionVenta = venCondicionVenta;
	}

	public String getIndCobrado() {
		return indCobrado;
	}

	public void setIndCobrado(String indCobrado) {
		this.indCobrado = indCobrado;
	}

	public CobHabilitacionCaja getCobHabilitacionCaja() {
		return cobHabilitacionCaja;
	}

	public void setCobHabilitacionCaja(CobHabilitacionCaja cobHabilitacionCaja) {
		this.cobHabilitacionCaja = cobHabilitacionCaja;
	}

	public void addDetalle(VenFacturaDetalle detalle) {
		if (!Objects.isNull(detalle)) {
			this.venFacturaDetalleList.add(calcularTotalLinea(detalle));
		}
	}

	private VenFacturaDetalle calcularTotalLinea(VenFacturaDetalle detalle) {
		var gravada = BigDecimal.ZERO;
		var iva = BigDecimal.ZERO;
		var exenta = BigDecimal.ZERO;
		var totalLinea = detalle.getMontoLinea();
		switch (detalle.getCodIva()) {
		case "IVA10":
			gravada = totalLinea.divide(BigDecimal.valueOf(1.1), 2, RoundingMode.HALF_UP);
			iva = totalLinea.subtract(gravada);
			break;
		case "IVA5":
			gravada = totalLinea.divide(BigDecimal.valueOf(1.05), 2, RoundingMode.HALF_UP);
			iva = totalLinea.subtract(gravada);
			break;
		case "EXE":
			exenta = totalLinea;
			gravada = BigDecimal.ZERO;
			iva = BigDecimal.ZERO;
			break;
		default:
			break;
		}
		detalle.setMontoGravado(gravada);
		detalle.setMontoExento(exenta);
		detalle.setMontoIva(iva);
		detalle.setMontoLinea(totalLinea);
		return detalle;
	}

	public void calcularTotales() {
		if (!Objects.isNull(this.venFacturaDetalleList)) {
			this.venFacturaDetalleList.forEach(detalle -> {
				this.montoTotalGravada = this.montoTotalGravada.add(detalle.getMontoGravado());
				this.montoTotalExenta = this.montoTotalExenta.add(detalle.getMontoExento());
				this.montoTotalIva = this.montoTotalIva.add(detalle.getMontoIva());
			});
			this.montoTotalFactura = this.montoTotalFactura.add(this.montoTotalGravada).add(this.montoTotalExenta)
					.add(this.montoTotalIva);

		}
	}

	public void setCabeceraADetalle() {
		if (!Objects.isNull(this.venFacturaDetalleList)) {
			this.venFacturaDetalleList.forEach(detalle -> {
				detalle.setVenFacturaCabecera(this);
			});
		}
	}

}
