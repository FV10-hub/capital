package py.com.capital.CapitaCreditos.entities.cobranzas;

import py.com.capital.CapitaCreditos.entities.base.BsEmpresa;
import py.com.capital.CapitaCreditos.entities.base.Common;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "cob_arqueos_cajas")
public class CobArqueosCajas extends Common implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "monto_efectivo")
    private BigDecimal montoEfectivo;

    @Column(name = "monto_cheques")
    private BigDecimal montoCheques;

    @Column(name = "monto_tarjetas")
    private BigDecimal montoTarjetas;

    @OneToOne
    @JoinColumn(name = "cob_habilitacion_id", referencedColumnName = "id", nullable = false)
    private CobHabilitacionCaja cobHabilitacionCaja;

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

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public CobHabilitacionCaja getCobHabilitacionCaja() {
        return cobHabilitacionCaja;
    }

    public void setCobHabilitacionCaja(CobHabilitacionCaja cobHabilitacionCaja) {
        this.cobHabilitacionCaja = cobHabilitacionCaja;
    }

    public BsEmpresa getBsEmpresa() {
        return bsEmpresa;
    }

    public void setBsEmpresa(BsEmpresa bsEmpresa) {
        this.bsEmpresa = bsEmpresa;
    }

    public BigDecimal getMontoEfectivo() {
        return montoEfectivo;
    }

    public void setMontoEfectivo(BigDecimal montoEfectivo) {
        this.montoEfectivo = montoEfectivo;
    }

    public BigDecimal getMontoCheques() {
        return montoCheques;
    }

    public void setMontoCheques(BigDecimal montoCheques) {
        this.montoCheques = montoCheques;
    }

    public BigDecimal getMontoTarjetas() {
        return montoTarjetas;
    }

    public void setMontoTarjetas(BigDecimal montoTarjetas) {
        this.montoTarjetas = montoTarjetas;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CobArqueosCajas that = (CobArqueosCajas) o;
        return Objects.equals(id, that.id) && Objects.equals(cobHabilitacionCaja, that.cobHabilitacionCaja) && Objects.equals(bsEmpresa, that.bsEmpresa);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, cobHabilitacionCaja, bsEmpresa);
    }
}
