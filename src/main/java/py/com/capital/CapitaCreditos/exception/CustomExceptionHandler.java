package py.com.capital.CapitaCreditos.exception;

import javax.faces.application.ViewExpiredException;
import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerWrapper;
import javax.faces.context.FacesContext;
import javax.faces.event.ExceptionQueuedEvent;
import javax.faces.event.ExceptionQueuedEventContext;
import java.util.Iterator;

public class CustomExceptionHandler extends ExceptionHandlerWrapper {

    private final ExceptionHandler wrapped;

    public CustomExceptionHandler(ExceptionHandler wrapped) {
        this.wrapped = wrapped;
    }

    @Override
    public ExceptionHandler getWrapped() {
        return wrapped;
    }

    @Override
    public void handle() throws RuntimeException {
        Iterator<ExceptionQueuedEvent> i = getUnhandledExceptionQueuedEvents().iterator();

        while (i.hasNext()) {
            ExceptionQueuedEvent event = i.next();
            ExceptionQueuedEventContext context = (ExceptionQueuedEventContext) event.getSource();
            Throwable t = context.getException();

            if (t instanceof ViewExpiredException) {
                try {
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.getExternalContext().invalidateSession();
                    // TODO: esto es por que al cerrar la sesion pierde el viewscoped del login
                    fc.getExternalContext().redirect(fc.getExternalContext().getRequestContextPath() + "/faces/pages/login.xhtml");
                    fc.responseComplete();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    i.remove();
                }
            }
        }
        getWrapped().handle();
    }
}

