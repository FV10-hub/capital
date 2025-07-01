package py.com.capital.CapitaCreditos.config;


import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import py.com.capital.CapitaCreditos.presentation.filters.LoginFilter;

@Configuration
public class FilterConfig {

    @Bean
    public FilterRegistrationBean<LoginFilter> loginFilterRegistration(LoginFilter loginFilter) {
        FilterRegistrationBean<LoginFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(loginFilter);
        // Aquí mapeas las URLs que protegerá el filtro
        registrationBean.addUrlPatterns("/pages/*");
        return registrationBean;
    }
}
