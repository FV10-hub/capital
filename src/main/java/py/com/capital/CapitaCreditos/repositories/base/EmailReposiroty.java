package py.com.capital.CapitaCreditos.repositories.base;

import py.com.capital.CapitaCreditos.dtos.EmaiRequest;

public interface EmailReposiroty {

    boolean sendEmail(EmaiRequest emaailRequest, String templateName);
}
