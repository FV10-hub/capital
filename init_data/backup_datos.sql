--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.4

-- Started on 2025-07-01 21:30:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16391)
-- Name: bs_empresas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_empresas (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    direc_empresa character varying(255),
    nombre_fantasia character varying(255),
    bs_personas_id bigint NOT NULL
);


ALTER TABLE public.bs_empresas OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16390)
-- Name: bs_empresas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_empresas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_empresas_id_seq OWNER TO postgres;

--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 215
-- Name: bs_empresas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_empresas_id_seq OWNED BY public.bs_empresas.id;


--
-- TOC entry 218 (class 1259 OID 16400)
-- Name: bs_iva; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_iva (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_iva character varying(255),
    descripcion character varying(255),
    porcentaje numeric(19,2)
);


ALTER TABLE public.bs_iva OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16399)
-- Name: bs_iva_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_iva_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_iva_id_seq OWNER TO postgres;

--
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 217
-- Name: bs_iva_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_iva_id_seq OWNED BY public.bs_iva.id;


--
-- TOC entry 220 (class 1259 OID 16409)
-- Name: bs_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_menu (
    id bigint NOT NULL,
    label character varying(255),
    nombre character varying(255),
    nro_orden integer,
    tipo_menu character varying(255),
    tipo_menu_agrupador character varying(255),
    url character varying(255),
    id_bs_modulo bigint NOT NULL,
    id_sub_menu bigint
);


ALTER TABLE public.bs_menu OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16408)
-- Name: bs_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_menu_id_seq OWNER TO postgres;

--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 219
-- Name: bs_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_menu_id_seq OWNED BY public.bs_menu.id;


--
-- TOC entry 222 (class 1259 OID 16418)
-- Name: bs_menu_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_menu_item (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    icon character varying(255),
    id_menu_item bigint,
    nro_orden character varying(255),
    tipo_menu character varying(255),
    titulo character varying(255),
    id_bs_menu bigint,
    id_bs_modulo bigint NOT NULL
);


ALTER TABLE public.bs_menu_item OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16417)
-- Name: bs_menu_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_menu_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_menu_item_id_seq OWNER TO postgres;

--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 221
-- Name: bs_menu_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_menu_item_id_seq OWNED BY public.bs_menu_item.id;


--
-- TOC entry 224 (class 1259 OID 16427)
-- Name: bs_modulo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_modulo (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    codigo character varying(255),
    icon character varying(255),
    nombre character varying(255),
    nro_orden integer,
    path character varying(255)
);


ALTER TABLE public.bs_modulo OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16426)
-- Name: bs_modulo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_modulo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_modulo_id_seq OWNER TO postgres;

--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 223
-- Name: bs_modulo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_modulo_id_seq OWNED BY public.bs_modulo.id;


--
-- TOC entry 226 (class 1259 OID 16436)
-- Name: bs_moneda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_moneda (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_moneda character varying(255),
    decimales integer,
    descripcion character varying(255)
);


ALTER TABLE public.bs_moneda OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16435)
-- Name: bs_moneda_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_moneda_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_moneda_id_seq OWNER TO postgres;

--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 225
-- Name: bs_moneda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_moneda_id_seq OWNED BY public.bs_moneda.id;


--
-- TOC entry 228 (class 1259 OID 16445)
-- Name: bs_parametros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_parametros (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    descripcion character varying(255),
    parametro character varying(255),
    valor character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_modulo_id bigint NOT NULL
);


ALTER TABLE public.bs_parametros OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16444)
-- Name: bs_parametros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_parametros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_parametros_id_seq OWNER TO postgres;

--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 227
-- Name: bs_parametros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_parametros_id_seq OWNED BY public.bs_parametros.id;


--
-- TOC entry 230 (class 1259 OID 16454)
-- Name: bs_permiso_rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_permiso_rol (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    descripcion character varying(255),
    id_bs_menu bigint,
    id_bs_rol bigint
);


ALTER TABLE public.bs_permiso_rol OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16453)
-- Name: bs_permiso_rol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_permiso_rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_permiso_rol_id_seq OWNER TO postgres;

--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 229
-- Name: bs_permiso_rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_permiso_rol_id_seq OWNED BY public.bs_permiso_rol.id;


--
-- TOC entry 232 (class 1259 OID 16463)
-- Name: bs_persona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_persona (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    documento character varying(50),
    email character varying(50),
    fec_nacimiento date,
    imagen character varying(100),
    nombre character varying(100) NOT NULL,
    nombre_completo character varying(100),
    primer_apellido character varying(100) NOT NULL,
    segundo_apellido character varying(45)
);


ALTER TABLE public.bs_persona OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16462)
-- Name: bs_persona_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_persona_id_seq OWNER TO postgres;

--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 231
-- Name: bs_persona_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_persona_id_seq OWNED BY public.bs_persona.id;


--
-- TOC entry 234 (class 1259 OID 16472)
-- Name: bs_rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_rol (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    nombre character varying(45) NOT NULL
);


ALTER TABLE public.bs_rol OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16471)
-- Name: bs_rol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_rol_id_seq OWNER TO postgres;

--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 233
-- Name: bs_rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_rol_id_seq OWNED BY public.bs_rol.id;


--
-- TOC entry 236 (class 1259 OID 16481)
-- Name: bs_talonarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_talonarios (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    bs_timbrado_id bigint NOT NULL,
    bs_tipo_comprobante_id bigint NOT NULL
);


ALTER TABLE public.bs_talonarios OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16480)
-- Name: bs_talonarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_talonarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_talonarios_id_seq OWNER TO postgres;

--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 235
-- Name: bs_talonarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_talonarios_id_seq OWNED BY public.bs_talonarios.id;


--
-- TOC entry 238 (class 1259 OID 16490)
-- Name: bs_timbrados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_timbrados (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_establecimiento character varying(255),
    cod_expedicion character varying(255),
    fecha_vigencia_desde date,
    fecha_vigencia_hasta date,
    ind_autoimpresor character varying(255),
    nro_desde numeric(19,2),
    nro_hasta numeric(19,2),
    nro_timbrado numeric(19,2),
    bs_empresa_id bigint NOT NULL
);


ALTER TABLE public.bs_timbrados OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16489)
-- Name: bs_timbrados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_timbrados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_timbrados_id_seq OWNER TO postgres;

--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 237
-- Name: bs_timbrados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_timbrados_id_seq OWNED BY public.bs_timbrados.id;


--
-- TOC entry 240 (class 1259 OID 16499)
-- Name: bs_tipo_comprobantes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_tipo_comprobantes (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_tip_comprobante character varying(255),
    descripcion character varying(255),
    ind_saldo character varying(255),
    ind_stock character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_modulo_id bigint NOT NULL
);


ALTER TABLE public.bs_tipo_comprobantes OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16498)
-- Name: bs_tipo_comprobantes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_tipo_comprobantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_tipo_comprobantes_id_seq OWNER TO postgres;

--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 239
-- Name: bs_tipo_comprobantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_tipo_comprobantes_id_seq OWNED BY public.bs_tipo_comprobantes.id;


--
-- TOC entry 242 (class 1259 OID 16508)
-- Name: bs_tipo_valor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_tipo_valor (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_tipo character varying(255),
    descripcion character varying(255),
    usa_efectivo character varying(255),
    bs_empresa_id bigint NOT NULL,
    id_bs_modulo bigint NOT NULL
);


ALTER TABLE public.bs_tipo_valor OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16507)
-- Name: bs_tipo_valor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_tipo_valor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_tipo_valor_id_seq OWNER TO postgres;

--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 241
-- Name: bs_tipo_valor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_tipo_valor_id_seq OWNED BY public.bs_tipo_valor.id;


--
-- TOC entry 244 (class 1259 OID 16517)
-- Name: bs_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_usuario (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_usuario character varying(255),
    password character varying(255),
    bs_empresa_id bigint,
    id_bs_persona bigint,
    id_bs_rol bigint
);


ALTER TABLE public.bs_usuario OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16516)
-- Name: bs_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_usuario_id_seq OWNER TO postgres;

--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 243
-- Name: bs_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_usuario_id_seq OWNED BY public.bs_usuario.id;


--
-- TOC entry 246 (class 1259 OID 16526)
-- Name: cob_cajas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_cajas (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_caja character varying(255),
    bs_empresa_id bigint,
    bs_usuario_id bigint
);


ALTER TABLE public.cob_cajas OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16525)
-- Name: cob_cajas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_cajas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_cajas_id_seq OWNER TO postgres;

--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 245
-- Name: cob_cajas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_cajas_id_seq OWNED BY public.cob_cajas.id;


--
-- TOC entry 248 (class 1259 OID 16535)
-- Name: cob_clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_clientes (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_cliente character varying(255),
    bs_empresa_id bigint NOT NULL,
    id_bs_persona bigint
);


ALTER TABLE public.cob_clientes OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16534)
-- Name: cob_clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_clientes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_clientes_id_seq OWNER TO postgres;

--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 247
-- Name: cob_clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_clientes_id_seq OWNED BY public.cob_clientes.id;


--
-- TOC entry 250 (class 1259 OID 16544)
-- Name: cob_cobradores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_cobradores (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_cobrador character varying(255),
    bs_empresa_id bigint NOT NULL,
    id_bs_persona bigint
);


ALTER TABLE public.cob_cobradores OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16543)
-- Name: cob_cobradores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_cobradores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_cobradores_id_seq OWNER TO postgres;

--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 249
-- Name: cob_cobradores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_cobradores_id_seq OWNED BY public.cob_cobradores.id;


--
-- TOC entry 252 (class 1259 OID 16553)
-- Name: cob_cobros_valores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_cobros_valores (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_deposito date,
    fecha_valor date,
    fecha_vencimiento date,
    id_comprobante bigint,
    ind_depositado character varying(255),
    monto_cuota numeric(19,2),
    nro_comprobante_completo character varying(255),
    nro_orden integer,
    nro_valor character varying(255),
    tipo_comprobante character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_tipo_valor_id bigint NOT NULL,
    tes_deposito_id bigint
);


ALTER TABLE public.cob_cobros_valores OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16552)
-- Name: cob_cobros_valores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_cobros_valores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_cobros_valores_id_seq OWNER TO postgres;

--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 251
-- Name: cob_cobros_valores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_cobros_valores_id_seq OWNED BY public.cob_cobros_valores.id;


--
-- TOC entry 254 (class 1259 OID 16562)
-- Name: cob_habilitaciones_cajas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_habilitaciones_cajas (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_apertura timestamp without time zone,
    fecha_cierre timestamp without time zone,
    hora_apertura character varying(255),
    hora_cierre character varying(255),
    ind_cerrado character varying(255),
    nro_habilitacion numeric(19,2),
    bs_usuario_id bigint NOT NULL,
    bs_cajas_id bigint NOT NULL
);


ALTER TABLE public.cob_habilitaciones_cajas OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 16561)
-- Name: cob_habilitaciones_cajas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_habilitaciones_cajas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_habilitaciones_cajas_id_seq OWNER TO postgres;

--
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 253
-- Name: cob_habilitaciones_cajas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_habilitaciones_cajas_id_seq OWNED BY public.cob_habilitaciones_cajas.id;


--
-- TOC entry 256 (class 1259 OID 16571)
-- Name: cob_recibos_cabecera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_recibos_cabecera (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_recibo date,
    ind_cobrado character varying(255),
    ind_impreso character varying(255),
    monto_total_recibo numeric(19,2),
    nro_recibo bigint,
    nro_recibo_completo character varying(255),
    observacion character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_talonario_id bigint,
    cob_cliente_id bigint NOT NULL,
    cob_cobrador_id bigint NOT NULL,
    cob_habilitacion_id bigint NOT NULL
);


ALTER TABLE public.cob_recibos_cabecera OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 16570)
-- Name: cob_recibos_cabecera_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_recibos_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_recibos_cabecera_id_seq OWNER TO postgres;

--
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 255
-- Name: cob_recibos_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_recibos_cabecera_id_seq OWNED BY public.cob_recibos_cabecera.id;


--
-- TOC entry 258 (class 1259 OID 16580)
-- Name: cob_recibos_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_recibos_detalle (
    id bigint NOT NULL,
    cantidad integer,
    dias_atraso integer,
    id_cuota_saldo bigint,
    monto_pagado numeric(19,2),
    nro_orden integer,
    cob_recibos_cabecera_id bigint,
    cob_saldo_id bigint
);


ALTER TABLE public.cob_recibos_detalle OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 16579)
-- Name: cob_recibos_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_recibos_detalle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_recibos_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 257
-- Name: cob_recibos_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_recibos_detalle_id_seq OWNED BY public.cob_recibos_detalle.id;


--
-- TOC entry 260 (class 1259 OID 16587)
-- Name: cob_saldos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_saldos (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_vencimiento date,
    id_comprobante bigint,
    id_cuota bigint,
    monto_cuota numeric(19,2),
    nro_comprobante_completo character varying(255),
    nro_cuota integer,
    saldo_cuota numeric(19,2),
    tipo_comprobante character varying(255),
    bs_empresa_id bigint NOT NULL,
    cob_cliente_id bigint NOT NULL
);


ALTER TABLE public.cob_saldos OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 16586)
-- Name: cob_saldos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_saldos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_saldos_id_seq OWNER TO postgres;

--
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 259
-- Name: cob_saldos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_saldos_id_seq OWNED BY public.cob_saldos.id;


--
-- TOC entry 262 (class 1259 OID 16596)
-- Name: com_proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.com_proveedores (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_proveedor character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_persona_id bigint
);


ALTER TABLE public.com_proveedores OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 16595)
-- Name: com_proveedores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.com_proveedores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.com_proveedores_id_seq OWNER TO postgres;

--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 261
-- Name: com_proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.com_proveedores_id_seq OWNED BY public.com_proveedores.id;


--
-- TOC entry 264 (class 1259 OID 16605)
-- Name: cre_desembolso_cabecera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cre_desembolso_cabecera (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_desembolso date,
    ind_desembolsado character varying(255),
    ind_facturado character varying(255),
    monto_total_capital numeric(19,2),
    monto_total_credito numeric(19,2),
    monto_total_interes numeric(19,2),
    monto_total_iva numeric(19,2),
    nro_desembolso numeric(19,2),
    taza_anual numeric(19,2),
    taza_mora numeric(19,2),
    bs_empresa_id bigint NOT NULL,
    bs_talonario_id bigint,
    cre_solicitud_credito_id bigint NOT NULL,
    cre_tipo_amortizacion_id bigint
);


ALTER TABLE public.cre_desembolso_cabecera OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 16604)
-- Name: cre_desembolso_cabecera_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cre_desembolso_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cre_desembolso_cabecera_id_seq OWNER TO postgres;

--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 263
-- Name: cre_desembolso_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_desembolso_cabecera_id_seq OWNED BY public.cre_desembolso_cabecera.id;


--
-- TOC entry 266 (class 1259 OID 16614)
-- Name: cre_desembolso_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cre_desembolso_detalle (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cantidad integer,
    fecha_vencimiento date,
    monto_capital numeric(19,2),
    monto_cuota numeric(19,2),
    monto_interes numeric(19,2),
    monto_iva numeric(19,2),
    nro_cuota integer,
    cre_desembolso_cabecera_id bigint,
    sto_articulo_id bigint
);


ALTER TABLE public.cre_desembolso_detalle OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 16613)
-- Name: cre_desembolso_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cre_desembolso_detalle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cre_desembolso_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 265
-- Name: cre_desembolso_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_desembolso_detalle_id_seq OWNED BY public.cre_desembolso_detalle.id;


--
-- TOC entry 268 (class 1259 OID 16623)
-- Name: cre_motivos_prestamos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cre_motivos_prestamos (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_motivo character varying(255),
    descripcion character varying(255)
);


ALTER TABLE public.cre_motivos_prestamos OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 16622)
-- Name: cre_motivos_prestamos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cre_motivos_prestamos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cre_motivos_prestamos_id_seq OWNER TO postgres;

--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 267
-- Name: cre_motivos_prestamos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_motivos_prestamos_id_seq OWNED BY public.cre_motivos_prestamos.id;


--
-- TOC entry 270 (class 1259 OID 16632)
-- Name: cre_solicitudes_creditos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cre_solicitudes_creditos (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_solicitud date,
    ind_autorizado character varying(255),
    ind_desembolsado character varying(255),
    monto_aprobado numeric(19,2),
    monto_solicitado numeric(19,2),
    plazo integer,
    primer_vencimiento date,
    bs_empresa_id bigint NOT NULL,
    cob_cliente_id bigint NOT NULL,
    cre_motivos_prestamos_id bigint NOT NULL,
    ven_vendedor_id bigint NOT NULL
);


ALTER TABLE public.cre_solicitudes_creditos OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 16631)
-- Name: cre_solicitudes_creditos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cre_solicitudes_creditos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cre_solicitudes_creditos_id_seq OWNER TO postgres;

--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 269
-- Name: cre_solicitudes_creditos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_solicitudes_creditos_id_seq OWNED BY public.cre_solicitudes_creditos.id;


--
-- TOC entry 272 (class 1259 OID 16641)
-- Name: cre_tipo_amortizaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cre_tipo_amortizaciones (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_tipo character varying(255),
    descripcion character varying(255)
);


ALTER TABLE public.cre_tipo_amortizaciones OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 16640)
-- Name: cre_tipo_amortizaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cre_tipo_amortizaciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cre_tipo_amortizaciones_id_seq OWNER TO postgres;

--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 271
-- Name: cre_tipo_amortizaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_tipo_amortizaciones_id_seq OWNED BY public.cre_tipo_amortizaciones.id;


