package py.com.capital.CapitaCreditos.dtos;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.stream.Collectors;


public class SqlSelectBuilder {
    private String table;
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

/* asi usar union all ejemplo en habilitacion de caja
public void resumenCobros(Long empresaId, Long usuarioId, Long habilitacion) {
        // 1. construir cada bloque con tu SqlSelectBuilder
        SqlSelectBuilder facturas = SqlSelectBuilder.from("ven_facturas_cabecera c")
                .select("tv.cod_tipo || ' - ' || tv.descripcion AS tipo_valor")
                .select("SUM(COALESCE(c.monto_total_factura,0)) AS tot_comprobante")
                .join("cob_habilitaciones_cajas hab ON hab.id = c.cob_habilitacion_caja_id")
                .join("cob_cajas caj ON hab.bs_cajas_id = caj.id AND hab.bs_usuario_id = caj.bs_usuario_id AND caj.bs_empresa_id = c.bs_empresa_id")
                .join("bs_talonarios tal ON c.bs_talonario_id = tal.id")
                .join("bs_tipo_comprobantes tip ON tal.bs_tipo_comprobante_id = tip.id")
                .join("cob_cobros_valores val ON c.bs_empresa_id = val.bs_empresa_id AND c.id = val.id_comprobante")
                .join("bs_tipo_valor tv ON val.bs_empresa_id = tv.bs_empresa_id AND val.bs_tipo_valor_id = tv.id")
                .where("c.bs_empresa_id = :empresaId")
                .where("caj.bs_usuario_id = :usuarioId")
                .where("hab.nro_habilitacion = :habilitacion")
                .where("tip.cod_tip_comprobante = 'CON'")
                .groupBy("tv.cod_tipo, tv.descripcion");

        SqlSelectBuilder recibos = SqlSelectBuilder.from("cob_recibos_cabecera c")
                .select("tv.cod_tipo || ' - ' || tv.descripcion AS tipo_valor")
                .select("SUM(COALESCE(c.monto_total_recibo,0)) AS tot_comprobante")
                .join("cob_habilitaciones_cajas hab ON hab.id = c.cob_habilitacion_id")
                .join("cob_cajas caj ON hab.bs_cajas_id = caj.id AND hab.bs_usuario_id = caj.bs_usuario_id AND caj.bs_empresa_id = c.bs_empresa_id")
                .join("bs_talonarios tal ON c.bs_talonario_id = tal.id")
                .join("bs_tipo_comprobantes tip ON tal.bs_tipo_comprobante_id = tip.id")
                .join("cob_cobros_valores val ON c.bs_empresa_id = val.bs_empresa_id AND c.id = val.id_comprobante")
                .join("bs_tipo_valor tv ON val.bs_empresa_id = tv.bs_empresa_id AND val.bs_tipo_valor_id = tv.id")
                .where("c.bs_empresa_id = :empresaId")
                .where("caj.bs_usuario_id = :usuarioId")
                .where("hab.nro_habilitacion = :habilitacion")
                .where("tip.cod_tip_comprobante = 'REC'")
                .groupBy("tv.cod_tipo, tv.descripcion");

        // 2. Unión manual
        String sql = "SELECT resumen.tipo_valor, SUM(resumen.tot_comprobante) AS total_cobrado " +
                "FROM (" + facturas.build() + " UNION ALL " + recibos.build() + ") resumen " +
                "GROUP BY resumen.tipo_valor " +
                "ORDER BY resumen.tipo_valor";

        Map<String, Object> params = Map.of(
                "empresaId", empresaId,
                "usuarioId", usuarioId,
                "habilitacion", habilitacion
        );

        List<Object[]> cobros = utilsService.ejecutarQuery(sql, params);
        Map<String, BigDecimal> montos = new HashMap<>();

        for (Object[] row : cobros) {
            String tipoValor = (String) row[0];
            BigDecimal monto = (BigDecimal) row[1];
            montos.put(tipoValor, monto);
        }

        this.montoCheque = montos.getOrDefault("CHE - CHEQUE", BigDecimal.ZERO);
        this.montoEfectivo = montos.getOrDefault("EFE - EFECTIVO", BigDecimal.ZERO);
        this.montoTarjeta = montos.getOrDefault("TAR - TARJETA", BigDecimal.ZERO);
    }
* */
