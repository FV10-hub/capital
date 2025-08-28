package py.com.capital.CapitaCreditos.dtos;

import java.util.List;
import java.util.Map;

public record EmaiRequest(String[] to, String subject, List<EmailAdjunto> attachment,
                          Map<String, Object> model) {
}
