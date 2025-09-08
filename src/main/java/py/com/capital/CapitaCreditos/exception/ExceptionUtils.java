package py.com.capital.CapitaCreditos.exception;

import org.hibernate.exception.ConstraintViolationException;

import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

public class ExceptionUtils {

    public static String obtenerMensajeUsuario(Throwable e) {
        Throwable causa = encontrarCausaRaiz(e);

        String mensaje = causa.getMessage();

        // Violación de clave foránea
        if (mensaje != null && mensaje.toLowerCase().contains("foreign key")) {
            return "No se puede eliminar este registro porque está relacionado con otros datos.";
        }

        // Violación de restricción única
        if (mensaje != null && (mensaje.toLowerCase().contains("unique")
                || mensaje.toLowerCase().contains("duplicate")
                || mensaje.toLowerCase().contains("ya existe"))) {
            return "Ya existe un registro con los mismos datos.";
        }

        // Casos conocidos por tipo
        if (causa instanceof ConstraintViolationException) {
            return "Violación de restricción de datos. Verifique los campos obligatorios o valores únicos.";
        }

        if (causa instanceof SQLIntegrityConstraintViolationException) {
            return "El registro no puede ser modificado o eliminado por restricciones de integridad.";
        }

        if (causa instanceof SQLException sqlEx) {
            // Códigos más comunes independientes del motor
            switch (sqlEx.getSQLState()) {
                case "23000": // estándar SQL
                    return "Error de integridad referencial en la base de datos.";
                case "23505": // código estándar para restricción UNIQUE
                    return "El valor ya existe y debe ser único.";
            }
        }

        return "Ocurrió un error inesperado. Por favor, intente nuevamente o contacte con soporte.";
    }

    private static Throwable encontrarCausaRaiz(Throwable throwable) {
        Throwable causa = throwable;
        while (causa.getCause() != null && causa != causa.getCause()) {
            causa = causa.getCause();
        }
        return causa;
    }

}
