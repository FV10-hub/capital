package py.com.capital.CapitaCreditos.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WelcomePageConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        //en vez del  <welcome-file-list> webxml
        // Redirige la ruta raíz ("/") a tu página de login
        registry.addViewController("/").setViewName("forward:/login.xhtml");
    }
}
