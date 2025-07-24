package py.com.capital.CapitaCreditos.entities.tesoreria;
/*
* 15 ene. 2024 - Elitebook
*/

import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.BsMoneda;
import py.com.capital.CapitaCreditos.entities.base.Common;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;


@Entity
@Table(name = "tes_debitos_creditos_bancarios")
public class TesDebitoCreditoBancario extends Common implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "fecha_debito")
	private LocalDate fechaDebito;
	
	@Column(name = "observacion")
	private String observacion;
	
	@Column(name = "monto_total_entrada")
	private BigDecimal montoTotalEntrada;


	@Column(name = "monto_total_salida")
	private BigDecimal montoTotalSalida;

	@ManyToOne
	@JoinColumn(name = "tes_banco_id_saliente", referencedColumnName = "id", nullable = false)
	private TesBanco tesBancoSaliente;

	@ManyToOne
	@JoinColumn(name = "tes_banco_id_entrante", referencedColumnName = "id", nullable = false)
	private TesBanco tesBancoEntrante;
	
	@OneToOne
	@JoinColumn(name = "cob_habilitacion_id", referencedColumnName = "id", nullable = false)
	private CobHabilitacionCaja cobHabilitacionCaja;

	@OneToOne()
	@JoinColumn(name = "bs_moneda_id")
	private BsMoneda bsMoneda;
	
	@ManyToOne
	@JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
	private BsEmpresa bsEmpresa;
	
	@PrePersist
	private void preInsert() {
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}


	
}

