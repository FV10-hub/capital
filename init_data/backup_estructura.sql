--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.3 (Debian 15.3-1.pgdg120+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
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
-- Name: bs_empresas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_empresas_id_seq OWNED BY public.bs_empresas.id;


--
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
-- Name: bs_iva_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_iva_id_seq OWNED BY public.bs_iva.id;


--
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
-- Name: bs_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_menu_id_seq OWNED BY public.bs_menu.id;


--
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
-- Name: bs_menu_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_menu_item_id_seq OWNED BY public.bs_menu_item.id;


--
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
-- Name: bs_modulo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_modulo_id_seq OWNED BY public.bs_modulo.id;


--
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
-- Name: bs_moneda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_moneda_id_seq OWNED BY public.bs_moneda.id;


--
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
-- Name: bs_parametros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_parametros_id_seq OWNED BY public.bs_parametros.id;


--
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
-- Name: bs_permiso_rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_permiso_rol_id_seq OWNED BY public.bs_permiso_rol.id;


--
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
-- Name: bs_persona_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_persona_id_seq OWNED BY public.bs_persona.id;


--
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
-- Name: bs_rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_rol_id_seq OWNED BY public.bs_rol.id;


--
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
-- Name: bs_talonarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_talonarios_id_seq OWNED BY public.bs_talonarios.id;


--
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
-- Name: bs_timbrados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_timbrados_id_seq OWNED BY public.bs_timbrados.id;


--
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
-- Name: bs_tipo_comprobantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_tipo_comprobantes_id_seq OWNED BY public.bs_tipo_comprobantes.id;


--
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
-- Name: bs_tipo_valor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_tipo_valor_id_seq OWNED BY public.bs_tipo_valor.id;


--
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
-- Name: bs_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_usuario_id_seq OWNED BY public.bs_usuario.id;


--
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
-- Name: cob_cajas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_cajas_id_seq OWNED BY public.cob_cajas.id;


--
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
-- Name: cob_clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_clientes_id_seq OWNED BY public.cob_clientes.id;


--
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
-- Name: cob_cobradores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_cobradores_id_seq OWNED BY public.cob_cobradores.id;


--
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
-- Name: cob_cobros_valores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_cobros_valores_id_seq OWNED BY public.cob_cobros_valores.id;


--
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
-- Name: cob_habilitaciones_cajas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_habilitaciones_cajas_id_seq OWNED BY public.cob_habilitaciones_cajas.id;


--
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
-- Name: cob_recibos_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_recibos_cabecera_id_seq OWNED BY public.cob_recibos_cabecera.id;


--
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
-- Name: cob_recibos_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_recibos_detalle_id_seq OWNED BY public.cob_recibos_detalle.id;


--
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
-- Name: cob_saldos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_saldos_id_seq OWNED BY public.cob_saldos.id;


--
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
-- Name: com_proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.com_proveedores_id_seq OWNED BY public.com_proveedores.id;


--
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
-- Name: cre_desembolso_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_desembolso_cabecera_id_seq OWNED BY public.cre_desembolso_cabecera.id;


--
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
-- Name: cre_desembolso_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_desembolso_detalle_id_seq OWNED BY public.cre_desembolso_detalle.id;


--
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
-- Name: cre_motivos_prestamos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_motivos_prestamos_id_seq OWNED BY public.cre_motivos_prestamos.id;


--
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
-- Name: cre_solicitudes_creditos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_solicitudes_creditos_id_seq OWNED BY public.cre_solicitudes_creditos.id;


--
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
-- Name: cre_tipo_amortizaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cre_tipo_amortizaciones_id_seq OWNED BY public.cre_tipo_amortizaciones.id;


--
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
-- Name: sto_ajuste_inventarios_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sto_ajuste_inventarios_cabecera_id_seq OWNED BY public.sto_ajuste_inventarios_cabecera.id;


--
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
-- Name: sto_ajuste_inventarios_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sto_ajuste_inventarios_detalle_id_seq OWNED BY public.sto_ajuste_inventarios_detalle.id;


--
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
-- Name: sto_articulos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sto_articulos_id_seq OWNED BY public.sto_articulos.id;


--
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
-- Name: tes_bancos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_bancos_id_seq OWNED BY public.tes_bancos.id;


--
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
-- Name: tes_depositos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_depositos_id_seq OWNED BY public.tes_depositos.id;


--
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
-- Name: tes_pago_comprobante_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_pago_comprobante_detalle_id_seq OWNED BY public.tes_pago_comprobante_detalle.id;


--
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
-- Name: tes_pagos_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_pagos_cabecera_id_seq OWNED BY public.tes_pagos_cabecera.id;


--
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
-- Name: tes_pagos_valores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_pagos_valores_id_seq OWNED BY public.tes_pagos_valores.id;


--
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
-- Name: ven_condicion_ventas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ven_condicion_ventas_id_seq OWNED BY public.ven_condicion_ventas.id;


--
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
-- Name: ven_facturas_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ven_facturas_cabecera_id_seq OWNED BY public.ven_facturas_cabecera.id;


--
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
-- Name: ven_facturas_detalles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ven_facturas_detalles_id_seq OWNED BY public.ven_facturas_detalles.id;


--
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
-- Name: ven_vendedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ven_vendedores_id_seq OWNED BY public.ven_vendedores.id;


--
-- Name: bs_empresas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_empresas ALTER COLUMN id SET DEFAULT nextval('public.bs_empresas_id_seq'::regclass);


--
-- Name: bs_iva id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_iva ALTER COLUMN id SET DEFAULT nextval('public.bs_iva_id_seq'::regclass);


--
-- Name: bs_menu id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu ALTER COLUMN id SET DEFAULT nextval('public.bs_menu_id_seq'::regclass);


--
-- Name: bs_menu_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu_item ALTER COLUMN id SET DEFAULT nextval('public.bs_menu_item_id_seq'::regclass);


--
-- Name: bs_modulo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_modulo ALTER COLUMN id SET DEFAULT nextval('public.bs_modulo_id_seq'::regclass);


--
-- Name: bs_moneda id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_moneda ALTER COLUMN id SET DEFAULT nextval('public.bs_moneda_id_seq'::regclass);


--
-- Name: bs_parametros id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros ALTER COLUMN id SET DEFAULT nextval('public.bs_parametros_id_seq'::regclass);


--
-- Name: bs_permiso_rol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol ALTER COLUMN id SET DEFAULT nextval('public.bs_permiso_rol_id_seq'::regclass);


--
-- Name: bs_persona id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_persona ALTER COLUMN id SET DEFAULT nextval('public.bs_persona_id_seq'::regclass);


--
-- Name: bs_rol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_rol ALTER COLUMN id SET DEFAULT nextval('public.bs_rol_id_seq'::regclass);


--
-- Name: bs_talonarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios ALTER COLUMN id SET DEFAULT nextval('public.bs_talonarios_id_seq'::regclass);


--
-- Name: bs_timbrados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_timbrados ALTER COLUMN id SET DEFAULT nextval('public.bs_timbrados_id_seq'::regclass);


--
-- Name: bs_tipo_comprobantes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_comprobantes ALTER COLUMN id SET DEFAULT nextval('public.bs_tipo_comprobantes_id_seq'::regclass);


--
-- Name: bs_tipo_valor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor ALTER COLUMN id SET DEFAULT nextval('public.bs_tipo_valor_id_seq'::regclass);


--
-- Name: bs_usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario ALTER COLUMN id SET DEFAULT nextval('public.bs_usuario_id_seq'::regclass);


--
-- Name: cob_cajas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas ALTER COLUMN id SET DEFAULT nextval('public.cob_cajas_id_seq'::regclass);


--
-- Name: cob_clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes ALTER COLUMN id SET DEFAULT nextval('public.cob_clientes_id_seq'::regclass);


--
-- Name: cob_cobradores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores ALTER COLUMN id SET DEFAULT nextval('public.cob_cobradores_id_seq'::regclass);


--
-- Name: cob_cobros_valores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores ALTER COLUMN id SET DEFAULT nextval('public.cob_cobros_valores_id_seq'::regclass);


--
-- Name: cob_habilitaciones_cajas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_habilitaciones_cajas ALTER COLUMN id SET DEFAULT nextval('public.cob_habilitaciones_cajas_id_seq'::regclass);


--
-- Name: cob_recibos_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera ALTER COLUMN id SET DEFAULT nextval('public.cob_recibos_cabecera_id_seq'::regclass);


--
-- Name: cob_recibos_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle ALTER COLUMN id SET DEFAULT nextval('public.cob_recibos_detalle_id_seq'::regclass);


--
-- Name: cob_saldos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos ALTER COLUMN id SET DEFAULT nextval('public.cob_saldos_id_seq'::regclass);


--
-- Name: com_proveedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores ALTER COLUMN id SET DEFAULT nextval('public.com_proveedores_id_seq'::regclass);


--
-- Name: cre_desembolso_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera ALTER COLUMN id SET DEFAULT nextval('public.cre_desembolso_cabecera_id_seq'::regclass);


--
-- Name: cre_desembolso_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_detalle ALTER COLUMN id SET DEFAULT nextval('public.cre_desembolso_detalle_id_seq'::regclass);


--
-- Name: cre_motivos_prestamos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_motivos_prestamos ALTER COLUMN id SET DEFAULT nextval('public.cre_motivos_prestamos_id_seq'::regclass);


--
-- Name: cre_solicitudes_creditos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos ALTER COLUMN id SET DEFAULT nextval('public.cre_solicitudes_creditos_id_seq'::regclass);


--
-- Name: cre_tipo_amortizaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_tipo_amortizaciones ALTER COLUMN id SET DEFAULT nextval('public.cre_tipo_amortizaciones_id_seq'::regclass);


--
-- Name: sto_ajuste_inventarios_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_cabecera ALTER COLUMN id SET DEFAULT nextval('public.sto_ajuste_inventarios_cabecera_id_seq'::regclass);


--
-- Name: sto_ajuste_inventarios_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_detalle ALTER COLUMN id SET DEFAULT nextval('public.sto_ajuste_inventarios_detalle_id_seq'::regclass);


--
-- Name: sto_articulos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos ALTER COLUMN id SET DEFAULT nextval('public.sto_articulos_id_seq'::regclass);


--
-- Name: tes_bancos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos ALTER COLUMN id SET DEFAULT nextval('public.tes_bancos_id_seq'::regclass);


--
-- Name: tes_depositos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos ALTER COLUMN id SET DEFAULT nextval('public.tes_depositos_id_seq'::regclass);


--
-- Name: tes_pago_comprobante_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pago_comprobante_detalle ALTER COLUMN id SET DEFAULT nextval('public.tes_pago_comprobante_detalle_id_seq'::regclass);


--
-- Name: tes_pagos_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera ALTER COLUMN id SET DEFAULT nextval('public.tes_pagos_cabecera_id_seq'::regclass);


--
-- Name: tes_pagos_valores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores ALTER COLUMN id SET DEFAULT nextval('public.tes_pagos_valores_id_seq'::regclass);


--
-- Name: ven_condicion_ventas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_condicion_ventas ALTER COLUMN id SET DEFAULT nextval('public.ven_condicion_ventas_id_seq'::regclass);


--
-- Name: ven_facturas_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera ALTER COLUMN id SET DEFAULT nextval('public.ven_facturas_cabecera_id_seq'::regclass);


--
-- Name: ven_facturas_detalles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_detalles ALTER COLUMN id SET DEFAULT nextval('public.ven_facturas_detalles_id_seq'::regclass);


--
-- Name: ven_vendedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores ALTER COLUMN id SET DEFAULT nextval('public.ven_vendedores_id_seq'::regclass);


--
-- Name: bs_empresas bs_empresas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_empresas
    ADD CONSTRAINT bs_empresas_pkey PRIMARY KEY (id);


--
-- Name: bs_empresas bs_empresas_unique_persona; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_empresas
    ADD CONSTRAINT bs_empresas_unique_persona UNIQUE (bs_personas_id);


--
-- Name: bs_iva bs_iva_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_iva
    ADD CONSTRAINT bs_iva_pkey PRIMARY KEY (id);


--
-- Name: bs_menu_item bs_menu_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu_item
    ADD CONSTRAINT bs_menu_item_pkey PRIMARY KEY (id);


--
-- Name: bs_menu bs_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu
    ADD CONSTRAINT bs_menu_pkey PRIMARY KEY (id);


--
-- Name: bs_modulo bs_modulo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_modulo
    ADD CONSTRAINT bs_modulo_pkey PRIMARY KEY (id);


--
-- Name: bs_modulo bs_modulo_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_modulo
    ADD CONSTRAINT bs_modulo_unique_codigo UNIQUE (codigo);


--
-- Name: bs_moneda bs_moneda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_moneda
    ADD CONSTRAINT bs_moneda_pkey PRIMARY KEY (id);


--
-- Name: bs_moneda bs_moneda_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_moneda
    ADD CONSTRAINT bs_moneda_unique_codigo UNIQUE (cod_moneda);


--
-- Name: bs_parametros bs_parametros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros
    ADD CONSTRAINT bs_parametros_pkey PRIMARY KEY (id);


--
-- Name: bs_parametros bs_parametros_unique_empresa_modulo_parametro; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros
    ADD CONSTRAINT bs_parametros_unique_empresa_modulo_parametro UNIQUE (parametro, bs_empresa_id, bs_modulo_id);


--
-- Name: bs_permiso_rol bs_permiso_rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol
    ADD CONSTRAINT bs_permiso_rol_pkey PRIMARY KEY (id);


--
-- Name: bs_persona bs_persona_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_persona
    ADD CONSTRAINT bs_persona_pkey PRIMARY KEY (id);


--
-- Name: bs_persona bs_persona_unique_documento; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_persona
    ADD CONSTRAINT bs_persona_unique_documento UNIQUE (documento);


--
-- Name: bs_rol bs_rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_rol
    ADD CONSTRAINT bs_rol_pkey PRIMARY KEY (id);


--
-- Name: bs_rol bs_rol_unique_nombre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_rol
    ADD CONSTRAINT bs_rol_unique_nombre UNIQUE (nombre);


--
-- Name: bs_talonarios bs_talonarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios
    ADD CONSTRAINT bs_talonarios_pkey PRIMARY KEY (id);


--
-- Name: bs_talonarios bs_talonarios_unique_timbrado_comprobante; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios
    ADD CONSTRAINT bs_talonarios_unique_timbrado_comprobante UNIQUE (bs_timbrado_id, bs_tipo_comprobante_id);


--
-- Name: bs_timbrados bs_timbrados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_timbrados
    ADD CONSTRAINT bs_timbrados_pkey PRIMARY KEY (id);


--
-- Name: bs_tipo_comprobantes bs_tipo_comprobantes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_comprobantes
    ADD CONSTRAINT bs_tipo_comprobantes_pkey PRIMARY KEY (id);


--
-- Name: bs_tipo_valor bs_tipo_valor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor
    ADD CONSTRAINT bs_tipo_valor_pkey PRIMARY KEY (id);


--
-- Name: bs_usuario bs_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT bs_usuario_pkey PRIMARY KEY (id);


--
-- Name: cob_cajas cob_cajas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas
    ADD CONSTRAINT cob_cajas_pkey PRIMARY KEY (id);


--
-- Name: cob_clientes cob_clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes
    ADD CONSTRAINT cob_clientes_pkey PRIMARY KEY (id);


--
-- Name: cob_clientes cob_clientes_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes
    ADD CONSTRAINT cob_clientes_unique_persona_empresa UNIQUE (cod_cliente, bs_empresa_id, id_bs_persona);


--
-- Name: cob_cobradores cob_cobradores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores
    ADD CONSTRAINT cob_cobradores_pkey PRIMARY KEY (id);


--
-- Name: cob_cobradores cob_cobradores_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores
    ADD CONSTRAINT cob_cobradores_unique_persona_empresa UNIQUE (cod_cobrador, bs_empresa_id, id_bs_persona);


--
-- Name: cob_cobros_valores cob_cobros_valores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT cob_cobros_valores_pkey PRIMARY KEY (id);


--
-- Name: cob_cobros_valores cob_cobros_valores_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT cob_cobros_valores_uniques UNIQUE (bs_empresa_id, bs_tipo_valor_id, nro_valor, id_comprobante);


--
-- Name: cob_habilitaciones_cajas cob_habilitaciones_cajas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_habilitaciones_cajas
    ADD CONSTRAINT cob_habilitaciones_cajas_pkey PRIMARY KEY (id);


--
-- Name: cob_recibos_cabecera cob_recibos_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT cob_recibos_cabecera_pkey PRIMARY KEY (id);


--
-- Name: cob_recibos_cabecera cob_recibos_cabecera_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT cob_recibos_cabecera_uniques UNIQUE (nro_recibo_completo, bs_talonario_id, bs_empresa_id);


--
-- Name: cob_recibos_detalle cob_recibos_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle
    ADD CONSTRAINT cob_recibos_detalle_pkey PRIMARY KEY (id);


--
-- Name: cob_saldos cob_saldos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos
    ADD CONSTRAINT cob_saldos_pkey PRIMARY KEY (id);


--
-- Name: cob_saldos cob_saldos_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos
    ADD CONSTRAINT cob_saldos_unique_persona_empresa UNIQUE (bs_empresa_id, cob_cliente_id, id_comprobante, tipo_comprobante, nro_cuota);


--
-- Name: com_proveedores com_proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores
    ADD CONSTRAINT com_proveedores_pkey PRIMARY KEY (id);


--
-- Name: com_proveedores com_proveedores_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores
    ADD CONSTRAINT com_proveedores_unique_persona_empresa UNIQUE (bs_empresa_id, bs_persona_id);


--
-- Name: cre_desembolso_cabecera cre_desembolso_cab_unique_nrodesem_sol; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT cre_desembolso_cab_unique_nrodesem_sol UNIQUE (cre_solicitud_credito_id);


--
-- Name: cre_desembolso_cabecera cre_desembolso_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT cre_desembolso_cabecera_pkey PRIMARY KEY (id);


--
-- Name: cre_desembolso_detalle cre_desembolso_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_detalle
    ADD CONSTRAINT cre_desembolso_detalle_pkey PRIMARY KEY (id);


--
-- Name: cre_motivos_prestamos cre_motivos_prestamos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_motivos_prestamos
    ADD CONSTRAINT cre_motivos_prestamos_pkey PRIMARY KEY (id);


--
-- Name: cre_solicitudes_creditos cre_solicitudes_creditos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT cre_solicitudes_creditos_pkey PRIMARY KEY (id);


--
-- Name: cre_tipo_amortizaciones cre_tipo_amortizaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_tipo_amortizaciones
    ADD CONSTRAINT cre_tipo_amortizaciones_pkey PRIMARY KEY (id);


--
-- Name: sto_ajuste_inventarios_cabecera sto_ajuste_inventarios_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_cabecera
    ADD CONSTRAINT sto_ajuste_inventarios_cabecera_pkey PRIMARY KEY (id);


--
-- Name: sto_ajuste_inventarios_cabecera sto_ajuste_inventarios_cabecera_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_cabecera
    ADD CONSTRAINT sto_ajuste_inventarios_cabecera_uniques UNIQUE (nro_operacion, tipo_operacion);


--
-- Name: sto_ajuste_inventarios_detalle sto_ajuste_inventarios_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_detalle
    ADD CONSTRAINT sto_ajuste_inventarios_detalle_pkey PRIMARY KEY (id);


--
-- Name: sto_articulos_existencias sto_articulos_existencias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos_existencias
    ADD CONSTRAINT sto_articulos_existencias_pkey PRIMARY KEY (id);


--
-- Name: sto_articulos sto_articulos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos
    ADD CONSTRAINT sto_articulos_pkey PRIMARY KEY (id);


--
-- Name: tes_bancos tes_bancos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT tes_bancos_pkey PRIMARY KEY (id);


--
-- Name: tes_bancos tes_bancos_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT tes_bancos_unique_persona_empresa UNIQUE (cod_banco, bs_moneda_id, bs_empresa_id, bs_persona_id);


--
-- Name: tes_depositos tes_depositos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT tes_depositos_pkey PRIMARY KEY (id);


--
-- Name: tes_depositos tes_depositos_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT tes_depositos_uniques UNIQUE (tes_banco_id, bs_empresa_id, nro_boleta);


--
-- Name: tes_pago_comprobante_detalle tes_pago_comprobante_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pago_comprobante_detalle
    ADD CONSTRAINT tes_pago_comprobante_detalle_pkey PRIMARY KEY (id);


--
-- Name: tes_pagos_cabecera tes_pagos_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT tes_pagos_cabecera_pkey PRIMARY KEY (id);


--
-- Name: tes_pagos_cabecera tes_pagos_cabecera_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT tes_pagos_cabecera_uniques UNIQUE (nro_pago, bs_empresa_id);


--
-- Name: tes_pagos_valores tes_pagos_valores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT tes_pagos_valores_pkey PRIMARY KEY (id);


--
-- Name: tes_pagos_valores tes_pagos_valores_uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT tes_pagos_valores_uniques UNIQUE (nro_valor, bs_tipo_valor_id, bs_empresa_id, tes_banco_id);


--
-- Name: sto_articulos_existencias unique_sto_articulo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos_existencias
    ADD CONSTRAINT unique_sto_articulo UNIQUE (sto_articulo_id);


--
-- Name: ven_condicion_ventas ven_condicion_ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_condicion_ventas
    ADD CONSTRAINT ven_condicion_ventas_pkey PRIMARY KEY (id);


--
-- Name: ven_facturas_cabecera ven_fact_cab_unique_nrofact_des; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT ven_fact_cab_unique_nrofact_des UNIQUE (id_comprobante, tipo_factura, nro_factura_completo);


--
-- Name: ven_facturas_cabecera ven_facturas_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT ven_facturas_cabecera_pkey PRIMARY KEY (id);


--
-- Name: ven_facturas_detalles ven_facturas_detalles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_detalles
    ADD CONSTRAINT ven_facturas_detalles_pkey PRIMARY KEY (id);


--
-- Name: ven_vendedores ven_vendedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores
    ADD CONSTRAINT ven_vendedores_pkey PRIMARY KEY (id);


--
-- Name: ven_condicion_ventas fk1kctdwdh75gqju10ahfxjfcf2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_condicion_ventas
    ADD CONSTRAINT fk1kctdwdh75gqju10ahfxjfcf2 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: com_proveedores fk1l044rpsd3864i9gdpn789npd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores
    ADD CONSTRAINT fk1l044rpsd3864i9gdpn789npd FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cob_recibos_cabecera fk1n6e6pjm0lgydwtwevfxsv44g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fk1n6e6pjm0lgydwtwevfxsv44g FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: bs_talonarios fk1t3k3r99m56rghc24faebvrpv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios
    ADD CONSTRAINT fk1t3k3r99m56rghc24faebvrpv FOREIGN KEY (bs_tipo_comprobante_id) REFERENCES public.bs_tipo_comprobantes(id);


--
-- Name: bs_usuario fk1x18egkv6cfg0xepm1sgbgl1x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT fk1x18egkv6cfg0xepm1sgbgl1x FOREIGN KEY (id_bs_rol) REFERENCES public.bs_rol(id);


--
-- Name: cob_recibos_cabecera fk1xlsfvqk1lsyfbcpcfnmjmk4h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fk1xlsfvqk1lsyfbcpcfnmjmk4h FOREIGN KEY (cob_habilitacion_id) REFERENCES public.cob_habilitaciones_cajas(id);


--
-- Name: bs_menu fk22hb8eml7cy6dpvy59bpewyop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu
    ADD CONSTRAINT fk22hb8eml7cy6dpvy59bpewyop FOREIGN KEY (id_sub_menu) REFERENCES public.bs_menu(id);


--
-- Name: ven_facturas_detalles fk29yj9l2anko3st5j4pqn6pfiu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_detalles
    ADD CONSTRAINT fk29yj9l2anko3st5j4pqn6pfiu FOREIGN KEY (ven_facturas_cabecera_id) REFERENCES public.ven_facturas_cabecera(id);


--
-- Name: bs_menu_item fk3g7tc7h8wt2m43xca8rp2jyfx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu_item
    ADD CONSTRAINT fk3g7tc7h8wt2m43xca8rp2jyfx FOREIGN KEY (id_bs_menu) REFERENCES public.bs_menu(id);


--
-- Name: ven_facturas_cabecera fk3n4unl3iy71lof6ulagu70tmq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fk3n4unl3iy71lof6ulagu70tmq FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: bs_tipo_valor fk3vp89j7oui7domwq3o5jeby91; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor
    ADD CONSTRAINT fk3vp89j7oui7domwq3o5jeby91 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cob_cobros_valores fk42q43c2w0rkrvpaa6pbqydij9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT fk42q43c2w0rkrvpaa6pbqydij9 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: bs_usuario fk42ssfp38sadjfrya84c0bmqq1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT fk42ssfp38sadjfrya84c0bmqq1 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: bs_tipo_comprobantes fk42x4t5hsqr2u19bc1x66anh8p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_comprobantes
    ADD CONSTRAINT fk42x4t5hsqr2u19bc1x66anh8p FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: tes_pagos_cabecera fk4i5d3voub0prb2j7aykbpofsi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT fk4i5d3voub0prb2j7aykbpofsi FOREIGN KEY (bs_talonario_id) REFERENCES public.bs_talonarios(id);


--
-- Name: tes_pagos_valores fk4o86k9qdmejm423i7rs8vs7ch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT fk4o86k9qdmejm423i7rs8vs7ch FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: ven_facturas_detalles fk4pdq72f0a0iylrwij8qkl1p3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_detalles
    ADD CONSTRAINT fk4pdq72f0a0iylrwij8qkl1p3 FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


--
-- Name: ven_facturas_cabecera fk4x4nqk31anhthjkm68xa8979r; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fk4x4nqk31anhthjkm68xa8979r FOREIGN KEY (cob_habilitacion_caja_id) REFERENCES public.cob_habilitaciones_cajas(id);


--
-- Name: tes_bancos fk4xvsgllxikxlbcv1jfci5ncgy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT fk4xvsgllxikxlbcv1jfci5ncgy FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: tes_bancos fk5tddpi4iihrng09a335x5lpla; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT fk5tddpi4iihrng09a335x5lpla FOREIGN KEY (bs_moneda_id) REFERENCES public.bs_moneda(id);


--
-- Name: cob_cobradores fk5xb31b967528ljy9c4uldh30n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores
    ADD CONSTRAINT fk5xb31b967528ljy9c4uldh30n FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cob_recibos_cabecera fk666sst765ols1vybysw4grfts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fk666sst765ols1vybysw4grfts FOREIGN KEY (cob_cobrador_id) REFERENCES public.cob_cobradores(id);


--
-- Name: bs_tipo_valor fk66io42jukuh2geyvuitkkew9t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor
    ADD CONSTRAINT fk66io42jukuh2geyvuitkkew9t FOREIGN KEY (id_bs_modulo) REFERENCES public.bs_modulo(id);


--
-- Name: bs_permiso_rol fk6mm1cqu0k5d9ikuep4y7g6ofx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol
    ADD CONSTRAINT fk6mm1cqu0k5d9ikuep4y7g6ofx FOREIGN KEY (id_bs_menu) REFERENCES public.bs_menu(id);


--
-- Name: cob_cobradores fk6ujgtgjegq7v5ye2m2vbcw880; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobradores
    ADD CONSTRAINT fk6ujgtgjegq7v5ye2m2vbcw880 FOREIGN KEY (id_bs_persona) REFERENCES public.bs_persona(id);


--
-- Name: bs_empresas fk71g70w71gnjrvdw1657gw2kdi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_empresas
    ADD CONSTRAINT fk71g70w71gnjrvdw1657gw2kdi FOREIGN KEY (bs_personas_id) REFERENCES public.bs_persona(id);


--
-- Name: tes_bancos fk7uycq8vhs2a54sk1ax88qdfb5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT fk7uycq8vhs2a54sk1ax88qdfb5 FOREIGN KEY (bs_persona_id) REFERENCES public.bs_persona(id);


--
-- Name: bs_menu fk84u2i3qvv2ymuq01hfb1ktpoc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu
    ADD CONSTRAINT fk84u2i3qvv2ymuq01hfb1ktpoc FOREIGN KEY (id_bs_modulo) REFERENCES public.bs_modulo(id);


--
-- Name: tes_pagos_valores fk8gbmyhg4og29nolhjqs6wlltg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT fk8gbmyhg4og29nolhjqs6wlltg FOREIGN KEY (tes_pagos_cabecera_id) REFERENCES public.tes_pagos_cabecera(id);


--
-- Name: bs_talonarios fk8thi56l20sx230hr5ycmyljmg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_talonarios
    ADD CONSTRAINT fk8thi56l20sx230hr5ycmyljmg FOREIGN KEY (bs_timbrado_id) REFERENCES public.bs_timbrados(id);


--
-- Name: cob_cajas fk912rnk3qo6kwowg0entsiwk7t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas
    ADD CONSTRAINT fk912rnk3qo6kwowg0entsiwk7t FOREIGN KEY (bs_usuario_id) REFERENCES public.bs_usuario(id);


--
-- Name: tes_pagos_cabecera fk9ywxuwblgp70f9pp6wiqupbdj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT fk9ywxuwblgp70f9pp6wiqupbdj FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: tes_depositos fka9nh2rpkn7u10ib068h7w896; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT fka9nh2rpkn7u10ib068h7w896 FOREIGN KEY (cob_habilitacion_id) REFERENCES public.cob_habilitaciones_cajas(id);


--
-- Name: tes_depositos fkcklqfy26vjxuo7to2q0eumol4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT fkcklqfy26vjxuo7to2q0eumol4 FOREIGN KEY (tes_banco_id) REFERENCES public.tes_bancos(id);


--
-- Name: cob_habilitaciones_cajas fkdd6ubbut6375vtd69lcrjaxfs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_habilitaciones_cajas
    ADD CONSTRAINT fkdd6ubbut6375vtd69lcrjaxfs FOREIGN KEY (bs_cajas_id) REFERENCES public.cob_cajas(id);


--
-- Name: cre_solicitudes_creditos fkdeaqxqneh5cfvrfkf4jt8fgj8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT fkdeaqxqneh5cfvrfkf4jt8fgj8 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cob_saldos fkdko1ofbbb0likbt9ssik5xnyo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos
    ADD CONSTRAINT fkdko1ofbbb0likbt9ssik5xnyo FOREIGN KEY (cob_cliente_id) REFERENCES public.cob_clientes(id);


--
-- Name: ven_facturas_cabecera fkdm7ghr63ycffbnhevr6vp3seh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fkdm7ghr63ycffbnhevr6vp3seh FOREIGN KEY (bs_talonario_id) REFERENCES public.bs_talonarios(id);


--
-- Name: cre_desembolso_cabecera fke9vl6be2t0fh6gci82rf0le5k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT fke9vl6be2t0fh6gci82rf0le5k FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cob_habilitaciones_cajas fkekiolt8r16g9yrd8dbfex5ior; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_habilitaciones_cajas
    ADD CONSTRAINT fkekiolt8r16g9yrd8dbfex5ior FOREIGN KEY (bs_usuario_id) REFERENCES public.bs_usuario(id);


--
-- Name: cob_recibos_cabecera fkf1u9sflqhv94tfp85ey7ysy17; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fkf1u9sflqhv94tfp85ey7ysy17 FOREIGN KEY (cob_cliente_id) REFERENCES public.cob_clientes(id);


--
-- Name: bs_tipo_comprobantes fkf9f01pvy0jpq1q42uqyxe77v7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_comprobantes
    ADD CONSTRAINT fkf9f01pvy0jpq1q42uqyxe77v7 FOREIGN KEY (bs_modulo_id) REFERENCES public.bs_modulo(id);


--
-- Name: sto_articulos_existencias fkfreklblwvujppk6xmtuoh002k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos_existencias
    ADD CONSTRAINT fkfreklblwvujppk6xmtuoh002k FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


--
-- Name: cob_cobros_valores fkh31b5ynpq92b29uxpx0uvw9pr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT fkh31b5ynpq92b29uxpx0uvw9pr FOREIGN KEY (bs_tipo_valor_id) REFERENCES public.bs_tipo_valor(id);


--
-- Name: ven_vendedores fkhtan16076c8jt6v8fakkct889; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores
    ADD CONSTRAINT fkhtan16076c8jt6v8fakkct889 FOREIGN KEY (id_bs_persona) REFERENCES public.bs_persona(id);


--
-- Name: cre_solicitudes_creditos fkhwitr6b8rkg1n6f63c9bpcu4r; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT fkhwitr6b8rkg1n6f63c9bpcu4r FOREIGN KEY (ven_vendedor_id) REFERENCES public.ven_vendedores(id);


--
-- Name: bs_menu_item fkieqvv51gdjunluuuhyqq061sn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu_item
    ADD CONSTRAINT fkieqvv51gdjunluuuhyqq061sn FOREIGN KEY (id_bs_modulo) REFERENCES public.bs_modulo(id);


--
-- Name: com_proveedores fkinmin3rabgggg7m4tnaihufxi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores
    ADD CONSTRAINT fkinmin3rabgggg7m4tnaihufxi FOREIGN KEY (bs_persona_id) REFERENCES public.bs_persona(id);


--
-- Name: sto_ajuste_inventarios_cabecera fkjay4voyandu8nl91kmfn8qdq5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_cabecera
    ADD CONSTRAINT fkjay4voyandu8nl91kmfn8qdq5 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: ven_facturas_cabecera fkjepod7216x4rjfewgdv1i50ce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fkjepod7216x4rjfewgdv1i50ce FOREIGN KEY (ven_vendedor_id) REFERENCES public.ven_vendedores(id);


--
-- Name: cob_cajas fkjll2tv62pu7tgxj82oop7s37c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas
    ADD CONSTRAINT fkjll2tv62pu7tgxj82oop7s37c FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cre_solicitudes_creditos fkjy2ho6trec0ueafxbb5dbx12p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT fkjy2ho6trec0ueafxbb5dbx12p FOREIGN KEY (cre_motivos_prestamos_id) REFERENCES public.cre_motivos_prestamos(id);


--
-- Name: cre_solicitudes_creditos fkjyoii0661sxyi0q2d8ofwkreq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_solicitudes_creditos
    ADD CONSTRAINT fkjyoii0661sxyi0q2d8ofwkreq FOREIGN KEY (cob_cliente_id) REFERENCES public.cob_clientes(id);


--
-- Name: ven_vendedores fkk3n2jp7bwts7shgea6ypvprb7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores
    ADD CONSTRAINT fkk3n2jp7bwts7shgea6ypvprb7 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: sto_ajuste_inventarios_detalle fkk6i7wmoydogjbwcfmnyb98yl2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_detalle
    ADD CONSTRAINT fkk6i7wmoydogjbwcfmnyb98yl2 FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


--
-- Name: bs_parametros fkkaoe7ju4lwb7fg0a3bgetccdh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros
    ADD CONSTRAINT fkkaoe7ju4lwb7fg0a3bgetccdh FOREIGN KEY (bs_modulo_id) REFERENCES public.bs_modulo(id);


--
-- Name: cob_recibos_cabecera fkl4t95sl76j4fcghlunakchw43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_cabecera
    ADD CONSTRAINT fkl4t95sl76j4fcghlunakchw43 FOREIGN KEY (bs_talonario_id) REFERENCES public.bs_talonarios(id);


--
-- Name: ven_facturas_cabecera fkl86o6oa59d6dyfk401vhx83au; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fkl86o6oa59d6dyfk401vhx83au FOREIGN KEY (cob_cliente_id) REFERENCES public.cob_clientes(id);


--
-- Name: bs_timbrados fklgdvk18byinijmkttd5h898i0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_timbrados
    ADD CONSTRAINT fklgdvk18byinijmkttd5h898i0 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: tes_pagos_valores fklgxk9vtjr0c6smrfank9cfs8d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT fklgxk9vtjr0c6smrfank9cfs8d FOREIGN KEY (bs_tipo_valor_id) REFERENCES public.bs_tipo_valor(id);


--
-- Name: bs_permiso_rol fklwj6pt6r3wdujsincvb0dv0dy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol
    ADD CONSTRAINT fklwj6pt6r3wdujsincvb0dv0dy FOREIGN KEY (id_bs_rol) REFERENCES public.bs_rol(id);


--
-- Name: sto_ajuste_inventarios_detalle fkm4gedyp511e6ke4bkpt1v3m4n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_ajuste_inventarios_detalle
    ADD CONSTRAINT fkm4gedyp511e6ke4bkpt1v3m4n FOREIGN KEY (sto_ajuste_inventarios_cabecera_id) REFERENCES public.sto_ajuste_inventarios_cabecera(id);


--
-- Name: tes_pagos_valores fkmamdoxobcopdony2pr9lve2w9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_valores
    ADD CONSTRAINT fkmamdoxobcopdony2pr9lve2w9 FOREIGN KEY (tes_banco_id) REFERENCES public.tes_bancos(id);


--
-- Name: bs_usuario fkmmr2uqbw782byg97g95esop9a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT fkmmr2uqbw782byg97g95esop9a FOREIGN KEY (id_bs_persona) REFERENCES public.bs_persona(id);


--
-- Name: cre_desembolso_detalle fkna4v690hqe0bqyv3l02029d81; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_detalle
    ADD CONSTRAINT fkna4v690hqe0bqyv3l02029d81 FOREIGN KEY (cre_desembolso_cabecera_id) REFERENCES public.cre_desembolso_cabecera(id);


--
-- Name: tes_pagos_cabecera fknovyjpnr953c3cgivxkrngcjf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT fknovyjpnr953c3cgivxkrngcjf FOREIGN KEY (cob_habilitacion_id) REFERENCES public.cob_habilitaciones_cajas(id);


--
-- Name: ven_facturas_cabecera fkobp6rivbg1np0jbdj3h94qyaj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_facturas_cabecera
    ADD CONSTRAINT fkobp6rivbg1np0jbdj3h94qyaj FOREIGN KEY (ven_condicion_venta_id) REFERENCES public.ven_condicion_ventas(id);


--
-- Name: cre_desembolso_cabecera fkolhx3445luatjis4fnv528ws8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT fkolhx3445luatjis4fnv528ws8 FOREIGN KEY (cre_tipo_amortizacion_id) REFERENCES public.cre_tipo_amortizaciones(id);


--
-- Name: cob_clientes fkon9ydojr2h4wwlukqydv8xdw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes
    ADD CONSTRAINT fkon9ydojr2h4wwlukqydv8xdw FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: sto_articulos fkovf4eguuqle7r1bl51ighc83g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos
    ADD CONSTRAINT fkovf4eguuqle7r1bl51ighc83g FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cre_desembolso_detalle fkpcoo9c69bc99u3jxne048vrlh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_detalle
    ADD CONSTRAINT fkpcoo9c69bc99u3jxne048vrlh FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


--
-- Name: cob_recibos_detalle fkpsslc4klrd3ysl82ovyfneybw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle
    ADD CONSTRAINT fkpsslc4klrd3ysl82ovyfneybw FOREIGN KEY (cob_recibos_cabecera_id) REFERENCES public.cob_recibos_cabecera(id);


--
-- Name: cre_desembolso_cabecera fkrs67ijv7se93y3r3ulxmx0eon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT fkrs67ijv7se93y3r3ulxmx0eon FOREIGN KEY (bs_talonario_id) REFERENCES public.bs_talonarios(id);


--
-- Name: tes_pago_comprobante_detalle fks35rcbmiu7dd4ec02k50ebsej; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pago_comprobante_detalle
    ADD CONSTRAINT fks35rcbmiu7dd4ec02k50ebsej FOREIGN KEY (tes_pagos_cabecera_id) REFERENCES public.tes_pagos_cabecera(id);


--
-- Name: cob_clientes fksca9jx2hu8sqensr399s2ay5h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_clientes
    ADD CONSTRAINT fksca9jx2hu8sqensr399s2ay5h FOREIGN KEY (id_bs_persona) REFERENCES public.bs_persona(id);


--
-- Name: bs_parametros fkscdxcj9s7b3qwx0a51g9f4w48; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_parametros
    ADD CONSTRAINT fkscdxcj9s7b3qwx0a51g9f4w48 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cob_cobros_valores fkskoirst2yiqtr9sux7jvjxsqe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT fkskoirst2yiqtr9sux7jvjxsqe FOREIGN KEY (tes_deposito_id) REFERENCES public.tes_depositos(id);


--
-- Name: cre_desembolso_cabecera fksmgqcsfcn3uetkvmi1me93vdq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_desembolso_cabecera
    ADD CONSTRAINT fksmgqcsfcn3uetkvmi1me93vdq FOREIGN KEY (cre_solicitud_credito_id) REFERENCES public.cre_solicitudes_creditos(id);


--
-- Name: cob_saldos fkspinx6wy0s1wio5lw5gdtjmoe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_saldos
    ADD CONSTRAINT fkspinx6wy0s1wio5lw5gdtjmoe FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: sto_articulos fksu61yolpthu0ay84qr4igfg99; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos
    ADD CONSTRAINT fksu61yolpthu0ay84qr4igfg99 FOREIGN KEY (bs_iva_id) REFERENCES public.bs_iva(id);


--
-- Name: tes_depositos fksw4mly1i667sb5n8hidwnwr8p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_depositos
    ADD CONSTRAINT fksw4mly1i667sb5n8hidwnwr8p FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: cob_recibos_detalle fkwebc0cfneqph5f2r5g4hft1t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle
    ADD CONSTRAINT fkwebc0cfneqph5f2r5g4hft1t FOREIGN KEY (cob_saldo_id) REFERENCES public.cob_saldos(id);


--
-- PostgreSQL database dump complete
--

