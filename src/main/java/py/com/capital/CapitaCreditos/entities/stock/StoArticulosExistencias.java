package py.com.capital.CapitaCreditos.entities.stock;

import java.math.BigDecimal;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "sto_articulos_existencias",
        uniqueConstraints = @UniqueConstraint(name = "unique_sto_articulo", columnNames = "sto_articulo_id"))
public class StoArticulosExistencias {

    @Id
    @SequenceGenerator(name = "sto_art_exist_generator", sequenceName = "sto_articulos_existencias_id_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sto_art_exist_generator")
    private Long id;

    // Relación Uno a Uno con StoArticulo
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sto_articulo_id", nullable = false)
    private StoArticulo stoArticulo;

    @Column(name = "existencia", precision = 19, scale = 2)
    private BigDecimal existencia;

    @Column(name = "existencia_anterior", precision = 19, scale = 2)
    private BigDecimal existenciaAnterior;

    // --- Constructores, Getters y Setters ---

    public StoArticulosExistencias() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public StoArticulo getStoArticulo() {
        return stoArticulo;
    }

    public void setStoArticulo(StoArticulo stoArticulo) {
        this.stoArticulo = stoArticulo;
    }

    public BigDecimal getExistencia() {
        return existencia;
    }

    public void setExistencia(BigDecimal existencia) {
        this.existencia = existencia;
    }

    public BigDecimal getExistenciaAnterior() {
        return existenciaAnterior;
    }

    public void setExistenciaAnterior(BigDecimal existenciaAnterior) {
        this.existenciaAnterior = existenciaAnterior;
    }
}