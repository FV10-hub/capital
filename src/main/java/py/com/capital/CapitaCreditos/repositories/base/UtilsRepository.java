package py.com.capital.CapitaCreditos.repositories.base;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Repository;
import py.com.capital.CapitaCreditos.dtos.SqlUpdateBuilder;

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

	@Transactional
	public boolean updateDinamico(SqlUpdateBuilder sqlUpdateBuilder) {
		try {
			String sql = sqlUpdateBuilder.build();
			var q = em.createNativeQuery(sql);
			// aca le pasamos todos los columna=valor como parametros
			sqlUpdateBuilder.params().forEach(q::setParameter);

			int filas = q.executeUpdate();
			return filas > 0;
		} catch (Exception e) {
			e.printStackTrace(System.err);
			return false;
		}
	}
}