--
-- TOC entry 274 (class 1259 OID 16650)
-- Name: sto_ajuste_inventarios_cabecera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sto_ajuste_inventarios_cabecera (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_operacion date,
    ind_autorizado character varying(255),
    nro_operacion bigint,
    observacion character varying(255),
    tipo_operacion character varying(255),
    bs_empresa_id bigint NOT NULL
);


ALTER TABLE public.sto_ajuste_inventarios_cabecera OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 16649)
-- Name: sto_ajuste_inventarios_cabecera_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sto_ajuste_inventarios_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sto_ajuste_inventarios_cabecera_id_seq OWNER TO postgres;

--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 273
-- Name: sto_ajuste_inventarios_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sto_ajuste_inventarios_cabecera_id_seq OWNED BY public.sto_ajuste_inventarios_cabecera.id;


--
-- TOC entry 276 (class 1259 OID 16659)
-- Name: sto_ajuste_inventarios_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sto_ajuste_inventarios_detalle (
    id bigint NOT NULL,
    cantidad_fisica integer,
    cantidad_sistema integer,
    nro_orden integer,
    sto_ajuste_inventarios_cabecera_id bigint,
    sto_articulo_id bigint
);


ALTER TABLE public.sto_ajuste_inventarios_detalle OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 16658)
-- Name: sto_ajuste_inventarios_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sto_ajuste_inventarios_detalle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sto_ajuste_inventarios_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 275
-- Name: sto_ajuste_inventarios_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sto_ajuste_inventarios_detalle_id_seq OWNED BY public.sto_ajuste_inventarios_detalle.id;


--
-- TOC entry 278 (class 1259 OID 16666)
-- Name: sto_articulos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sto_articulos (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_articulo character varying(255),
    descripcion character varying(255),
    ind_inventariable character varying(255),
    precio_unitario numeric(19,2),
    bs_empresa_id bigint NOT NULL,
    bs_iva_id bigint NOT NULL
);


ALTER TABLE public.sto_articulos OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 16674)
-- Name: sto_articulos_existencias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sto_articulos_existencias (
    id bigint NOT NULL,
    existencia numeric(19,2),
    existencia_anterior numeric(19,2),
    sto_articulo_id bigint NOT NULL
);


ALTER TABLE public.sto_articulos_existencias OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16389)
-- Name: sto_articulos_existencias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sto_articulos_existencias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sto_articulos_existencias_id_seq OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 16665)
-- Name: sto_articulos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sto_articulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sto_articulos_id_seq OWNER TO postgres;

--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 277
-- Name: sto_articulos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sto_articulos_id_seq OWNED BY public.sto_articulos.id;


--
-- TOC entry 281 (class 1259 OID 16680)
-- Name: tes_bancos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_bancos (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    saldo_cuenta numeric(19,2),
    cod_banco character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_moneda_id bigint,
    bs_persona_id bigint
);


ALTER TABLE public.tes_bancos OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 16679)
-- Name: tes_bancos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_bancos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_bancos_id_seq OWNER TO postgres;

--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 280
-- Name: tes_bancos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_bancos_id_seq OWNED BY public.tes_bancos.id;


--
-- TOC entry 283 (class 1259 OID 16689)
-- Name: tes_depositos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_depositos (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_deposito date,
    monto_total_deposito numeric(19,2),
    nro_boleta bigint,
    observacion character varying(255),
    bs_empresa_id bigint NOT NULL,
    cob_habilitacion_id bigint NOT NULL,
    tes_banco_id bigint NOT NULL
);


ALTER TABLE public.tes_depositos OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 16688)
-- Name: tes_depositos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_depositos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_depositos_id_seq OWNER TO postgres;

--
-- TOC entry 3918 (class 0 OID 0)
-- Dependencies: 282
-- Name: tes_depositos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_depositos_id_seq OWNED BY public.tes_depositos.id;


--
-- TOC entry 285 (class 1259 OID 16698)
-- Name: tes_pago_comprobante_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_pago_comprobante_detalle (
    id bigint NOT NULL,
    id_cuota_saldo bigint,
    monto_pagado numeric(19,2),
    nro_orden integer,
    tipo_comprobante character varying(255),
    tes_pagos_cabecera_id bigint
);


ALTER TABLE public.tes_pago_comprobante_detalle OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 16697)
-- Name: tes_pago_comprobante_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_pago_comprobante_detalle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_pago_comprobante_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 3919 (class 0 OID 0)
-- Dependencies: 284
-- Name: tes_pago_comprobante_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_pago_comprobante_detalle_id_seq OWNED BY public.tes_pago_comprobante_detalle.id;


--
-- TOC entry 287 (class 1259 OID 16705)
-- Name: tes_pagos_cabecera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_pagos_cabecera (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    beneficiario character varying(255),
    fecha_pago date,
    id_beneficiario bigint,
    ind_autorizado character varying(255),
    ind_impreso character varying(255),
    monto_total_pago numeric(19,2),
    nro_pago bigint,
    nro_pago_completo character varying(255),
    observacion character varying(255),
    tipo_operacion character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_talonario_id bigint,
    cob_habilitacion_id bigint NOT NULL
);


ALTER TABLE public.tes_pagos_cabecera OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 16704)
-- Name: tes_pagos_cabecera_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_pagos_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_pagos_cabecera_id_seq OWNER TO postgres;

--
-- TOC entry 3920 (class 0 OID 0)
-- Dependencies: 286
-- Name: tes_pagos_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_pagos_cabecera_id_seq OWNED BY public.tes_pagos_cabecera.id;


--
-- TOC entry 289 (class 1259 OID 16714)
-- Name: tes_pagos_valores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_pagos_valores (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_entrega date,
    fecha_valor date,
    fecha_vencimiento date,
    ind_entregado character varying(255),
    monto_cuota numeric(19,2),
    nro_orden integer,
    nro_valor character varying(255),
    tipo_operacion character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_tipo_valor_id bigint NOT NULL,
    tes_banco_id bigint NOT NULL,
    tes_pagos_cabecera_id bigint
);


ALTER TABLE public.tes_pagos_valores OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 16713)
-- Name: tes_pagos_valores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_pagos_valores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_pagos_valores_id_seq OWNER TO postgres;

--
-- TOC entry 3921 (class 0 OID 0)
-- Dependencies: 288
-- Name: tes_pagos_valores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_pagos_valores_id_seq OWNED BY public.tes_pagos_valores.id;


--
-- TOC entry 291 (class 1259 OID 16723)
-- Name: ven_condicion_ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ven_condicion_ventas (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_condicion character varying(255),
    descripcion character varying(255),
    intervalo numeric(19,2),
    plazo numeric(19,2),
    bs_empresa_id bigint NOT NULL
);


ALTER TABLE public.ven_condicion_ventas OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 16722)
-- Name: ven_condicion_ventas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ven_condicion_ventas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ven_condicion_ventas_id_seq OWNER TO postgres;

--
-- TOC entry 3922 (class 0 OID 0)
-- Dependencies: 290
-- Name: ven_condicion_ventas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ven_condicion_ventas_id_seq OWNED BY public.ven_condicion_ventas.id;


--
-- TOC entry 293 (class 1259 OID 16732)
-- Name: ven_facturas_cabecera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ven_facturas_cabecera (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_factura date,
    id_comprobante bigint,
    ind_cobrado character varying(255),
    ind_impreso character varying(255),
    monto_total_exenta numeric(19,2),
    monto_total_factura numeric(19,2),
    monto_total_gravada numeric(19,2),
    monto_total_iva numeric(19,2),
    nro_factura bigint,
    nro_factura_completo character varying(255),
    observacion character varying(255),
    tipo_factura character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_talonario_id bigint NOT NULL,
    cob_cliente_id bigint NOT NULL,
    cob_habilitacion_caja_id bigint NOT NULL,
    ven_condicion_venta_id bigint NOT NULL,
    ven_vendedor_id bigint NOT NULL
);


ALTER TABLE public.ven_facturas_cabecera OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 16731)
-- Name: ven_facturas_cabecera_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ven_facturas_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ven_facturas_cabecera_id_seq OWNER TO postgres;

--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 292
-- Name: ven_facturas_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ven_facturas_cabecera_id_seq OWNED BY public.ven_facturas_cabecera.id;


--
-- TOC entry 295 (class 1259 OID 16741)
-- Name: ven_facturas_detalles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ven_facturas_detalles (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cantidad integer,
    cod_iva character varying(255),
    monto_exento numeric(19,2),
    monto_gravado numeric(19,2),
    monto_iva numeric(19,2),
    monto_linea numeric(19,2),
    nro_orden integer,
    precio_unitario numeric(19,2),
    sto_articulo_id bigint,
    ven_facturas_cabecera_id bigint
);


ALTER TABLE public.ven_facturas_detalles OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 16740)
-- Name: ven_facturas_detalles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ven_facturas_detalles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ven_facturas_detalles_id_seq OWNER TO postgres;

--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 294
-- Name: ven_facturas_detalles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ven_facturas_detalles_id_seq OWNED BY public.ven_facturas_detalles.id;


--
-- TOC entry 297 (class 1259 OID 16750)
-- Name: ven_vendedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ven_vendedores (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_vendedor character varying(255),
    bs_empresa_id bigint NOT NULL,
    id_bs_persona bigint
);


ALTER TABLE public.ven_vendedores OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 16749)
-- Name: ven_vendedores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ven_vendedores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ven_vendedores_id_seq OWNER TO postgres;

--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 296
-- Name: ven_vendedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ven_vendedores_id_seq OWNED BY public.ven_vendedores.id;


--
-- TOC entry 3404 (class 2604 OID 16394)
-- Name: bs_empresas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_empresas ALTER COLUMN id SET DEFAULT nextval('public.bs_empresas_id_seq'::regclass);


--
-- TOC entry 3405 (class 2604 OID 16403)
-- Name: bs_iva id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_iva ALTER COLUMN id SET DEFAULT nextval('public.bs_iva_id_seq'::regclass);


--
-- TOC entry 3406 (class 2604 OID 16412)
-- Name: bs_menu id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu ALTER COLUMN id SET DEFAULT nextval('public.bs_menu_id_seq'::regclass);


--
-- TOC entry 3407 (class 2604 OID 16421)
-- Name: bs_menu_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu_item ALTER COLUMN id SET DEFAULT nextval('public.bs_menu_item_id_seq'::regclass);


--
-- TOC entry 3408 (class 2604 OID 16430)
-- Name: bs_modulo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_modulo ALTER COLUMN id SET DEFAULT nextval('public.bs_modulo_id_seq'::regclass);


--
-- TOC entry 3409 (class 2604 OID 16439)
-- Name: bs_moneda id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_moneda ALTER COLUMN id SET DEFAULT nextval('public.bs_moneda_id_seq'::regclass);


--
-- TOC entry 3410 (class 2604 OID 16448)
-- Name: bs_parametros id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros ALTER COLUMN id SET DEFAULT nextval('public.bs_parametros_id_seq'::regclass);


--
-- TOC entry 3411 (class 2604 OID 16457)
-- Name: bs_permiso_rol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol ALTER COLUMN id SET DEFAULT nextval('public.bs_permiso_rol_id_seq'::regclass);


--
-- TOC entry 3412 (class 2604 OID 16466)
-- Name: bs_persona id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_persona ALTER COLUMN id SET DEFAULT nextval('public.bs_persona_id_seq'::regclass);


--
-- TOC entry 3413 (class 2604 OID 16475)
-- Name: bs_rol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_rol ALTER COLUMN id SET DEFAULT nextval('public.bs_rol_id_seq'::regclass);


--
-- TOC entry 3414 (class 2604 OID 16484)
-- Name: bs_talonarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios ALTER COLUMN id SET DEFAULT nextval('public.bs_talonarios_id_seq'::regclass);


--
-- TOC entry 3415 (class 2604 OID 16493)
-- Name: bs_timbrados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_timbrados ALTER COLUMN id SET DEFAULT nextval('public.bs_timbrados_id_seq'::regclass);


--
-- TOC entry 3416 (class 2604 OID 16502)
-- Name: bs_tipo_comprobantes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_comprobantes ALTER COLUMN id SET DEFAULT nextval('public.bs_tipo_comprobantes_id_seq'::regclass);


--
-- TOC entry 3417 (class 2604 OID 16511)
-- Name: bs_tipo_valor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor ALTER COLUMN id SET DEFAULT nextval('public.bs_tipo_valor_id_seq'::regclass);


--
-- TOC entry 3418 (class 2604 OID 16520)
-- Name: bs_usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario ALTER COLUMN id SET DEFAULT nextval('public.bs_usuario_id_seq'::regclass);


--
-- TOC entry 3419 (class 2604 OID 16529)
-- Name: cob_cajas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas ALTER COLUMN id SET DEFAULT nextval('public.cob_cajas_id_seq'::regclass);


--
-- TOC entry 3420 (class 2604 OID 16538)
-- Name: cob_clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes ALTER COLUMN id SET DEFAULT nextval('public.cob_clientes_id_seq'::regclass);


--
-- TOC entry 3421 (class 2604 OID 16547)
-- Name: cob_cobradores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores ALTER COLUMN id SET DEFAULT nextval('public.cob_cobradores_id_seq'::regclass);


--
-- TOC entry 3422 (class 2604 OID 16556)
-- Name: cob_cobros_valores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores ALTER COLUMN id SET DEFAULT nextval('public.cob_cobros_valores_id_seq'::regclass);


--
-- TOC entry 3423 (class 2604 OID 16565)
-- Name: cob_habilitaciones_cajas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_habilitaciones_cajas ALTER COLUMN id SET DEFAULT nextval('public.cob_habilitaciones_cajas_id_seq'::regclass);


--
-- TOC entry 3424 (class 2604 OID 16574)
-- Name: cob_recibos_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera ALTER COLUMN id SET DEFAULT nextval('public.cob_recibos_cabecera_id_seq'::regclass);


--
-- TOC entry 3425 (class 2604 OID 16583)
-- Name: cob_recibos_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle ALTER COLUMN id SET DEFAULT nextval('public.cob_recibos_detalle_id_seq'::regclass);


--
-- TOC entry 3426 (class 2604 OID 16590)
-- Name: cob_saldos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos ALTER COLUMN id SET DEFAULT nextval('public.cob_saldos_id_seq'::regclass);


--
-- TOC entry 3427 (class 2604 OID 16599)
-- Name: com_proveedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores ALTER COLUMN id SET DEFAULT nextval('public.com_proveedores_id_seq'::regclass);


--
-- TOC entry 3428 (class 2604 OID 16608)
-- Name: cre_desembolso_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera ALTER COLUMN id SET DEFAULT nextval('public.cre_desembolso_cabecera_id_seq'::regclass);


--
-- TOC entry 3429 (class 2604 OID 16617)
-- Name: cre_desembolso_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_detalle ALTER COLUMN id SET DEFAULT nextval('public.cre_desembolso_detalle_id_seq'::regclass);


--
-- TOC entry 3430 (class 2604 OID 16626)
-- Name: cre_motivos_prestamos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_motivos_prestamos ALTER COLUMN id SET DEFAULT nextval('public.cre_motivos_prestamos_id_seq'::regclass);


--
-- TOC entry 3431 (class 2604 OID 16635)
-- Name: cre_solicitudes_creditos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos ALTER COLUMN id SET DEFAULT nextval('public.cre_solicitudes_creditos_id_seq'::regclass);


--
-- TOC entry 3432 (class 2604 OID 16644)
-- Name: cre_tipo_amortizaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_tipo_amortizaciones ALTER COLUMN id SET DEFAULT nextval('public.cre_tipo_amortizaciones_id_seq'::regclass);


--
-- TOC entry 3433 (class 2604 OID 16653)
-- Name: sto_ajuste_inventarios_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_cabecera ALTER COLUMN id SET DEFAULT nextval('public.sto_ajuste_inventarios_cabecera_id_seq'::regclass);


--
-- TOC entry 3434 (class 2604 OID 16662)
-- Name: sto_ajuste_inventarios_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_detalle ALTER COLUMN id SET DEFAULT nextval('public.sto_ajuste_inventarios_detalle_id_seq'::regclass);


--
-- TOC entry 3435 (class 2604 OID 16669)
-- Name: sto_articulos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos ALTER COLUMN id SET DEFAULT nextval('public.sto_articulos_id_seq'::regclass);


--
-- TOC entry 3436 (class 2604 OID 16683)
-- Name: tes_bancos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos ALTER COLUMN id SET DEFAULT nextval('public.tes_bancos_id_seq'::regclass);


--
-- TOC entry 3437 (class 2604 OID 16692)
-- Name: tes_depositos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos ALTER COLUMN id SET DEFAULT nextval('public.tes_depositos_id_seq'::regclass);


--
-- TOC entry 3438 (class 2604 OID 16701)
-- Name: tes_pago_comprobante_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pago_comprobante_detalle ALTER COLUMN id SET DEFAULT nextval('public.tes_pago_comprobante_detalle_id_seq'::regclass);


--
-- TOC entry 3439 (class 2604 OID 16708)
-- Name: tes_pagos_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera ALTER COLUMN id SET DEFAULT nextval('public.tes_pagos_cabecera_id_seq'::regclass);


--
-- TOC entry 3440 (class 2604 OID 16717)
-- Name: tes_pagos_valores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores ALTER COLUMN id SET DEFAULT nextval('public.tes_pagos_valores_id_seq'::regclass);


--
-- TOC entry 3441 (class 2604 OID 16726)
-- Name: ven_condicion_ventas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_condicion_ventas ALTER COLUMN id SET DEFAULT nextval('public.ven_condicion_ventas_id_seq'::regclass);


--
-- TOC entry 3442 (class 2604 OID 16735)
-- Name: ven_facturas_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera ALTER COLUMN id SET DEFAULT nextval('public.ven_facturas_cabecera_id_seq'::regclass);


