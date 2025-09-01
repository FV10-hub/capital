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

--
-- Name: actualizar_solicitud_desembolsado(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_solicitud_desembolsado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE cre_solicitudes_creditos
    SET ind_desembolsado = NEW.ind_desembolsado
    WHERE id = NEW.cre_solicitud_credito_id
    and bs_empresa_id = NEW.bs_empresa_id;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_solicitud_desembolsado() OWNER TO postgres;

--
-- Name: calcular_nuevo_nro_orden(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calcular_nuevo_nro_orden() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Obtener el último nro_orden
    SELECT COALESCE(MAX(nro_orden), 0) + 1 INTO NEW.nro_orden
    FROM bs_modulo;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.calcular_nuevo_nro_orden() OWNER TO postgres;

--
-- Name: delete_pantalla_menu_item(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_pantalla_menu_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    id_menu_item_to_subitem INT;
BEGIN
        DELETE FROM public.bs_menu_item
        WHERE id_bs_menu = OLD.id;
    RETURN OLD;        
END;
$$;


ALTER FUNCTION public.delete_pantalla_menu_item() OWNER TO postgres;

--
-- Name: fn_actualizar_ind_desembolsado(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_ind_desembolsado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.ind_desembolsado = 'S' AND OLD.ind_desembolsado != 'S' THEN
        UPDATE cre_solicitudes_creditos
        SET ind_desembolsado = NEW.ind_desembolsado
        WHERE id = NEW.cre_solicitud_credito_id;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_actualizar_ind_desembolsado() OWNER TO postgres;

--
-- Name: fn_actualizar_ind_fact_desembolsado(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_ind_fact_desembolsado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN    
    IF TG_OP = 'INSERT' THEN
        IF NEW.tipo_factura = 'DESEMBOLSO' THEN
            UPDATE cre_desembolso_cabecera
            SET ind_facturado = 'S', ind_desembolsado = 'S'
            WHERE id = NEW.id_comprobante;
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.tipo_factura = 'DESEMBOLSO' THEN
            UPDATE cre_desembolso_cabecera
            SET ind_facturado = 'N', ind_desembolsado = 'N'
            WHERE id = OLD.id_comprobante;
        END IF;
        DELETE FROM public.cob_saldos 
        WHERE id_comprobante = OLD.id_comprobante 
        and bs_empresa_id = OLD.bs_empresa_id 
        and cob_cliente_id = OLD.cob_cliente_id;
    END IF;



    RETURN NULL;
END;
$$;


ALTER FUNCTION public.fn_actualizar_ind_fact_desembolsado() OWNER TO postgres;

--
-- Name: fn_bs_menu_calcular_nuevo_nro_orden(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_bs_menu_calcular_nuevo_nro_orden() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Obtener el último nro_orden para el id_bs_modulo específico
    SELECT COALESCE(MAX(nro_orden), 0) + 1 INTO NEW.nro_orden
    FROM bs_menu
    WHERE id_bs_modulo = NEW.id_bs_modulo;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_bs_menu_calcular_nuevo_nro_orden() OWNER TO postgres;

--
-- Name: fn_cob_actualizar_saldo_cuota(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_cob_actualizar_saldo_cuota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.monto_pagado > (SELECT saldo_cuota FROM cob_saldos WHERE id = NEW.cob_saldo_id) THEN
        RAISE EXCEPTION 'El monto pagado no puede ser mayor que el saldo de la cuota.';
    END IF;

    UPDATE cob_saldos
    SET saldo_cuota = saldo_cuota - NEW.monto_pagado
    WHERE id = NEW.cob_saldo_id;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_cob_actualizar_saldo_cuota() OWNER TO postgres;

--
-- Name: fn_cob_deshacer_saldo_cuota(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_cob_deshacer_saldo_cuota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE cob_saldos
    SET saldo_cuota = saldo_cuota + OLD.monto_pagado
    WHERE id = OLD.cob_saldo_id;

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.fn_cob_deshacer_saldo_cuota() OWNER TO postgres;

--
-- Name: fn_com_actualiza_existencia_articulo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_com_actualiza_existencia_articulo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF COALESCE((SELECT ind_inventariable FROM sto_articulos WHERE id = 
        CASE
            WHEN TG_OP = 'INSERT' THEN NEW.sto_articulo_id
            WHEN TG_OP = 'DELETE' THEN OLD.sto_articulo_id
        END), 'N') = 'S' THEN
        IF TG_OP = 'INSERT' THEN
            UPDATE sto_articulos_existencias
            SET existencia = existencia + NEW.cantidad
            WHERE sto_articulo_id = NEW.sto_articulo_id;
        ELSIF TG_OP = 'DELETE' THEN
            UPDATE sto_articulos_existencias
            SET existencia = existencia - OLD.cantidad
            WHERE sto_articulo_id = OLD.sto_articulo_id;
        END IF;
    END IF;

    RETURN CASE
        WHEN TG_OP = 'INSERT' THEN NEW
        WHEN TG_OP = 'DELETE' THEN OLD
    END;
END;
$$;


ALTER FUNCTION public.fn_com_actualiza_existencia_articulo() OWNER TO postgres;

--
-- Name: fn_com_eliminar_saldos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_com_eliminar_saldos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN    
        DELETE FROM public.com_saldos 
        WHERE id_comprobante = OLD.id 
        and bs_empresa_id = OLD.bs_empresa_id 
        and com_proveedor_id = OLD.com_proveedor_id;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.fn_com_eliminar_saldos() OWNER TO postgres;

--
-- Name: fn_genera_cod_cobrador(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_genera_cod_cobrador() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.cod_cobrador IS NULL OR NEW.cod_cobrador = '' THEN
    NEW.cod_cobrador := nextval('public.seq_cod_cobrador')::text;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_genera_cod_cobrador() OWNER TO postgres;

--
-- Name: fn_genera_cod_proveedor(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_genera_cod_proveedor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.cod_proveedor IS NULL OR NEW.cod_proveedor = '' THEN
    NEW.cod_proveedor := nextval('public.seq_cod_proveedor')::text;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_genera_cod_proveedor() OWNER TO postgres;

--
-- Name: fn_genera_cod_vendedor(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_genera_cod_vendedor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.cod_vendedor IS NULL OR NEW.cod_vendedor = '' THEN
    NEW.cod_vendedor := nextval('public.seq_cod_vendedor')::text;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_genera_cod_vendedor() OWNER TO postgres;

--
-- Name: fn_inserta_sto_articulos_existencias(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_inserta_sto_articulos_existencias() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.ind_inventariable = 'S' THEN
        INSERT INTO sto_articulos_existencias (sto_articulo_id, existencia)
        VALUES (NEW.id, 1);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_inserta_sto_articulos_existencias() OWNER TO postgres;

--
-- Name: fn_sto_actualizar_existencia_detalle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_sto_actualizar_existencia_detalle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    autorizado_actual CHAR(1);
    tipo_operacion_actual CHAR(50);
BEGIN
    BEGIN
	    SELECT COALESCE(ind_autorizado, 'N'), COALESCE(tipo_operacion, 'N')
	    	INTO autorizado_actual, tipo_operacion_actual
	    FROM sto_ajuste_inventarios_cabecera
	    WHERE id = COALESCE(NEW.sto_ajuste_inventarios_cabecera_id, OLD.sto_ajuste_inventarios_cabecera_id);
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error al ejecutar la consulta: %', SQLERRM;
	
	END;

   --el tipo de operacion es solo semantico ya que cantidad_fisica se estabelcera como stock actual
    IF autorizado_actual = 'S' THEN
        IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
            IF tipo_operacion_actual = 'ENTRADA' THEN
                UPDATE public.sto_articulos_existencias
                SET existencia_anterior = existencia, existencia = NEW.cantidad_fisica
                WHERE sto_articulo_id = NEW.sto_articulo_id;
            ELSIF tipo_operacion_actual = 'SALIDA' THEN
                UPDATE public.sto_articulos_existencias
                SET existencia_anterior = existencia, existencia = NEW.cantidad_fisica
                WHERE sto_articulo_id = NEW.sto_articulo_id;
            END IF;
        END IF;
    ELSIF autorizado_actual = 'N' OR TG_OP = 'DELETE' THEN
        UPDATE public.sto_articulos_existencias
        SET existencia = existencia_anterior
        WHERE sto_articulo_id = OLD.sto_articulo_id;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.fn_sto_actualizar_existencia_detalle() OWNER TO postgres;

--
-- Name: fn_tes_actualizar_saldo_banco(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_tes_actualizar_saldo_banco() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE tes_bancos
        SET saldo_cuenta = saldo_cuenta + NEW.monto_total_deposito
        WHERE id = NEW.tes_banco_id;
        return new;
    ELSIF TG_OP = 'UPDATE' AND NEW.estado = 'ANULADO' then
    	UPDATE cob_cobros_valores
        SET tes_deposito_id = null, ind_depositado = 'N', fecha_deposito = null
        WHERE tes_deposito_id = NEW.id;
    
       UPDATE tes_bancos
        SET saldo_cuenta = saldo_cuenta - NEW.monto_total_deposito
        WHERE id = NEW.tes_banco_id;
       return NEW;   
    ELSIF TG_OP = 'DELETE' then
    	if old.ESTADO != 'ANULADO' THEN
	    	UPDATE cob_cobros_valores
	        SET tes_deposito_id = null, ind_depositado = 'N', fecha_deposito = null
	        WHERE tes_deposito_id = OLD.id;
	    
	       UPDATE tes_bancos
	        SET saldo_cuenta = saldo_cuenta - OLD.monto_total_deposito
	        WHERE id = OLD.tes_banco_id;
	       return old;
	     END IF;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.fn_tes_actualizar_saldo_banco() OWNER TO postgres;

--
-- Name: fn_tes_pago_actualizar_saldo_banco(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_tes_pago_actualizar_saldo_banco() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    monto numeric(19, 2);
BEGIN
    -- Calcula el monto afectado en base a la operación (insertar, actualizar, eliminar)
    IF TG_OP = 'INSERT' THEN
        monto := NEW.monto_cuota;
       	UPDATE tes_bancos
	    SET saldo_cuenta = saldo_cuenta - monto
	    where bs_empresa_id = new.bs_empresa_id 
	    and id = NEW.tes_banco_id;
	ELSIF TG_OP = 'UPDATE' THEN   
		monto := NEW.monto_cuota - OLD.monto_cuota;
       	UPDATE tes_bancos
	    SET saldo_cuenta = saldo_cuenta - monto
	    where bs_empresa_id = new.bs_empresa_id 
	    and id = NEW.tes_banco_id;
    ELSIF TG_OP = 'DELETE' THEN
        monto := OLD.monto_cuota;
       	UPDATE tes_bancos
	    SET saldo_cuenta = saldo_cuenta + monto
	    where bs_empresa_id = new.bs_empresa_id 
	    and id = NEW.tes_banco_id;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.fn_tes_pago_actualizar_saldo_banco() OWNER TO postgres;

--
-- Name: fn_vec_eliminar_saldos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_vec_eliminar_saldos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN    
    IF NEW.estado = 'ANULADO' THEN
        DELETE FROM public.com_saldos 
        WHERE id_comprobante = NEW.id_comprobante 
        and bs_empresa_id = NEW.bs_empresa_id 
        and com_proveedor_id = NEW.com_proveedor_id;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_vec_eliminar_saldos() OWNER TO postgres;

--
-- Name: fn_ven_actualiza_existencia_articulo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_ven_actualiza_existencia_articulo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF COALESCE((SELECT ind_inventariable FROM sto_articulos WHERE id = 
        CASE
            WHEN TG_OP = 'INSERT' THEN NEW.sto_articulo_id
            WHEN TG_OP = 'DELETE' THEN OLD.sto_articulo_id
        END), 'N') = 'S' THEN
        IF TG_OP = 'INSERT' THEN
            UPDATE sto_articulos_existencias
            SET existencia = existencia - NEW.cantidad
            WHERE sto_articulo_id = NEW.sto_articulo_id;
        ELSIF TG_OP = 'DELETE' THEN
            UPDATE sto_articulos_existencias
            SET existencia = existencia + OLD.cantidad
            WHERE sto_articulo_id = OLD.sto_articulo_id;
        END IF;
    END IF;

    RETURN CASE
        WHEN TG_OP = 'INSERT' THEN NEW
        WHEN TG_OP = 'DELETE' THEN OLD
    END;
END;
$$;


ALTER FUNCTION public.fn_ven_actualiza_existencia_articulo() OWNER TO postgres;

--
-- Name: fn_ven_eliminar_saldos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_ven_eliminar_saldos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN    
    IF NEW.estado = 'ANULADO' THEN
        DELETE FROM public.cob_saldos 
        WHERE id_comprobante = NEW.id_comprobante 
        and bs_empresa_id = NEW.bs_empresa_id 
        and cob_cliente_id = NEW.cob_cliente_id;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_ven_eliminar_saldos() OWNER TO postgres;

--
-- Name: fun_numeros_a_letras(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fun_numeros_a_letras(num numeric) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
 
	DECLARE	--Declaramos las variables a ser usadas
	d VARCHAR[]; --variable para unidades y parte de las decenas
	f VARCHAR[]; --variable para el resto de las decenas
	g VARCHAR[]; --variable para las centenas
	numt VARCHAR; --variable para la conversion de nro a letra
	txt VARCHAR; -- variable para la impresion a letras
	a INTEGER;
	a1 INTEGER;
	a2 INTEGER;
	n INTEGER;
	p INTEGER;
	negativo BOOLEAN;
BEGIN
	-- Máximo 999.999.999,99; si es mayor, retorna nulo
	IF num > 999999999.99 THEN
		RETURN '---';
	END IF;
	txt = '';
	d = ARRAY[' un',' dos',' tres',' cuatro',' cinco',' seis',' siete',' ocho',' nueve',' diez',' once',' doce',' trece',' catorce',' quince',
		' dieciseis',' diecisiete',' dieciocho',' diecinueve',' veinte',' veintiun',' veintidos', ' veintitres', ' veinticuatro', ' veinticinco',
		' veintiseis',' veintisiete',' veintiocho',' veintinueve'];-- Declaracion  de las Unidades y Primera Parte de las Decenas
	f = ARRAY ['','',' treinta',' cuarenta',' cincuenta',' sesenta',' setenta',' ochenta', ' noventa'];-- Declaracion del resto de las Decenas
	g= ARRAY [' ciento',' doscientos',' trescientos',' cuatrocientos',' quinientos',' seiscientos',' setecientos',' ochocientos',' novecientos'];-- Declaracion de las Centenas
	numt = LPAD((num::numeric(12,2))::text,12,'0');
	IF strpos(numt,'-') > 0 THEN
	   negativo = TRUE;
	ELSE
	   negativo = FALSE;
	END IF;
	numt = TRANSLATE(numt,'-','0');
	numt = TRANSLATE(numt,'.,','');
	-- Se Tratan 4 grupos: millones, miles, unidades y decimales
	p = 1;
	FOR i IN 1..4 LOOP
		IF i < 4 THEN
			n = substring(numt::text FROM p FOR 3);
		ELSE
			n = substring(numt::text FROM p FOR 2);
		END IF;
		p = p + 3;
		IF i = 4 THEN
			IF txt = '' THEN
				txt = ' cero';
			END IF;
			IF n > 0 THEN
			-- Empieza con los decimales
				txt = txt || ' con';
			END IF;
		END IF;
		-- Centenas
		IF n > 99 THEN
			a = substring(n::text FROM 1 FOR 1);
			a1 = substring(n::text FROM 2 FOR 2);
			IF a = 1 THEN
				IF a1 = 0 THEN
					txt = txt || ' cien';
				ELSE
					txt = txt || ' ciento';
				END IF;
			ELSE
				txt = txt || g[a];
			END IF;
		ELSE
			a1 = n;
		END IF;
		-- Decenas
		a = a1;
		IF a > 0 THEN
			IF a < 30 THEN
				IF a = 21 AND (i = 3 OR i = 4) THEN
					txt = txt || ' veintiuno';
				ELSIF n = 1 AND i = 2 THEN
					txt = txt;
				ELSIF a = 1 AND (i = 3 OR i = 4)THEN
					txt = txt || ' uno';
				ELSE
					txt = txt || d[a];
				END IF;
			ELSE
				a1 = substring(a::text FROM 1 FOR 1);
				a2 = substring(a::text FROM 2 FOR 1);
				IF a2 = 1 AND (i = 3 OR i = 4) THEN
						txt = txt || f[a1] || ' y' || ' uno';
				ELSE
					IF a2 <> 0 THEN
						txt = txt || f[a1] || ' y' || d[a2];
					ELSE
						txt = txt || f[a1];
					END IF;
				END IF;
			END IF;
		END IF;
		IF n > 0 THEN
			IF i = 1 THEN
				IF n = 1 THEN
					txt = txt || ' millón';
				ELSE
					txt = txt || ' millones';
				END IF;
			ELSIF i = 2 THEN
				txt = txt || ' mil';
			END IF;		
		END IF;
	END LOOP;
	txt = LTRIM(txt);
	IF negativo = TRUE THEN
	   txt= '-' || txt;
	END IF;
    RETURN txt;
END;
$$;


ALTER FUNCTION public.fun_numeros_a_letras(num numeric) OWNER TO postgres;

--
-- Name: genera_cob_cliente(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.genera_cob_cliente() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.cod_cliente IS NULL OR NEW.cod_cliente = '' THEN
    NEW.cod_cliente := nextval('public.seq_cod_cliente')::text;
    -- con prefijo/padding:
    -- NEW.cod_cliente := 'CL-' || lpad(nextval('public.seq_cod_cliente')::text, 6, '0');
    -- HEX:
    -- NEW.cod_cliente := upper(to_hex(nextval('public.seq_cod_cliente')));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.genera_cob_cliente() OWNER TO postgres;

--
-- Name: insertar_menu_item_agrupador(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_menu_item_agrupador() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
IF TG_OP = 'INSERT' THEN
    INSERT INTO public.bs_menu_item(
            estado, fecha_modificacion, fecha_creacion, 
            id_menu_item, nro_orden, titulo, id_bs_menu, 
            id_bs_modulo, icon, tipo_menu)
    VALUES (
       'ACTIVO', -- Estado predeterminado
        NOW(), -- Fecha de modificación actual
        NOW(), -- Fecha de creación actual
        NULL, -- Debes proporcionar el valor apropiado para 'id_menu_item'
        NULL, -- Debes proporcionar el valor apropiado para 'nro_orden'
        'Definiciones', -- Debes proporcionar el valor apropiado para 'titulo'
        null, -- ID de bs_menu
        NEW.id, -- ID de bs_modulo
        'pi pi-fw pi-list', -- Debes proporcionar el valor apropiado para 'icon'
        'DEFINICION' -- Tipo de menú agrupador
    );
    INSERT INTO public.bs_menu_item(
            estado, fecha_modificacion, fecha_creacion, 
            id_menu_item, nro_orden, titulo, id_bs_menu, 
            id_bs_modulo, icon, tipo_menu)
    VALUES ( 
        'ACTIVO', -- Estado predeterminado
        NOW(), -- Fecha de modificación actual
        NOW(), -- Fecha de creación actual
        NULL, -- Debes proporcionar el valor apropiado para 'id_menu_item'
        NULL, -- Debes proporcionar el valor apropiado para 'nro_orden'
        'Movimientos', -- Debes proporcionar el valor apropiado para 'titulo'
        null, -- ID de bs_menu
        NEW.id, -- ID de bs_modulo
        'pi pi-fw pi-box', -- Debes proporcionar el valor apropiado para 'icon'
        'MOVIMIENTOS' -- Tipo de menú agrupador
    );
    INSERT INTO public.bs_menu_item(
            estado, fecha_modificacion, fecha_creacion, 
            id_menu_item, nro_orden, titulo, id_bs_menu, 
            id_bs_modulo, icon, tipo_menu)
    VALUES ( -- Aquí debes proporcionar el valor apropiado para 'id'
        'ACTIVO', -- Estado predeterminado
        NOW(), -- Fecha de modificación actual
        NOW(), -- Fecha de creación actual
        NULL, -- Debes proporcionar el valor apropiado para 'id_menu_item'
        NULL, -- Debes proporcionar el valor apropiado para 'nro_orden'
        'Reportes', -- Debes proporcionar el valor apropiado para 'titulo'
        null, -- ID de bs_menu
        NEW.id, -- ID de bs_modulo
        'pi pi-fw pi-print', -- Debes proporcionar el valor apropiado para 'icon'
        'REPORTES' -- Tipo de menú agrupador
        );
    RETURN NEW;
ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM public.bs_menu_item
        WHERE id_bs_modulo = OLD.id;
	RETURN OLD;		
END IF;

END;
$$;


ALTER FUNCTION public.insertar_menu_item_agrupador() OWNER TO postgres;

--
-- Name: set_nombre_completo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_nombre_completo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.nombre_completo := NEW.nombre || ' ' || NEW.primer_apellido || ' ' || NEW.segundo_apellido;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_nombre_completo() OWNER TO postgres;

--
-- Name: set_pantalla_menu_item(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_pantalla_menu_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    id_menu_item_to_subitem INT;
BEGIN
IF TG_OP = 'INSERT' THEN
        BEGIN
            SELECT id 
            INTO id_menu_item_to_subitem
            FROM public.bs_menu_item mi
            WHERE mi.id_bs_modulo = NEW.id_bs_modulo
            and mi.tipo_menu = NEW.tipo_menu_agrupador
			and mi.id_bs_menu is null
            LIMIT 1;
        EXCEPTION
            WHEN OTHERS THEN
                id_menu_item_to_subitem := 0;
        END;
        INSERT INTO public.bs_menu_item(
                estado, fecha_modificacion, fecha_creacion, 
                id_menu_item, nro_orden, titulo, id_bs_menu, 
                id_bs_modulo, icon, tipo_menu)
        VALUES (
            'ACTIVO', 
            NOW(), 
            NOW(), 
            id_menu_item_to_subitem, 
            null, 
            NEW.nombre, 
            NEW.id, 
            NEW.id_bs_modulo,
            'pi pi-fw pi-ellipsis-v', 
            'MENU' 
        );
    
    RETURN NEW;        
END IF;

END;
$$;


ALTER FUNCTION public.set_pantalla_menu_item() OWNER TO postgres;

--
-- Name: tes_debcred_actualizar_saldos_bancarios(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tes_debcred_actualizar_saldos_bancarios() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Resta al banco saliente
        UPDATE tes_bancos
        SET saldo_cuenta = COALESCE(saldo_cuenta, 0) - COALESCE(NEW.monto_total_salida, 0)
        WHERE id = NEW.tes_banco_id_saliente;

        -- Suma al banco entrante
        UPDATE tes_bancos
        SET saldo_cuenta = COALESCE(saldo_cuenta, 0) + COALESCE(NEW.monto_total_entrada, 0)
        WHERE id = NEW.tes_banco_id_entrante;

        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        -- Revertir: sumar al saliente, restar al entrante
        UPDATE tes_bancos
        SET saldo_cuenta = COALESCE(saldo_cuenta, 0) + COALESCE(OLD.monto_total_salida, 0)
        WHERE id = OLD.tes_banco_id_saliente;

        UPDATE tes_bancos
        SET saldo_cuenta = COALESCE(saldo_cuenta, 0) - COALESCE(OLD.monto_total_entrada, 0)
        WHERE id = OLD.tes_banco_id_entrante;

        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.tes_debcred_actualizar_saldos_bancarios() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bs_access_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_access_log (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_usuario character varying(255),
    ip_address character varying(255),
    success character varying(255)
);


ALTER TABLE public.bs_access_log OWNER TO postgres;

--
-- Name: bs_access_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_access_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_access_log_id_seq OWNER TO postgres;

--
-- Name: bs_access_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_access_log_id_seq OWNED BY public.bs_access_log.id;


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
    segundo_apellido character varying(45),
    tipo_documento character varying(100),
    tipo_persona character varying(100)
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
-- Name: bs_reset_password_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bs_reset_password_token (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_usuario character varying(255),
    expires_at timestamp without time zone,
    token character varying(255),
    validated character varying(255)
);


ALTER TABLE public.bs_reset_password_token OWNER TO postgres;

--
-- Name: bs_reset_password_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bs_reset_password_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bs_reset_password_token_id_seq OWNER TO postgres;

--
-- Name: bs_reset_password_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bs_reset_password_token_id_seq OWNED BY public.bs_reset_password_token.id;


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
    id_bs_rol bigint,
    bloqueado_hasta timestamp without time zone,
    intentos_fallidos integer
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
-- Name: cob_arqueos_cajas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_arqueos_cajas (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    monto_cheques numeric(19,2),
    monto_efectivo numeric(19,2),
    monto_tarjetas numeric(19,2),
    bs_empresa_id bigint NOT NULL,
    cob_habilitacion_id bigint NOT NULL
);


ALTER TABLE public.cob_arqueos_cajas OWNER TO postgres;

--
-- Name: cob_arqueos_cajas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cob_arqueos_cajas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cob_arqueos_cajas_id_seq OWNER TO postgres;

--
-- Name: cob_arqueos_cajas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cob_arqueos_cajas_id_seq OWNED BY public.cob_arqueos_cajas.id;


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
    tes_deposito_id bigint,
    ind_consiliado character varying(255)
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
-- Name: com_facturas_cabecera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.com_facturas_cabecera (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_factura date,
    ind_pagado character varying(255),
    monto_total_exenta numeric(19,2),
    monto_total_factura numeric(19,2),
    monto_total_gravada numeric(19,2),
    monto_total_iva numeric(19,2),
    nro_factura_completo character varying(255),
    observacion character varying(255),
    tipo_factura character varying(255),
    bs_empresa_id bigint NOT NULL,
    com_proveedor_id bigint NOT NULL
);


ALTER TABLE public.com_facturas_cabecera OWNER TO postgres;

--
-- Name: com_facturas_cabecera_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.com_facturas_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.com_facturas_cabecera_id_seq OWNER TO postgres;

--
-- Name: com_facturas_cabecera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.com_facturas_cabecera_id_seq OWNED BY public.com_facturas_cabecera.id;


--
-- Name: com_facturas_detalles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.com_facturas_detalles (
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
    com_facturas_cabecera_id bigint,
    sto_articulo_id bigint
);


ALTER TABLE public.com_facturas_detalles OWNER TO postgres;

--
-- Name: com_facturas_detalles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.com_facturas_detalles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.com_facturas_detalles_id_seq OWNER TO postgres;

--
-- Name: com_facturas_detalles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.com_facturas_detalles_id_seq OWNED BY public.com_facturas_detalles.id;


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
-- Name: com_saldos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.com_saldos (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_vencimiento date,
    id_comprobante bigint,
    monto_cuota numeric(19,2),
    nro_comprobante_completo character varying(255),
    nro_cuota integer,
    saldo_cuota numeric(19,2),
    tipo_comprobante character varying(255),
    bs_empresa_id bigint NOT NULL,
    com_proveedor_id bigint NOT NULL
);


ALTER TABLE public.com_saldos OWNER TO postgres;

--
-- Name: com_saldos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.com_saldos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.com_saldos_id_seq OWNER TO postgres;

--
-- Name: com_saldos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.com_saldos_id_seq OWNED BY public.com_saldos.id;


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
-- Name: seq_cod_cobrador; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_cod_cobrador
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE public.seq_cod_cobrador OWNER TO postgres;

--
-- Name: seq_cod_proveedor; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_cod_proveedor
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE public.seq_cod_proveedor OWNER TO postgres;

--
-- Name: seq_cod_vendedor; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_cod_vendedor
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE public.seq_cod_vendedor OWNER TO postgres;

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
-- Name: tes_conciliaciones_valores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_conciliaciones_valores (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_valor date,
    ind_conciliado character varying(255),
    monto_valor numeric(19,2),
    nro_valor character varying(255),
    observacion character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_tipo_valor_id bigint NOT NULL,
    cob_cobros_valores_id bigint NOT NULL
);


ALTER TABLE public.tes_conciliaciones_valores OWNER TO postgres;

--
-- Name: tes_conciliaciones_valores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_conciliaciones_valores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_conciliaciones_valores_id_seq OWNER TO postgres;

--
-- Name: tes_conciliaciones_valores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_conciliaciones_valores_id_seq OWNED BY public.tes_conciliaciones_valores.id;


--
-- Name: tes_debitos_creditos_bancarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_debitos_creditos_bancarios (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_debito date,
    monto_total_entrada numeric(19,2),
    monto_total_salida numeric(19,2),
    observacion character varying(255),
    bs_empresa_id bigint NOT NULL,
    bs_moneda_id bigint,
    cob_habilitacion_id bigint NOT NULL,
    tes_banco_id_entrante bigint NOT NULL,
    tes_banco_id_saliente bigint NOT NULL
);


ALTER TABLE public.tes_debitos_creditos_bancarios OWNER TO postgres;

--
-- Name: tes_debitos_creditos_bancarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_debitos_creditos_bancarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_debitos_creditos_bancarios_id_seq OWNER TO postgres;

--
-- Name: tes_debitos_creditos_bancarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_debitos_creditos_bancarios_id_seq OWNED BY public.tes_debitos_creditos_bancarios.id;


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
-- Name: bs_access_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_access_log ALTER COLUMN id SET DEFAULT nextval('public.bs_access_log_id_seq'::regclass);


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
-- Name: bs_reset_password_token id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_reset_password_token ALTER COLUMN id SET DEFAULT nextval('public.bs_reset_password_token_id_seq'::regclass);


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
-- Name: cob_arqueos_cajas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_arqueos_cajas ALTER COLUMN id SET DEFAULT nextval('public.cob_arqueos_cajas_id_seq'::regclass);


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
-- Name: com_facturas_cabecera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_cabecera ALTER COLUMN id SET DEFAULT nextval('public.com_facturas_cabecera_id_seq'::regclass);


--
-- Name: com_facturas_detalles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_detalles ALTER COLUMN id SET DEFAULT nextval('public.com_facturas_detalles_id_seq'::regclass);


--
-- Name: com_proveedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_proveedores ALTER COLUMN id SET DEFAULT nextval('public.com_proveedores_id_seq'::regclass);


--
-- Name: com_saldos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_saldos ALTER COLUMN id SET DEFAULT nextval('public.com_saldos_id_seq'::regclass);


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
-- Name: tes_conciliaciones_valores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_conciliaciones_valores ALTER COLUMN id SET DEFAULT nextval('public.tes_conciliaciones_valores_id_seq'::regclass);


--
-- Name: tes_debitos_creditos_bancarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_debitos_creditos_bancarios ALTER COLUMN id SET DEFAULT nextval('public.tes_debitos_creditos_bancarios_id_seq'::regclass);


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
-- Data for Name: bs_access_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (10, 'ACTIVO', '2025-08-28 10:55:44.618601', '2025-08-28 10:55:44.618601', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (11, 'ACTIVO', '2025-08-28 18:04:13.570513', '2025-08-28 18:04:13.570513', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (12, 'ACTIVO', '2025-08-29 15:25:51.314863', '2025-08-29 15:25:51.314863', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (13, 'ACTIVO', '2025-08-29 15:26:01.476673', '2025-08-29 15:26:01.476673', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (14, 'ACTIVO', '2025-08-30 07:25:18.116957', '2025-08-30 07:25:18.116957', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (15, 'ACTIVO', '2025-08-30 07:25:48.192499', '2025-08-30 07:25:48.192499', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (16, 'ACTIVO', '2025-08-30 07:33:17.306309', '2025-08-30 07:33:17.306309', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (17, 'ACTIVO', '2025-08-30 07:33:33.057221', '2025-08-30 07:33:33.057221', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (18, 'ACTIVO', '2025-08-30 07:38:13.971071', '2025-08-30 07:38:13.971071', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (19, 'ACTIVO', '2025-08-30 07:50:31.944994', '2025-08-30 07:50:31.944994', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (20, 'ACTIVO', '2025-08-30 07:50:40.689283', '2025-08-30 07:50:40.689283', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (21, 'ACTIVO', '2025-09-01 16:06:52.466073', '2025-09-01 16:06:52.466073', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (22, 'ACTIVO', '2025-09-01 16:09:24.084293', '2025-09-01 16:09:24.084293', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');


--
-- Data for Name: bs_empresas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_empresas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, direc_empresa, nombre_fantasia, bs_personas_id) VALUES (1, 'ACTIVO', '2023-11-24 16:58:47.235596', '2023-11-24 16:58:47.235596', NULL, 'Asuncion, Barrio Carmelitas', 'CAPITAL CREDITOS S.A.', 3);


--
-- Data for Name: bs_iva; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_iva (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_iva, descripcion, porcentaje) VALUES (1, 'ACTIVO', '2023-11-24 15:31:55.768829', '2023-11-24 15:31:55.768829', NULL, 'IVA10', 'IVA 10', 10.00);
INSERT INTO public.bs_iva (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_iva, descripcion, porcentaje) VALUES (2, 'ACTIVO', '2023-11-24 15:32:33.140511', '2023-11-24 15:32:33.140511', NULL, 'IVA5', 'IVA 5', 21.00);
INSERT INTO public.bs_iva (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_iva, descripcion, porcentaje) VALUES (4, 'ACTIVO', '2024-01-25 19:53:16.738656', '2024-01-25 19:53:16.737648', 'fvazquez', 'EX', 'EXENTA', 0.00);


--
-- Data for Name: bs_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (41, 'Caja', 'Cajas por Usuario', 4, 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCaja.xhtml', 8, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (42, 'habilitacion caja', 'Habilitacion de Caja', 5, 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobHabilitacionCaja.xhtml', 8, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (43, 'talonario', 'Talonarios', 14, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTalonario.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (44, 'timbrado', 'Timbrados', 15, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTimbrado.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (45, 'desembolso credito', 'Desembolso de Credito', 4, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/creditos/movimientos/CreDesembolsoCredito.xhtml', 9, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (46, 'Facturas', 'Facturacion', 3, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/ventas/movimientos/VenFacturas.xhtml', 11, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (47, 'proveedor', 'Proveedores', 1, 'ITEM', 'DEFINICION', '/pages/cliente/compras/definicion/ComProveedor.xhtml', 14, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (48, 'banco', 'Bancos', 1, 'ITEM', 'DEFINICION', '/pages/cliente/tesoreria/definicion/TesBanco.xhtml', 10, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (49, 'ajuste inventario', 'Ajustes de Inventarios', 2, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/stock/movimientos/StoAjusteInventario.xhtml', 13, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (50, 'recibos', 'Recibos', 6, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/cobranzas/movimientos/CobRecibos.xhtml', 8, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (51, 'deposito', 'Depositos', 2, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/tesoreria/movimientos/TesDeposito.xhtml', 10, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (1, 'Usuarios', 'Usuarios', 6, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsUsuario.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (6, 'Personas', 'Personas', 5, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsPersona.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (5, 'Roles', 'Roles', 2, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsRol.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (3, 'Modulos', 'Modulos', 1, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsModulo.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (22, 'Impuestos', 'Impuestos', 9, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsIva.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (21, 'Monedas', 'Monedas', 10, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsMoneda.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (24, 'Parametros Generales', 'Parametros Generales', 8, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsParametro.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (28, 'Cobrador', 'Cobrador', 2, 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCobrador.xhtml', 8, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (27, 'Clientes', 'Clientes', 1, 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCliente.xhtml', 8, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (23, 'Empresas', 'Empresas', 7, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsEmpresa.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (52, 'pago', 'Pagos/Desembolsos', 3, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/tesoreria/movimientos/TesPago.xhtml', 10, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (53, 'ventas por fecha', 'Ventas por Fecha y Cliente', 4, 'ITEM', 'REPORTES', '/pages/cliente/ventas/reportes/VenVentasPorFecha.xhtml', 11, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (54, 'recibos por fecha', 'Recibos por Fecha y Cliente', 7, 'ITEM', 'REPORTES', '/pages/cliente/cobranzas/reportes/CobRecibosPorFecha.xhtml', 8, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (55, 'desembolsos por fecha', 'Desembolsos por Fecha y Cliente', 5, 'ITEM', 'REPORTES', '/pages/cliente/creditos/reportes/CreDesembolsosPorFecha.xhtml', 9, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (35, 'Condicion venta', 'Condicion venta', 2, 'ITEM', 'DEFINICION', '/pages/cliente/ventas/definicion/VenCondicionVenta.xhtml', 11, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (34, 'Vendedores', 'Vendedores', 1, 'ITEM', 'DEFINICION', '/pages/cliente/ventas/definicion/VenVendedor.xhtml', 11, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (36, 'Articulos', 'Articulos', 1, 'ITEM', 'DEFINICION', '/pages/cliente/stock/definicion/StoArticulo.xhtml', 13, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (37, 'Reporte Permisos Rol por Fecha', 'Reporte Permisos Rol por Fecha', 13, 'ITEM', 'REPORTES', '/pages/cliente/base/reportes/BsPermisoRolPorFechaCreacion.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (38, 'Tipo Amortizacion', 'Tipo Amortizacion', 1, 'ITEM', 'DEFINICION', '/pages/cliente/creditos/definicion/CreTipoAmortizacion.xhtml', 9, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (39, 'Motivo Prestamo', 'Motivo Prestamo', 2, 'ITEM', 'DEFINICION', '/pages/cliente/creditos/definicion/CreMotivoPrestamo.xhtml', 9, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (40, 'Solicitud de Credito', 'Solicitud de Credito', 3, 'ITEM', 'MOVIMIENTOS', '/pages/cliente/creditos/movimientos/CreSolicitudCredito.xhtml', 9, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (17, 'Menus', 'Menus', 3, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsMenu.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (18, 'Permisos por Pantalla', 'Permisos por Pantalla', 4, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsPermisoRol.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (26, 'Tipos de Comprobantes', 'Tipos de Comprobantes', 12, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTipoComprobante.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (25, 'Tipos de Valores', 'Tipos de Valores', 11, 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTipoValor.xhtml', 1, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (56, 'Compras', 'Compras de Servicios', 2, 'ITEM', 'MOVIMIENTOS', '/faces/pages/cliente/compras/movimientos/ComCompras.xhtml', 14, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (57, 'Debitos Creditos Bancarios', 'Debitos y Creditos Bancarios', 4, 'ITEM', 'MOVIMIENTOS', '/faces/pages/cliente/tesoreria/movimientos/TesDebitosCreditosBancarios.xhtml', 10, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (58, 'Notas Creditos', 'Notas de Creditos', 5, 'ITEM', 'MOVIMIENTOS', '/faces/pages/cliente/ventas/movimientos/VenNotasCreditos.xhtml', 11, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (59, 'Conciliacion Bancaria', 'Conciliacion Bancaria', 5, 'ITEM', 'MOVIMIENTOS', '/faces/pages/cliente/tesoreria/movimientos/TesConciliacionBancaria.xhtml', 10, NULL);


--
-- Data for Name: bs_menu_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (1, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (8, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (9, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (2, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-ellipsis-v', 1, '2', 'MENU', 'Modulos', 3, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (3, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-ellipsis-v', 1, '3', 'MENU', 'Persona', 6, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (4, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-ellipsis-v', 1, '5', 'MENU', 'Roles', 5, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (5, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', NULL, 'pi pi-fw pi-ellipsis-v', 1, '7', 'MENU', 'Usuarios', 1, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (11, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (12, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (13, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (14, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 9);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (15, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 9);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (16, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 9);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (17, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (18, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (19, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (20, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (21, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (22, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (23, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 12);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (24, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 12);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (25, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 12);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (27, 'ACTIVO', '2023-09-12 13:38:42.593191', '2023-09-12 13:38:42.593191', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Permisos por Pantalla', 18, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (26, 'ACTIVO', '2023-09-12 13:31:52.496447', '2023-09-12 13:31:52.496447', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Menus', 17, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (28, 'ACTIVO', '2023-11-23 11:49:39.706615', '2023-11-23 11:49:39.706615', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Monedas', 21, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (29, 'ACTIVO', '2023-11-24 15:29:19.649737', '2023-11-24 15:29:19.649737', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Impuestos', 22, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (30, 'ACTIVO', '2023-11-24 16:54:32.841298', '2023-11-24 16:54:32.841298', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Empresas', 23, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (31, 'ACTIVO', '2023-11-27 10:33:13.73056', '2023-11-27 10:33:13.73056', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Parametros Generales', 24, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (32, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 13);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (33, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 13);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (34, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 13);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (35, 'ACTIVO', '2023-11-30 16:50:59.51816', '2023-11-30 16:50:59.51816', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Tipos de Valores', 25, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (36, 'ACTIVO', '2023-11-30 16:51:34.092384', '2023-11-30 16:51:34.092384', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Tipos de Comprobantes', 26, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (37, 'ACTIVO', '2023-12-01 11:15:49.877244', '2023-12-01 11:15:49.877244', NULL, 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Clientes', 27, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (38, 'ACTIVO', '2023-12-01 11:16:28.895258', '2023-12-01 11:16:28.895258', NULL, 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Cobrador', 28, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (65, 'ACTIVO', '2024-01-22 12:05:39.357153', '2024-01-22 12:05:39.357153', NULL, 'pi pi-fw pi-ellipsis-v', 18, NULL, 'MENU', 'Pagos/Desembolsos', 52, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (44, 'ACTIVO', '2023-12-12 17:55:18.715526', '2023-12-12 17:55:18.715526', NULL, 'pi pi-fw pi-ellipsis-v', 20, NULL, 'MENU', 'Vendedores', 34, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (45, 'ACTIVO', '2023-12-12 17:59:18.370812', '2023-12-12 17:59:18.370812', NULL, 'pi pi-fw pi-ellipsis-v', 20, NULL, 'MENU', 'Condicion venta', 35, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (46, 'ACTIVO', '2023-12-12 18:00:14.048414', '2023-12-12 18:00:14.048414', NULL, 'pi pi-fw pi-ellipsis-v', 32, NULL, 'MENU', 'Articulos', 36, 13);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (47, 'ACTIVO', '2023-12-15 14:28:00.440027', '2023-12-15 14:28:00.440027', NULL, 'pi pi-fw pi-ellipsis-v', 9, NULL, 'MENU', 'Reporte Permisos Rol por Fecha', 37, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (48, 'ACTIVO', '2023-12-27 10:45:07.453953', '2023-12-27 10:45:07.453953', NULL, 'pi pi-fw pi-ellipsis-v', 14, NULL, 'MENU', 'Tipo Amortizacion', 38, 9);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (49, 'ACTIVO', '2023-12-27 10:45:44.742158', '2023-12-27 10:45:44.742158', NULL, 'pi pi-fw pi-ellipsis-v', 14, NULL, 'MENU', 'Motivo Prestamo', 39, 9);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (50, 'ACTIVO', '2023-12-27 15:23:23.074387', '2023-12-27 15:23:23.074387', NULL, 'pi pi-fw pi-ellipsis-v', 15, NULL, 'MENU', 'Solicitud de Credito', 40, 9);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (51, 'ACTIVO', '2023-12-28 15:47:02.363933', '2023-12-28 15:47:02.363933', NULL, 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Cajas por Usuario', 41, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (52, 'ACTIVO', '2023-12-28 15:48:50.792045', '2023-12-28 15:48:50.792045', NULL, 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Habilitacion de Caja', 42, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (53, 'ACTIVO', '2024-01-02 17:15:09.117451', '2024-01-02 17:15:09.117451', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Talonarios', 43, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (54, 'ACTIVO', '2024-01-02 17:15:25.935552', '2024-01-02 17:15:25.935552', NULL, 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Timbrados', 44, 1);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (55, 'ACTIVO', '2024-01-04 14:20:34.987513', '2024-01-04 14:20:34.987513', NULL, 'pi pi-fw pi-ellipsis-v', 15, NULL, 'MENU', 'Desembolso de Credito', 45, 9);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (56, 'ACTIVO', '2024-01-10 15:28:27.608602', '2024-01-10 15:28:27.608602', NULL, 'pi pi-fw pi-ellipsis-v', 21, NULL, 'MENU', 'Facturacion', 46, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (57, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', NULL, 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 14);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (58, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', NULL, 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 14);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (59, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', NULL, 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 14);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (60, 'ACTIVO', '2024-01-12 19:32:22.264846', '2024-01-12 19:32:22.264846', NULL, 'pi pi-fw pi-ellipsis-v', 57, NULL, 'MENU', 'Proveedores', 47, 14);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (61, 'ACTIVO', '2024-01-12 19:32:47.387516', '2024-01-12 19:32:47.387516', NULL, 'pi pi-fw pi-ellipsis-v', 17, NULL, 'MENU', 'Bancos', 48, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (62, 'ACTIVO', '2024-01-12 23:34:38.56794', '2024-01-12 23:34:38.56794', NULL, 'pi pi-fw pi-ellipsis-v', 33, NULL, 'MENU', 'Ajustes de Inventarios', 49, 13);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (63, 'ACTIVO', '2024-01-15 16:44:38.482895', '2024-01-15 16:44:38.482895', NULL, 'pi pi-fw pi-ellipsis-v', 12, NULL, 'MENU', 'Recibos', 50, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (64, 'ACTIVO', '2024-01-18 15:24:21.817528', '2024-01-18 15:24:21.817528', NULL, 'pi pi-fw pi-ellipsis-v', 18, NULL, 'MENU', 'Depositos', 51, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (66, 'ACTIVO', '2024-02-12 12:11:15.227474', '2024-02-12 12:11:15.227474', NULL, 'pi pi-fw pi-ellipsis-v', 22, NULL, 'MENU', 'Ventas por Fecha y Cliente', 53, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (67, 'ACTIVO', '2024-02-13 08:38:38.543221', '2024-02-13 08:38:38.543221', NULL, 'pi pi-fw pi-ellipsis-v', 13, NULL, 'MENU', 'Recibos por Fecha y Cliente', 54, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (68, 'ACTIVO', '2024-02-13 10:31:29.805258', '2024-02-13 10:31:29.805258', NULL, 'pi pi-fw pi-ellipsis-v', 16, NULL, 'MENU', 'Desembolsos por Fecha y Cliente', 55, 9);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (69, 'ACTIVO', '2025-07-28 19:38:41.788002', '2025-07-28 19:38:41.788002', NULL, 'pi pi-fw pi-ellipsis-v', 58, NULL, 'MENU', 'Compras de Servicios', 56, 14);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (70, 'ACTIVO', '2025-07-30 15:47:49.982603', '2025-07-30 15:47:49.982603', NULL, 'pi pi-fw pi-ellipsis-v', 18, NULL, 'MENU', 'Debitos y Creditos Bancarios', 57, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (71, 'ACTIVO', '2025-07-31 15:59:26.143568', '2025-07-31 15:59:26.143568', NULL, 'pi pi-fw pi-ellipsis-v', 21, NULL, 'MENU', 'Notas de Creditos', 58, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (72, 'ACTIVO', '2025-08-01 13:40:09.847245', '2025-08-01 13:40:09.847245', NULL, 'pi pi-fw pi-ellipsis-v', 18, NULL, 'MENU', 'Conciliacion Bancaria', 59, 10);


--
-- Data for Name: bs_modulo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (14, 'ACTIVO', '2024-01-12 19:31:47.085795', '2024-01-12 19:31:47.085795', 'fvazquez', 'COM', 'pi pi-shopping-cart', 'COMPRAS', 8, 'compras');
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (8, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'fvazquez', 'COB', 'pi pi-fw pi-phone', 'COBRANZAS', 2, 'cobranzas');
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (1, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'fvazquez', 'BS', 'pi pi-fw pi-cog', 'MODULO BASE', 1, 'base');
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (10, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'fvazquez', 'TES', 'pi pi-fw pi-chart-bar', 'TESORERIA', 5, 'tesoreria');
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (9, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'fvazquez', 'CRE', 'pi pi-fw pi-wallet', 'CREDITOS', 4, 'creditos');
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (12, 'INACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'fvazquez', 'CON', 'pi pi-fw pi-euro', 'CONTABILIDAD', 6, 'contabilidad');
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (11, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'fvazquez', 'VEN', 'pi pi-fw pi-chart-line', 'VENTAS', 3, 'ventas');
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (13, 'ACTIVO', '2023-11-29 09:12:32.676719', '2023-11-29 09:12:32.676719', 'fvazquez', 'STO', 'pi pi-shopping-bag', 'STOCK', 7, 'stock');


--
-- Data for Name: bs_moneda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_moneda (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_moneda, decimales, descripcion) VALUES (1, 'ACTIVO', '2023-11-23 15:30:46.655571', '2023-11-23 15:30:46.655571', NULL, 'GS', 0, 'GUARANIES');
INSERT INTO public.bs_moneda (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_moneda, decimales, descripcion) VALUES (2, 'ACTIVO', '2023-11-23 15:31:02.869325', '2023-11-23 15:31:02.869325', NULL, 'USD', 2, 'DOLARES');


--
-- Data for Name: bs_parametros; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, parametro, valor, bs_empresa_id, bs_modulo_id) VALUES (2, 'ACTIVO', '2023-11-27 10:44:52.649203', '2023-11-27 10:44:52.649203', NULL, 'Parametro de prueba', 'BSPARAMETRO', 'valor_prueba', 1, 8);
INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, parametro, valor, bs_empresa_id, bs_modulo_id) VALUES (3, 'ACTIVO', '2024-01-04 16:44:15.211679', '2024-01-04 16:44:15.211679', 'fvazquez', 'Parametro para la taza anual', 'TAZANUAL', '35', 1, 9);
INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, parametro, valor, bs_empresa_id, bs_modulo_id) VALUES (4, 'ACTIVO', '2024-01-04 16:44:49.039995', '2024-01-04 16:44:49.039995', 'fvazquez', 'Parametro para taza mora', 'TAZAMORA', '3', 1, 9);
INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, parametro, valor, bs_empresa_id, bs_modulo_id) VALUES (5, 'ACTIVO', '2024-01-05 11:38:13.821259', '2024-01-05 11:38:13.819816', 'fvazquez', 'Articulo utilizado para cuotas de creditos', 'CUO', 'CUO', 1, 9);
INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, parametro, valor, bs_empresa_id, bs_modulo_id) VALUES (6, 'ACTIVO', '2024-01-11 16:59:13.972738', '2024-01-11 16:59:13.972738', 'fvazquez', 'CONDICION VENTA PARA DESEMBOLSO', 'CREDES', 'CREDES', 1, 11);


--
-- Data for Name: bs_permiso_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (8, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 17, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (9, NULL, '2023-11-23 11:51:21.950434', '2023-11-23 11:51:21.950434', NULL, 'PERMISOS', 21, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (10, NULL, '2023-11-24 15:29:43.718738', '2023-11-24 15:29:43.718738', NULL, 'PERMISOS', 22, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (11, NULL, '2023-11-24 16:54:52.131547', '2023-11-24 16:54:52.131547', NULL, 'PERMISOS', 23, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (12, NULL, '2023-11-27 10:33:34.230844', '2023-11-27 10:33:34.230844', NULL, 'PERMISOS', 24, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (13, NULL, '2023-11-30 16:52:29.634115', '2023-11-30 16:52:29.634115', NULL, 'PERMISOS', 25, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (14, NULL, '2023-11-30 16:52:51.769645', '2023-11-30 16:52:51.769645', NULL, 'PERMISOS', 26, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (15, NULL, '2023-12-01 11:17:03.421675', '2023-12-01 11:17:03.421675', NULL, 'PERMISOS', 27, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (16, NULL, '2023-12-01 11:17:14.116104', '2023-12-01 11:17:14.116104', NULL, 'PERMISOS', 28, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (19, NULL, '2023-12-12 18:01:33.25567', '2023-12-12 18:01:33.25567', NULL, 'PERMISOS', 34, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (20, NULL, '2023-12-12 18:01:46.00111', '2023-12-12 18:01:46.00111', NULL, 'PERMISOS', 35, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (21, NULL, '2023-12-12 18:01:59.948197', '2023-12-12 18:01:59.948197', NULL, 'PERMISOS', 36, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (4, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 3, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (3, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 1, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (6, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 6, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (5, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 5, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (7, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 18, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (22, NULL, '2023-12-15 14:28:38.729036', '2023-12-15 14:28:38.729036', 'fvazquez', 'PERMISOS', 37, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (23, NULL, '2023-12-27 10:46:00.953943', '2023-12-27 10:46:00.953943', 'fvazquez', 'PERMISOS', 38, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (24, NULL, '2023-12-27 10:46:33.184631', '2023-12-27 10:46:33.184631', 'fvazquez', 'PERMISOS', 39, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (25, NULL, '2023-12-27 15:23:39.717078', '2023-12-27 15:23:39.717078', 'fvazquez', 'PERMISOS', 40, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (26, NULL, '2023-12-28 15:51:14.130045', '2023-12-28 15:51:14.130045', 'fvazquez', 'PERMISOS', 41, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (27, NULL, '2023-12-28 15:51:23.954357', '2023-12-28 15:51:23.954357', 'fvazquez', 'PERMISOS', 42, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (28, NULL, '2024-01-02 17:15:37.563449', '2024-01-02 17:15:37.563449', 'fvazquez', 'PERMISOS', 43, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (29, NULL, '2024-01-02 17:15:44.727419', '2024-01-02 17:15:44.727419', 'fvazquez', 'PERMISOS', 44, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (30, NULL, '2024-01-04 14:20:54.989778', '2024-01-04 14:20:54.989778', 'fvazquez', 'PERMISOS', 45, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (31, NULL, '2024-01-10 15:28:41.518061', '2024-01-10 15:28:41.518061', 'fvazquez', 'PERMISOS', 46, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (32, NULL, '2024-01-12 19:33:02.007685', '2024-01-12 19:33:02.007685', 'fvazquez', 'PERMISOS', 47, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (33, NULL, '2024-01-12 19:33:16.864186', '2024-01-12 19:33:16.864186', 'fvazquez', 'PERMISOS', 48, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (34, NULL, '2024-01-12 23:34:55.585819', '2024-01-12 23:34:55.585819', 'fvazquez', 'PERMISOS', 49, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (35, NULL, '2024-01-15 16:44:48.73731', '2024-01-15 16:44:48.73731', 'fvazquez', 'PERMISOS', 50, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (36, NULL, '2024-01-18 15:24:34.353535', '2024-01-18 15:24:34.353535', 'fvazquez', 'PERMISOS', 51, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (37, NULL, '2024-01-22 12:05:51.580568', '2024-01-22 12:05:51.580568', 'fvazquez', 'PERMISOS', 52, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (38, NULL, '2024-02-12 12:11:27.075193', '2024-02-12 12:11:27.075193', 'fvazquez', 'PERMISOS', 53, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (39, NULL, '2024-02-13 08:38:51.666126', '2024-02-13 08:38:51.666126', 'fvazquez', 'PERMISOS', 54, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (40, NULL, '2024-02-13 10:33:26.581093', '2024-02-13 10:33:26.581093', 'fvazquez', 'PERMISOS', 55, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (41, NULL, '2025-07-28 19:40:20.440131', '2025-07-28 19:40:20.440131', 'fvazquez', 'PERMISOS', 56, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (42, NULL, '2025-07-30 15:48:10.932604', '2025-07-30 15:48:10.932604', 'fvazquez', 'PERMISOS', 57, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (43, NULL, '2025-07-31 15:59:37.819788', '2025-07-31 15:59:37.819788', 'fvazquez', 'PERMISOS', 58, 1);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol) VALUES (44, NULL, '2025-08-01 13:40:22.292648', '2025-08-01 13:40:22.292648', 'fvazquez', 'PERMISOS', 59, 1);


--
-- Data for Name: bs_persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona) VALUES (7, 'ACTIVO', '2023-11-27 17:29:16.776996', '2023-11-27 17:29:16.776996', NULL, '44444', 'ffff@gm.com', '1990-11-14', NULL, 'Roberto', 'Roberto Gimenez Benitez', 'Gimenez', 'Benitez', 'CI', 'FISICA');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona) VALUES (8, 'ACTIVO', '2023-11-28 16:56:20.157804', '2023-11-28 16:56:20.157804', NULL, '55555', 'AAA@GMAIL.COM', '2000-10-21', NULL, 'ALBERTO', 'ALBERTO FERNANDEZ LOPEZ', 'FERNANDEZ', 'LOPEZ', 'CI', 'FISICA');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona) VALUES (3, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '4864105', 'fernandorafa@live.com', '1991-10-21', NULL, 'fernando', 'fernnado vazquez', 'vazquez', 'lopez', 'CI', 'FISICA');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona) VALUES (10, 'ACTIVO', '2024-01-12 20:00:17.136873', '2024-01-12 20:00:17.136873', 'fvazquez', '800099927-8', 'itau@itau.com.py', '2024-01-23', NULL, 'BANCO ITAU S.A.', 'BANCO ITAU S.A.  ', 'BANCO ITAU S.A.  ', 'BANCO ITAU S.A.  ', 'CI', 'FISICA');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona) VALUES (11, 'ACTIVO', '2024-02-13 16:52:03.090551', '2024-02-13 16:52:03.090474', 'fvazquez', '800029172-9', 'FFF@FFF.COM', '2024-02-01', NULL, ' BANCO CONTINENTAL BANCO CONTINENTAL', ' BANCO CONTINENTAL BANCO CONTINENTAL', 'BANCO CONTINENTAL', 'BANCO CONTINENTAL', 'CI', 'FISICA');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona) VALUES (6, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '888888', 'dddd@dd.com', '1991-10-21', NULL, 'paula', 'paula vazquez', 'vazquez', 'lopez', 'CI', 'FISICA');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona) VALUES (5, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '777777', 'ooo@ooo.com', '1991-10-21', NULL, 'luis', 'luis vazquez', 'vazquez', 'lopez', 'CI', 'FISICA');


--
-- Data for Name: bs_reset_password_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (14, 'ACTIVO', '2025-08-29 16:39:04.380566', '2025-08-29 16:39:04.380566', 'fvazquez', 'fvazquez', '2025-08-29 16:54:04.347864', '916615', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (15, 'ACTIVO', '2025-08-29 16:44:23.898534', '2025-08-29 16:44:23.898534', 'fvazquez', 'fvazquez', '2025-08-29 16:59:23.870998', '711774', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (16, 'ACTIVO', '2025-08-29 16:47:05.369155', '2025-08-29 16:47:05.369155', 'fvazquez', 'fvazquez', '2025-08-29 17:02:05.322904', '742357', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (17, 'ACTIVO', '2025-08-29 16:48:14.922558', '2025-08-29 16:48:14.922558', 'fvazquez', 'fvazquez', '2025-08-29 17:03:14.878115', '456649', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (18, 'ACTIVO', '2025-08-29 17:08:33.642514', '2025-08-29 17:08:33.642514', 'fvazquez', 'fvazquez', '2025-08-29 17:23:33.584787', '488327', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (19, 'ACTIVO', '2025-08-29 17:16:50.939275', '2025-08-29 17:16:50.939275', 'fvazquez', 'fvazquez', '2025-08-29 17:31:50.907425', '734824', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (20, 'ACTIVO', '2025-08-29 17:21:28.167004', '2025-08-29 17:21:28.167004', 'fvazquez', 'fvazquez', '2025-08-29 17:36:28.123012', '713055', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (21, 'ACTIVO', '2025-08-29 17:56:14.171639', '2025-08-29 17:56:14.171639', 'fvazquez', 'fvazquez', '2025-08-29 18:11:14.132288', '715707', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (22, 'ACTIVO', '2025-08-29 17:58:27.072265', '2025-08-29 17:58:27.072265', 'fvazquez', 'fvazquez', '2025-08-29 18:13:27.037359', '489258', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (23, 'ACTIVO', '2025-08-29 17:59:55.375026', '2025-08-29 17:59:55.375026', 'fvazquez', 'fvazquez', '2025-08-29 18:14:55.320208', '677657', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (24, 'ACTIVO', '2025-08-30 07:14:14.619447', '2025-08-30 07:14:14.618473', 'fvazquez', 'fvazquez', '2025-08-30 07:29:14.579452', '805425', 'S');
INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (25, 'ACTIVO', '2025-08-30 07:37:06.986893', '2025-08-30 07:37:06.986893', 'fvazquez', 'fvazquez', '2025-08-30 07:52:06.94929', '331399', 'S');


--
-- Data for Name: bs_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (1, 'ACTIVO', '2023-09-05 16:16:21.69327', '2023-09-05 16:16:21.69327', NULL, 'USER');
INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (3, 'ACTIVO', '2023-09-05 16:16:21.69327', '2023-09-05 16:16:21.69327', NULL, 'ADMIN');


--
-- Data for Name: bs_talonarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (2, 'ACTIVO', '2024-01-02 17:28:26.527748', '2024-01-02 17:28:26.527748', 'fvazquez', 2, 1);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (3, 'ACTIVO', '2024-01-05 16:51:03.274948', '2024-01-05 16:51:03.274948', 'fvazquez', 3, 3);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (5, 'ACTIVO', '2024-01-10 20:04:52.046571', '2024-01-10 20:04:52.046571', 'fvazquez', 3, 2);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (6, 'ACTIVO', '2024-01-16 09:23:26.311944', '2024-01-16 09:23:26.311944', 'fvazquez', 3, 4);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (7, 'ACTIVO', '2024-01-22 16:28:54.537469', '2024-01-22 16:28:54.537469', 'fvazquez', 3, 5);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (8, 'ACTIVO', '2025-07-31 17:07:38.193451', '2025-07-31 17:07:38.193451', 'fvazquez', 4, 7);


--
-- Data for Name: bs_timbrados; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_timbrados (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_establecimiento, cod_expedicion, fecha_vigencia_desde, fecha_vigencia_hasta, ind_autoimpresor, nro_desde, nro_hasta, nro_timbrado, bs_empresa_id) VALUES (2, 'ACTIVO', '2024-01-02 17:23:52.428487', '2024-01-02 17:23:40.71023', 'fvazquez', '001', '002', '2024-01-02', '2024-01-31', 'N', 1.00, 999.00, 1234567.00, 1);
INSERT INTO public.bs_timbrados (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_establecimiento, cod_expedicion, fecha_vigencia_desde, fecha_vigencia_hasta, ind_autoimpresor, nro_desde, nro_hasta, nro_timbrado, bs_empresa_id) VALUES (3, 'ACTIVO', '2024-01-05 16:48:54.262894', '2024-01-05 16:48:54.262894', 'fvazquez', '001', '001', '2024-01-01', '2024-12-31', 'N', 1.00, 999999.00, 12345678.00, 1);
INSERT INTO public.bs_timbrados (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_establecimiento, cod_expedicion, fecha_vigencia_desde, fecha_vigencia_hasta, ind_autoimpresor, nro_desde, nro_hasta, nro_timbrado, bs_empresa_id) VALUES (4, 'ACTIVO', '2025-07-31 17:07:08.335736', '2025-07-31 17:07:08.335736', 'fvazquez', '001', '001', '2025-07-31', '2026-10-30', 'N', 1.00, 999999.00, 18882717.00, 1);


--
-- Data for Name: bs_tipo_comprobantes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id) VALUES (3, 'ACTIVO', '2024-01-05 16:48:14.975214', '2024-01-05 16:48:14.975214', 'fvazquez', 'DES', 'DESEMBOLSO', 'S', NULL, 1, 9);
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id) VALUES (1, 'ACTIVO', '2024-01-10 20:04:19.190016', '2023-11-30 17:18:44.250534', 'fvazquez', 'CRE', 'CREDITO', 'S', NULL, 1, 11);
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id) VALUES (4, 'ACTIVO', '2024-01-16 09:23:16.25807', '2024-01-16 09:23:16.25807', 'fvazquez', 'REC', 'RECIBOS', 'N', NULL, 1, 8);
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id) VALUES (2, 'ACTIVO', '2024-01-10 20:04:04.092481', '2023-11-30 17:19:17.294537', 'fvazquez', 'CON', 'CONTADO', 'N', NULL, 1, 11);
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id) VALUES (5, 'ACTIVO', '2024-01-22 16:28:43.614046', '2024-01-22 16:28:43.614046', 'fvazquez', 'PAG', 'PAGOS', 'S', NULL, 1, 10);
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id) VALUES (6, 'ACTIVO', '2025-07-29 12:27:36.842086', '2025-07-29 12:27:36.842086', 'fvazquez', 'COM', 'COMPRAS', 'S', NULL, 1, 14);
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id) VALUES (7, 'ACTIVO', '2025-07-31 17:06:23.811455', '2025-07-31 17:06:23.811455', 'fvazquez', 'NCR', 'NOTAS DE CREDITOS', 'S', NULL, 1, 11);


--
-- Data for Name: bs_tipo_valor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_tipo_valor (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion, usa_efectivo, bs_empresa_id, id_bs_modulo) VALUES (1, 'ACTIVO', '2023-11-30 17:05:15.727047', '2023-11-30 17:05:15.727047', NULL, 'EFE', 'EFECTIVO', 'S', 1, 8);
INSERT INTO public.bs_tipo_valor (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion, usa_efectivo, bs_empresa_id, id_bs_modulo) VALUES (2, 'ACTIVO', '2023-11-30 17:09:37.933158', '2023-11-30 17:09:37.933158', NULL, 'CHE', 'CHEQUE', 'N', 1, 8);


--
-- Data for Name: bs_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (6, 'ACTIVO', '2025-08-26 19:17:01.361836', '2025-08-26 19:17:01.361836', 'fvazquez', 'lvazquez', '$2a$10$084VeP3ZX8nOYEbeiYT5FeK65JQQpr6iNTxTDizLWHK2sjT0fj65q', 1, 5, 1, NULL, 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (4, 'ACTIVO', '2023-11-27 17:29:54.032836', '2023-11-27 17:29:54.032836', 'fvazquez', 'rgimenez', '$2a$10$084VeP3ZX8nOYEbeiYT5FeK65JQQpr6iNTxTDizLWHK2sjT0fj65q', 1, 7, 1, NULL, 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (5, 'ACTIVO', '2023-11-28 17:09:33.989613', '2023-11-28 17:09:33.989613', 'fvazquez', 'afernandez', '$2a$10$084VeP3ZX8nOYEbeiYT5FeK65JQQpr6iNTxTDizLWHK2sjT0fj65q', 1, 8, 1, NULL, 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (3, 'ACTIVO', '2023-09-07 13:28:08.054202', '2023-09-07 13:28:08.054202', 'fvazquez', 'PRAFAELLA', '$2a$10$084VeP3ZX8nOYEbeiYT5FeK65JQQpr6iNTxTDizLWHK2sjT0fj65q', 1, 6, 3, NULL, 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (1, 'ACTIVO', '2025-08-30 07:50:40.821841', '2023-09-07 13:28:08.054202', 'fvazquez', 'fvazquez', '$2a$10$FPfP6xZg5BbIWX1AgBMP/eepzsiOVZzR0sv4WERstjritgKiltJx6', 1, 3, 1, NULL, 0);


--
-- Data for Name: cob_arqueos_cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_arqueos_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, monto_cheques, monto_efectivo, monto_tarjetas, bs_empresa_id, cob_habilitacion_id) VALUES (3, 'ACTIVO', '2025-07-28 18:54:03.199088', '2025-07-28 18:54:03.199088', NULL, 34000.00, 120000.00, 60000.00, 1, 9);


--
-- Data for Name: cob_cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_caja, bs_empresa_id, bs_usuario_id) VALUES (17, 'ACTIVO', '2023-12-29 15:51:26.367354', '2023-12-29 15:51:26.367354', 'fvazquez', 'FVAZQUEZ', 1, 1);


--
-- Data for Name: cob_clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_clientes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cliente, bs_empresa_id, id_bs_persona) VALUES (1, 'ACTIVO', '2023-12-01 11:23:36.837974', '2023-12-01 11:23:36.837974', NULL, '1', 1, 3);
INSERT INTO public.cob_clientes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cliente, bs_empresa_id, id_bs_persona) VALUES (4, 'ACTIVO', '2023-12-01 11:57:11.658446', '2023-12-01 11:57:11.658446', NULL, '2', 1, 5);
INSERT INTO public.cob_clientes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cliente, bs_empresa_id, id_bs_persona) VALUES (5, 'ACTIVO', '2023-12-29 15:51:05.052154', '2023-12-29 15:51:05.052154', 'fvazquez', '3', 1, 8);


--
-- Data for Name: cob_cobradores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cobradores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cobrador, bs_empresa_id, id_bs_persona) VALUES (2, 'ACTIVO', '2023-12-01 11:30:01.723144', '2023-12-01 11:30:01.723144', NULL, '1', 1, 3);
INSERT INTO public.cob_cobradores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cobrador, bs_empresa_id, id_bs_persona) VALUES (3, 'ACTIVO', '2023-12-01 12:22:18.62225', '2023-12-01 12:22:18.62225', NULL, '2', 1, 6);


--
-- Data for Name: cob_cobros_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cobros_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, fecha_valor, fecha_vencimiento, id_comprobante, ind_depositado, monto_cuota, nro_comprobante_completo, nro_orden, nro_valor, tipo_comprobante, bs_empresa_id, bs_tipo_valor_id, tes_deposito_id, ind_consiliado) VALUES (10, 'ACTIVO', '2024-01-19 17:33:57.560512', '2024-01-18 11:14:53.80722', 'fvazquez', '2024-01-19', '2024-01-18', '2024-01-18', 7, 'S', 12500.00, '001-001-000000003', 1, '0', 'RECIBO', 1, 1, 30, 'N');
INSERT INTO public.cob_cobros_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, fecha_valor, fecha_vencimiento, id_comprobante, ind_depositado, monto_cuota, nro_comprobante_completo, nro_orden, nro_valor, tipo_comprobante, bs_empresa_id, bs_tipo_valor_id, tes_deposito_id, ind_consiliado) VALUES (15, 'ACTIVO', '2024-01-25 19:45:03.19408', '2024-01-25 19:44:24.332655', 'fvazquez', '2024-01-25', '2024-01-25', '2024-01-25', 16, 'S', 150000.00, '001-001-000000001', 1, '0', 'FACTURA', 1, 1, 31, 'N');


--
-- Data for Name: cob_habilitaciones_cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_habilitaciones_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_apertura, fecha_cierre, hora_apertura, hora_cierre, ind_cerrado, nro_habilitacion, bs_usuario_id, bs_cajas_id) VALUES (8, 'ACTIVO', '2023-12-29 15:51:53.335839', '2023-12-29 15:51:37.190834', 'fvazquez', '2023-12-29 15:51:32.93391', '2023-12-29 15:51:53.314767', '15:51:32', '15:51:53', 'S', 1.00, 1, 17);
INSERT INTO public.cob_habilitaciones_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_apertura, fecha_cierre, hora_apertura, hora_cierre, ind_cerrado, nro_habilitacion, bs_usuario_id, bs_cajas_id) VALUES (9, 'ACTIVO', '2025-07-28 18:54:02.701053', '2024-01-15 16:48:58.618427', 'fvazquez', '2024-01-15 16:48:56.191648', '2025-07-28 18:54:02.643338', '16:48:56', '18:54:02', 'S', 2.00, 1, 17);
INSERT INTO public.cob_habilitaciones_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_apertura, fecha_cierre, hora_apertura, hora_cierre, ind_cerrado, nro_habilitacion, bs_usuario_id, bs_cajas_id) VALUES (10, 'ACTIVO', '2025-07-29 12:12:49.134149', '2025-07-29 12:12:49.134149', 'fvazquez', '2025-07-29 12:12:47.286193', NULL, '12:12:47', NULL, 'N', 3.00, 1, 17);


--
-- Data for Name: cob_recibos_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, ind_cobrado, ind_impreso, monto_total_recibo, nro_recibo, nro_recibo_completo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id) VALUES (6, 'ACTIVO', '2024-01-16 14:40:47.031068', '2024-01-16 14:40:47.031068', 'fvazquez', '2024-01-16', 'N', 'N', 989633.58, 2, '001-001-000000002', 'dede', 1, 6, 1, 3, 9);
INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, ind_cobrado, ind_impreso, monto_total_recibo, nro_recibo, nro_recibo_completo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id) VALUES (5, 'ACTIVO', '2024-01-16 14:39:55.275965', '2024-01-16 14:39:55.275965', 'fvazquez', '2024-01-16', 'N', 'N', 329877.86, 1, '001-001-000000001', 'dede', 1, 6, 1, 3, 9);
INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, ind_cobrado, ind_impreso, monto_total_recibo, nro_recibo, nro_recibo_completo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id) VALUES (7, 'ACTIVO', '2024-01-18 11:14:53.620988', '2024-01-18 11:14:53.620988', 'fvazquez', '2024-01-18', 'N', 'S', 12500.00, 3, '001-001-000000003', 'PRUEBA DE COBRO', 1, 6, 1, 3, 9);


--
-- Data for Name: cob_recibos_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (8, 1, 0, 26, 329877.86, 1, 5, 26);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (9, 1, 0, 27, 329877.86, 1, 6, 27);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (10, 1, 0, 28, 329877.86, 2, 6, 28);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (11, 1, 1, 39, 12500.00, 1, 7, 39);


--
-- Data for Name: cob_saldos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (29, 'ACTIVO', '2024-01-15 17:17:53.002011', '2024-01-15 17:17:53.002011', 'fvazquez', '2024-05-31', 6, 65, 329877.86, '3.00', 5, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (30, 'ACTIVO', '2024-01-15 17:17:53.005025', '2024-01-15 17:17:53.005025', 'fvazquez', '2024-06-30', 6, 66, 329877.86, '3.00', 6, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (31, 'ACTIVO', '2024-01-15 17:17:53.008043', '2024-01-15 17:17:53.008043', 'fvazquez', '2024-07-31', 6, 67, 329877.86, '3.00', 7, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (32, 'ACTIVO', '2024-01-15 17:17:53.009061', '2024-01-15 17:17:53.009061', 'fvazquez', '2024-08-31', 6, 68, 329877.86, '3.00', 8, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (33, 'ACTIVO', '2024-01-15 17:17:53.01004', '2024-01-15 17:17:53.01004', 'fvazquez', '2024-09-30', 6, 69, 329877.86, '3.00', 9, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (34, 'ACTIVO', '2024-01-15 17:17:53.011565', '2024-01-15 17:17:53.011565', 'fvazquez', '2024-10-31', 6, 70, 329877.86, '3.00', 10, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (35, 'ACTIVO', '2024-01-15 17:17:53.01261', '2024-01-15 17:17:53.01261', 'fvazquez', '2024-11-30', 6, 71, 329877.86, '3.00', 11, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (36, 'ACTIVO', '2024-01-15 17:17:53.014639', '2024-01-15 17:17:53.014639', 'fvazquez', '2024-12-31', 6, 72, 329877.86, '3.00', 12, 329877.86, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (39, 'ACTIVO', '2024-01-17 17:12:03.803368', '2024-01-17 17:12:03.803368', NULL, '2024-01-17', 15, 15, 12500.00, '001-002-000000003', 1, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (25, 'ACTIVO', '2024-01-15 17:17:52.994991', '2024-01-15 17:17:52.994991', 'fvazquez', '2024-01-05', 6, 61, 329877.86, '3.00', 1, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (26, 'ACTIVO', '2024-01-15 17:17:52.998009', '2024-01-15 17:17:52.998009', 'fvazquez', '2024-02-29', 6, 62, 329877.86, '3.00', 2, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (27, 'ACTIVO', '2024-01-15 17:17:52.999011', '2024-01-15 17:17:52.999011', 'fvazquez', '2024-03-31', 6, 63, 329877.86, '3.00', 3, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (28, 'ACTIVO', '2024-01-15 17:17:53.000009', '2024-01-15 17:17:53.000009', 'fvazquez', '2024-04-30', 6, 64, 329877.86, '3.00', 4, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (43, 'ACTIVO', '2024-01-17 17:12:03.813574', '2024-01-17 17:12:03.813574', NULL, '2024-05-17', 15, 15, 12500.00, '001-002-000000003', 5, 12500.00, 'FACTURA', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (63, 'ACTIVO', '2025-08-01 09:54:38.47995', '2025-08-01 09:54:38.47995', 'fvazquez', '2025-08-01', 18, 18, -23550.00, '001-001-000000001', 1, 0.00, 'NCR', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (51, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.676256', 'fvazquez', '2025-07-31', 17, 17, 1962.50, '001-002-000000001', 1, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (52, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.746779', 'fvazquez', '2025-08-31', 17, 17, 1962.50, '001-002-000000001', 2, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (53, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.750037', 'fvazquez', '2025-09-30', 17, 17, 1962.50, '001-002-000000001', 3, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (54, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.752939', 'fvazquez', '2025-10-31', 17, 17, 1962.50, '001-002-000000001', 4, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (55, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.7558', 'fvazquez', '2025-11-30', 17, 17, 1962.50, '001-002-000000001', 5, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (56, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.758682', 'fvazquez', '2025-12-31', 17, 17, 1962.50, '001-002-000000001', 6, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (57, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.76444', 'fvazquez', '2026-01-31', 17, 17, 1962.50, '001-002-000000001', 7, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (58, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.767117', 'fvazquez', '2026-02-28', 17, 17, 1962.50, '001-002-000000001', 8, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (59, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.769834', 'fvazquez', '2026-03-31', 17, 17, 1962.50, '001-002-000000001', 9, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (60, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.771964', 'fvazquez', '2026-04-30', 17, 17, 1962.50, '001-002-000000001', 10, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (61, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.774116', 'fvazquez', '2026-05-31', 17, 17, 1962.50, '001-002-000000001', 11, 0.00, 'FACTURA', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (62, 'ACTIVO', '2025-08-01 09:54:46.105484', '2025-07-31 19:46:09.776223', 'fvazquez', '2026-06-30', 17, 17, 1962.50, '001-002-000000001', 12, 0.00, 'FACTURA', 1, 1);


--
-- Data for Name: com_facturas_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: com_facturas_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: com_proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.com_proveedores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_proveedor, bs_empresa_id, bs_persona_id) VALUES (1, 'ACTIVO', '2024-01-12 19:49:38.255322', '2024-01-12 19:49:38.255322', 'fvazquez', '1', 1, 7);


--
-- Data for Name: com_saldos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: cre_desembolso_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id) VALUES (5, 'ACTIVO', '2024-01-09 10:38:28.692587', '2024-01-09 10:37:52.65986', 'fvazquez', '2024-01-10', 'S', 'N', 2000000.00, 2652199.06, 411090.05, 241109.01, 2.00, 36.00, 3.00, 1, 3, 3, 3);
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id) VALUES (4, 'ACTIVO', '2024-01-08 17:01:53.678368', '2024-01-05 17:43:13.47727', 'fvazquez', '2024-01-05', 'S', 'N', 2000000.04, 2700000.12, 636363.60, 63636.48, 1.00, 35.00, 3.00, 1, 3, 2, 3);
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id) VALUES (6, 'ACTIVO', '2024-01-15 17:15:11.455102', '2024-01-11 19:44:11.11461', 'fvazquez', '2024-01-11', 'S', 'S', 3000000.00, 3958534.30, 598667.54, 359866.75, 3.00, 35.00, 3.00, 1, 3, 4, 3);


--
-- Data for Name: cre_desembolso_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (37, 'ACTIVO', '2024-01-05 17:43:13.479691', '2024-01-05 17:43:13.479691', 'fvazquez', 1, '2023-12-31', 166666.67, 225000.00, 53030.30, 5303.04, 1, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (38, 'ACTIVO', '2024-01-05 17:43:13.480688', '2024-01-05 17:43:13.480688', 'fvazquez', 1, '2024-01-31', 166666.67, 225000.00, 53030.30, 5303.04, 2, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (39, 'ACTIVO', '2024-01-05 17:43:13.481695', '2024-01-05 17:43:13.481695', 'fvazquez', 1, '2024-02-29', 166666.67, 225000.00, 53030.30, 5303.04, 3, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (40, 'ACTIVO', '2024-01-05 17:43:13.484016', '2024-01-05 17:43:13.484016', 'fvazquez', 1, '2024-03-29', 166666.67, 225000.00, 53030.30, 5303.04, 4, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (41, 'ACTIVO', '2024-01-05 17:43:13.484834', '2024-01-05 17:43:13.484834', 'fvazquez', 1, '2024-04-29', 166666.67, 225000.00, 53030.30, 5303.04, 5, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (42, 'ACTIVO', '2024-01-05 17:43:13.486832', '2024-01-05 17:43:13.486832', 'fvazquez', 1, '2024-05-29', 166666.67, 225000.00, 53030.30, 5303.04, 6, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (43, 'ACTIVO', '2024-01-05 17:43:13.488834', '2024-01-05 17:43:13.488834', 'fvazquez', 1, '2024-06-29', 166666.67, 225000.00, 53030.30, 5303.04, 7, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (44, 'ACTIVO', '2024-01-05 17:43:13.490403', '2024-01-05 17:43:13.490403', 'fvazquez', 1, '2024-07-29', 166666.67, 225000.00, 53030.30, 5303.04, 8, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (45, 'ACTIVO', '2024-01-05 17:43:13.492538', '2024-01-05 17:43:13.492538', 'fvazquez', 1, '2024-08-29', 166666.67, 225000.00, 53030.30, 5303.04, 9, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (46, 'ACTIVO', '2024-01-05 17:43:13.494078', '2024-01-05 17:43:13.494078', 'fvazquez', 1, '2024-09-29', 166666.67, 225000.00, 53030.30, 5303.04, 10, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (47, 'ACTIVO', '2024-01-05 17:43:13.496431', '2024-01-05 17:43:13.496431', 'fvazquez', 1, '2024-10-29', 166666.67, 225000.00, 53030.30, 5303.04, 11, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (48, 'ACTIVO', '2024-01-05 17:43:13.497932', '2024-01-05 17:43:13.497423', 'fvazquez', 1, '2024-11-29', 166666.67, 225000.00, 53030.30, 5303.04, 12, 4, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (49, 'ACTIVO', '2024-01-09 10:37:52.714117', '2024-01-09 10:37:52.714117', 'fvazquez', 1, '2023-12-31', 140924.17, 221016.59, 60000.00, 20092.42, 1, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (50, 'ACTIVO', '2024-01-09 10:37:52.721635', '2024-01-09 10:37:52.721635', 'fvazquez', 1, '2024-01-31', 145151.90, 221016.59, 55772.27, 20092.42, 2, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (51, 'ACTIVO', '2024-01-09 10:37:52.723046', '2024-01-09 10:37:52.723046', 'fvazquez', 1, '2024-02-29', 149506.45, 221016.59, 51417.72, 20092.42, 3, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (52, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-03-29', 153991.65, 221016.59, 46932.52, 20092.42, 4, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (53, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-04-29', 158611.40, 221016.59, 42312.78, 20092.42, 5, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (54, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-05-29', 163369.74, 221016.59, 37554.43, 20092.42, 6, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (55, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-06-29', 168270.83, 221016.59, 32653.34, 20092.42, 7, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (56, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-07-29', 173318.95, 221016.59, 27605.22, 20092.42, 8, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (57, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-08-29', 178518.52, 221016.59, 22405.65, 20092.42, 9, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (58, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-09-29', 183874.08, 221016.59, 17050.09, 20092.42, 10, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (59, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-10-29', 189390.30, 221016.59, 11533.87, 20092.42, 11, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (60, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, '2024-11-29', 195072.01, 221016.59, 5852.16, 20092.42, 12, 5, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (61, 'ACTIVO', '2024-01-11 19:44:11.179159', '2024-01-11 19:44:11.178643', 'fvazquez', 1, '2024-01-31', 212388.96, 329877.86, 87500.00, 29988.90, 1, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (62, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-02-29', 218583.64, 329877.86, 81305.32, 29988.90, 2, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (63, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-03-31', 224959.00, 329877.86, 74929.97, 29988.90, 3, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (64, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-04-30', 231520.30, 329877.86, 68368.66, 29988.90, 4, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (65, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-05-31', 238272.98, 329877.86, 61615.99, 29988.90, 5, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (66, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-06-30', 245222.60, 329877.86, 54666.36, 29988.90, 6, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (67, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-07-31', 252374.93, 329877.86, 47514.03, 29988.90, 7, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (68, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-08-31', 259735.87, 329877.86, 40153.10, 29988.90, 8, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (69, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, '2024-09-30', 267311.50, 329877.86, 32577.47, 29988.90, 9, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (70, 'ACTIVO', '2024-01-11 19:44:11.194903', '2024-01-11 19:44:11.194903', 'fvazquez', 1, '2024-10-31', 275108.08, 329877.86, 24780.88, 29988.90, 10, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (71, 'ACTIVO', '2024-01-11 19:44:11.194903', '2024-01-11 19:44:11.194903', 'fvazquez', 1, '2024-11-30', 283132.07, 329877.86, 16756.90, 29988.90, 11, 6, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (72, 'ACTIVO', '2024-01-11 19:44:11.197894', '2024-01-11 19:44:11.197894', 'fvazquez', 1, '2024-12-31', 291390.08, 329877.86, 8498.88, 29988.90, 12, 6, 4);


--
-- Data for Name: cre_motivos_prestamos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (1, 'ACTIVO', '2023-12-27 11:13:34.866513', '2023-12-27 11:12:56.302497', 'fvazquez', '01', 'VIVIENDA');
INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (2, 'ACTIVO', '2023-12-27 11:14:06.851146', '2023-12-27 11:14:06.851146', 'fvazquez', '02', 'VEHICULO');
INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (3, 'ACTIVO', '2023-12-27 11:14:16.114921', '2023-12-27 11:14:16.114921', 'fvazquez', '03', 'CONSUMO');


--
-- Data for Name: cre_solicitudes_creditos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (3, 'ACTIVO', '2023-12-29 15:53:05.571648', '2023-12-29 15:52:53.899229', 'fvazquez', '2023-12-29', 'S', 'S', 2000000.00, 2000000.00, 12, '2023-12-31', 1, 5, 1, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (2, 'ACTIVO', '2023-12-27 17:56:54.625092', '2023-12-27 17:56:04.757176', 'fvazquez', '2023-12-27', 'S', 'S', 2000000.00, 2500000.00, 12, '2023-12-31', 1, 4, 2, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (4, 'ACTIVO', '2024-01-11 17:11:35.156332', '2024-01-11 17:00:06.956275', 'fvazquez', '2024-01-11', 'S', 'S', 3000000.00, 3000000.00, 12, '2024-01-31', 1, 1, 2, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (5, 'ACTIVO', '2024-12-16 12:16:03.804271', '2024-12-16 12:15:48.919972', 'fvazquez', '2024-12-16', 'S', 'N', 1500000.00, 1500000.00, 12, '2024-12-31', 1, 4, 3, 1);


--
-- Data for Name: cre_tipo_amortizaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_tipo_amortizaciones (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion) VALUES (2, 'ACTIVO', '2023-12-27 11:01:12.871061', '2023-12-27 11:01:12.871061', 'fvazquez', 'AME', 'AMERICANO');
INSERT INTO public.cre_tipo_amortizaciones (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion) VALUES (3, 'ACTIVO', '2023-12-27 11:01:21.438394', '2023-12-27 11:01:21.438394', 'fvazquez', 'FRA', 'FRANCES');
INSERT INTO public.cre_tipo_amortizaciones (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion) VALUES (4, 'ACTIVO', '2023-12-27 11:01:31.830206', '2023-12-27 11:01:31.830206', 'fvazquez', 'ALE', 'ALEMAN');


--
-- Data for Name: sto_ajuste_inventarios_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: sto_ajuste_inventarios_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: sto_articulos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id) VALUES (1, 'ACTIVO', '2023-12-12 18:54:58.587664', '2023-12-12 18:54:58.587664', NULL, 'ART', 'ARTICULO', 'S', 150000.00, 1, 1);
INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id) VALUES (4, 'ACTIVO', '2024-01-05 11:53:54.082811', '2024-01-05 11:53:54.082811', 'fvazquez', 'CUO', 'CUOTAS', 'N', 1000.00, 1, 1);
INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id) VALUES (5, 'ACTIVO', '2024-01-10 19:31:52.519536', '2024-01-10 19:31:52.519536', 'fvazquez', 'DES', 'DESEMBOLSO', 'N', 1000.00, 1, 1);
INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id) VALUES (3, 'ACTIVO', '2023-12-12 19:00:41.15117', '2023-12-12 19:00:41.15117', NULL, 'ART 2', 'ARTICULO 2', 'S', 23550.00, 1, 2);
INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id) VALUES (6, 'ACTIVO', '2024-01-11 14:00:59.656862', '2024-01-11 14:00:59.656862', 'fvazquez', 'ART 3', 'ARTICULO 3', 'S', 15000.00, 1, 1);


--
-- Data for Name: sto_articulos_existencias; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sto_articulos_existencias (id, existencia, existencia_anterior, sto_articulo_id) VALUES (5, 4.00, 5.00, 6);
INSERT INTO public.sto_articulos_existencias (id, existencia, existencia_anterior, sto_articulo_id) VALUES (1, 0.00, 2.00, 1);
INSERT INTO public.sto_articulos_existencias (id, existencia, existencia_anterior, sto_articulo_id) VALUES (2, -1.00, 1.00, 3);


--
-- Data for Name: tes_bancos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_bancos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, saldo_cuenta, cod_banco, bs_empresa_id, bs_moneda_id, bs_persona_id) VALUES (3, 'ACTIVO', '2024-01-12 20:13:53.773426', '2024-01-12 20:13:53.773426', 'fvazquez', 15000.00, '8000299281', 1, 2, 10);
INSERT INTO public.tes_bancos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, saldo_cuenta, cod_banco, bs_empresa_id, bs_moneda_id, bs_persona_id) VALUES (1, 'ACTIVO', '2024-01-12 20:12:51.442285', '2024-01-12 20:12:51.442285', 'fvazquez', 13615000.00, '8000299281', 1, 1, 10);
INSERT INTO public.tes_bancos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, saldo_cuenta, cod_banco, bs_empresa_id, bs_moneda_id, bs_persona_id) VALUES (4, 'ACTIVO', '2025-07-30 19:09:03.970342', '2025-07-30 19:09:03.970342', 'fvazquez', 550000.00, '88287271819', 1, 1, 11);


--
-- Data for Name: tes_conciliaciones_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: tes_debitos_creditos_bancarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_debitos_creditos_bancarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_debito, monto_total_entrada, monto_total_salida, observacion, bs_empresa_id, bs_moneda_id, cob_habilitacion_id, tes_banco_id_entrante, tes_banco_id_saliente) VALUES (2, 'ACTIVO', '2025-07-30 21:08:49.864606', '2025-07-30 21:08:49.864606', 'fvazquez', '2025-07-30', 50000.00, 50000.00, 'obervacion', 1, 1, 10, 4, 1);


--
-- Data for Name: tes_depositos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (27, 'ANULADO', '2024-01-19 17:25:01.955941', '2024-01-19 17:23:31.602884', 'fvazquez', '2024-01-19', 12500.00, 99988877, 'PRUEBA DEFINITIVA', 1, 9, 1);
INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (30, 'ACTIVO', '2024-01-19 17:33:57.522029', '2024-01-19 17:33:57.522029', 'fvazquez', '2024-01-19', 12500.00, 88991736, 'PRUEBA DE VALIDACION', 1, 9, 1);
INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (31, 'ACTIVO', '2024-01-25 19:45:03.171802', '2024-01-25 19:45:03.171802', 'fvazquez', '2024-01-25', 150000.00, 881819, 'prueba', 1, 9, 1);


--
-- Data for Name: tes_pago_comprobante_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pago_comprobante_detalle (id, id_cuota_saldo, monto_pagado, nro_orden, tipo_comprobante, tes_pagos_cabecera_id) VALUES (2, 6, 3000000.00, 1, 'DESEMBOLSO', 3);


--
-- Data for Name: tes_pagos_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pagos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, beneficiario, fecha_pago, id_beneficiario, ind_autorizado, ind_impreso, monto_total_pago, nro_pago, nro_pago_completo, observacion, tipo_operacion, bs_empresa_id, bs_talonario_id, cob_habilitacion_id) VALUES (3, 'ACTIVO', '2024-02-10 21:04:13.873714', '2024-02-10 21:04:13.873714', 'fvazquez', 'fernnado vazquez', '2024-02-10', 1, 'N', 'S', 3000000.00, 1, '001-001-000000001', 'prueba de desembolso', 'DESEMBOLSO', 1, 7, 9);


--
-- Data for Name: tes_pagos_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pagos_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_entrega, fecha_valor, fecha_vencimiento, ind_entregado, monto_cuota, nro_orden, nro_valor, tipo_operacion, bs_empresa_id, bs_tipo_valor_id, tes_banco_id, tes_pagos_cabecera_id) VALUES (2, 'ACTIVO', '2024-02-10 21:04:13.917314', '2024-02-10 21:04:13.917314', NULL, NULL, '2024-02-10', '2024-02-10', NULL, 3000000.00, 1, '178383892', 'DESEMBOLSO', 1, 2, 1, 3);


--
-- Data for Name: ven_condicion_ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_condicion_ventas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_condicion, descripcion, intervalo, plazo, bs_empresa_id) VALUES (1, 'ACTIVO', '2023-12-12 18:16:54.954645', '2023-12-12 18:16:54.954645', NULL, 'CON', 'CONTADO', 0.00, 1.00, 1);
INSERT INTO public.ven_condicion_ventas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_condicion, descripcion, intervalo, plazo, bs_empresa_id) VALUES (4, 'ACTIVO', '2024-01-11 16:58:23.31292', '2024-01-11 16:58:23.31292', 'fvazquez', 'CREDES', 'CREDITO DESEMBOLSO', 30.00, 1.00, 1);
INSERT INTO public.ven_condicion_ventas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_condicion, descripcion, intervalo, plazo, bs_empresa_id) VALUES (5, 'ACTIVO', '2025-07-31 18:01:13.742973', '2025-07-31 18:01:13.742973', 'fvazquez', 'NCR', 'NOTAS DE CREDITO', 30.00, 1.00, 1);
INSERT INTO public.ven_condicion_ventas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_condicion, descripcion, intervalo, plazo, bs_empresa_id) VALUES (2, 'ACTIVO', '2023-12-12 18:17:53.259151', '2023-12-12 18:17:53.259151', NULL, 'CRE', 'CREDITO 12', 30.00, 12.00, 1);
INSERT INTO public.ven_condicion_ventas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_condicion, descripcion, intervalo, plazo, bs_empresa_id) VALUES (6, 'ACTIVO', '2025-07-31 19:57:09.21258', '2025-07-31 19:57:09.21258', 'fvazquez', 'CRE', 'CREDITOS ONE', 30.00, 1.00, 1);


--
-- Data for Name: ven_facturas_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (16, 'ACTIVO', '2024-01-25 19:44:24.289558', '2024-01-25 18:56:55.811218', 'fvazquez', '2024-01-25', NULL, 'S', 'S', 0.00, 150000.00, 136363.64, 13636.36, 1, '001-001-000000001', 'prueba de impresion', 'FACTURA', 1, 5, 1, 9, 1, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (17, 'ACTIVO', '2025-07-31 19:46:08.736989', '2025-07-31 19:46:08.736989', 'fvazquez', '2025-07-31', NULL, 'N', 'N', 0.00, 23550.00, 22428.57, 1121.43, 1, '001-002-000000001', 'Prueba de nota de credito', 'FACTURA', 1, 2, 1, 10, 2, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (18, 'ACTIVO', '2025-08-01 09:54:38.102919', '2025-08-01 09:54:38.102919', 'fvazquez', '2025-08-01', 17, 'N', 'N', 0.00, 23550.00, 22428.57, 1121.43, 1, '001-001-000000001', 'observacion', 'NCR', 1, 8, 1, 10, 5, 1);


--
-- Data for Name: ven_facturas_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (17, 'ACTIVO', '2024-01-25 18:56:55.903752', '2024-01-25 18:56:55.903752', 'fvazquez', 1, 'IVA10', 0.00, 136363.64, 13636.36, 150000.00, 1, 150000.00, 1, 16);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (18, 'ACTIVO', '2025-07-31 19:46:09.050055', '2025-07-31 19:46:09.050055', 'fvazquez', 1, 'IVA5', 0.00, 22428.57, 1121.43, 23550.00, 1, 23550.00, 3, 17);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (19, NULL, '2025-08-01 09:54:38.275046', '2025-08-01 09:54:38.275046', NULL, 1, 'IVA5', 0.00, 22428.57, 1121.43, 23550.00, 1, 23550.00, 3, 18);


--
-- Data for Name: ven_vendedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_vendedores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_vendedor, bs_empresa_id, id_bs_persona) VALUES (1, 'ACTIVO', '2023-12-12 18:05:35.672767', '2023-12-12 18:05:35.672767', NULL, '1', 1, 6);


--
-- Name: bs_access_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_access_log_id_seq', 22, true);


--
-- Name: bs_empresas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_empresas_id_seq', 6, true);


--
-- Name: bs_iva_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_iva_id_seq', 4, true);


--
-- Name: bs_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_menu_id_seq', 59, true);


--
-- Name: bs_menu_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_menu_item_id_seq', 72, true);


--
-- Name: bs_modulo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_modulo_id_seq', 15, true);


--
-- Name: bs_moneda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_moneda_id_seq', 5, true);


--
-- Name: bs_parametros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_parametros_id_seq', 6, true);


--
-- Name: bs_permiso_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_permiso_rol_id_seq', 44, true);


--
-- Name: bs_persona_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_persona_id_seq', 11, true);


--
-- Name: bs_reset_password_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_reset_password_token_id_seq', 25, true);


--
-- Name: bs_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_rol_id_seq', 4, true);


--
-- Name: bs_talonarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_talonarios_id_seq', 8, true);


--
-- Name: bs_timbrados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_timbrados_id_seq', 4, true);


--
-- Name: bs_tipo_comprobantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_tipo_comprobantes_id_seq', 7, true);


--
-- Name: bs_tipo_valor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_tipo_valor_id_seq', 3, true);


--
-- Name: bs_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_usuario_id_seq', 6, true);


--
-- Name: cob_arqueos_cajas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_arqueos_cajas_id_seq', 3, true);


--
-- Name: cob_cajas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cajas_id_seq', 26, true);


--
-- Name: cob_clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_clientes_id_seq', 5, true);


--
-- Name: cob_cobradores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cobradores_id_seq', 3, true);


--
-- Name: cob_cobros_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cobros_valores_id_seq', 15, true);


--
-- Name: cob_habilitaciones_cajas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_habilitaciones_cajas_id_seq', 10, true);


--
-- Name: cob_recibos_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_recibos_cabecera_id_seq', 7, true);


--
-- Name: cob_recibos_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_recibos_detalle_id_seq', 11, true);


--
-- Name: cob_saldos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_saldos_id_seq', 63, true);


--
-- Name: com_facturas_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_facturas_cabecera_id_seq', 4, true);


--
-- Name: com_facturas_detalles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_facturas_detalles_id_seq', 4, true);


--
-- Name: com_proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_proveedores_id_seq', 2, true);


--
-- Name: com_saldos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_saldos_id_seq', 5, true);


--
-- Name: cre_desembolso_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_desembolso_cabecera_id_seq', 6, true);


--
-- Name: cre_desembolso_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_desembolso_detalle_id_seq', 72, true);


--
-- Name: cre_motivos_prestamos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_motivos_prestamos_id_seq', 4, true);


--
-- Name: cre_solicitudes_creditos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_solicitudes_creditos_id_seq', 5, true);


--
-- Name: cre_tipo_amortizaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_tipo_amortizaciones_id_seq', 4, true);


--
-- Name: seq_cod_cobrador; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cod_cobrador', 2, false);


--
-- Name: seq_cod_proveedor; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cod_proveedor', 1, false);


--
-- Name: seq_cod_vendedor; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cod_vendedor', 1, false);


--
-- Name: sto_ajuste_inventarios_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_ajuste_inventarios_cabecera_id_seq', 12, true);


--
-- Name: sto_ajuste_inventarios_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_ajuste_inventarios_detalle_id_seq', 12, true);


--
-- Name: sto_articulos_existencias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_articulos_existencias_id_seq', 5, true);


--
-- Name: sto_articulos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_articulos_id_seq', 6, true);


--
-- Name: tes_bancos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_bancos_id_seq', 4, true);


--
-- Name: tes_conciliaciones_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_conciliaciones_valores_id_seq', 1, false);


--
-- Name: tes_debitos_creditos_bancarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_debitos_creditos_bancarios_id_seq', 2, true);


--
-- Name: tes_depositos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_depositos_id_seq', 31, true);


--
-- Name: tes_pago_comprobante_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pago_comprobante_detalle_id_seq', 2, true);


--
-- Name: tes_pagos_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pagos_cabecera_id_seq', 3, true);


--
-- Name: tes_pagos_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pagos_valores_id_seq', 2, true);


--
-- Name: ven_condicion_ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_condicion_ventas_id_seq', 6, true);


--
-- Name: ven_facturas_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_facturas_cabecera_id_seq', 18, true);


--
-- Name: ven_facturas_detalles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_facturas_detalles_id_seq', 19, true);


--
-- Name: ven_vendedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_vendedores_id_seq', 2, true);


--
-- Name: bs_access_log bs_access_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_access_log
    ADD CONSTRAINT bs_access_log_pkey PRIMARY KEY (id);


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
-- Name: bs_iva bs_iva_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_iva
    ADD CONSTRAINT bs_iva_unique_codigo UNIQUE (cod_iva);


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
-- Name: bs_menu bs_menu_unique_url; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_menu
    ADD CONSTRAINT bs_menu_unique_url UNIQUE (url);


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
-- Name: bs_modulo bs_modulo_unique_codigo_nombre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_modulo
    ADD CONSTRAINT bs_modulo_unique_codigo_nombre UNIQUE (codigo, nombre);


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
-- Name: bs_permiso_rol bs_permiso_rol_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_permiso_rol
    ADD CONSTRAINT bs_permiso_rol_unique_codigo UNIQUE (id_bs_rol, id_bs_menu);


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
-- Name: bs_persona bs_persona_unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_persona
    ADD CONSTRAINT bs_persona_unique_email UNIQUE (email);


--
-- Name: bs_reset_password_token bs_reset_password_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_reset_password_token
    ADD CONSTRAINT bs_reset_password_token_pkey PRIMARY KEY (id);


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
-- Name: bs_tipo_valor bs_tipo_valor_unique_cod_modulo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_tipo_valor
    ADD CONSTRAINT bs_tipo_valor_unique_cod_modulo UNIQUE (cod_tipo, id_bs_modulo);


--
-- Name: bs_usuario bs_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT bs_usuario_pkey PRIMARY KEY (id);


--
-- Name: bs_usuario bs_usuario_unique_cod_pers_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bs_usuario
    ADD CONSTRAINT bs_usuario_unique_cod_pers_empresa UNIQUE (cod_usuario, id_bs_persona, bs_empresa_id);


--
-- Name: cob_arqueos_cajas cob_arqueos_cajas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_arqueos_cajas
    ADD CONSTRAINT cob_arqueos_cajas_pkey PRIMARY KEY (id);


--
-- Name: cob_cajas cob_cajas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas
    ADD CONSTRAINT cob_cajas_pkey PRIMARY KEY (id);


--
-- Name: cob_cajas cob_cajas_unique_cod_usu_emp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cajas
    ADD CONSTRAINT cob_cajas_unique_cod_usu_emp UNIQUE (cod_caja, bs_usuario_id, bs_empresa_id);


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
-- Name: com_facturas_cabecera com_fact_cab_unique_nrofact_des; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_cabecera
    ADD CONSTRAINT com_fact_cab_unique_nrofact_des UNIQUE (tipo_factura, nro_factura_completo);


--
-- Name: com_facturas_cabecera com_facturas_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_cabecera
    ADD CONSTRAINT com_facturas_cabecera_pkey PRIMARY KEY (id);


--
-- Name: com_facturas_detalles com_facturas_detalles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_detalles
    ADD CONSTRAINT com_facturas_detalles_pkey PRIMARY KEY (id);


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
-- Name: com_saldos com_saldos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_saldos
    ADD CONSTRAINT com_saldos_pkey PRIMARY KEY (id);


--
-- Name: com_saldos com_saldos_unique_saldo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_saldos
    ADD CONSTRAINT com_saldos_unique_saldo UNIQUE (bs_empresa_id, com_proveedor_id, id_comprobante, tipo_comprobante, nro_cuota);


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
-- Name: cre_motivos_prestamos cre_motivos_prestamos_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_motivos_prestamos
    ADD CONSTRAINT cre_motivos_prestamos_unique_codigo UNIQUE (cod_motivo);


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
-- Name: cre_tipo_amortizaciones cre_tipo_amortizaciones_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cre_tipo_amortizaciones
    ADD CONSTRAINT cre_tipo_amortizaciones_unique_codigo UNIQUE (cod_tipo);


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
-- Name: sto_articulos sto_articulos_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto_articulos
    ADD CONSTRAINT sto_articulos_unique_codigo UNIQUE (cod_articulo, bs_empresa_id);


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
-- Name: tes_conciliaciones_valores tes_conciliaciones_valores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_conciliaciones_valores
    ADD CONSTRAINT tes_conciliaciones_valores_pkey PRIMARY KEY (id);


--
-- Name: tes_debitos_creditos_bancarios tes_debitos_creditos_bancarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_debitos_creditos_bancarios
    ADD CONSTRAINT tes_debitos_creditos_bancarios_pkey PRIMARY KEY (id);


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
-- Name: ven_vendedores ven_vendedores_unique_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_vendedores
    ADD CONSTRAINT ven_vendedores_unique_codigo UNIQUE (cod_vendedor, id_bs_persona, bs_empresa_id);


--
-- Name: bs_persona actualizar_nombre_completo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER actualizar_nombre_completo BEFORE INSERT ON public.bs_persona FOR EACH ROW EXECUTE FUNCTION public.set_nombre_completo();


--
-- Name: bs_modulo actualizar_nro_orden; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER actualizar_nro_orden BEFORE INSERT ON public.bs_modulo FOR EACH ROW EXECUTE FUNCTION public.calcular_nuevo_nro_orden();


--
-- Name: bs_modulo bs_modulo_menu_item_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bs_modulo_menu_item_trigger AFTER INSERT OR DELETE ON public.bs_modulo FOR EACH ROW EXECUTE FUNCTION public.insertar_menu_item_agrupador();


--
-- Name: bs_menu delete_pantalla_menu_item_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER delete_pantalla_menu_item_trigger BEFORE DELETE ON public.bs_menu FOR EACH ROW EXECUTE FUNCTION public.delete_pantalla_menu_item();


--
-- Name: bs_menu set_pantalla_menu_item_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_pantalla_menu_item_trigger AFTER INSERT ON public.bs_menu FOR EACH ROW EXECUTE FUNCTION public.set_pantalla_menu_item();


--
-- Name: bs_menu tr_bs_menu_actualizar_nro_orden; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_bs_menu_actualizar_nro_orden BEFORE INSERT ON public.bs_menu FOR EACH ROW EXECUTE FUNCTION public.fn_bs_menu_calcular_nuevo_nro_orden();


--
-- Name: cre_desembolso_cabecera trg_actualizar_credito_desembolsado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_actualizar_credito_desembolsado AFTER INSERT OR UPDATE ON public.cre_desembolso_cabecera FOR EACH ROW EXECUTE FUNCTION public.actualizar_solicitud_desembolsado();


--
-- Name: cre_desembolso_cabecera trg_actualizar_ind_desembolsado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_actualizar_ind_desembolsado AFTER UPDATE ON public.cre_desembolso_cabecera FOR EACH ROW EXECUTE FUNCTION public.fn_actualizar_ind_desembolsado();


--
-- Name: ven_facturas_cabecera trg_actualizar_ind_fact_desembolsado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_actualizar_ind_fact_desembolsado AFTER INSERT OR DELETE ON public.ven_facturas_cabecera FOR EACH ROW EXECUTE FUNCTION public.fn_actualizar_ind_fact_desembolsado();


--
-- Name: tes_debitos_creditos_bancarios trg_actualizar_saldos_bancarios; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_actualizar_saldos_bancarios AFTER INSERT OR DELETE ON public.tes_debitos_creditos_bancarios FOR EACH ROW EXECUTE FUNCTION public.tes_debcred_actualizar_saldos_bancarios();


--
-- Name: cob_recibos_detalle trg_cob_actualizar_saldo_cuota; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_cob_actualizar_saldo_cuota AFTER INSERT OR UPDATE ON public.cob_recibos_detalle FOR EACH ROW EXECUTE FUNCTION public.fn_cob_actualizar_saldo_cuota();


--
-- Name: cob_recibos_detalle trg_cob_deshacer_saldo_cuota; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_cob_deshacer_saldo_cuota BEFORE DELETE ON public.cob_recibos_detalle FOR EACH ROW EXECUTE FUNCTION public.fn_cob_deshacer_saldo_cuota();


--
-- Name: com_facturas_detalles trg_com_actualiza_existencia_articulo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_com_actualiza_existencia_articulo AFTER INSERT OR DELETE ON public.com_facturas_detalles FOR EACH ROW EXECUTE FUNCTION public.fn_com_actualiza_existencia_articulo();


--
-- Name: com_facturas_cabecera trg_com_eliminar_saldos; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_com_eliminar_saldos BEFORE DELETE ON public.com_facturas_cabecera FOR EACH ROW EXECUTE FUNCTION public.fn_com_eliminar_saldos();


--
-- Name: cob_clientes trg_genera_cob_cliente; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_genera_cob_cliente BEFORE INSERT ON public.cob_clientes FOR EACH ROW EXECUTE FUNCTION public.genera_cob_cliente();


--
-- Name: cob_cobradores trg_genera_cod_cobrador; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_genera_cod_cobrador BEFORE INSERT ON public.cob_cobradores FOR EACH ROW EXECUTE FUNCTION public.fn_genera_cod_cobrador();


--
-- Name: com_proveedores trg_genera_cod_proveedor; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_genera_cod_proveedor BEFORE INSERT ON public.com_proveedores FOR EACH ROW EXECUTE FUNCTION public.fn_genera_cod_proveedor();


--
-- Name: ven_vendedores trg_genera_cod_vendedor; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_genera_cod_vendedor BEFORE INSERT ON public.ven_vendedores FOR EACH ROW EXECUTE FUNCTION public.fn_genera_cod_vendedor();


--
-- Name: sto_articulos trg_inserta_sto_articulos_existencias; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_inserta_sto_articulos_existencias AFTER INSERT ON public.sto_articulos FOR EACH ROW EXECUTE FUNCTION public.fn_inserta_sto_articulos_existencias();


--
-- Name: sto_ajuste_inventarios_detalle trg_sto_actualizar_existencia_detalle; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sto_actualizar_existencia_detalle AFTER INSERT OR DELETE OR UPDATE ON public.sto_ajuste_inventarios_detalle FOR EACH ROW EXECUTE FUNCTION public.fn_sto_actualizar_existencia_detalle();


--
-- Name: tes_depositos trg_tes_actualizar_saldo_banco; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tes_actualizar_saldo_banco BEFORE INSERT OR DELETE OR UPDATE ON public.tes_depositos FOR EACH ROW EXECUTE FUNCTION public.fn_tes_actualizar_saldo_banco();


--
-- Name: tes_pagos_valores trg_tes_pago_actualizar_saldo_banco; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tes_pago_actualizar_saldo_banco AFTER INSERT OR DELETE OR UPDATE ON public.tes_pagos_valores FOR EACH ROW EXECUTE FUNCTION public.fn_tes_pago_actualizar_saldo_banco();


--
-- Name: ven_facturas_detalles trg_ven_actualiza_existencia_articulo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_ven_actualiza_existencia_articulo AFTER INSERT OR DELETE ON public.ven_facturas_detalles FOR EACH ROW EXECUTE FUNCTION public.fn_ven_actualiza_existencia_articulo();


--
-- Name: ven_facturas_cabecera trg_ven_eliminar_saldos; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_ven_eliminar_saldos BEFORE UPDATE ON public.ven_facturas_cabecera FOR EACH ROW EXECUTE FUNCTION public.fn_ven_eliminar_saldos();


--
-- Name: com_saldos fk11cio1r6wcou8v8ae9xi43yhr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_saldos
    ADD CONSTRAINT fk11cio1r6wcou8v8ae9xi43yhr FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


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
-- Name: com_facturas_detalles fk2invgk6ffoovy0s400elaudsv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_detalles
    ADD CONSTRAINT fk2invgk6ffoovy0s400elaudsv FOREIGN KEY (sto_articulo_id) REFERENCES public.sto_articulos(id);


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
-- Name: com_facturas_detalles fk6g7ttstde0jjs5f1ukl0nckta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_detalles
    ADD CONSTRAINT fk6g7ttstde0jjs5f1ukl0nckta FOREIGN KEY (com_facturas_cabecera_id) REFERENCES public.com_facturas_cabecera(id);


--
-- Name: cob_arqueos_cajas fk6jcq6m5ggkdy34on2nbd4pa8k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_arqueos_cajas
    ADD CONSTRAINT fk6jcq6m5ggkdy34on2nbd4pa8k FOREIGN KEY (cob_habilitacion_id) REFERENCES public.cob_habilitaciones_cajas(id);


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
-- Name: tes_debitos_creditos_bancarios fk75j0jgg2am2pxu38l98iq87su; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_debitos_creditos_bancarios
    ADD CONSTRAINT fk75j0jgg2am2pxu38l98iq87su FOREIGN KEY (cob_habilitacion_id) REFERENCES public.cob_habilitaciones_cajas(id);


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
-- Name: tes_conciliaciones_valores fk9c01niiicts84metlyno773i2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_conciliaciones_valores
    ADD CONSTRAINT fk9c01niiicts84metlyno773i2 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: tes_pagos_cabecera fk9ywxuwblgp70f9pp6wiqupbdj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_pagos_cabecera
    ADD CONSTRAINT fk9ywxuwblgp70f9pp6wiqupbdj FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: tes_debitos_creditos_bancarios fka4hwjtaiv4wf3t1cvgdp970wk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_debitos_creditos_bancarios
    ADD CONSTRAINT fka4hwjtaiv4wf3t1cvgdp970wk FOREIGN KEY (bs_moneda_id) REFERENCES public.bs_moneda(id);


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
-- Name: cob_arqueos_cajas fkcy1jbtgd7uc2q7vksjxeji7ar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_arqueos_cajas
    ADD CONSTRAINT fkcy1jbtgd7uc2q7vksjxeji7ar FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: com_facturas_cabecera fkd5ypkwv0upxahbup5hk1oacu4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_cabecera
    ADD CONSTRAINT fkd5ypkwv0upxahbup5hk1oacu4 FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


--
-- Name: tes_debitos_creditos_bancarios fkd8bew0yg9r68xrdfjidr6qf2i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_debitos_creditos_bancarios
    ADD CONSTRAINT fkd8bew0yg9r68xrdfjidr6qf2i FOREIGN KEY (tes_banco_id_entrante) REFERENCES public.tes_bancos(id);


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
-- Name: com_facturas_cabecera fkdqhvb03rr5qh12fhh7ytvhiv1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_facturas_cabecera
    ADD CONSTRAINT fkdqhvb03rr5qh12fhh7ytvhiv1 FOREIGN KEY (com_proveedor_id) REFERENCES public.com_proveedores(id);


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
-- Name: tes_conciliaciones_valores fkf7mwvdulph9rtltw853efrwow; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_conciliaciones_valores
    ADD CONSTRAINT fkf7mwvdulph9rtltw853efrwow FOREIGN KEY (cob_cobros_valores_id) REFERENCES public.cob_cobros_valores(id);


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
-- Name: tes_debitos_creditos_bancarios fkfykejyt502nwebn29piwgk9dm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_debitos_creditos_bancarios
    ADD CONSTRAINT fkfykejyt502nwebn29piwgk9dm FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


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
-- Name: tes_conciliaciones_valores fklrow0575wvux9q6w7ixmljrlc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_conciliaciones_valores
    ADD CONSTRAINT fklrow0575wvux9q6w7ixmljrlc FOREIGN KEY (bs_tipo_valor_id) REFERENCES public.bs_tipo_valor(id);


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
-- Name: tes_debitos_creditos_bancarios fkstkmi3roptc5s0dchfeeikcw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_debitos_creditos_bancarios
    ADD CONSTRAINT fkstkmi3roptc5s0dchfeeikcw FOREIGN KEY (tes_banco_id_saliente) REFERENCES public.tes_bancos(id);


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
-- Name: com_saldos fkt5u58b9g1o7s98a8s9irqglwi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.com_saldos
    ADD CONSTRAINT fkt5u58b9g1o7s98a8s9irqglwi FOREIGN KEY (com_proveedor_id) REFERENCES public.com_proveedores(id);


--
-- Name: cob_recibos_detalle fkwebc0cfneqph5f2r5g4hft1t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle
    ADD CONSTRAINT fkwebc0cfneqph5f2r5g4hft1t FOREIGN KEY (cob_saldo_id) REFERENCES public.cob_saldos(id);


--
-- PostgreSQL database dump complete
--

