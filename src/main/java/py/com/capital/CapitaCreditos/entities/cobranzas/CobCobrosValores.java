package py.com.capital.CapitaCreditos.entities.cobranzas;

import jakarta.persistence.*;
import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsTipoValor;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.tesoreria.TesDeposito;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/*
* 12 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "cob_cobros_valores", uniqueConstraints = 
@UniqueConstraint(name = "cob_cobros_valores_uniques", columnNames = {
		"bs_empresa_id", "bs_tipo_valor_id", "nro_valor", "id_comprobante" }))
public class CobCobrosValores extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "id_comprobante")
	private Long idComprobate;

	// RECIBO, FACTURA
	@Column(name = "tipo_comprobante")
	private String tipoComprobante;
	
	@Column(name = "nro_comprobante_completo")
	private String nroComprobanteCompleto;
	
	@Column(name = "nro_orden")
	private Integer nroOrden;
	
	@Column(name = "monto_cuota")
    private BigDecimal montoValor;

	@Column(name = "nro_valor")
	private String nroValor;
	
	@Column(name = "fecha_valor")
	private LocalDate fechaValor;

	@Column(name = "fecha_vencimiento")
	private LocalDate fechaVencimiento;
	
	@Column(name = "ind_depositado")
	private String indDepositado;

	@Transient
	private boolean indDepositadoBoolean;

	@Column(name = "fecha_deposito")
	private LocalDate fechaDeposito;
	
	@ManyToOne
	@JoinColumn(name = "tes_deposito_id", referencedColumnName = "id", nullable = true)
	private TesDeposito tesDeposito;

	@ManyToOne
	@JoinColumn(name = "bs_tipo_valor_id", referencedColumnName = "id", nullable = false)
	private BsTipoValor bsTipoValor;
	
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

	public Integer getNroOrden() {
		return nroOrden;
	}

	public void setNroOrden(Integer nroOrden) {
		this.nroOrden = nroOrden;
	}

	public BigDecimal getMontoValor() {
		return montoValor;
	}

	public void setMontoValor(BigDecimal montoValor) {
		this.montoValor = montoValor;
	}

	public String getNroValor() {
		return nroValor;
	}

	public void setNroValor(String nroValor) {
		this.nroValor = nroValor;
	}

	public LocalDate getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(LocalDate fechaValor) {
		this.fechaValor = fechaValor;
	}

	public LocalDate getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(LocalDate fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public BsTipoValor getBsTipoValor() {
		return bsTipoValor;
	}

	public void setBsTipoValor(BsTipoValor bsTipoValor) {
		this.bsTipoValor = bsTipoValor;
	}

	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	public String getIndDepositado() {
		return indDepositado;
	}

	public void setIndDepositado(String indDepositado) {
		this.indDepositado = indDepositado;
	}

	public boolean isIndDepositadoBoolean() {
		if (!Objects.isNull(indDepositado)) {
			indDepositadoBoolean = indDepositado.equalsIgnoreCase("S");
		}
		return indDepositadoBoolean;
	}

	public void setIndDepositadoBoolean(boolean indDepositadoBoolean) {
		indDepositado = indDepositadoBoolean ? "S" : "N";
		this.indDepositadoBoolean = indDepositadoBoolean;
	}

	public LocalDate getFechaDeposito() {
		return fechaDeposito;
	}

	public void setFechaDeposito(LocalDate fechaDeposito) {
		this.fechaDeposito = fechaDeposito;
	}

	public TesDeposito getTesDeposito() {
		return tesDeposito;
	}

	public void setTesDeposito(TesDeposito tesDeposito) {
		this.tesDeposito = tesDeposito;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((idComprobate == null) ? 0 : idComprobate.hashCode());
		result = prime * result + ((nroValor == null) ? 0 : nroValor.hashCode());
		result = prime * result + ((bsTipoValor == null) ? 0 : bsTipoValor.hashCode());
		result = prime * result + ((bsEmpresa == null) ? 0 : bsEmpresa.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		CobCobrosValores other = (CobCobrosValores) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (idComprobate == null) {
			if (other.idComprobate != null)
				return false;
		} else if (!idComprobate.equals(other.idComprobate))
			return false;
		if (nroValor == null) {
			if (other.nroValor != null)
				return false;
		} else if (!nroValor.equals(other.nroValor))
			return false;
		if (bsTipoValor == null) {
			if (other.bsTipoValor != null)
				return false;
		} else if (!bsTipoValor.equals(other.bsTipoValor))
			return false;
		if (bsEmpresa == null) {
			if (other.bsEmpresa != null)
				return false;
		} else if (!bsEmpresa.equals(other.bsEmpresa))
			return false;
		return true;
	}

	
	
}
