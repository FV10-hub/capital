package py.com.capital.CapitaCreditos;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class CapitaCreditosApplication {

	public static void main(String[] args) {
		SpringApplication.run(CapitaCreditosApplication.class, args);
	}

}
