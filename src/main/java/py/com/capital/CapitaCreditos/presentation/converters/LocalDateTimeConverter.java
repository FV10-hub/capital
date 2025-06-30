package py.com.capital.CapitaCreditos.presentation.converters;

import jakarta.faces.component.UIComponent;
import jakarta.faces.context.FacesContext;
import jakarta.faces.convert.Converter;
import jakarta.faces.convert.FacesConverter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


/*
* 28 dic. 2023 - Elitebook
*/
@FacesConverter("localDateTimeConverter")
public class LocalDateTimeConverter implements Converter {

    private DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    @Override
    public Object getAsObject(FacesContext context, UIComponent component, String value) {
        if (value != null && !value.isEmpty()) {
            return LocalDateTime.parse(value, dateTimeFormatter);
        }
        return null;
    }

    @Override
    public String getAsString(FacesContext context, UIComponent component, Object value) {
        if (value instanceof LocalDateTime) {
            return dateTimeFormatter.format((LocalDateTime) value);
        }
        return null;
    }
}