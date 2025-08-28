package py.com.capital.CapitaCreditos.services.impl;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring5.SpringTemplateEngine;
import py.com.capital.CapitaCreditos.dtos.EmaiRequest;
import py.com.capital.CapitaCreditos.repositories.base.EmailReposiroty;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.nio.charset.StandardCharsets;

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
}
