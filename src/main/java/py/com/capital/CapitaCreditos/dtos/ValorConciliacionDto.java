package py.com.capital.CapitaCreditos.dtos;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ValorConciliacionDto {

    private Long id;                // id de Cobro o Pago
    private String tipoRegistro;    // "COBRO" o "PAGO"
    private String tipoValor;       // bsTipoValor.descripcion
    private String nroComprobante;
    private String tipoComprobante;
    private String nroValor;
    private LocalDate fechaValor;
    private LocalDate fechaVencimiento;
    private BigDecimal montoValor;

    public ValorConciliacionDto(Long id, String tipoRegistro, String tipoValor, String nroComprobante,
                                String tipoComprobante, String nroValor,
                                LocalDate fechaValor, LocalDate fechaVencimiento, BigDecimal montoValor) {
        this.id = id;
        this.tipoRegistro = tipoRegistro;
        this.tipoValor = tipoValor;
        this.nroComprobante = nroComprobante;
        this.tipoComprobante = tipoComprobante;
        this.nroValor = nroValor;
        this.fechaValor = fechaValor;
        this.fechaVencimiento = fechaVencimiento;
        this.montoValor = montoValor;
    }

    // getters y setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTipoRegistro() {
        return tipoRegistro;
    }

    public void setTipoRegistro(String tipoRegistro) {
        this.tipoRegistro = tipoRegistro;
    }

    public String getTipoValor() {
        return tipoValor;
    }

    public void setTipoValor(String tipoValor) {
        this.tipoValor = tipoValor;
    }

    public String getNroComprobante() {
        return nroComprobante;
    }

    public void setNroComprobante(String nroComprobante) {
        this.nroComprobante = nroComprobante;
    }

    public String getTipoComprobante() {
        return tipoComprobante;
    }

    public void setTipoComprobante(String tipoComprobante) {
        this.tipoComprobante = tipoComprobante;
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

    public BigDecimal getMontoValor() {
        return montoValor;
    }

    public void setMontoValor(BigDecimal montoValor) {
        this.montoValor = montoValor;
    }
}

