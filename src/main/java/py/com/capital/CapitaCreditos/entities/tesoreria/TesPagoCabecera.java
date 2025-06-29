package py.com.capital.CapitaCreditos.entities.tesoreria;
/*
* 15 ene. 2024 - Elitebook
*/

import jakarta.persistence.*;
import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "tes_pagos_cabecera", uniqueConstraints = @UniqueConstraint(name = "tes_pagos_cabecera_uniques", columnNames = {
		"nro_pago", "bs_empresa_id"
}))
public class TesPagoCabecera extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_pago")
	private LocalDate fechaPago;

	@Column(name = "observacion")
	private String observacion;

	@Column(name = "nro_pago")
	private Long nroPago;

	@Column(name = "nro_pago_completo")
	private String nroPagoCompleto;

	@Column(name = "ind_impreso")
	private String indImpreso;

	@Transient
	private boolean indImpresoBoolean;

	@Column(name = "ind_autorizado")
	private String indAutorizado;

	@Transient
	private boolean indAutorizadoBoolean;

	@Column(name = "monto_total_pago")
	private BigDecimal montoTotalPago;

	@Column(name = "id_beneficiario")
	private Long idBeneficiario;

	@Column(name = "beneficiario")
	private String beneficiario;

	// DESEMBOLSO O PAGO PROVEEDOR
	@Column(name = "tipo_operacion")
	private String tipoOperacion;

	@OneToOne
	@JoinColumn(name = "cob_habilitacion_id", referencedColumnName = "id", nullable = false)
	private CobHabilitacionCaja cobHabilitacionCaja;

	@OneToOne
	@JoinColumn(name = "bs_talonario_id", referencedColumnName = "id", nullable = true)
	private BsTalonario bsTalonario;

	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;

	@OneToMany(mappedBy = "tesPagoCabecera", cascade = CascadeType.ALL)
	@LazyCollection(LazyCollectionOption.FALSE)
	private List<TesPagoComprobanteDetalle> tesPagoComprobanteDetallesList;

	@OneToMany(mappedBy = "tesPagoCabecera", cascade = CascadeType.ALL)
	@LazyCollection(LazyCollectionOption.FALSE)
	private List<TesPagoValores> tesPagoValoresList;

	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}

	public TesPagoCabecera() {
		this.tesPagoComprobanteDetallesList = new ArrayList<>();
		this.tesPagoValoresList = new ArrayList<>();
		this.montoTotalPago = BigDecimal.ZERO;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public LocalDate getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(LocalDate fechaPago) {
		this.fechaPago = fechaPago;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public Long getNroPago() {
		return nroPago;
	}

	public void setNroPago(Long nroPago) {
		this.nroPago = nroPago;
	}

	public String getNroPagoCompleto() {
		return nroPagoCompleto;
	}

	public void setNroPagoCompleto(String nroPagoCompleto) {
		this.nroPagoCompleto = nroPagoCompleto;
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

	public BigDecimal getMontoTotalPago() {
		return montoTotalPago;
	}

	public void setMontoTotalPago(BigDecimal montoTotalPago) {
		this.montoTotalPago = montoTotalPago;
	}

	public Long getIdBeneficiario() {
		return idBeneficiario;
	}

	public void setIdBeneficiario(Long idBeneficiario) {
		this.idBeneficiario = idBeneficiario;
	}

	public String getBeneficiario() {
		return beneficiario;
	}

	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}

	public String getTipoOperacion() {
		return tipoOperacion;
	}

	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
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

	public List<TesPagoComprobanteDetalle> getTesPagoComprobanteDetallesList() {
		return tesPagoComprobanteDetallesList;
	}

	public void setTesPagoComprobanteDetallesList(List<TesPagoComprobanteDetalle> tesPagoComprobanteDetallesList) {
		this.tesPagoComprobanteDetallesList = tesPagoComprobanteDetallesList;
	}

	public List<TesPagoValores> getTesPagoValoresList() {
		return tesPagoValoresList;
	}

	public void setTesPagoValoresList(List<TesPagoValores> tesPagoValoresList) {
		this.tesPagoValoresList = tesPagoValoresList;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, bsTalonario, cobHabilitacionCaja, idBeneficiario);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		TesPagoCabecera other = (TesPagoCabecera) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(bsTalonario, other.bsTalonario)
				&& Objects.equals(cobHabilitacionCaja, other.cobHabilitacionCaja)
				&& Objects.equals(idBeneficiario, other.idBeneficiario);
	}

	public void addComprobanteDetalle(TesPagoComprobanteDetalle detalle) {
		if (!Objects.isNull(detalle)) {
			this.tesPagoComprobanteDetallesList.add(detalle);
		}
	}

	public void addValorDetalle(TesPagoValores detalle) {
		if (!Objects.isNull(detalle)) {
			this.tesPagoValoresList.add(detalle);
		}
	}

	public void setCabeceraADetalle() {
		if (!Objects.isNull(this.tesPagoComprobanteDetallesList)) {
			this.tesPagoComprobanteDetallesList.forEach(detalle -> {
				detalle.setTesPagoCabecera(this);
			});
		}
		if (!Objects.isNull(this.tesPagoValoresList)) {
			this.tesPagoValoresList.forEach(detalle -> {
				detalle.setTesPagoCabecera(this);
			});
		}
	}

	public void calcularTotales() {
		if (!Objects.isNull(this.tesPagoValoresList)) {
			this.tesPagoValoresList.forEach(detalle -> {
				this.montoTotalPago = this.montoTotalPago.add(detalle.getMontoValor());
			});
		}
	}

}
