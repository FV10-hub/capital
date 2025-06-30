package py.com.capital.CapitaCreditos.presentation.utils;

public enum Estado {
    ACTIVO("ACTIVO"),
    INACTIVO("INACTIVO");

    private final String estado;

    private Estado(String estado) {
        this.estado = estado;
    }

    public String getEstado() {
        return estado;
    }
}
