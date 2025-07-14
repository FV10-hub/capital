package py.com.capital.CapitaCreditos.exception;

import javax.faces.application.ViewExpiredException;
import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerWrapper;
import javax.faces.context.FacesContext;
import javax.faces.event.ExceptionQueuedEvent;
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
    public void handle() {
        Iterator<ExceptionQueuedEvent> events = getUnhandledExceptionQueuedEvents().iterator();

        while (events.hasNext()) {
            ExceptionQueuedEvent event = events.next();
            if (event.getContext() != null) {
                Throwable exception = event.getContext().getException();
                if (exception instanceof ViewExpiredException) {
                    FacesContext facesContext = FacesContext.getCurrentInstance();
                    try {
                        facesContext.getExternalContext().redirect(
                                facesContext.getExternalContext().getRequestContextPath() + "/faces/pages/login.xhtml");
                        facesContext.responseComplete();
                    } catch (Exception e) {
                        // Logear error si es necesario
                    } finally {
                        events.remove();
                    }
                }
            }
        }

        getWrapped().handle();
    }
}