--
-- TOC entry 3443 (class 2604 OID 16744)
-- Name: ven_facturas_detalles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_detalles ALTER COLUMN id SET DEFAULT nextval('public.ven_facturas_detalles_id_seq'::regclass);


--
-- TOC entry 3444 (class 2604 OID 16753)
-- Name: ven_vendedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores ALTER COLUMN id SET DEFAULT nextval('public.ven_vendedores_id_seq'::regclass);


--
-- TOC entry 3797 (class 0 OID 16391)
-- Dependencies: 216
-- Data for Name: bs_empresas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_empresas VALUES (1, 'ACTIVO', '2023-11-24 16:58:47.235596', '2023-11-24 16:58:47.235596', NULL, 'Asuncion, Barrio Carmelitas', 'CAPITAL CREDITOS S.A.', 3);


--
-- TOC entry 3799 (class 0 OID 16400)
-- Dependencies: 218
-- Data for Name: bs_iva; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_iva VALUES (1, 'ACTIVO', '2023-11-24 15:31:55.768829', '2023-11-24 15:31:55.768829', NULL, 'IVA10', 'IVA 10', 10.00);
INSERT INTO public.bs_iva VALUES (2, 'ACTIVO', '2023-11-24 15:32:33.140511', '2023-11-24 15:32:33.140511', NULL, 'IVA5', 'IVA 5', 21.00);
INSERT INTO public.bs_iva VALUES (4, 'ACTIVO', '2024-01-25 19:53:16.738656', '2024-01-25 19:53:16.737648', 'fvazquez', 'EX', 'EXENTA', 0.00);


