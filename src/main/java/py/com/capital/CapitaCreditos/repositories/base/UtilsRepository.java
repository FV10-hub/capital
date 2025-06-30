package py.com.capital.CapitaCreditos.repositories.base;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import org.springframework.stereotype.Repository;

/*
* 25 ene. 2024 - Elitebook
*/
@Repository
public class UtilsRepository {
	
	@PersistenceContext
	private EntityManager em;
	
	 public UtilsRepository(EntityManager em) {
	        this.em = em;
	    }

	@Transactional
	public boolean updateRecord(String tableName, String camposValores, String whereCamposyValores) {
		try {
			String query = String.format("UPDATE %s SET %s WHERE %s", tableName, camposValores, whereCamposyValores);
	        int filasAfectadas = em.createNativeQuery(query).executeUpdate();
	        return filasAfectadas > 0;
        } catch (Exception e) {
        	e.printStackTrace(System.err);
            return false;
        }
	}
}
