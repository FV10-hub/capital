package py.com.capital.CapitaCreditos.repositories.base;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import py.com.capital.CapitaCreditos.dtos.SqlUpdateBuilder;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

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

    @Transactional
    public <T, ID> T reload(Class<T> type, Long id) {
        //recargo y sincronizo el objeto con la DB
        if (id == null) return null;
        em.flush();
        em.clear();
        return em.find(type, id);  // trae fresco de la DB
    }
}