--
-- TOC entry 3801 (class 0 OID 16409)
-- Dependencies: 220
-- Data for Name: bs_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_menu VALUES (41, 'Caja', 'Cajas por Usuario', 4, 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCaja.xhtml', 8, NULL);
INSERT INTO public.bs_menu VALUES (42, 'habilitacion caja', 'Habilitacion de Caja', 5, 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobHabilitacionCaja.xhtml', 8, NULL);
INSERT INTO public.bs_menu VALUES (43, 'talonario', 'Talonarios', 14, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTalonario.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (44, 'timbrado', 'Timbrados', 15, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTimbrado.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (45, 'desembolso credito', 'Desembolso de Credito', 4, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/creditos/movimientos/CreDesembolsoCredito.xhtml', 9, NULL);
INSERT INTO public.bs_menu VALUES (46, 'Facturas', 'Facturacion', 3, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/ventas/movimientos/VenFacturas.xhtml', 11, NULL);
INSERT INTO public.bs_menu VALUES (47, 'proveedor', 'Proveedores', 1, 'ITEM', 'DEFINICION', '/pages/cliente/compras/definicion/ComProveedor.xhtml', 14, NULL);
INSERT INTO public.bs_menu VALUES (48, 'banco', 'Bancos', 1, 'ITEM', 'DEFINICION', '/pages/cliente/tesoreria/definicion/TesBanco.xhtml', 10, NULL);
INSERT INTO public.bs_menu VALUES (49, 'ajuste inventario', 'Ajustes de Inventarios', 2, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/stock/movimientos/StoAjusteInventario.xhtml', 13, NULL);
INSERT INTO public.bs_menu VALUES (50, 'recibos', 'Recibos', 6, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/cobranzas/movimientos/CobRecibos.xhtml', 8, NULL);
INSERT INTO public.bs_menu VALUES (51, 'deposito', 'Depositos', 2, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/tesoreria/movimientos/TesDeposito.xhtml', 10, NULL);
INSERT INTO public.bs_menu VALUES (1, 'Usuarios', 'Usuarios', 6, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsUsuario.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (6, 'Personas', 'Personas', 5, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsPersona.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (5, 'Roles', 'Roles', 2, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsRol.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (3, 'Modulos', 'Modulos', 1, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsModulo.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (22, 'Impuestos', 'Impuestos', 9, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsIva.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (21, 'Monedas', 'Monedas', 10, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsMoneda.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (24, 'Parametros Generales', 'Parametros Generales', 8, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsParametro.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (28, 'Cobrador', 'Cobrador', 2, 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCobrador.xhtml', 8, NULL);
INSERT INTO public.bs_menu VALUES (27, 'Clientes', 'Clientes', 1, 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCliente.xhtml', 8, NULL);
INSERT INTO public.bs_menu VALUES (23, 'Empresas', 'Empresas', 7, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsEmpresa.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (52, 'pago', 'Pagos/Desembolsos', 3, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/tesoreria/movimientos/TesPago.xhtml', 10, NULL);
INSERT INTO public.bs_menu VALUES (53, 'ventas por fecha', 'Ventas por Fecha y Cliente', 4, 'ITEM', 'REPORTES', '/pages/cliente/ventas/reportes/VenVentasPorFecha.xhtml', 11, NULL);
INSERT INTO public.bs_menu VALUES (54, 'recibos por fecha', 'Recibos por Fecha y Cliente', 7, 'ITEM', 'REPORTES', '/pages/cliente/cobranzas/reportes/CobRecibosPorFecha.xhtml', 8, NULL);
INSERT INTO public.bs_menu VALUES (55, 'desembolsos por fecha', 'Desembolsos por Fecha y Cliente', 5, 'ITEM', 'REPORTES', '/pages/cliente/creditos/reportes/CreDesembolsosPorFecha.xhtml', 9, NULL);
INSERT INTO public.bs_menu VALUES (35, 'Condicion venta', 'Condicion venta', 2, 'ITEM', 'DEFINICION', '/pages/cliente/ventas/definicion/VenCondicionVenta.xhtml', 11, NULL);
INSERT INTO public.bs_menu VALUES (34, 'Vendedores', 'Vendedores', 1, 'ITEM', 'DEFINICION', '/pages/cliente/ventas/definicion/VenVendedor.xhtml', 11, NULL);
INSERT INTO public.bs_menu VALUES (36, 'Articulos', 'Articulos', 1, 'ITEM', 'DEFINICION', '/pages/cliente/stock/definicion/StoArticulo.xhtml', 13, NULL);
INSERT INTO public.bs_menu VALUES (37, 'Reporte Permisos Rol por Fecha', 'Reporte Permisos Rol por Fecha', 13, 'ITEM', 'REPORTES', '/pages/cliente/base/reportes/BsPermisoRolPorFechaCreacion.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (38, 'Tipo Amortizacion', 'Tipo Amortizacion', 1, 'ITEM', 'DEFINICION', '/pages/cliente/creditos/definicion/CreTipoAmortizacion.xhtml', 9, NULL);
INSERT INTO public.bs_menu VALUES (39, 'Motivo Prestamo', 'Motivo Prestamo', 2, 'ITEM', 'DEFINICION', '/pages/cliente/creditos/definicion/CreMotivoPrestamo.xhtml', 9, NULL);
INSERT INTO public.bs_menu VALUES (40, 'Solicitud de Credito', 'Solicitud de Credito', 3, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/creditos/movimientos/CreSolicitudCredito.xhtml', 9, NULL);
INSERT INTO public.bs_menu VALUES (17, 'Menus', 'Menus', 3, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsMenu.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (18, 'Permisos por Pantalla', 'Permisos por Pantalla', 4, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsPermisoRol.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (26, 'Tipos de Comprobantes', 'Tipos de Comprobantes', 12, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTipoComprobante.xhtml', 1, NULL);
INSERT INTO public.bs_menu VALUES (25, 'Tipos de Valores', 'Tipos de Valores', 11, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTipoValor.xhtml', 1, NULL);


--
-- TOC entry 3803 (class 0 OID 16418)
-- Dependencies: 222
-- Data for Name: bs_menu_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_menu_item VALUES (1, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 1);
INSERT INTO public.bs_menu_item VALUES (8, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 1);
INSERT INTO public.bs_menu_item VALUES (9, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 1);
INSERT INTO public.bs_menu_item VALUES (2, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-ellipsis-v', 1, '2', 'MENU', 'Modulos', 3, 1);
INSERT INTO public.bs_menu_item VALUES (3, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-ellipsis-v', 1, '3', 'MENU', 'Persona', 6, 1);
INSERT INTO public.bs_menu_item VALUES (4, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-ellipsis-v', 1, '5', 'MENU', 'Roles', 5, 1);
INSERT INTO public.bs_menu_item VALUES (5, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-ellipsis-v', 1, '7', 'MENU', 'Usuarios', 1, 1);
INSERT INTO public.bs_menu_item VALUES (11, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 8);
INSERT INTO public.bs_menu_item VALUES (12, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 8);
INSERT INTO public.bs_menu_item VALUES (13, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 8);
INSERT INTO public.bs_menu_item VALUES (14, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 9);
INSERT INTO public.bs_menu_item VALUES (15, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 9);
INSERT INTO public.bs_menu_item VALUES (16, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 9);
INSERT INTO public.bs_menu_item VALUES (17, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 10);
INSERT INTO public.bs_menu_item VALUES (18, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 10);
INSERT INTO public.bs_menu_item VALUES (19, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 10);
INSERT INTO public.bs_menu_item VALUES (20, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 11);
INSERT INTO public.bs_menu_item VALUES (21, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 11);
INSERT INTO public.bs_menu_item VALUES (22, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 11);
INSERT INTO public.bs_menu_item VALUES (23, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 12);
INSERT INTO public.bs_menu_item VALUES (24, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 12);
INSERT INTO public.bs_menu_item VALUES (25, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 12);
INSERT INTO public.bs_menu_item VALUES (27, 'ACTIVO', '2023-09-12 13:38:42.593191', '2023-09-12 13:38:42.593191', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Permisos por Pantalla', 18, 1);
INSERT INTO public.bs_menu_item VALUES (26, 'ACTIVO', '2023-09-12 13:31:52.496447', '2023-09-12 13:31:52.496447', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Menus', 17, 1);
INSERT INTO public.bs_menu_item VALUES (28, 'ACTIVO', '2023-11-23 11:49:39.706615', '2023-11-23 11:49:39.706615', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Monedas', 21, 1);
INSERT INTO public.bs_menu_item VALUES (29, 'ACTIVO', '2023-11-24 15:29:19.649737', '2023-11-24 15:29:19.649737', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Impuestos', 22, 1);
INSERT INTO public.bs_menu_item VALUES (30, 'ACTIVO', '2023-11-24 16:54:32.841298', '2023-11-24 16:54:32.841298', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Empresas', 23, 1);
INSERT INTO public.bs_menu_item VALUES (31, 'ACTIVO', '2023-11-27 10:33:13.73056', '2023-11-27 10:33:13.73056', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Parametros Generales', 24, 1);
INSERT INTO public.bs_menu_item VALUES (32, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 13);
INSERT INTO public.bs_menu_item VALUES (33, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 13);
INSERT INTO public.bs_menu_item VALUES (34, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 13);
INSERT INTO public.bs_menu_item VALUES (35, 'ACTIVO', '2023-11-30 16:50:59.51816', '2023-11-30 16:50:59.51816', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Tipos de Valores', 25, 1);
INSERT INTO public.bs_menu_item VALUES (36, 'ACTIVO', '2023-11-30 16:51:34.092384', '2023-11-30 16:51:34.092384', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Tipos de Comprobantes', 26, 1);
INSERT INTO public.bs_menu_item VALUES (37, 'ACTIVO', '2023-12-01 11:15:49.877244', '2023-12-01 11:15:49.877244', NULL, 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Clientes', 27, 8);
INSERT INTO public.bs_menu_item VALUES (38, 'ACTIVO', '2023-12-01 11:16:28.895258', '2023-12-01 11:16:28.895258', NULL, 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Cobrador', 28, 8);
INSERT INTO public.bs_menu_item VALUES (65, 'ACTIVO', '2024-01-22 12:05:39.357153', '2024-01-22 12:05:39.357153', NULL, 'pi pi-fw pi-ellipsis-v', 18, NULL, 'MENU', 'Pagos/Desembolsos', 52, 10);
INSERT INTO public.bs_menu_item VALUES (44, 'ACTIVO', '2023-12-12 17:55:18.715526', '2023-12-12 17:55:18.715526', NULL, 'pi pi-fw pi-ellipsis-v', 20, NULL, 'MENU', 'Vendedores', 34, 11);
INSERT INTO public.bs_menu_item VALUES (45, 'ACTIVO', '2023-12-12 17:59:18.370812', '2023-12-12 17:59:18.370812', NULL, 'pi pi-fw pi-ellipsis-v', 20, NULL, 'MENU', 'Condicion venta', 35, 11);
INSERT INTO public.bs_menu_item VALUES (46, 'ACTIVO', '2023-12-12 18:00:14.048414', '2023-12-12 18:00:14.048414', NULL, 'pi pi-fw pi-ellipsis-v', 32, NULL, 'MENU', 'Articulos', 36, 13);
INSERT INTO public.bs_menu_item VALUES (47, 'ACTIVO', '2023-12-15 14:28:00.440027', '2023-12-15 14:28:00.440027', NULL, 'pi pi-fw pi-ellipsis-v', 9, NULL, 'MENU', 'Reporte Permisos Rol por Fecha', 37, 1);
INSERT INTO public.bs_menu_item VALUES (48, 'ACTIVO', '2023-12-27 10:45:07.453953', '2023-12-27 10:45:07.453953', NULL, 'pi pi-fw pi-ellipsis-v', 14, NULL, 'MENU', 'Tipo Amortizacion', 38, 9);
INSERT INTO public.bs_menu_item VALUES (49, 'ACTIVO', '2023-12-27 10:45:44.742158', '2023-12-27 10:45:44.742158', NULL, 'pi pi-fw pi-ellipsis-v', 14, NULL, 'MENU', 'Motivo Prestamo', 39, 9);
INSERT INTO public.bs_menu_item VALUES (50, 'ACTIVO', '2023-12-27 15:23:23.074387', '2023-12-27 15:23:23.074387', NULL, 'pi pi-fw pi-ellipsis-v', 15, NULL, 'MENU', 'Solicitud de Credito', 40, 9);
INSERT INTO public.bs_menu_item VALUES (51, 'ACTIVO', '2023-12-28 15:47:02.363933', '2023-12-28 15:47:02.363933', NULL, 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Cajas por Usuario', 41, 8);
INSERT INTO public.bs_menu_item VALUES (52, 'ACTIVO', '2023-12-28 15:48:50.792045', '2023-12-28 15:48:50.792045', NULL, 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Habilitacion de Caja', 42, 8);
INSERT INTO public.bs_menu_item VALUES (53, 'ACTIVO', '2024-01-02 17:15:09.117451', '2024-01-02 17:15:09.117451', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Talonarios', 43, 1);
INSERT INTO public.bs_menu_item VALUES (54, 'ACTIVO', '2024-01-02 17:15:25.935552', '2024-01-02 17:15:25.935552', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Timbrados', 44, 1);
INSERT INTO public.bs_menu_item VALUES (55, 'ACTIVO', '2024-01-04 14:20:34.987513', '2024-01-04 14:20:34.987513', NULL, 'pi pi-fw pi-ellipsis-v', 15, NULL, 'MENU', 'Desembolso de Credito', 45, 9);
INSERT INTO public.bs_menu_item VALUES (56, 'ACTIVO', '2024-01-10 15:28:27.608602', '2024-01-10 15:28:27.608602', NULL, 'pi pi-fw pi-ellipsis-v', 21, NULL, 'MENU', 'Facturacion', 46, 11);
INSERT INTO public.bs_menu_item VALUES (57, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 14);
INSERT INTO public.bs_menu_item VALUES (58, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 14);
INSERT INTO public.bs_menu_item VALUES (59, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 14);
INSERT INTO public.bs_menu_item VALUES (60, 'ACTIVO', '2024-01-12 19:32:22.264846', '2024-01-12 19:32:22.264846', NULL, 'pi pi-fw pi-ellipsis-v', 57, NULL, 'MENU', 'Proveedores', 47, 14);
INSERT INTO public.bs_menu_item VALUES (61, 'ACTIVO', '2024-01-12 19:32:47.387516', '2024-01-12 19:32:47.387516', NULL, 'pi pi-fw pi-ellipsis-v', 17, NULL, 'MENU', 'Bancos', 48, 10);
INSERT INTO public.bs_menu_item VALUES (62, 'ACTIVO', '2024-01-12 23:34:38.56794', '2024-01-12 23:34:38.56794', NULL, 'pi pi-fw pi-ellipsis-v', 33, NULL, 'MENU', 'Ajustes de Inventarios', 49, 13);
INSERT INTO public.bs_menu_item VALUES (63, 'ACTIVO', '2024-01-15 16:44:38.482895', '2024-01-15 16:44:38.482895', NULL, 'pi pi-fw pi-ellipsis-v', 12, NULL, 'MENU', 'Recibos', 50, 8);
INSERT INTO public.bs_menu_item VALUES (64, 'ACTIVO', '2024-01-18 15:24:21.817528', '2024-01-18 15:24:21.817528', NULL, 'pi pi-fw pi-ellipsis-v', 18, NULL, 'MENU', 'Depositos', 51, 10);
INSERT INTO public.bs_menu_item VALUES (66, 'ACTIVO', '2024-02-12 12:11:15.227474', '2024-02-12 12:11:15.227474', NULL, 'pi pi-fw pi-ellipsis-v', 22, NULL, 'MENU', 'Ventas por Fecha y Cliente', 53, 11);
INSERT INTO public.bs_menu_item VALUES (67, 'ACTIVO', '2024-02-13 08:38:38.543221', '2024-02-13 08:38:38.543221', NULL, 'pi pi-fw pi-ellipsis-v', 13, NULL, 'MENU', 'Recibos por Fecha y Cliente', 54, 8);
INSERT INTO public.bs_menu_item VALUES (68, 'ACTIVO', '2024-02-13 10:31:29.805258', '2024-02-13 10:31:29.805258', NULL, 'pi pi-fw pi-ellipsis-v', 16, NULL, 'MENU', 'Desembolsos por Fecha y Cliente', 55, 9);


--
-- TOC entry 3805 (class 0 OID 16427)
-- Dependencies: 224
-- Data for Name: bs_modulo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_modulo VALUES (8, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', NULL, 'COB', 'pi pi-fw pi-phone', 'COBRANZAS', 2, 'cobranzas');
INSERT INTO public.bs_modulo VALUES (1, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', NULL, 'BS', 'pi pi-fw pi-cog', 'MODULO BASE', 1, 'base');
INSERT INTO public.bs_modulo VALUES (10, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', NULL, 'TES', 'pi pi-fw pi-chart-bar', 'TESORERIA', 5, 'tesoreria');
INSERT INTO public.bs_modulo VALUES (9, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', NULL, 'CRE', 'pi pi-fw pi-wallet', 'CREDITOS', 4, 'creditos');
INSERT INTO public.bs_modulo VALUES (12, 'INACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', NULL, 'CON', 'pi pi-fw pi-euro', 'CONTABILIDAD', 6, 'contabilidad');
INSERT INTO public.bs_modulo VALUES (11, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', NULL, 'VEN', 'pi pi-fw pi-chart-line', 'VENTAS', 3, 'ventas');
INSERT INTO public.bs_modulo VALUES (13, 'ACTIVO', '2023-11-29 09:12:32.676719', '2023-11-29 09:12:32.676719', NULL, 'STO', 'pi pi-shopping-bag', 'STOCK', 7, 'stock');
INSERT INTO public.bs_modulo VALUES (14, 'ACTIVO', '2024-01-12 19:31:47.085795', '2024-01-12 19:31:47.085795', 'fvazquez', 'COM', 'pi pi-shopping-cart', 'COMPRAS', 8, 'compras');


--
-- TOC entry 3807 (class 0 OID 16436)
-- Dependencies: 226
-- Data for Name: bs_moneda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_moneda VALUES (1, 'ACTIVO', '2023-11-23 15:30:46.655571', '2023-11-23 15:30:46.655571', NULL, 'GS', 0, 'GUARANIES');
INSERT INTO public.bs_moneda VALUES (2, 'ACTIVO', '2023-11-23 15:31:02.869325', '2023-11-23 15:31:02.869325', NULL, 'USD', 2, 'DOLARES');


--
-- TOC entry 3809 (class 0 OID 16445)
-- Dependencies: 228
-- Data for Name: bs_parametros; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_parametros VALUES (2, 'ACTIVO', '2023-11-27 10:44:52.649203', '2023-11-27 10:44:52.649203', NULL, 'Parametro de prueba', 'BSPARAMETRO', 'valor_prueba', 1, 8);
INSERT INTO public.bs_parametros VALUES (3, 'ACTIVO', '2024-01-04 16:44:15.211679', '2024-01-04 16:44:15.211679', 'fvazquez', 'Parametro para la taza anual', 'TAZANUAL', '35', 1, 9);
INSERT INTO public.bs_parametros VALUES (4, 'ACTIVO', '2024-01-04 16:44:49.039995', '2024-01-04 16:44:49.039995', 'fvazquez', 'Parametro para taza mora', 'TAZAMORA', '3', 1, 9);
INSERT INTO public.bs_parametros VALUES (5, 'ACTIVO', '2024-01-05 11:38:13.821259', '2024-01-05 11:38:13.819816', 'fvazquez', 'Articulo utilizado para cuotas de creditos', 'CUO', 'CUO', 1, 9);
INSERT INTO public.bs_parametros VALUES (6, 'ACTIVO', '2024-01-11 16:59:13.972738', '2024-01-11 16:59:13.972738', 'fvazquez', 'CONDICION VENTA PARA DESEMBOLSO', 'CREDES', 'CREDES', 1, 11);


--
-- TOC entry 3811 (class 0 OID 16454)
-- Dependencies: 230
-- Data for Name: bs_permiso_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_permiso_rol VALUES (8, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 17, 1);
INSERT INTO public.bs_permiso_rol VALUES (9, NULL, '2023-11-23 11:51:21.950434', '2023-11-23 11:51:21.950434', NULL, 'PERMISOS', 21, 1);
INSERT INTO public.bs_permiso_rol VALUES (10, NULL, '2023-11-24 15:29:43.718738', '2023-11-24 15:29:43.718738', NULL, 'PERMISOS', 22, 1);
INSERT INTO public.bs_permiso_rol VALUES (11, NULL, '2023-11-24 16:54:52.131547', '2023-11-24 16:54:52.131547', NULL, 'PERMISOS', 23, 1);
INSERT INTO public.bs_permiso_rol VALUES (12, NULL, '2023-11-27 10:33:34.230844', '2023-11-27 10:33:34.230844', NULL, 'PERMISOS', 24, 1);
INSERT INTO public.bs_permiso_rol VALUES (13, NULL, '2023-11-30 16:52:29.634115', '2023-11-30 16:52:29.634115', NULL, 'PERMISOS', 25, 1);
INSERT INTO public.bs_permiso_rol VALUES (14, NULL, '2023-11-30 16:52:51.769645', '2023-11-30 16:52:51.769645', NULL, 'PERMISOS', 26, 1);
INSERT INTO public.bs_permiso_rol VALUES (15, NULL, '2023-12-01 11:17:03.421675', '2023-12-01 11:17:03.421675', NULL, 'PERMISOS', 27, 1);
INSERT INTO public.bs_permiso_rol VALUES (16, NULL, '2023-12-01 11:17:14.116104', '2023-12-01 11:17:14.116104', NULL, 'PERMISOS', 28, 1);
INSERT INTO public.bs_permiso_rol VALUES (19, NULL, '2023-12-12 18:01:33.25567', '2023-12-12 18:01:33.25567', NULL, 'PERMISOS', 34, 1);
INSERT INTO public.bs_permiso_rol VALUES (20, NULL, '2023-12-12 18:01:46.00111', '2023-12-12 18:01:46.00111', NULL, 'PERMISOS', 35, 1);
INSERT INTO public.bs_permiso_rol VALUES (21, NULL, '2023-12-12 18:01:59.948197', '2023-12-12 18:01:59.948197', NULL, 'PERMISOS', 36, 1);
INSERT INTO public.bs_permiso_rol VALUES (4, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 3, 1);
INSERT INTO public.bs_permiso_rol VALUES (3, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 1, 1);
INSERT INTO public.bs_permiso_rol VALUES (6, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 6, 1);
INSERT INTO public.bs_permiso_rol VALUES (5, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 5, 1);
INSERT INTO public.bs_permiso_rol VALUES (7, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 18, 1);
INSERT INTO public.bs_permiso_rol VALUES (22, NULL, '2023-12-15 14:28:38.729036', '2023-12-15 14:28:38.729036', 'fvazquez', 'PERMISOS', 37, 1);
INSERT INTO public.bs_permiso_rol VALUES (23, NULL, '2023-12-27 10:46:00.953943', '2023-12-27 10:46:00.953943', 'fvazquez', 'PERMISOS', 38, 1);
INSERT INTO public.bs_permiso_rol VALUES (24, NULL, '2023-12-27 10:46:33.184631', '2023-12-27 10:46:33.184631', 'fvazquez', 'PERMISOS', 39, 1);
INSERT INTO public.bs_permiso_rol VALUES (25, NULL, '2023-12-27 15:23:39.717078', '2023-12-27 15:23:39.717078', 'fvazquez', 'PERMISOS', 40, 1);
INSERT INTO public.bs_permiso_rol VALUES (26, NULL, '2023-12-28 15:51:14.130045', '2023-12-28 15:51:14.130045', 'fvazquez', 'PERMISOS', 41, 1);
INSERT INTO public.bs_permiso_rol VALUES (27, NULL, '2023-12-28 15:51:23.954357', '2023-12-28 15:51:23.954357', 'fvazquez', 'PERMISOS', 42, 1);
INSERT INTO public.bs_permiso_rol VALUES (28, NULL, '2024-01-02 17:15:37.563449', '2024-01-02 17:15:37.563449', 'fvazquez', 'PERMISOS', 43, 1);
INSERT INTO public.bs_permiso_rol VALUES (29, NULL, '2024-01-02 17:15:44.727419', '2024-01-02 17:15:44.727419', 'fvazquez', 'PERMISOS', 44, 1);
INSERT INTO public.bs_permiso_rol VALUES (30, NULL, '2024-01-04 14:20:54.989778', '2024-01-04 14:20:54.989778', 'fvazquez', 'PERMISOS', 45, 1);
INSERT INTO public.bs_permiso_rol VALUES (31, NULL, '2024-01-10 15:28:41.518061', '2024-01-10 15:28:41.518061', 'fvazquez', 'PERMISOS', 46, 1);
INSERT INTO public.bs_permiso_rol VALUES (32, NULL, '2024-01-12 19:33:02.007685', '2024-01-12 19:33:02.007685', 'fvazquez', 'PERMISOS', 47, 1);
INSERT INTO public.bs_permiso_rol VALUES (33, NULL, '2024-01-12 19:33:16.864186', '2024-01-12 19:33:16.864186', 'fvazquez', 'PERMISOS', 48, 1);
INSERT INTO public.bs_permiso_rol VALUES (34, NULL, '2024-01-12 23:34:55.585819', '2024-01-12 23:34:55.585819', 'fvazquez', 'PERMISOS', 49, 1);
INSERT INTO public.bs_permiso_rol VALUES (35, NULL, '2024-01-15 16:44:48.73731', '2024-01-15 16:44:48.73731', 'fvazquez', 'PERMISOS', 50, 1);
INSERT INTO public.bs_permiso_rol VALUES (36, NULL, '2024-01-18 15:24:34.353535', '2024-01-18 15:24:34.353535', 'fvazquez', 'PERMISOS', 51, 1);
INSERT INTO public.bs_permiso_rol VALUES (37, NULL, '2024-01-22 12:05:51.580568', '2024-01-22 12:05:51.580568', 'fvazquez', 'PERMISOS', 52, 1);
INSERT INTO public.bs_permiso_rol VALUES (38, NULL, '2024-02-12 12:11:27.075193', '2024-02-12 12:11:27.075193', 'fvazquez', 'PERMISOS', 53, 1);
INSERT INTO public.bs_permiso_rol VALUES (39, NULL, '2024-02-13 08:38:51.666126', '2024-02-13 08:38:51.666126', 'fvazquez', 'PERMISOS', 54, 1);
INSERT INTO public.bs_permiso_rol VALUES (40, NULL, '2024-02-13 10:33:26.581093', '2024-02-13 10:33:26.581093', 'fvazquez', 'PERMISOS', 55, 1);


--
-- TOC entry 3813 (class 0 OID 16463)
-- Dependencies: 232
-- Data for Name: bs_persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_persona VALUES (7, 'ACTIVO', '2023-11-27 17:29:16.776996', '2023-11-27 17:29:16.776996', NULL, '44444', 'ffff@gm.com', '1990-11-14', NULL, 'Roberto', 'Roberto Gimenez Benitez', 'Gimenez', 'Benitez');
INSERT INTO public.bs_persona VALUES (8, 'ACTIVO', '2023-11-28 16:56:20.157804', '2023-11-28 16:56:20.157804', NULL, '55555', 'AAA@GMAIL.COM', '2000-10-21', NULL, 'ALBERTO', 'ALBERTO FERNANDEZ LOPEZ', 'FERNANDEZ', 'LOPEZ');
INSERT INTO public.bs_persona VALUES (5, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '777777', '', '1991-10-21', NULL, 'luis', 'luis vazquez', 'vazquez', 'lopez');
INSERT INTO public.bs_persona VALUES (3, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '4864105', 'fernandorafa@live.com', '1991-10-21', NULL, 'fernando', 'fernnado vazquez', 'vazquez', 'lopez');
INSERT INTO public.bs_persona VALUES (6, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '888888', '', '1991-10-21', NULL, 'paula', 'paula vazquez', 'vazquez', 'lopez');
INSERT INTO public.bs_persona VALUES (10, 'ACTIVO', '2024-01-12 20:00:17.136873', '2024-01-12 20:00:17.136873', 'fvazquez', '800099927-8', 'itau@itau.com.py', '2024-01-23', NULL, 'BANCO ITAU S.A.', 'BANCO ITAU S.A.  ', '', '');
INSERT INTO public.bs_persona VALUES (11, 'ACTIVO', '2024-02-13 16:52:03.090551', '2024-02-13 16:52:03.090474', 'fvazquez', '800029172-9', 'FFF@FFF.COM', '2024-02-01', NULL, '', ' BANCO CONTINENTAL BANCO CONTINENTAL', 'BANCO CONTINENTAL', 'BANCO CONTINENTAL');


--
-- TOC entry 3815 (class 0 OID 16472)
-- Dependencies: 234
-- Data for Name: bs_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_rol VALUES (1, 'ACTIVO', '2023-09-05 16:16:21.69327', '2023-09-05 16:16:21.69327', NULL, 'USER');
INSERT INTO public.bs_rol VALUES (3, 'ACTIVO', '2023-09-05 16:16:21.69327', '2023-09-05 16:16:21.69327', NULL, 'ADMIN');


--
-- TOC entry 3817 (class 0 OID 16481)
-- Dependencies: 236
-- Data for Name: bs_talonarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_talonarios VALUES (2, 'ACTIVO', '2024-01-02 17:28:26.527748', '2024-01-02 17:28:26.527748', 'fvazquez', 2, 1);
INSERT INTO public.bs_talonarios VALUES (3, 'ACTIVO', '2024-01-05 16:51:03.274948', '2024-01-05 16:51:03.274948', 'fvazquez', 3, 3);
INSERT INTO public.bs_talonarios VALUES (5, 'ACTIVO', '2024-01-10 20:04:52.046571', '2024-01-10 20:04:52.046571', 'fvazquez', 3, 2);
INSERT INTO public.bs_talonarios VALUES (6, 'ACTIVO', '2024-01-16 09:23:26.311944', '2024-01-16 09:23:26.311944', 'fvazquez', 3, 4);
INSERT INTO public.bs_talonarios VALUES (7, 'ACTIVO', '2024-01-22 16:28:54.537469', '2024-01-22 16:28:54.537469', 'fvazquez', 3, 5);


--
-- TOC entry 3819 (class 0 OID 16490)
-- Dependencies: 238
-- Data for Name: bs_timbrados; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_timbrados VALUES (2, 'ACTIVO', '2024-01-02 17:23:52.428487', '2024-01-02 17:23:40.71023', 'fvazquez', '001', '002', '2024-01-02', '2024-01-31', 'N', 1.00, 999.00, 1234567.00, 1);
INSERT INTO public.bs_timbrados VALUES (3, 'ACTIVO', '2024-01-05 16:48:54.262894', '2024-01-05 16:48:54.262894', 'fvazquez', '001', '001', '2024-01-01', '2024-12-31', 'N', 1.00, 999999.00, 12345678.00, 1);


--
-- TOC entry 3821 (class 0 OID 16499)
-- Dependencies: 240
-- Data for Name: bs_tipo_comprobantes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_tipo_comprobantes VALUES (3, 'ACTIVO', '2024-01-05 16:48:14.975214', '2024-01-05 16:48:14.975214', 'fvazquez', 'DES', 'DESEMBOLSO', 'S', NULL, 1, 9);
INSERT INTO public.bs_tipo_comprobantes VALUES (1, 'ACTIVO', '2024-01-10 20:04:19.190016', '2023-11-30 17:18:44.250534', 'fvazquez', 'CRE', 'CREDITO', 'S', NULL, 1, 11);
INSERT INTO public.bs_tipo_comprobantes VALUES (4, 'ACTIVO', '2024-01-16 09:23:16.25807', '2024-01-16 09:23:16.25807', 'fvazquez', 'REC', 'RECIBOS', 'N', NULL, 1, 8);
INSERT INTO public.bs_tipo_comprobantes VALUES (2, 'ACTIVO', '2024-01-10 20:04:04.092481', '2023-11-30 17:19:17.294537', 'fvazquez', 'CON', 'CONTADO', 'N', NULL, 1, 11);
INSERT INTO public.bs_tipo_comprobantes VALUES (5, 'ACTIVO', '2024-01-22 16:28:43.614046', '2024-01-22 16:28:43.614046', 'fvazquez', 'PAG', 'PAGOS', 'S', NULL, 1, 10);


--
-- TOC entry 3823 (class 0 OID 16508)
-- Dependencies: 242
-- Data for Name: bs_tipo_valor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_tipo_valor VALUES (1, 'ACTIVO', '2023-11-30 17:05:15.727047', '2023-11-30 17:05:15.727047', NULL, 'EFE', 'EFECTIVO', 'S', 1, 8);
INSERT INTO public.bs_tipo_valor VALUES (2, 'ACTIVO', '2023-11-30 17:09:37.933158', '2023-11-30 17:09:37.933158', NULL, 'CHE', 'CHEQUE', 'N', 1, 8);


--
-- TOC entry 3825 (class 0 OID 16517)
-- Dependencies: 244
-- Data for Name: bs_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_usuario VALUES (4, 'ACTIVO', '2023-11-27 17:29:54.032836', '2023-11-27 17:29:54.032836', NULL, 'rgimenez', 'oqgJiaeLzGWnEayCcEI6XeycqqhKVVznqZdi78Ep0OaL6XA0q0cP+XZ1/sY4OHmP', 1, 7, 1);
INSERT INTO public.bs_usuario VALUES (5, 'ACTIVO', '2023-11-28 17:09:33.989613', '2023-11-28 17:09:33.989613', NULL, 'afernandez', 'un8ovPVuGDRyVA9KUkGZCGKgpNR0PfihZuJfPLHHQtfw9e97ZniQIpWZDtbHJ+aO', 1, 8, 1);
INSERT INTO public.bs_usuario VALUES (3, 'ACTIVO', '2023-09-07 13:28:08.054202', '2023-09-07 13:28:08.054202', NULL, 'PRAFAELLA', 'un8ovPVuGDRyVA9KUkGZCGKgpNR0PfihZuJfPLHHQtfw9e97ZniQIpWZDtbHJ+aO', 1, 6, 3);
INSERT INTO public.bs_usuario VALUES (1, 'ACTIVO', '2023-09-07 13:28:08.054202', '2023-09-07 13:28:08.054202', NULL, 'fvazquez', 'un8ovPVuGDRyVA9KUkGZCGKgpNR0PfihZuJfPLHHQtfw9e97ZniQIpWZDtbHJ+aO', 1, 3, 1);


--
-- TOC entry 3827 (class 0 OID 16526)
-- Dependencies: 246
-- Data for Name: cob_cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cajas VALUES (17, 'ACTIVO', '2023-12-29 15:51:26.367354', '2023-12-29 15:51:26.367354', 'fvazquez', 'FVAZQUEZ', 1, 1);


--
-- TOC entry 3829 (class 0 OID 16535)
-- Dependencies: 248
-- Data for Name: cob_clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_clientes VALUES (1, 'ACTIVO', '2023-12-01 11:23:36.837974', '2023-12-01 11:23:36.837974', NULL, 'FV10', 1, 3);
INSERT INTO public.cob_clientes VALUES (4, 'ACTIVO', '2023-12-01 11:57:11.658446', '2023-12-01 11:57:11.658446', NULL, 'LUIs', 1, 5);
INSERT INTO public.cob_clientes VALUES (5, 'ACTIVO', '2023-12-29 15:51:05.052154', '2023-12-29 15:51:05.052154', 'fvazquez', 'eded', 1, 8);


--
-- TOC entry 3831 (class 0 OID 16544)
-- Dependencies: 250
-- Data for Name: cob_cobradores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cobradores VALUES (2, 'ACTIVO', '2023-12-01 11:30:01.723144', '2023-12-01 11:30:01.723144', NULL, 'FV10COB', 1, 3);
INSERT INTO public.cob_cobradores VALUES (3, 'ACTIVO', '2023-12-01 12:22:18.62225', '2023-12-01 12:22:18.62225', NULL, 'pau', 1, 6);


--
-- TOC entry 3833 (class 0 OID 16553)
-- Dependencies: 252
-- Data for Name: cob_cobros_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cobros_valores VALUES (10, 'ACTIVO', '2024-01-19 17:33:57.560512', '2024-01-18 11:14:53.80722', 'fvazquez', '2024-01-19', '2024-01-18', '2024-01-18', 7, 'S', 12500.00, '001-001-000000003', 1, '0', 'RECIBO', 1, 1, 30);
INSERT INTO public.cob_cobros_valores VALUES (15, 'ACTIVO', '2024-01-25 19:45:03.19408', '2024-01-25 19:44:24.332655', 'fvazquez', '2024-01-25', '2024-01-25', '2024-01-25', 16, 'S', 150000.00, '001-001-000000001', 1, '0', 'FACTURA', 1, 1, 31);


--
-- TOC entry 3835 (class 0 OID 16562)
-- Dependencies: 254
-- Data for Name: cob_habilitaciones_cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_habilitaciones_cajas VALUES (8, 'ACTIVO', '2023-12-29 15:51:53.335839', '2023-12-29 15:51:37.190834', 'fvazquez', '2023-12-29 15:51:32.93391', '2023-12-29 15:51:53.314767', '15:51:32', '15:51:53', 'S', 1.00, 1, 17);
INSERT INTO public.cob_habilitaciones_cajas VALUES (9, 'ACTIVO', '2024-01-19 18:28:37.647924', '2024-01-15 16:48:58.618427', 'fvazquez', '2024-01-15 16:48:56.191648', NULL, '16:48:56', NULL, 'N', 2.00, 1, 17);


--
-- TOC entry 3837 (class 0 OID 16571)
-- Dependencies: 256
-- Data for Name: cob_recibos_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_recibos_cabecera VALUES (6, 'ACTIVO', '2024-01-16 14:40:47.031068', '2024-01-16 14:40:47.031068', 'fvazquez', '2024-01-16', 'N', 'N', 989633.58, 2, '001-001-000000002', 'dede', 1, 6, 1, 3, 9);
INSERT INTO public.cob_recibos_cabecera VALUES (5, 'ACTIVO', '2024-01-16 14:39:55.275965', '2024-01-16 14:39:55.275965', 'fvazquez', '2024-01-16', 'N', 'N', 329877.86, 1, '001-001-000000001', 'dede', 1, 6, 1, 3, 9);
INSERT INTO public.cob_recibos_cabecera VALUES (7, 'ACTIVO', '2024-01-18 11:14:53.620988', '2024-01-18 11:14:53.620988', 'fvazquez', '2024-01-18', 'N', 'S', 12500.00, 3, '001-001-000000003', 'PRUEBA DE COBRO', 1, 6, 1, 3, 9);


--
-- TOC entry 3839 (class 0 OID 16580)
-- Dependencies: 258
-- Data for Name: cob_recibos_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_recibos_detalle VALUES (8, 1, 0, 26, 329877.86, 1, 5, 26);
INSERT INTO public.cob_recibos_detalle VALUES (9, 1, 0, 27, 329877.86, 1, 6, 27);
INSERT INTO public.cob_recibos_detalle VALUES (10, 1, 0, 28, 329877.86, 2, 6, 28);
INSERT INTO public.cob_recibos_detalle VALUES (11, 1, 1, 39, 12500.00, 1, 7, 39);


--
-- TOC entry 3841 (class 0 OID 16587)
-- Dependencies: 260
-- Data for Name: cob_saldos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_saldos VALUES (29, 'ACTIVO', '2024-01-15 17:17:53.002011', '2024-01-15 17:17:53.002011', 'fvazquez', '2024-05-31', 6, 65, 329877.86, '3.00', 5, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (30, 'ACTIVO', '2024-01-15 17:17:53.005025', '2024-01-15 17:17:53.005025', 'fvazquez', '2024-06-30', 6, 66, 329877.86, '3.00', 6, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (31, 'ACTIVO', '2024-01-15 17:17:53.008043', '2024-01-15 17:17:53.008043', 'fvazquez', '2024-07-31', 6, 67, 329877.86, '3.00', 7, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (32, 'ACTIVO', '2024-01-15 17:17:53.009061', '2024-01-15 17:17:53.009061', 'fvazquez', '2024-08-31', 6, 68, 329877.86, '3.00', 8, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (33, 'ACTIVO', '2024-01-15 17:17:53.01004', '2024-01-15 17:17:53.01004', 'fvazquez', '2024-09-30', 6, 69, 329877.86, '3.00', 9, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (34, 'ACTIVO', '2024-01-15 17:17:53.011565', '2024-01-15 17:17:53.011565', 'fvazquez', '2024-10-31', 6, 70, 329877.86, '3.00', 10, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (35, 'ACTIVO', '2024-01-15 17:17:53.01261', '2024-01-15 17:17:53.01261', 'fvazquez', '2024-11-30', 6, 71, 329877.86, '3.00', 11, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (36, 'ACTIVO', '2024-01-15 17:17:53.014639', '2024-01-15 17:17:53.014639', 'fvazquez', '2024-12-31', 6, 72, 329877.86, '3.00', 12, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (39, 'ACTIVO', '2024-01-17 17:12:03.803368', '2024-01-17 17:12:03.803368', NULL, '2024-01-17', 15, 15, 12500.00, '001-002-000000003', 1, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos VALUES (25, 'ACTIVO', '2024-01-15 17:17:52.994991', '2024-01-15 17:17:52.994991', 'fvazquez', '2024-01-05', 6, 61, 329877.86, '3.00', 1, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (26, 'ACTIVO', '2024-01-15 17:17:52.998009', '2024-01-15 17:17:52.998009', 'fvazquez', '2024-02-29', 6, 62, 329877.86, '3.00', 2, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (27, 'ACTIVO', '2024-01-15 17:17:52.999011', '2024-01-15 17:17:52.999011', 'fvazquez', '2024-03-31', 6, 63, 329877.86, '3.00', 3, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (28, 'ACTIVO', '2024-01-15 17:17:53.000009', '2024-01-15 17:17:53.000009', 'fvazquez', '2024-04-30', 6, 64, 329877.86, '3.00', 4, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos VALUES (43, 'ACTIVO', '2024-01-17 17:12:03.813574', '2024-01-17 17:12:03.813574', NULL, '2024-05-17', 15, 15, 12500.00, '001-002-000000003', 5, 12500.00, 'FACTURA', 1, 5);


--
-- TOC entry 3843 (class 0 OID 16596)
-- Dependencies: 262
-- Data for Name: com_proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.com_proveedores VALUES (1, 'ACTIVO', '2024-01-12 19:49:38.255322', '2024-01-12 19:49:38.255322', 'fvazquez', 'PP', 1, 7);


--
-- TOC entry 3845 (class 0 OID 16605)
-- Dependencies: 264
-- Data for Name: cre_desembolso_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_desembolso_cabecera VALUES (5, 'ACTIVO', '2024-01-09 10:38:28.692587', '2024-01-09 10:37:52.65986', 'fvazquez', '2024-01-10', 'S', 'N', 2000000.00, 2652199.06, 411090.05, 241109.01, 2.00, 36.00, 3.00, 1, 3, 3, 3);
INSERT INTO public.cre_desembolso_cabecera VALUES (4, 'ACTIVO', '2024-01-08 17:01:53.678368', '2024-01-05 17:43:13.47727', 'fvazquez', '2024-01-05', 'S', 'N', 2000000.04, 2700000.12, 636363.60, 63636.48, 1.00, 35.00, 3.00, 1, 3, 2, 3);
INSERT INTO public.cre_desembolso_cabecera VALUES (6, 'ACTIVO', '2024-01-15 17:15:11.455102', '2024-01-11 19:44:11.11461', 'fvazquez', '2024-01-11', 'S', 'S', 3000000.00, 3958534.30, 598667.54, 359866.75, 3.00, 35.00, 3.00, 1, 3, 4, 3);


--
-- TOC entry 3847 (class 0 OID 16614)
-- Dependencies: 266
-- Data for Name: cre_desembolso_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_desembolso_detalle VALUES (37, 'ACTIVO', '2024-01-05 17:43:13.479691', '2024-01-05 17:43:13.479691', 'fvazquez', 1, '2023-12-31', 166666.67, 225000.00, 53030.30, 5303.04, 1, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (38, 'ACTIVO', '2024-01-05 17:43:13.480688', '2024-01-05 17:43:13.480688', 'fvazquez', 1, '2024-01-31', 166666.67, 225000.00, 53030.30, 5303.04, 2, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (39, 'ACTIVO', '2024-01-05 17:43:13.481695', '2024-01-05 17:43:13.481695', 'fvazquez', 1, '2024-02-29', 166666.67, 225000.00, 53030.30, 5303.04, 3, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (40, 'ACTIVO', '2024-01-05 17:43:13.484016', '2024-01-05 17:43:13.484016', 'fvazquez', 1, '2024-03-29', 166666.67, 225000.00, 53030.30, 5303.04, 4, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (41, 'ACTIVO', '2024-01-05 17:43:13.484834', '2024-01-05 17:43:13.484834', 'fvazquez', 1, '2024-04-29', 166666.67, 225000.00, 53030.30, 5303.04, 5, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (42, 'ACTIVO', '2024-01-05 17:43:13.486832', '2024-01-05 17:43:13.486832', 'fvazquez', 1, '2024-05-29', 166666.67, 225000.00, 53030.30, 5303.04, 6, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (43, 'ACTIVO', '2024-01-05 17:43:13.488834', '2024-01-05 17:43:13.488834', 'fvazquez', 1, '2024-06-29', 166666.67, 225000.00, 53030.30, 5303.04, 7, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (44, 'ACTIVO', '2024-01-05 17:43:13.490403', '2024-01-05 17:43:13.490403', 'fvazquez', 1, '2024-07-29', 166666.67, 225000.00, 53030.30, 5303.04, 8, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (45, 'ACTIVO', '2024-01-05 17:43:13.492538', '2024-01-05 17:43:13.492538', 'fvazquez', 1, '2024-08-29', 166666.67, 225000.00, 53030.30, 5303.04, 9, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (46, 'ACTIVO', '2024-01-05 17:43:13.494078', '2024-01-05 17:43:13.494078', 'fvazquez', 1, '2024-09-29', 166666.67, 225000.00, 53030.30, 5303.04, 10, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (47, 'ACTIVO', '2024-01-05 17:43:13.496431', '2024-01-05 17:43:13.496431', 'fvazquez', 1, '2024-10-29', 166666.67, 225000.00, 53030.30, 5303.04, 11, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (48, 'ACTIVO', '2024-01-05 17:43:13.497932', '2024-01-05 17:43:13.497423', 'fvazquez', 1, '2024-11-29', 166666.67, 225000.00, 53030.30, 5303.04, 12, 4, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (49, 'ACTIVO', '2024-01-09 10:37:52.714117', '2024-01-09 10:37:52.714117', 'fvazquez', 1, '2023-12-31', 140924.17, 221016.59, 60000.00, 20092.42, 1, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (50, 'ACTIVO', '2024-01-09 10:37:52.721635', '2024-01-09 10:37:52.721635', 'fvazquez', 1, '2024-01-31', 145151.90, 221016.59, 55772.27, 20092.42, 2, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (51, 'ACTIVO', '2024-01-09 10:37:52.723046', '2024-01-09 10:37:52.723046', 'fvazquez', 1, '2024-02-29', 149506.45, 221016.59, 51417.72, 20092.42, 3, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (52, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-03-29', 153991.65, 221016.59, 46932.52, 20092.42, 4, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (53, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-04-29', 158611.40, 221016.59, 42312.78, 20092.42, 5, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (54, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-05-29', 163369.74, 221016.59, 37554.43, 20092.42, 6, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (55, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-06-29', 168270.83, 221016.59, 32653.34, 20092.42, 7, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (56, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-07-29', 173318.95, 221016.59, 27605.22, 20092.42, 8, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (57, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-08-29', 178518.52, 221016.59, 22405.65, 20092.42, 9, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (58, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-09-29', 183874.08, 221016.59, 17050.09, 20092.42, 10, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (59, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-10-29', 189390.30, 221016.59, 11533.87, 20092.42, 11, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (60, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-11-29', 195072.01, 221016.59, 5852.16, 20092.42, 12, 5, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (61, 'ACTIVO', '2024-01-11 19:44:11.179159', '2024-01-11 19:44:11.178643', 'fvazquez', 1, '2024-01-31', 212388.96, 329877.86, 87500.00, 29988.90, 1, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (62, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-02-29', 218583.64, 329877.86, 81305.32, 29988.90, 2, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (63, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-03-31', 224959.00, 329877.86, 74929.97, 29988.90, 3, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (64, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-04-30', 231520.30, 329877.86, 68368.66, 29988.90, 4, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (65, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-05-31', 238272.98, 329877.86, 61615.99, 29988.90, 5, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (66, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-06-30', 245222.60, 329877.86, 54666.36, 29988.90, 6, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (67, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-07-31', 252374.93, 329877.86, 47514.03, 29988.90, 7, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (68, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-08-31', 259735.87, 329877.86, 40153.10, 29988.90, 8, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (69, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-09-30', 267311.50, 329877.86, 32577.47, 29988.90, 9, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (70, 'ACTIVO', '2024-01-11 19:44:11.194903', '2024-01-11 19:44:11.194903', 'fvazquez', 1, '2024-10-31', 275108.08, 329877.86, 24780.88, 29988.90, 10, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (71, 'ACTIVO', '2024-01-11 19:44:11.194903', '2024-01-11 19:44:11.194903', 'fvazquez', 1, '2024-11-30', 283132.07, 329877.86, 16756.90, 29988.90, 11, 6, 4);
INSERT INTO public.cre_desembolso_detalle VALUES (72, 'ACTIVO', '2024-01-11 19:44:11.197894', '2024-01-11 19:44:11.197894', 'fvazquez', 1, '2024-12-31', 291390.08, 329877.86, 8498.88, 29988.90, 12, 6, 4);


--
-- TOC entry 3849 (class 0 OID 16623)
-- Dependencies: 268
-- Data for Name: cre_motivos_prestamos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_motivos_prestamos VALUES (1, 'ACTIVO', '2023-12-27 11:13:34.866513', '2023-12-27 11:12:56.302497', 'fvazquez', '01', 'VIVIENDA');
INSERT INTO public.cre_motivos_prestamos VALUES (2, 'ACTIVO', '2023-12-27 11:14:06.851146', '2023-12-27 11:14:06.851146', 'fvazquez', '02', 'VEHICULO');
INSERT INTO public.cre_motivos_prestamos VALUES (3, 'ACTIVO', '2023-12-27 11:14:16.114921', '2023-12-27 11:14:16.114921', 'fvazquez', '03', 'CONSUMO');


--
-- TOC entry 3851 (class 0 OID 16632)
-- Dependencies: 270
-- Data for Name: cre_solicitudes_creditos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_solicitudes_creditos VALUES (3, 'ACTIVO', '2023-12-29 15:53:05.571648', '2023-12-29 15:52:53.899229', 'fvazquez', '2023-12-29', 'S', 'S', 2000000.00, 2000000.00, 12, '2023-12-31', 1, 5, 1, 1);
INSERT INTO public.cre_solicitudes_creditos VALUES (2, 'ACTIVO', '2023-12-27 17:56:54.625092', '2023-12-27 17:56:04.757176', 'fvazquez', '2023-12-27', 'S', 'S', 2000000.00, 2500000.00, 12, '2023-12-31', 1, 4, 2, 1);
INSERT INTO public.cre_solicitudes_creditos VALUES (4, 'ACTIVO', '2024-01-11 17:11:35.156332', '2024-01-11 17:00:06.956275', 'fvazquez', '2024-01-11', 'S', 'S', 3000000.00, 3000000.00, 12, '2024-01-31', 1, 1, 2, 1);
INSERT INTO public.cre_solicitudes_creditos VALUES (5, 'ACTIVO', '2024-12-16 12:16:03.804271', '2024-12-16 12:15:48.919972', 'fvazquez', '2024-12-16', 'S', 'N', 1500000.00, 1500000.00, 12, '2024-12-31', 1, 4, 3, 1);


--
-- TOC entry 3853 (class 0 OID 16641)
-- Dependencies: 272
-- Data for Name: cre_tipo_amortizaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_tipo_amortizaciones VALUES (2, 'ACTIVO', '2023-12-27 11:01:12.871061', '2023-12-27 11:01:12.871061', 'fvazquez', 'AME', 'AMERICANO');
INSERT INTO public.cre_tipo_amortizaciones VALUES (3, 'ACTIVO', '2023-12-27 11:01:21.438394', '2023-12-27 11:01:21.438394', 'fvazquez', 'FRA', 'FRANCES');
INSERT INTO public.cre_tipo_amortizaciones VALUES (4, 'ACTIVO', '2023-12-27 11:01:31.830206', '2023-12-27 11:01:31.830206', 'fvazquez', 'ALE', 'ALEMAN');


--
-- TOC entry 3855 (class 0 OID 16650)
-- Dependencies: 274
-- Data for Name: sto_ajuste_inventarios_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3857 (class 0 OID 16659)
-- Dependencies: 276
-- Data for Name: sto_ajuste_inventarios_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3859 (class 0 OID 16666)
-- Dependencies: 278
-- Data for Name: sto_articulos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sto_articulos VALUES (1, 'ACTIVO', '2023-12-12 18:54:58.587664', '2023-12-12 18:54:58.587664', NULL, 'ART', 'ARTICULO', 'S', 150000.00, 1, 1);
INSERT INTO public.sto_articulos VALUES (4, 'ACTIVO', '2024-01-05 11:53:54.082811', '2024-01-05 11:53:54.082811', 'fvazquez', 'CUO', 'CUOTAS', 'N', 1000.00, 1, 1);
INSERT INTO public.sto_articulos VALUES (5, 'ACTIVO', '2024-01-10 19:31:52.519536', '2024-01-10 19:31:52.519536', 'fvazquez', 'DES', 'DESEMBOLSO', 'N', 1000.00, 1, 1);
INSERT INTO public.sto_articulos VALUES (3, 'ACTIVO', '2023-12-12 19:00:41.15117', '2023-12-12 19:00:41.15117', NULL, 'ART 2', 'ARTICULO 2', 'S', 23550.00, 1, 2);
INSERT INTO public.sto_articulos VALUES (6, 'ACTIVO', '2024-01-11 14:00:59.656862', '2024-01-11 14:00:59.656862', 'fvazquez', 'ART 3', 'ARTICULO 3', 'S', 15000.00, 1, 1);


--
-- TOC entry 3860 (class 0 OID 16674)
-- Dependencies: 279
-- Data for Name: sto_articulos_existencias; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sto_articulos_existencias VALUES (2, 1.00, 1.00, 3);
INSERT INTO public.sto_articulos_existencias VALUES (5, 4.00, 5.00, 6);
INSERT INTO public.sto_articulos_existencias VALUES (1, 0.00, 2.00, 1);


--
-- TOC entry 3862 (class 0 OID 16680)
-- Dependencies: 281
-- Data for Name: tes_bancos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_bancos VALUES (3, 'ACTIVO', '2024-01-12 20:13:53.773426', '2024-01-12 20:13:53.773426', 'fvazquez', 15000.00, '8000299281', 1, 2, 10);
INSERT INTO public.tes_bancos VALUES (1, 'ACTIVO', '2024-01-12 20:12:51.442285', '2024-01-12 20:12:51.442285', 'fvazquez', 13665000.00, '8000299281', 1, 1, 10);


--
-- TOC entry 3864 (class 0 OID 16689)
-- Dependencies: 283
-- Data for Name: tes_depositos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_depositos VALUES (27, 'ANULADO', '2024-01-19 17:25:01.955941', '2024-01-19 17:23:31.602884', 'fvazquez', '2024-01-19', 12500.00, 99988877, 'PRUEBA DEFINITIVA', 1, 9, 1);
INSERT INTO public.tes_depositos VALUES (30, 'ACTIVO', '2024-01-19 17:33:57.522029', '2024-01-19 17:33:57.522029', 'fvazquez', '2024-01-19', 12500.00, 88991736, 'PRUEBA DE VALIDACION', 1, 9, 1);
INSERT INTO public.tes_depositos VALUES (31, 'ACTIVO', '2024-01-25 19:45:03.171802', '2024-01-25 19:45:03.171802', 'fvazquez', '2024-01-25', 150000.00, 881819, 'prueba', 1, 9, 1);


--
-- TOC entry 3866 (class 0 OID 16698)
-- Dependencies: 285
-- Data for Name: tes_pago_comprobante_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pago_comprobante_detalle VALUES (2, 6, 3000000.00, 1, 'DESEMBOLSO', 3);


--
-- TOC entry 3868 (class 0 OID 16705)
-- Dependencies: 287
-- Data for Name: tes_pagos_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pagos_cabecera VALUES (3, 'ACTIVO', '2024-02-10 21:04:13.873714', '2024-02-10 21:04:13.873714', 'fvazquez', 'fernnado vazquez', '2024-02-10', 1, 'N', 'S', 3000000.00, 1, '001-001-000000001', 'prueba de desembolso', 'DESEMBOLSO', 1, 7, 9);


--
-- TOC entry 3870 (class 0 OID 16714)
-- Dependencies: 289
-- Data for Name: tes_pagos_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pagos_valores VALUES (2, 'ACTIVO', '2024-02-10 21:04:13.917314', '2024-02-10 21:04:13.917314', NULL, NULL, '2024-02-10', '2024-02-10', NULL, 3000000.00, 1, '178383892', 'DESEMBOLSO', 1, 2, 1, 3);


--
-- TOC entry 3872 (class 0 OID 16723)
-- Dependencies: 291
-- Data for Name: ven_condicion_ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_condicion_ventas VALUES (1, 'ACTIVO', '2023-12-12 18:16:54.954645', '2023-12-12 18:16:54.954645', NULL, 'CON', 'CONTADO', 0.00, 1.00, 1);
INSERT INTO public.ven_condicion_ventas VALUES (2, 'ACTIVO', '2023-12-12 18:17:53.259151', '2023-12-12 18:17:53.259151', NULL, 'CRE', 'CREDITO', 30.00, 12.00, 1);
INSERT INTO public.ven_condicion_ventas VALUES (4, 'ACTIVO', '2024-01-11 16:58:23.31292', '2024-01-11 16:58:23.31292', 'fvazquez', 'CREDES', 'CREDITO DESEMBOLSO', 30.00, 1.00, 1);


--
-- TOC entry 3874 (class 0 OID 16732)
-- Dependencies: 293
-- Data for Name: ven_facturas_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_facturas_cabecera VALUES (16, 'ACTIVO', '2024-01-25 19:44:24.289558', '2024-01-25 18:56:55.811218', 'fvazquez', '2024-01-25', NULL, 'S', 'S', 0.00, 150000.00, 136363.64, 13636.36, 1, '001-001-000000001', 'prueba de impresion', 'FACTURA', 1, 5, 1, 9, 1, 1);


--
-- TOC entry 3876 (class 0 OID 16741)
-- Dependencies: 295
-- Data for Name: ven_facturas_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_facturas_detalles VALUES (17, 'ACTIVO', '2024-01-25 18:56:55.903752', '2024-01-25 18:56:55.903752', 'fvazquez', 1, 'IVA10', 0.00, 136363.64, 13636.36, 150000.00, 1, 150000.00, 1, 16);


--
-- TOC entry 3878 (class 0 OID 16750)
-- Dependencies: 297
-- Data for Name: ven_vendedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_vendedores VALUES (1, 'ACTIVO', '2023-12-12 18:05:35.672767', '2023-12-12 18:05:35.672767', NULL, 'VEN', 1, 6);


--
-- TOC entry 3926 (class 0 OID 0)
-- Dependencies: 215
-- Name: bs_empresas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_empresas_id_seq', 6, true);


--
-- TOC entry 3927 (class 0 OID 0)
-- Dependencies: 217
-- Name: bs_iva_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_iva_id_seq', 4, true);


--
-- TOC entry 3928 (class 0 OID 0)
-- Dependencies: 219
-- Name: bs_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_menu_id_seq', 55, true);


--
-- TOC entry 3929 (class 0 OID 0)
-- Dependencies: 221
-- Name: bs_menu_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_menu_item_id_seq', 68, true);


--
-- TOC entry 3930 (class 0 OID 0)
-- Dependencies: 223
-- Name: bs_modulo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_modulo_id_seq', 14, true);


--
-- TOC entry 3931 (class 0 OID 0)
-- Dependencies: 225
-- Name: bs_moneda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_moneda_id_seq', 5, true);


--
-- TOC entry 3932 (class 0 OID 0)
-- Dependencies: 227
-- Name: bs_parametros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_parametros_id_seq', 6, true);


--
-- TOC entry 3933 (class 0 OID 0)
-- Dependencies: 229
-- Name: bs_permiso_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_permiso_rol_id_seq', 40, true);


--
-- TOC entry 3934 (class 0 OID 0)
-- Dependencies: 231
-- Name: bs_persona_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_persona_id_seq', 11, true);


--
-- TOC entry 3935 (class 0 OID 0)
-- Dependencies: 233
-- Name: bs_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_rol_id_seq', 3, true);


--
-- TOC entry 3936 (class 0 OID 0)
-- Dependencies: 235
-- Name: bs_talonarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_talonarios_id_seq', 7, true);


--
-- TOC entry 3937 (class 0 OID 0)
-- Dependencies: 237
-- Name: bs_timbrados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_timbrados_id_seq', 3, true);


--
-- TOC entry 3938 (class 0 OID 0)
-- Dependencies: 239
-- Name: bs_tipo_comprobantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_tipo_comprobantes_id_seq', 5, true);


--
-- TOC entry 3939 (class 0 OID 0)
-- Dependencies: 241
-- Name: bs_tipo_valor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_tipo_valor_id_seq', 3, true);


--
-- TOC entry 3940 (class 0 OID 0)
-- Dependencies: 243
-- Name: bs_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_usuario_id_seq', 5, true);


--
-- TOC entry 3941 (class 0 OID 0)
-- Dependencies: 245
-- Name: cob_cajas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cajas_id_seq', 26, true);


--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 247
-- Name: cob_clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_clientes_id_seq', 5, true);


--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 249
-- Name: cob_cobradores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cobradores_id_seq', 3, true);


--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 251
-- Name: cob_cobros_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cobros_valores_id_seq', 15, true);


--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 253
-- Name: cob_habilitaciones_cajas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_habilitaciones_cajas_id_seq', 9, true);


--
-- TOC entry 3946 (class 0 OID 0)
-- Dependencies: 255
-- Name: cob_recibos_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_recibos_cabecera_id_seq', 7, true);


--
-- TOC entry 3947 (class 0 OID 0)
-- Dependencies: 257
-- Name: cob_recibos_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_recibos_detalle_id_seq', 11, true);


--
-- TOC entry 3948 (class 0 OID 0)
-- Dependencies: 259
-- Name: cob_saldos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_saldos_id_seq', 50, true);


--
-- TOC entry 3949 (class 0 OID 0)
-- Dependencies: 261
-- Name: com_proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_proveedores_id_seq', 2, true);


--
-- TOC entry 3950 (class 0 OID 0)
-- Dependencies: 263
-- Name: cre_desembolso_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_desembolso_cabecera_id_seq', 6, true);


--
-- TOC entry 3951 (class 0 OID 0)
-- Dependencies: 265
-- Name: cre_desembolso_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_desembolso_detalle_id_seq', 72, true);


--
-- TOC entry 3952 (class 0 OID 0)
-- Dependencies: 267
-- Name: cre_motivos_prestamos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_motivos_prestamos_id_seq', 4, true);


--
-- TOC entry 3953 (class 0 OID 0)
-- Dependencies: 269
-- Name: cre_solicitudes_creditos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_solicitudes_creditos_id_seq', 5, true);


--
-- TOC entry 3954 (class 0 OID 0)
-- Dependencies: 271
-- Name: cre_tipo_amortizaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_tipo_amortizaciones_id_seq', 4, true);


--
-- TOC entry 3955 (class 0 OID 0)
-- Dependencies: 273
-- Name: sto_ajuste_inventarios_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_ajuste_inventarios_cabecera_id_seq', 12, true);


--
-- TOC entry 3956 (class 0 OID 0)
-- Dependencies: 275
-- Name: sto_ajuste_inventarios_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_ajuste_inventarios_detalle_id_seq', 12, true);


--
-- TOC entry 3957 (class 0 OID 0)
-- Dependencies: 214
-- Name: sto_articulos_existencias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_articulos_existencias_id_seq', 5, true);


--
-- TOC entry 3958 (class 0 OID 0)
-- Dependencies: 277
-- Name: sto_articulos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_articulos_id_seq', 6, true);


--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 280
-- Name: tes_bancos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_bancos_id_seq', 3, true);


--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 282
-- Name: tes_depositos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_depositos_id_seq', 31, true);


--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 284
-- Name: tes_pago_comprobante_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pago_comprobante_detalle_id_seq', 2, true);


--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 286
-- Name: tes_pagos_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pagos_cabecera_id_seq', 3, true);


--
-- TOC entry 3963 (class 0 OID 0)
-- Dependencies: 288
-- Name: tes_pagos_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pagos_valores_id_seq', 2, true);


--
-- TOC entry 3964 (class 0 OID 0)
-- Dependencies: 290
-- Name: ven_condicion_ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_condicion_ventas_id_seq', 4, true);


--
-- TOC entry 3965 (class 0 OID 0)
-- Dependencies: 292
-- Name: ven_facturas_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_facturas_cabecera_id_seq', 16, true);


--
-- TOC entry 3966 (class 0 OID 0)
-- Dependencies: 294
-- Name: ven_facturas_detalles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_facturas_detalles_id_seq', 17, true);


--
-- TOC entry 3967 (class 0 OID 0)
-- Dependencies: 296
-- Name: ven_vendedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_vendedores_id_seq', 2, true);


--
-- TOC entry 3446 (class 2606 OID 16398)
-- Name: bs_empresas bs_empresas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_empresas
    ADD CONSTRAINT bs_empresas_pkey PRIMARY KEY (id);


--
-- TOC entry 3448 (class 2606 OID 16759)
-- Name: bs_empresas bs_empresas_unique_persona; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_empresas
    ADD CONSTRAINT bs_empresas_unique_persona UNIQUE (bs_personas_id);


--
-- TOC entry 3450 (class 2606 OID 16407)
-- Name: bs_iva bs_iva_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_iva
    ADD CONSTRAINT bs_iva_pkey PRIMARY KEY (id);


--
-- TOC entry 3454 (class 2606 OID 16425)
-- Name: bs_menu_item bs_menu_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu_item
    ADD CONSTRAINT bs_menu_item_pkey PRIMARY KEY (id);


--
-- TOC entry 3452 (class 2606 OID 16416)
-- Name: bs_menu bs_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu
    ADD CONSTRAINT bs_menu_pkey PRIMARY KEY (id);


--
-- TOC entry 3456 (class 2606 OID 16434)
-- Name: bs_modulo bs_modulo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_modulo
    ADD CONSTRAINT bs_modulo_pkey PRIMARY KEY (id);


--
-- TOC entry 3458 (class 2606 OID 16761)
-- Name: bs_modulo bs_modulo_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_modulo
    ADD CONSTRAINT bs_modulo_unique_codigo UNIQUE (codigo);


--
-- TOC entry 3460 (class 2606 OID 16443)
-- Name: bs_moneda bs_moneda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_moneda
    ADD CONSTRAINT bs_moneda_pkey PRIMARY KEY (id);


--
-- TOC entry 3462 (class 2606 OID 16763)
-- Name: bs_moneda bs_moneda_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_moneda
    ADD CONSTRAINT bs_moneda_unique_codigo UNIQUE (cod_moneda);


--
-- TOC entry 3464 (class 2606 OID 16452)
-- Name: bs_parametros bs_parametros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros
    ADD CONSTRAINT bs_parametros_pkey PRIMARY KEY (id);


--
-- TOC entry 3466 (class 2606 OID 16765)
-- Name: bs_parametros bs_parametros_unique_empresa_modulo_parametro; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros
    ADD CONSTRAINT bs_parametros_unique_empresa_modulo_parametro UNIQUE (parametro, bs_empresa_id, bs_modulo_id);


--
-- TOC entry 3468 (class 2606 OID 16461)
-- Name: bs_permiso_rol bs_permiso_rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol
    ADD CONSTRAINT bs_permiso_rol_pkey PRIMARY KEY (id);


--
-- TOC entry 3470 (class 2606 OID 16470)
-- Name: bs_persona bs_persona_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_persona
    ADD CONSTRAINT bs_persona_pkey PRIMARY KEY (id);


--
-- TOC entry 3472 (class 2606 OID 16767)
-- Name: bs_persona bs_persona_unique_documento; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_persona
    ADD CONSTRAINT bs_persona_unique_documento UNIQUE (documento);


--
-- TOC entry 3474 (class 2606 OID 16479)
-- Name: bs_rol bs_rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_rol
    ADD CONSTRAINT bs_rol_pkey PRIMARY KEY (id);


--
-- TOC entry 3476 (class 2606 OID 16769)
-- Name: bs_rol bs_rol_unique_nombre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_rol
    ADD CONSTRAINT bs_rol_unique_nombre UNIQUE (nombre);


--
-- TOC entry 3478 (class 2606 OID 16488)
-- Name: bs_talonarios bs_talonarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios
    ADD CONSTRAINT bs_talonarios_pkey PRIMARY KEY (id);


--
-- TOC entry 3480 (class 2606 OID 16771)
-- Name: bs_talonarios bs_talonarios_unique_timbrado_comprobante; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios
    ADD CONSTRAINT bs_talonarios_unique_timbrado_comprobante UNIQUE (bs_timbrado_id, bs_tipo_comprobante_id);


--
-- TOC entry 3482 (class 2606 OID 16497)
-- Name: bs_timbrados bs_timbrados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_timbrados
    ADD CONSTRAINT bs_timbrados_pkey PRIMARY KEY (id);


--
-- TOC entry 3484 (class 2606 OID 16506)
-- Name: bs_tipo_comprobantes bs_tipo_comprobantes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_comprobantes
    ADD CONSTRAINT bs_tipo_comprobantes_pkey PRIMARY KEY (id);


--
-- TOC entry 3486 (class 2606 OID 16515)
-- Name: bs_tipo_valor bs_tipo_valor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor
    ADD CONSTRAINT bs_tipo_valor_pkey PRIMARY KEY (id);


--
-- TOC entry 3488 (class 2606 OID 16524)
-- Name: bs_usuario bs_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT bs_usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 3490 (class 2606 OID 16533)
-- Name: cob_cajas cob_cajas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas
    ADD CONSTRAINT cob_cajas_pkey PRIMARY KEY (id);


--
-- TOC entry 3492 (class 2606 OID 16542)
-- Name: cob_clientes cob_clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes
    ADD CONSTRAINT cob_clientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3494 (class 2606 OID 16773)
-- Name: cob_clientes cob_clientes_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes
    ADD CONSTRAINT cob_clientes_unique_persona_empresa UNIQUE (cod_cliente, bs_empresa_id, id_bs_persona);


--
-- TOC entry 3496 (class 2606 OID 16551)
-- Name: cob_cobradores cob_cobradores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores
    ADD CONSTRAINT cob_cobradores_pkey PRIMARY KEY (id);


--
-- TOC entry 3498 (class 2606 OID 16775)
-- Name: cob_cobradores cob_cobradores_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores
    ADD CONSTRAINT cob_cobradores_unique_persona_empresa UNIQUE (cod_cobrador, bs_empresa_id, id_bs_persona);


--
-- TOC entry 3500 (class 2606 OID 16560)
-- Name: cob_cobros_valores cob_cobros_valores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT cob_cobros_valores_pkey PRIMARY KEY (id);


--
-- TOC entry 3502 (class 2606 OID 16777)
-- Name: cob_cobros_valores cob_cobros_valores_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT cob_cobros_valores_uniques UNIQUE (bs_empresa_id, bs_tipo_valor_id, nro_valor, id_comprobante);


--
-- TOC entry 3504 (class 2606 OID 16569)
-- Name: cob_habilitaciones_cajas cob_habilitaciones_cajas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_habilitaciones_cajas
    ADD CONSTRAINT cob_habilitaciones_cajas_pkey PRIMARY KEY (id);


--
-- TOC entry 3506 (class 2606 OID 16578)
-- Name: cob_recibos_cabecera cob_recibos_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT cob_recibos_cabecera_pkey PRIMARY KEY (id);


--
-- TOC entry 3508 (class 2606 OID 16779)
-- Name: cob_recibos_cabecera cob_recibos_cabecera_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT cob_recibos_cabecera_uniques UNIQUE (nro_recibo_completo, bs_talonario_id, bs_empresa_id);


--
-- TOC entry 3510 (class 2606 OID 16585)
-- Name: cob_recibos_detalle cob_recibos_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle
    ADD CONSTRAINT cob_recibos_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3512 (class 2606 OID 16594)
-- Name: cob_saldos cob_saldos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos
    ADD CONSTRAINT cob_saldos_pkey PRIMARY KEY (id);


--
-- TOC entry 3514 (class 2606 OID 16781)
-- Name: cob_saldos cob_saldos_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos
    ADD CONSTRAINT cob_saldos_unique_persona_empresa UNIQUE (bs_empresa_id, cob_cliente_id, id_comprobante, tipo_comprobante, nro_cuota);


--
-- TOC entry 3516 (class 2606 OID 16603)
-- Name: com_proveedores com_proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores
    ADD CONSTRAINT com_proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 3518 (class 2606 OID 16783)
-- Name: com_proveedores com_proveedores_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores
    ADD CONSTRAINT com_proveedores_unique_persona_empresa UNIQUE (bs_empresa_id, bs_persona_id);


--
-- TOC entry 3520 (class 2606 OID 16785)
-- Name: cre_desembolso_cabecera cre_desembolso_cab_unique_nrodesem_sol; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT cre_desembolso_cab_unique_nrodesem_sol UNIQUE (cre_solicitud_credito_id);


--
-- TOC entry 3522 (class 2606 OID 16612)
-- Name: cre_desembolso_cabecera cre_desembolso_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT cre_desembolso_cabecera_pkey PRIMARY KEY (id);


--
-- TOC entry 3524 (class 2606 OID 16621)
-- Name: cre_desembolso_detalle cre_desembolso_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_detalle
    ADD CONSTRAINT cre_desembolso_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3526 (class 2606 OID 16630)
-- Name: cre_motivos_prestamos cre_motivos_prestamos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_motivos_prestamos
    ADD CONSTRAINT cre_motivos_prestamos_pkey PRIMARY KEY (id);


--
-- TOC entry 3528 (class 2606 OID 16639)
-- Name: cre_solicitudes_creditos cre_solicitudes_creditos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT cre_solicitudes_creditos_pkey PRIMARY KEY (id);


--
-- TOC entry 3530 (class 2606 OID 16648)
-- Name: cre_tipo_amortizaciones cre_tipo_amortizaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_tipo_amortizaciones
    ADD CONSTRAINT cre_tipo_amortizaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 3532 (class 2606 OID 16657)
-- Name: sto_ajuste_inventarios_cabecera sto_ajuste_inventarios_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_cabecera
    ADD CONSTRAINT sto_ajuste_inventarios_cabecera_pkey PRIMARY KEY (id);


--
-- TOC entry 3534 (class 2606 OID 16787)
-- Name: sto_ajuste_inventarios_cabecera sto_ajuste_inventarios_cabecera_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_cabecera
    ADD CONSTRAINT sto_ajuste_inventarios_cabecera_uniques UNIQUE (nro_operacion, tipo_operacion);


--
-- TOC entry 3536 (class 2606 OID 16664)
-- Name: sto_ajuste_inventarios_detalle sto_ajuste_inventarios_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_detalle
    ADD CONSTRAINT sto_ajuste_inventarios_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3540 (class 2606 OID 16678)
-- Name: sto_articulos_existencias sto_articulos_existencias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos_existencias
    ADD CONSTRAINT sto_articulos_existencias_pkey PRIMARY KEY (id);


--
-- TOC entry 3538 (class 2606 OID 16673)
-- Name: sto_articulos sto_articulos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos
    ADD CONSTRAINT sto_articulos_pkey PRIMARY KEY (id);


--
-- TOC entry 3544 (class 2606 OID 16687)
-- Name: tes_bancos tes_bancos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT tes_bancos_pkey PRIMARY KEY (id);


--
-- TOC entry 3546 (class 2606 OID 16791)
-- Name: tes_bancos tes_bancos_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT tes_bancos_unique_persona_empresa UNIQUE (cod_banco, bs_moneda_id, bs_empresa_id, bs_persona_id);


--
-- TOC entry 3548 (class 2606 OID 16696)
-- Name: tes_depositos tes_depositos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT tes_depositos_pkey PRIMARY KEY (id);


--
-- TOC entry 3550 (class 2606 OID 16793)
-- Name: tes_depositos tes_depositos_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT tes_depositos_uniques UNIQUE (tes_banco_id, bs_empresa_id, nro_boleta);


--
-- TOC entry 3552 (class 2606 OID 16703)
-- Name: tes_pago_comprobante_detalle tes_pago_comprobante_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pago_comprobante_detalle
    ADD CONSTRAINT tes_pago_comprobante_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3554 (class 2606 OID 16712)
-- Name: tes_pagos_cabecera tes_pagos_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT tes_pagos_cabecera_pkey PRIMARY KEY (id);


--
-- TOC entry 3556 (class 2606 OID 16795)
-- Name: tes_pagos_cabecera tes_pagos_cabecera_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT tes_pagos_cabecera_uniques UNIQUE (nro_pago, bs_empresa_id);


--
-- TOC entry 3558 (class 2606 OID 16721)
-- Name: tes_pagos_valores tes_pagos_valores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT tes_pagos_valores_pkey PRIMARY KEY (id);


--
-- TOC entry 3560 (class 2606 OID 16797)
-- Name: tes_pagos_valores tes_pagos_valores_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT tes_pagos_valores_uniques UNIQUE (nro_valor, bs_tipo_valor_id, bs_empresa_id, tes_banco_id);


--
-- TOC entry 3542 (class 2606 OID 16789)
-- Name: sto_articulos_existencias unique_sto_articulo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos_existencias
    ADD CONSTRAINT unique_sto_articulo UNIQUE (sto_articulo_id);


--
-- TOC entry 3562 (class 2606 OID 16730)
-- Name: ven_condicion_ventas ven_condicion_ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_condicion_ventas
    ADD CONSTRAINT ven_condicion_ventas_pkey PRIMARY KEY (id);


--
-- TOC entry 3564 (class 2606 OID 16799)
-- Name: ven_facturas_cabecera ven_fact_cab_unique_nrofact_des; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT ven_fact_cab_unique_nrofact_des UNIQUE (id_comprobante, tipo_factura, nro_factura_completo);


--
-- TOC entry 3566 (class 2606 OID 16739)
-- Name: ven_facturas_cabecera ven_facturas_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT ven_facturas_cabecera_pkey PRIMARY KEY (id);


--
-- TOC entry 3568 (class 2606 OID 16748)
-- Name: ven_facturas_detalles ven_facturas_detalles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_detalles
    ADD CONSTRAINT ven_facturas_detalles_pkey PRIMARY KEY (id);


--
-- TOC entry 3570 (class 2606 OID 16757)
-- Name: ven_vendedores ven_vendedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores
    ADD CONSTRAINT ven_vendedores_pkey PRIMARY KEY (id);


--
-- TOC entry 3642 (class 2606 OID 17155)
-- Name: ven_condicion_ventas fk1kctdwdh75gqju10ahfxjfcf2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_condicion_ventas
    ADD CONSTRAINT fk1kctdwdh75gqju10ahfxjfcf2 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3610 (class 2606 OID 16995)
-- Name: com_proveedores fk1l044rpsd3864i9gdpn789npd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores
    ADD CONSTRAINT fk1l044rpsd3864i9gdpn789npd FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3601 (class 2606 OID 16950)
-- Name: cob_recibos_cabecera fk1n6e6pjm0lgydwtwevfxsv44g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fk1n6e6pjm0lgydwtwevfxsv44g FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3580 (class 2606 OID 16850)
-- Name: bs_talonarios fk1t3k3r99m56rghc24faebvrpv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios
    ADD CONSTRAINT fk1t3k3r99m56rghc24faebvrpv FOREIGN KEY (bs_tipo_comprobante_id) REFERENCES public.bs_tipo_comprobantes(id);


--
-- TOC entry 3587 (class 2606 OID 16890)
-- Name: bs_usuario fk1x18egkv6cfg0xepm1sgbgl1x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT fk1x18egkv6cfg0xepm1sgbgl1x FOREIGN KEY (id_bs_rol) REFERENCES public.bs_rol(id);


--
-- TOC entry 3602 (class 2606 OID 16970)
-- Name: cob_recibos_cabecera fk1xlsfvqk1lsyfbcpcfnmjmk4h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fk1xlsfvqk1lsyfbcpcfnmjmk4h FOREIGN KEY (cob_habilitacion_id) REFERENCES public.cob_habilitaciones_cajas(id);


--
-- TOC entry 3572 (class 2606 OID 16810)
-- Name: bs_menu fk22hb8eml7cy6dpvy59bpewyop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu
    ADD CONSTRAINT fk22hb8eml7cy6dpvy59bpewyop FOREIGN KEY (id_sub_menu) REFERENCES public.bs_menu(id);


--
-- TOC entry 3649 (class 2606 OID 17195)
-- Name: ven_facturas_detalles fk29yj9l2anko3st5j4pqn6pfiu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_detalles
    ADD CONSTRAINT fk29yj9l2anko3st5j4pqn6pfiu FOREIGN KEY (ven_facturas_cabecera_id) REFERENCES public.ven_facturas_cabecera(id);


--
-- TOC entry 3574 (class 2606 OID 16815)
-- Name: bs_menu_item fk3g7tc7h8wt2m43xca8rp2jyfx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu_item
    ADD CONSTRAINT fk3g7tc7h8wt2m43xca8rp2jyfx FOREIGN KEY (id_bs_menu) REFERENCES public.bs_menu(id);


--
-- TOC entry 3643 (class 2606 OID 17160)
-- Name: ven_facturas_cabecera fk3n4unl3iy71lof6ulagu70tmq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fk3n4unl3iy71lof6ulagu70tmq FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3585 (class 2606 OID 16870)
-- Name: bs_tipo_valor fk3vp89j7oui7domwq3o5jeby91; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor
    ADD CONSTRAINT fk3vp89j7oui7domwq3o5jeby91 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3596 (class 2606 OID 16925)
-- Name: cob_cobros_valores fk42q43c2w0rkrvpaa6pbqydij9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT fk42q43c2w0rkrvpaa6pbqydij9 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3588 (class 2606 OID 16880)
-- Name: bs_usuario fk42ssfp38sadjfrya84c0bmqq1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT fk42ssfp38sadjfrya84c0bmqq1 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3583 (class 2606 OID 16860)
-- Name: bs_tipo_comprobantes fk42x4t5hsqr2u19bc1x66anh8p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_comprobantes
    ADD CONSTRAINT fk42x4t5hsqr2u19bc1x66anh8p FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3635 (class 2606 OID 17125)
-- Name: tes_pagos_cabecera fk4i5d3voub0prb2j7aykbpofsi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT fk4i5d3voub0prb2j7aykbpofsi FOREIGN KEY (bs_talonario_id) REFERENCES public.bs_talonarios(id);


--
-- TOC entry 3638 (class 2606 OID 17135)
-- Name: tes_pagos_valores fk4o86k9qdmejm423i7rs8vs7ch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT fk4o86k9qdmejm423i7rs8vs7ch FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3650 (class 2606 OID 17190)
-- Name: ven_facturas_detalles fk4pdq72f0a0iylrwij8qkl1p3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_detalles
    ADD CONSTRAINT fk4pdq72f0a0iylrwij8qkl1p3 FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


--
-- TOC entry 3644 (class 2606 OID 17175)
-- Name: ven_facturas_cabecera fk4x4nqk31anhthjkm68xa8979r; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fk4x4nqk31anhthjkm68xa8979r FOREIGN KEY (cob_habilitacion_caja_id) REFERENCES public.cob_habilitaciones_cajas(id);


--
-- TOC entry 3628 (class 2606 OID 17085)
-- Name: tes_bancos fk4xvsgllxikxlbcv1jfci5ncgy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT fk4xvsgllxikxlbcv1jfci5ncgy FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3629 (class 2606 OID 17090)
-- Name: tes_bancos fk5tddpi4iihrng09a335x5lpla; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT fk5tddpi4iihrng09a335x5lpla FOREIGN KEY (bs_moneda_id) REFERENCES public.bs_moneda(id);


--
-- TOC entry 3594 (class 2606 OID 16915)
-- Name: cob_cobradores fk5xb31b967528ljy9c4uldh30n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores
    ADD CONSTRAINT fk5xb31b967528ljy9c4uldh30n FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3603 (class 2606 OID 16965)
-- Name: cob_recibos_cabecera fk666sst765ols1vybysw4grfts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fk666sst765ols1vybysw4grfts FOREIGN KEY (cob_cobrador_id) REFERENCES public.cob_cobradores(id);


--
-- TOC entry 3586 (class 2606 OID 16875)
-- Name: bs_tipo_valor fk66io42jukuh2geyvuitkkew9t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor
    ADD CONSTRAINT fk66io42jukuh2geyvuitkkew9t FOREIGN KEY (id_bs_modulo) REFERENCES public.bs_modulo(id);


--
-- TOC entry 3578 (class 2606 OID 16835)
-- Name: bs_permiso_rol fk6mm1cqu0k5d9ikuep4y7g6ofx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol
    ADD CONSTRAINT fk6mm1cqu0k5d9ikuep4y7g6ofx FOREIGN KEY (id_bs_menu) REFERENCES public.bs_menu(id);


--
-- TOC entry 3595 (class 2606 OID 16920)
-- Name: cob_cobradores fk6ujgtgjegq7v5ye2m2vbcw880; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores
    ADD CONSTRAINT fk6ujgtgjegq7v5ye2m2vbcw880 FOREIGN KEY (id_bs_persona) REFERENCES public.bs_persona(id);


--
-- TOC entry 3571 (class 2606 OID 16800)
-- Name: bs_empresas fk71g70w71gnjrvdw1657gw2kdi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_empresas
    ADD CONSTRAINT fk71g70w71gnjrvdw1657gw2kdi FOREIGN KEY (bs_personas_id) REFERENCES public.bs_persona(id);


--
-- TOC entry 3630 (class 2606 OID 17095)
-- Name: tes_bancos fk7uycq8vhs2a54sk1ax88qdfb5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT fk7uycq8vhs2a54sk1ax88qdfb5 FOREIGN KEY (bs_persona_id) REFERENCES public.bs_persona(id);


--
-- TOC entry 3573 (class 2606 OID 16805)
-- Name: bs_menu fk84u2i3qvv2ymuq01hfb1ktpoc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu
    ADD CONSTRAINT fk84u2i3qvv2ymuq01hfb1ktpoc FOREIGN KEY (id_bs_modulo) REFERENCES public.bs_modulo(id);


--
-- TOC entry 3639 (class 2606 OID 17150)
-- Name: tes_pagos_valores fk8gbmyhg4og29nolhjqs6wlltg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT fk8gbmyhg4og29nolhjqs6wlltg FOREIGN KEY (tes_pagos_cabecera_id) REFERENCES public.tes_pagos_cabecera(id);


--
-- TOC entry 3581 (class 2606 OID 16845)
-- Name: bs_talonarios fk8thi56l20sx230hr5ycmyljmg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios
    ADD CONSTRAINT fk8thi56l20sx230hr5ycmyljmg FOREIGN KEY (bs_timbrado_id) REFERENCES public.bs_timbrados(id);


--
-- TOC entry 3590 (class 2606 OID 16900)
-- Name: cob_cajas fk912rnk3qo6kwowg0entsiwk7t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas
    ADD CONSTRAINT fk912rnk3qo6kwowg0entsiwk7t FOREIGN KEY (bs_usuario_id) REFERENCES public.bs_usuario(id);


--
-- TOC entry 3636 (class 2606 OID 17120)
-- Name: tes_pagos_cabecera fk9ywxuwblgp70f9pp6wiqupbdj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT fk9ywxuwblgp70f9pp6wiqupbdj FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3631 (class 2606 OID 17105)
-- Name: tes_depositos fka9nh2rpkn7u10ib068h7w896; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT fka9nh2rpkn7u10ib068h7w896 FOREIGN KEY (cob_habilitacion_id) REFERENCES public.cob_habilitaciones_cajas(id);


--
-- TOC entry 3632 (class 2606 OID 17110)
-- Name: tes_depositos fkcklqfy26vjxuo7to2q0eumol4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT fkcklqfy26vjxuo7to2q0eumol4 FOREIGN KEY (tes_banco_id) REFERENCES public.tes_bancos(id);


--
-- TOC entry 3599 (class 2606 OID 16945)
-- Name: cob_habilitaciones_cajas fkdd6ubbut6375vtd69lcrjaxfs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_habilitaciones_cajas
    ADD CONSTRAINT fkdd6ubbut6375vtd69lcrjaxfs FOREIGN KEY (bs_cajas_id) REFERENCES public.cob_cajas(id);


--
-- TOC entry 3618 (class 2606 OID 17035)
-- Name: cre_solicitudes_creditos fkdeaqxqneh5cfvrfkf4jt8fgj8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT fkdeaqxqneh5cfvrfkf4jt8fgj8 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3608 (class 2606 OID 16990)
-- Name: cob_saldos fkdko1ofbbb0likbt9ssik5xnyo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos
    ADD CONSTRAINT fkdko1ofbbb0likbt9ssik5xnyo FOREIGN KEY (cob_cliente_id) REFERENCES public.cob_clientes(id);


--
-- TOC entry 3645 (class 2606 OID 17165)
-- Name: ven_facturas_cabecera fkdm7ghr63ycffbnhevr6vp3seh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fkdm7ghr63ycffbnhevr6vp3seh FOREIGN KEY (bs_talonario_id) REFERENCES public.bs_talonarios(id);


--
-- TOC entry 3612 (class 2606 OID 17005)
-- Name: cre_desembolso_cabecera fke9vl6be2t0fh6gci82rf0le5k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT fke9vl6be2t0fh6gci82rf0le5k FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3600 (class 2606 OID 16940)
-- Name: cob_habilitaciones_cajas fkekiolt8r16g9yrd8dbfex5ior; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_habilitaciones_cajas
    ADD CONSTRAINT fkekiolt8r16g9yrd8dbfex5ior FOREIGN KEY (bs_usuario_id) REFERENCES public.bs_usuario(id);


--
-- TOC entry 3604 (class 2606 OID 16960)
-- Name: cob_recibos_cabecera fkf1u9sflqhv94tfp85ey7ysy17; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fkf1u9sflqhv94tfp85ey7ysy17 FOREIGN KEY (cob_cliente_id) REFERENCES public.cob_clientes(id);


--
-- TOC entry 3584 (class 2606 OID 16865)
-- Name: bs_tipo_comprobantes fkf9f01pvy0jpq1q42uqyxe77v7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_comprobantes
    ADD CONSTRAINT fkf9f01pvy0jpq1q42uqyxe77v7 FOREIGN KEY (bs_modulo_id) REFERENCES public.bs_modulo(id);


--
-- TOC entry 3627 (class 2606 OID 17080)
-- Name: sto_articulos_existencias fkfreklblwvujppk6xmtuoh002k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos_existencias
    ADD CONSTRAINT fkfreklblwvujppk6xmtuoh002k FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


--
-- TOC entry 3597 (class 2606 OID 16930)
-- Name: cob_cobros_valores fkh31b5ynpq92b29uxpx0uvw9pr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT fkh31b5ynpq92b29uxpx0uvw9pr FOREIGN KEY (bs_tipo_valor_id) REFERENCES public.bs_tipo_valor(id);


--
-- TOC entry 3651 (class 2606 OID 17205)
-- Name: ven_vendedores fkhtan16076c8jt6v8fakkct889; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores
    ADD CONSTRAINT fkhtan16076c8jt6v8fakkct889 FOREIGN KEY (id_bs_persona) REFERENCES public.bs_persona(id);


--
-- TOC entry 3619 (class 2606 OID 17050)
-- Name: cre_solicitudes_creditos fkhwitr6b8rkg1n6f63c9bpcu4r; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT fkhwitr6b8rkg1n6f63c9bpcu4r FOREIGN KEY (ven_vendedor_id) REFERENCES public.ven_vendedores(id);


--
-- TOC entry 3575 (class 2606 OID 16820)
-- Name: bs_menu_item fkieqvv51gdjunluuuhyqq061sn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu_item
    ADD CONSTRAINT fkieqvv51gdjunluuuhyqq061sn FOREIGN KEY (id_bs_modulo) REFERENCES public.bs_modulo(id);


--
-- TOC entry 3611 (class 2606 OID 17000)
-- Name: com_proveedores fkinmin3rabgggg7m4tnaihufxi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores
    ADD CONSTRAINT fkinmin3rabgggg7m4tnaihufxi FOREIGN KEY (bs_persona_id) REFERENCES public.bs_persona(id);


--
-- TOC entry 3622 (class 2606 OID 17055)
-- Name: sto_ajuste_inventarios_cabecera fkjay4voyandu8nl91kmfn8qdq5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_cabecera
    ADD CONSTRAINT fkjay4voyandu8nl91kmfn8qdq5 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3646 (class 2606 OID 17185)
-- Name: ven_facturas_cabecera fkjepod7216x4rjfewgdv1i50ce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fkjepod7216x4rjfewgdv1i50ce FOREIGN KEY (ven_vendedor_id) REFERENCES public.ven_vendedores(id);


--
-- TOC entry 3591 (class 2606 OID 16895)
-- Name: cob_cajas fkjll2tv62pu7tgxj82oop7s37c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas
    ADD CONSTRAINT fkjll2tv62pu7tgxj82oop7s37c FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3620 (class 2606 OID 17045)
-- Name: cre_solicitudes_creditos fkjy2ho6trec0ueafxbb5dbx12p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT fkjy2ho6trec0ueafxbb5dbx12p FOREIGN KEY (cre_motivos_prestamos_id) REFERENCES public.cre_motivos_prestamos(id);


--
-- TOC entry 3621 (class 2606 OID 17040)
-- Name: cre_solicitudes_creditos fkjyoii0661sxyi0q2d8ofwkreq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT fkjyoii0661sxyi0q2d8ofwkreq FOREIGN KEY (cob_cliente_id) REFERENCES public.cob_clientes(id);


--
-- TOC entry 3652 (class 2606 OID 17200)
-- Name: ven_vendedores fkk3n2jp7bwts7shgea6ypvprb7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores
    ADD CONSTRAINT fkk3n2jp7bwts7shgea6ypvprb7 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3623 (class 2606 OID 17065)
-- Name: sto_ajuste_inventarios_detalle fkk6i7wmoydogjbwcfmnyb98yl2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_detalle
    ADD CONSTRAINT fkk6i7wmoydogjbwcfmnyb98yl2 FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


--
-- TOC entry 3576 (class 2606 OID 16830)
-- Name: bs_parametros fkkaoe7ju4lwb7fg0a3bgetccdh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros
    ADD CONSTRAINT fkkaoe7ju4lwb7fg0a3bgetccdh FOREIGN KEY (bs_modulo_id) REFERENCES public.bs_modulo(id);


--
-- TOC entry 3605 (class 2606 OID 16955)
-- Name: cob_recibos_cabecera fkl4t95sl76j4fcghlunakchw43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fkl4t95sl76j4fcghlunakchw43 FOREIGN KEY (bs_talonario_id) REFERENCES public.bs_talonarios(id);


--
-- TOC entry 3647 (class 2606 OID 17170)
-- Name: ven_facturas_cabecera fkl86o6oa59d6dyfk401vhx83au; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fkl86o6oa59d6dyfk401vhx83au FOREIGN KEY (cob_cliente_id) REFERENCES public.cob_clientes(id);


--
-- TOC entry 3582 (class 2606 OID 16855)
-- Name: bs_timbrados fklgdvk18byinijmkttd5h898i0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_timbrados
    ADD CONSTRAINT fklgdvk18byinijmkttd5h898i0 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3640 (class 2606 OID 17140)
-- Name: tes_pagos_valores fklgxk9vtjr0c6smrfank9cfs8d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT fklgxk9vtjr0c6smrfank9cfs8d FOREIGN KEY (bs_tipo_valor_id) REFERENCES public.bs_tipo_valor(id);


--
-- TOC entry 3579 (class 2606 OID 16840)
-- Name: bs_permiso_rol fklwj6pt6r3wdujsincvb0dv0dy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol
    ADD CONSTRAINT fklwj6pt6r3wdujsincvb0dv0dy FOREIGN KEY (id_bs_rol) REFERENCES public.bs_rol(id);


--
-- TOC entry 3624 (class 2606 OID 17060)
-- Name: sto_ajuste_inventarios_detalle fkm4gedyp511e6ke4bkpt1v3m4n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_detalle
    ADD CONSTRAINT fkm4gedyp511e6ke4bkpt1v3m4n FOREIGN KEY (sto_ajuste_inventarios_cabecera_id) REFERENCES public.sto_ajuste_inventarios_cabecera(id);


--
-- TOC entry 3641 (class 2606 OID 17145)
-- Name: tes_pagos_valores fkmamdoxobcopdony2pr9lve2w9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT fkmamdoxobcopdony2pr9lve2w9 FOREIGN KEY (tes_banco_id) REFERENCES public.tes_bancos(id);


--
-- TOC entry 3589 (class 2606 OID 16885)
-- Name: bs_usuario fkmmr2uqbw782byg97g95esop9a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT fkmmr2uqbw782byg97g95esop9a FOREIGN KEY (id_bs_persona) REFERENCES public.bs_persona(id);


--
-- TOC entry 3616 (class 2606 OID 17025)
-- Name: cre_desembolso_detalle fkna4v690hqe0bqyv3l02029d81; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_detalle
    ADD CONSTRAINT fkna4v690hqe0bqyv3l02029d81 FOREIGN KEY (cre_desembolso_cabecera_id) REFERENCES public.cre_desembolso_cabecera(id);


--
-- TOC entry 3637 (class 2606 OID 17130)
-- Name: tes_pagos_cabecera fknovyjpnr953c3cgivxkrngcjf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT fknovyjpnr953c3cgivxkrngcjf FOREIGN KEY (cob_habilitacion_id) REFERENCES public.cob_habilitaciones_cajas(id);


--
-- TOC entry 3648 (class 2606 OID 17180)
-- Name: ven_facturas_cabecera fkobp6rivbg1np0jbdj3h94qyaj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fkobp6rivbg1np0jbdj3h94qyaj FOREIGN KEY (ven_condicion_venta_id) REFERENCES public.ven_condicion_ventas(id);


--
-- TOC entry 3613 (class 2606 OID 17020)
-- Name: cre_desembolso_cabecera fkolhx3445luatjis4fnv528ws8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT fkolhx3445luatjis4fnv528ws8 FOREIGN KEY (cre_tipo_amortizacion_id) REFERENCES public.cre_tipo_amortizaciones(id);


--
-- TOC entry 3592 (class 2606 OID 16905)
-- Name: cob_clientes fkon9ydojr2h4wwlukqydv8xdw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes
    ADD CONSTRAINT fkon9ydojr2h4wwlukqydv8xdw FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3625 (class 2606 OID 17070)
-- Name: sto_articulos fkovf4eguuqle7r1bl51ighc83g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos
    ADD CONSTRAINT fkovf4eguuqle7r1bl51ighc83g FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3617 (class 2606 OID 17030)
-- Name: cre_desembolso_detalle fkpcoo9c69bc99u3jxne048vrlh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_detalle
    ADD CONSTRAINT fkpcoo9c69bc99u3jxne048vrlh FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


--
-- TOC entry 3606 (class 2606 OID 16975)
-- Name: cob_recibos_detalle fkpsslc4klrd3ysl82ovyfneybw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle
    ADD CONSTRAINT fkpsslc4klrd3ysl82ovyfneybw FOREIGN KEY (cob_recibos_cabecera_id) REFERENCES public.cob_recibos_cabecera(id);


--
-- TOC entry 3614 (class 2606 OID 17010)
-- Name: cre_desembolso_cabecera fkrs67ijv7se93y3r3ulxmx0eon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT fkrs67ijv7se93y3r3ulxmx0eon FOREIGN KEY (bs_talonario_id) REFERENCES public.bs_talonarios(id);


--
-- TOC entry 3634 (class 2606 OID 17115)
-- Name: tes_pago_comprobante_detalle fks35rcbmiu7dd4ec02k50ebsej; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pago_comprobante_detalle
    ADD CONSTRAINT fks35rcbmiu7dd4ec02k50ebsej FOREIGN KEY (tes_pagos_cabecera_id) REFERENCES public.tes_pagos_cabecera(id);


--
-- TOC entry 3593 (class 2606 OID 16910)
-- Name: cob_clientes fksca9jx2hu8sqensr399s2ay5h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes
    ADD CONSTRAINT fksca9jx2hu8sqensr399s2ay5h FOREIGN KEY (id_bs_persona) REFERENCES public.bs_persona(id);


--
-- TOC entry 3577 (class 2606 OID 16825)
-- Name: bs_parametros fkscdxcj9s7b3qwx0a51g9f4w48; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros
    ADD CONSTRAINT fkscdxcj9s7b3qwx0a51g9f4w48 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3598 (class 2606 OID 16935)
-- Name: cob_cobros_valores fkskoirst2yiqtr9sux7jvjxsqe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT fkskoirst2yiqtr9sux7jvjxsqe FOREIGN KEY (tes_deposito_id) REFERENCES public.tes_depositos(id);


--
-- TOC entry 3615 (class 2606 OID 17015)
-- Name: cre_desembolso_cabecera fksmgqcsfcn3uetkvmi1me93vdq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT fksmgqcsfcn3uetkvmi1me93vdq FOREIGN KEY (cre_solicitud_credito_id) REFERENCES public.cre_solicitudes_creditos(id);


--
-- TOC entry 3609 (class 2606 OID 16985)
-- Name: cob_saldos fkspinx6wy0s1wio5lw5gdtjmoe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos
    ADD CONSTRAINT fkspinx6wy0s1wio5lw5gdtjmoe FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3626 (class 2606 OID 17075)
-- Name: sto_articulos fksu61yolpthu0ay84qr4igfg99; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos
    ADD CONSTRAINT fksu61yolpthu0ay84qr4igfg99 FOREIGN KEY (bs_iva_id) REFERENCES public.bs_iva(id);


--
-- TOC entry 3633 (class 2606 OID 17100)
-- Name: tes_depositos fksw4mly1i667sb5n8hidwnwr8p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT fksw4mly1i667sb5n8hidwnwr8p FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- TOC entry 3607 (class 2606 OID 16980)
-- Name: cob_recibos_detalle fkwebc0cfneqph5f2r5g4hft1t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle
    ADD CONSTRAINT fkwebc0cfneqph5f2r5g4hft1t FOREIGN KEY (cob_saldo_id) REFERENCES public.cob_saldos(id);


-- Completed on 2025-07-01 21:30:35

--
-- PostgreSQL database dump complete
--

