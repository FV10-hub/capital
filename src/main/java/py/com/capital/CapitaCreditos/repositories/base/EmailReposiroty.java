package py.com.capital.CapitaCreditos.repositories.base;

import py.com.capital.CapitaCreditos.dtos.EmaiRequest;
import py.com.capital.CapitaCreditos.dtos.EmailAdjunto;

import java.util.List;

public interface EmailReposiroty {

    boolean sendEmail(EmaiRequest emaailRequest, String templateName);
    List<EmailAdjunto> prepararAdjuntos(String directorio) throws Exception;
}
