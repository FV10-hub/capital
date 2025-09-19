package py.com.capital.CapitaCreditos.dtos;

import java.util.*;

public class SqlUpdateBuilder {
    private final String table;
    private final LinkedHashMap<String, String> setClauses = new LinkedHashMap<>();
    private final List<String> whereClauses = new ArrayList<>();
    private final LinkedHashMap<String, Object> params = new LinkedHashMap<>();
    private int seq = 1;

    private SqlUpdateBuilder(String table) {
        this.table = Objects.requireNonNull(table, "tabla requerida");
    }

    public static SqlUpdateBuilder table(String table) {
        return new SqlUpdateBuilder(table);
    }

    /**
     * SET columna = :pN (parametrizado)
     */
    public SqlUpdateBuilder set(String column, Object value) {
        String p = nextParam();
        setClauses.put(column, ":" + p);
        params.put(p, value);
        return this;
    }

    /**
     * SET crudo (ej: "saldo = saldo - :monto") con parámetros adicionales opcionales
     */
    public SqlUpdateBuilder setRaw(String expression, Map<String, Object> extraParams) {
        setClauses.put("__RAW__" + setClauses.size(), expression);
        if (extraParams != null) params.putAll(extraParams);
        return this;
    }

    /**
     * WHERE columna = :pN
     */
    public SqlUpdateBuilder whereEq(String column, Object value) {
        String p = nextParam();
        whereClauses.add(column + " = :" + p);
        params.put(p, value);
        return this;
    }

    /**
     * WHERE crudo (ej: "fecha < now()" o "saldo >= :min")
     */
    public SqlUpdateBuilder whereRaw(String clause, Map<String, Object> extraParams) {
        whereClauses.add(clause);
        if (extraParams != null) params.putAll(extraParams);
        return this;
    }

    /**
     * SQL final
     */
    public String build() {
        if (setClauses.isEmpty()) throw new IllegalStateException("UPDATE sin SET");
        StringBuilder sb = new StringBuilder();
        sb.append("UPDATE ").append(table).append(" SET ");
        sb.append(String.join(", ",
                setClauses.entrySet().stream()
                        .map(e -> e.getKey().startsWith("__RAW__") ? e.getValue() : (e.getKey() + " = " + e.getValue()))
                        .toList()
        ));
        if (!whereClauses.isEmpty()) {
            sb.append(" WHERE ").append(String.join(" AND ", whereClauses));
        }
        return sb.toString();
    }

    /**
     * Parámetros para setear en el Query
     */
    public Map<String, Object> params() {
        return Collections.unmodifiableMap(params);
    }

    private String nextParam() {
        return "p" + (seq++);
    }
}


/*ejemplos de como usar
String sql = SqlUpdateBuilder.table("public.cre_desembolso_cabecera")
    .set("ind_impreso", "S")
    .whereEq("bs_empresa_id", commonsUtilitiesController.getIdEmpresaLogueada())
    .whereEq("id", this.tesPagoCabecera.getId())
    .build();

var q = em.createNativeQuery(sql);
// Setear parámetros (en el mismo orden no importa; usa los nombres del builder)
SqlUpdateBuilder.table("x"); // solo para que veas los nombres; realmente:
Map<String,Object> params = Map.of(); // ver abajo

// Mejor: conservá el builder para extraer params:
SqlUpdateBuilder ub = SqlUpdateBuilder.table("public.cre_desembolso_cabecera")
    .set("ind_impreso", "S")
    .whereEq("bs_empresa_id", commonsUtilitiesController.getIdEmpresaLogueada())
    .whereEq("id", this.tesPagoCabecera.getId());

String sql2 = ub.build();
var q2 = em.createNativeQuery(sql2);
ub.params().forEach(q2::setParameter);

int filas = q2.executeUpdate();

SqlUpdateBuilder ub = SqlUpdateBuilder.table("public.tes_bancos")
    .setRaw("saldo_cuenta = saldo_cuenta - :monto", Map.of("monto", monto))
    .set("usuario_modificacion", usuario)
    .setRaw("fecha_modificacion = now()", null)
    .whereEq("id", bancoId)
    .whereEq("bs_empresa_id", empresaId)
    .whereRaw("saldo_cuenta >= :monto", Map.of("monto", monto));

String sql = ub.build();
var q = em.createNativeQuery(sql);
ub.params().forEach(q::setParameter);
int filas = q.executeUpdate();
 */
