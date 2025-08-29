package py.com.capital.CapitaCreditos.services.impl;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring5.SpringTemplateEngine;
import py.com.capital.CapitaCreditos.dtos.EmaiRequest;
import py.com.capital.CapitaCreditos.dtos.EmailAdjunto;
import py.com.capital.CapitaCreditos.repositories.base.EmailReposiroty;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
public class EmailServiceImpl implements EmailReposiroty {
    private static final Logger LOGGER = LogManager.getLogger(EmailServiceImpl.class);
    private final JavaMailSender emailSender;

    private SpringTemplateEngine templateEngine;

    @Value("${app.mail.from:no-reply@capitalsys.local}")
    private String from;


    public EmailServiceImpl(JavaMailSender mailSender, SpringTemplateEngine templateEngine) {
        this.emailSender = mailSender;
        this.templateEngine = templateEngine;
    }

    @Override
    public boolean sendEmail(EmaiRequest mail, String templateName) {
        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
                    StandardCharsets.UTF_8.name());

            Context context = new Context();
            context.setVariables(mail.model());
            String html = templateEngine.process("email/" + templateName, context);

            helper.setTo(mail.to());
            helper.setText(html, true);
            helper.setSubject(mail.subject());
            helper.setFrom(from);
            if (mail.attachment() != null)
                mail.attachment().forEach((item) -> {
                    try {
                        helper.addAttachment(item.fileName(), item.file());
                    } catch (MessagingException e) {
                        e.printStackTrace();
                    }
                });


            emailSender.send(message);
            LOGGER.info("Email sending successfully to " + mail.to());

            return true;
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            return false;
        }
    }

    @Override
    public List<EmailAdjunto> prepararAdjuntos(String directorio) throws Exception {
        File folder = new File(directorio);

        if (!folder.exists() || !folder.isDirectory()) {
            throw new Exception("No existe el directorio o no es un directorio: " + directorio);
        }

        String[] nombres = folder.list();
        if (nombres == null) {
            return Collections.emptyList();
        }

        List<EmailAdjunto> adjuntos = new ArrayList<>();
        for (String nombre : nombres) {
            if (nombre.toLowerCase().endsWith(".pdf")) {
                File archivo = new File(folder, nombre);
                if (archivo.isFile()) {
                    adjuntos.add(new EmailAdjunto(archivo, nombre));
                }
            }
        }
        return adjuntos;
    }
}
