package py.com.capital.CapitaCreditos.dtos;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.stream.Collectors;


public class SqlSelectBuilder {
    private String table;                       // FROM ...
    private final List<String> selectFields = new ArrayList<>();
    private final List<String> joins = new ArrayList<>();
    private final List<String> whereClauses = new ArrayList<>();
    private final List<String> groupByFields = new ArrayList<>();
    private final List<String> havingClauses = new ArrayList<>();
    private final List<String> orderClauses = new ArrayList<>();
    private Integer limit;
    private Integer offset;

    private SqlSelectBuilder(String table) {
        this.table = Objects.requireNonNull(table, "table es requerido");
    }

    public static SqlSelectBuilder from(String tableOrAliased) {
        return new SqlSelectBuilder(tableOrAliased);
    }

    public SqlSelectBuilder select(String... fields) {
        if (fields != null) {
            for (String f : fields) {
                if (f != null && !f.isBlank()) selectFields.add(f.trim());
            }
        }
        return this;
    }

    /**
     * SELECT con expresión (ej: "count(*) as total")
     */
    public SqlSelectBuilder selectExpr(String expr) {
        if (expr != null && !expr.isBlank()) selectFields.add(expr.trim());
        return this;
    }

    /**
     * INNER JOIN ...
     */
    public SqlSelectBuilder join(String joinClause) {
        if (joinClause != null && !joinClause.isBlank()) joins.add("JOIN " + joinClause.trim());
        return this;
    }

    /**
     * LEFT JOIN ...
     */
    public SqlSelectBuilder leftJoin(String joinClause) {
        if (joinClause != null && !joinClause.isBlank()) joins.add("LEFT JOIN " + joinClause.trim());
        return this;
    }

    /**
     * WHERE (se concatenan con AND) — podés usar parámetros :nombre
     */
    public SqlSelectBuilder where(String clause) {
        if (clause != null && !clause.isBlank()) whereClauses.add(clause.trim());
        return this;
    }

    /**
     * GROUP BY ...
     */
    public SqlSelectBuilder groupBy(String... fields) {
        if (fields != null) {
            for (String f : fields) {
                if (f != null && !f.isBlank()) groupByFields.add(f.trim());
            }
        }
        return this;
    }

    /**
     * HAVING ... (se concatenan con AND)
     */
    public SqlSelectBuilder having(String clause) {
        if (clause != null && !clause.isBlank()) havingClauses.add(clause.trim());
        return this;
    }

    /**
     * ORDER BY campo ASC|DESC (puede llamarse varias veces)
     */
    public SqlSelectBuilder orderBy(String field, String direction) {
        String dir = (direction == null) ? "ASC" : direction.trim().toUpperCase(Locale.ROOT);
        if (!dir.equals("ASC") && !dir.equals("DESC")) dir = "ASC";
        orderClauses.add(field.trim() + " " + dir);
        return this;
    }

    public SqlSelectBuilder limit(int limit) {
        if (limit > 0) this.limit = limit;
        return this;
    }

    public SqlSelectBuilder offset(int offset) {
        if (offset >= 0) this.offset = offset;
        return this;
    }

    /**
     * Devuelve el SQL final
     */
    public String build() {
        String fields = selectFields.isEmpty() ? "*" : String.join(", ", selectFields);

        StringBuilder sb = new StringBuilder();
        sb.append("SELECT ").append(fields).append(" FROM ").append(table).append(" ");

        if (!joins.isEmpty()) {
            sb.append(String.join(" ", joins)).append(" ");
        }
        if (!whereClauses.isEmpty()) {
            sb.append("WHERE ").append(String.join(" AND ", whereClauses)).append(" ");
        }
        if (!groupByFields.isEmpty()) {
            sb.append("GROUP BY ").append(String.join(", ", groupByFields)).append(" ");
        }
        if (!havingClauses.isEmpty()) {
            sb.append("HAVING ").append(String.join(" AND ", havingClauses)).append(" ");
        }
        if (!orderClauses.isEmpty()) {
            sb.append("ORDER BY ").append(orderClauses.stream().collect(Collectors.joining(", "))).append(" ");
        }
        if (limit != null) sb.append("LIMIT ").append(limit).append(" ");
        if (offset != null) sb.append("OFFSET ").append(offset).append(" ");

        return sb.toString().trim();
    }

    @Override
    public String toString() {
        //para pasarle al em
        return build();
    }
}

/*
* EJEMPLO DE COMO USAR EN EL UTILREPOSRITORY
public List<Object[]> buscarBancos(Long empresaId, String texto, int limit) {
        String sql = SqlSelectBuilder.from("public.tes_bancos b")
                .select("b.id", "b.cod_banco", "b.saldo_cuenta")
                .where("b.bs_empresa_id = :empresaId")
                .where(texto != null && !texto.isBlank() ? "b.cod_banco ILIKE :q" : null)
                .orderBy("b.cod_banco", "ASC")
                .limit(limit)
                .build();

        var q = em.createNativeQuery(sql);
        q.setParameter("empresaId", empresaId);
        if (texto != null && !texto.isBlank()) q.setParameter("q", "%" + texto + "%");
        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();
        return rows;
    }
    *
    * CON INNER JOIN
    String sql = SqlSelectBuilder.from("public.com_saldos s")
    .select("c.id", "c.razon_social", "SUM(s.saldo_cuota) AS total")
    .join("public.com_proveedores c ON c.id = s.com_proveedor_id")
    .where("s.bs_empresa_id = :empresaId")
    .where("s.saldo_cuota > 0")
    .groupBy("c.id", "c.razon_social")
    .orderBy("total", "DESC")
    .limit(50)
    .build();
    *
    * CON LEFT JOIN
    String sql = SqlSelectBuilder.from("public.tes_bancos b")
    .select("b.id", "b.cod_banco", "COALESCE(SUM(m.importe),0) as movs_mes")
    .leftJoin("public.tes_movimientos m ON m.tes_banco_id = b.id AND date_trunc('month', m.fecha) = date_trunc('month', now())")
    .where("b.bs_empresa_id = :empresaId")
    .groupBy("b.id", "b.cod_banco")
    .having("COALESCE(SUM(m.importe),0) >= :minimo")
    .orderBy("movs_mes", "DESC")
    .build();
* */
