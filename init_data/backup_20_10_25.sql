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
    NEW.cod_cobrador := nextval('seq_cod_cobrador')::text;
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
    NEW.cod_proveedor := nextval('seq_cod_proveedor')::text;
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
    NEW.cod_vendedor := nextval('seq_cod_vendedor')::text;
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
	    where bs_empresa_id = old.bs_empresa_id 
	    and id = old.tes_banco_id;
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
    IF NEW.estado = 'ANULADO' then
    	UPDATE cre_desembolso_cabecera
	       SET ind_facturado   = 'N',
	           ind_desembolsado = 'N'
	     WHERE id = NEW.id_comprobante;
	    
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
    NEW.cod_cliente := nextval('seq_cod_cliente')::text;
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
-- Name: marcar_valor_no_conciliado(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.marcar_valor_no_conciliado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE public.cob_cobros_valores
     SET ind_conciliado     = 'N',
         fecha_modificacion = NOW(),
         usuario_modificacion = COALESCE(
             current_setting('app.current_user', true),
             OLD.usuario_modificacion,
             'system'
         )
   WHERE id = OLD.cob_cobros_valores_id
     AND bs_empresa_id = OLD.bs_empresa_id;

  RETURN OLD;
END;
$$;


ALTER FUNCTION public.marcar_valor_no_conciliado() OWNER TO postgres;

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
    id_bs_rol bigint,
    puede_crear character varying(1),
    puede_editar character varying(1),
    puede_eliminar character varying(1)
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
    tipo_persona character varying(100),
    es_banco character varying(1)
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
    bs_tipo_comprobante_id bigint NOT NULL,
    proximo_numero numeric(19,2)
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
-- Name: seq_cod_cliente; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_cod_cliente
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE public.seq_cod_cliente OWNER TO postgres;

--
-- Name: cob_clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_clientes (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_cliente character varying(255) DEFAULT (nextval('public.seq_cod_cliente'::regclass))::text,
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
-- Name: cob_cobradores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cob_cobradores (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_cobrador character varying(255) DEFAULT (nextval('public.seq_cod_cobrador'::regclass))::text,
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
    ind_conciliado character varying(255),
    bs_persona_juridica bigint
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
    bs_cajas_id bigint NOT NULL,
    ind_impreso character varying(1)
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
    com_proveedor_id bigint NOT NULL,
    nro_timbrado numeric(19,2)
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
-- Name: com_proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.com_proveedores (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    cod_proveedor character varying(255) DEFAULT (nextval('public.seq_cod_proveedor'::regclass))::text,
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
    cre_tipo_amortizacion_id bigint,
    ind_pagare_impreso character varying(1),
    ind_contrato_impreso character varying(1),
    ind_proforma_impreso character varying(1)
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
    bs_persona_id bigint,
    CONSTRAINT tes_bancos_chk_saldo_no_negativo CHECK ((saldo_cuenta >= (0)::numeric))
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
-- Name: tes_bancos_saldos_historicos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_bancos_saldos_historicos (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    egresos numeric(19,2) NOT NULL,
    fecha_saldo date NOT NULL,
    ingresos numeric(19,2) NOT NULL,
    saldo_final numeric(19,2) NOT NULL,
    saldo_inicial numeric(19,2) NOT NULL,
    bs_empresa_id bigint NOT NULL,
    tes_banco_id bigint NOT NULL
);


ALTER TABLE public.tes_bancos_saldos_historicos OWNER TO postgres;

--
-- Name: tes_bancos_saldos_historicos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_bancos_saldos_historicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_bancos_saldos_historicos_id_seq OWNER TO postgres;

--
-- Name: tes_bancos_saldos_historicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_bancos_saldos_historicos_id_seq OWNED BY public.tes_bancos_saldos_historicos.id;


--
-- Name: tes_chequeras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tes_chequeras (
    id bigint NOT NULL,
    estado character varying(255),
    fecha_modificacion timestamp without time zone,
    fecha_creacion timestamp without time zone,
    usuario_modificacion character varying(255),
    fecha_vigencia_desde date,
    fecha_vigencia_hasta date,
    nro_desde bigint,
    nro_hasta bigint,
    proximo_numero numeric(19,2),
    bs_empresa_id bigint NOT NULL,
    bs_tipo_valor_id bigint NOT NULL,
    tes_banco_id bigint NOT NULL
);


ALTER TABLE public.tes_chequeras OWNER TO postgres;

--
-- Name: tes_chequeras_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tes_chequeras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tes_chequeras_id_seq OWNER TO postgres;

--
-- Name: tes_chequeras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tes_chequeras_id_seq OWNED BY public.tes_chequeras.id;


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
    cob_cobros_valores_id bigint,
    tipo_operacion character varying(255),
    tes_pagos_valores_id bigint
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
    tes_pagos_cabecera_id bigint,
    ind_conciliado character varying(255)
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
    cod_vendedor character varying(255) DEFAULT (nextval('public.seq_cod_vendedor'::regclass))::text,
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
-- Name: tes_bancos_saldos_historicos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos_saldos_historicos ALTER COLUMN id SET DEFAULT nextval('public.tes_bancos_saldos_historicos_id_seq'::regclass);


--
-- Name: tes_chequeras id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_chequeras ALTER COLUMN id SET DEFAULT nextval('public.tes_chequeras_id_seq'::regclass);


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
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (23, 'ACTIVO', '2025-09-01 19:12:42.079136', '2025-09-01 19:12:42.079136', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (24, 'ACTIVO', '2025-09-01 19:16:22.12773', '2025-09-01 19:16:22.12773', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (25, 'ACTIVO', '2025-09-01 19:26:42.848682', '2025-09-01 19:26:42.84764', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (26, 'ACTIVO', '2025-09-01 19:34:23.270837', '2025-09-01 19:34:23.270837', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (27, 'ACTIVO', '2025-09-01 19:36:17.513217', '2025-09-01 19:36:17.513217', 'acomercial', 'acomercial', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (28, 'ACTIVO', '2025-09-01 19:38:06.634002', '2025-09-01 19:38:06.634002', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (29, 'ACTIVO', '2025-09-01 20:10:45.105019', '2025-09-01 20:10:45.105019', 'acomercial', 'acomercial', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (30, 'ACTIVO', '2025-09-01 20:18:32.969632', '2025-09-01 20:18:32.969632', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (31, 'ACTIVO', '2025-09-01 20:18:49.531304', '2025-09-01 20:18:49.531304', 'acomercial', 'acomercial', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (32, 'ACTIVO', '2025-09-02 11:04:43.718414', '2025-09-02 11:04:43.718414', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (33, 'ACTIVO', '2025-09-02 11:07:34.565836', '2025-09-02 11:07:34.565836', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (34, 'ACTIVO', '2025-09-02 13:21:25.184165', '2025-09-02 13:21:25.184165', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (35, 'ACTIVO', '2025-09-02 14:08:18.96308', '2025-09-02 14:08:18.96308', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (36, 'ACTIVO', '2025-09-02 14:20:43.125398', '2025-09-02 14:20:43.125398', 'janalisis', 'janalisis', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (37, 'ACTIVO', '2025-09-02 14:37:02.29868', '2025-09-02 14:37:02.29868', 'janalisis', 'janalisis', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (38, 'ACTIVO', '2025-09-02 14:40:05.683453', '2025-09-02 14:40:05.683453', 'janalisis', 'janalisis', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (39, 'ACTIVO', '2025-09-02 14:51:09.915534', '2025-09-02 14:51:09.915534', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (40, 'ACTIVO', '2025-09-02 15:01:39.2372', '2025-09-02 15:01:39.2372', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (41, 'ACTIVO', '2025-09-02 15:05:42.406285', '2025-09-02 15:05:42.406285', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (42, 'ACTIVO', '2025-09-02 15:44:27.664922', '2025-09-02 15:44:27.664922', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (43, 'ACTIVO', '2025-09-02 15:48:22.147808', '2025-09-02 15:48:22.147808', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (44, 'ACTIVO', '2025-09-02 15:51:23.35379', '2025-09-02 15:51:23.352786', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (45, 'ACTIVO', '2025-09-02 16:17:06.559798', '2025-09-02 16:17:06.559798', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (46, 'ACTIVO', '2025-09-02 16:22:22.346585', '2025-09-02 16:22:22.346585', 'aauxiliar', 'aauxiliar', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (47, 'ACTIVO', '2025-09-02 16:23:19.244382', '2025-09-02 16:23:19.244382', 'etesorero', 'etesorero', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (48, 'ACTIVO', '2025-09-02 16:31:41.87759', '2025-09-02 16:31:41.87759', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (49, 'ACTIVO', '2025-09-02 17:41:10.597624', '2025-09-02 17:41:10.597624', 'mcaja', 'mcaja', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (50, 'ACTIVO', '2025-09-02 18:00:08.086267', '2025-09-02 18:00:08.086267', 'mcaja', 'mcaja', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (51, 'ACTIVO', '2025-09-02 18:17:11.706981', '2025-09-02 18:17:11.706981', 'aauxiliar', 'aauxiliar', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (52, 'ACTIVO', '2025-09-02 18:17:54.284454', '2025-09-02 18:17:54.284454', 'etesorero', 'etesorero', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (53, 'ACTIVO', '2025-09-04 14:29:29.409614', '2025-09-04 14:29:29.409614', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (54, 'ACTIVO', '2025-09-04 14:33:28.088872', '2025-09-04 14:33:28.088872', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (55, 'ACTIVO', '2025-09-04 14:44:43.10087', '2025-09-04 14:44:43.10087', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (56, 'ACTIVO', '2025-09-04 14:54:45.048666', '2025-09-04 14:54:45.048666', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (57, 'ACTIVO', '2025-09-04 15:45:59.165286', '2025-09-04 15:45:59.165286', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (58, 'ACTIVO', '2025-09-04 15:57:57.908705', '2025-09-04 15:57:57.908705', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (59, 'ACTIVO', '2025-09-04 20:15:44.39608', '2025-09-04 20:15:44.396063', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (60, 'ACTIVO', '2025-09-04 20:27:52.088202', '2025-09-04 20:27:52.088195', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (61, 'ACTIVO', '2025-09-04 22:22:54.352905', '2025-09-04 22:22:54.352868', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (62, 'ACTIVO', '2025-09-04 22:44:57.886378', '2025-09-04 22:44:57.886218', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (63, 'ACTIVO', '2025-09-04 22:58:38.754418', '2025-09-04 22:58:38.754411', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (64, 'ACTIVO', '2025-09-04 23:25:04.317925', '2025-09-04 23:25:04.31779', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (65, 'ACTIVO', '2025-09-04 23:48:45.211563', '2025-09-04 23:48:45.211554', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (66, 'ACTIVO', '2025-09-04 20:27:50.208434', '2025-09-04 20:27:50.208434', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (67, 'ACTIVO', '2025-09-04 20:31:13.542276', '2025-09-04 20:31:13.542276', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (68, 'ACTIVO', '2025-09-04 20:33:12.785504', '2025-09-04 20:33:12.785504', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (69, 'ACTIVO', '2025-09-04 20:34:59.11927', '2025-09-04 20:34:59.11927', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (70, 'ACTIVO', '2025-09-04 20:38:22.241027', '2025-09-04 20:38:22.241027', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (71, 'ACTIVO', '2025-09-04 20:43:54.027745', '2025-09-04 20:43:54.027745', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (72, 'ACTIVO', '2025-09-04 20:45:55.049275', '2025-09-04 20:45:55.049275', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (73, 'ACTIVO', '2025-09-04 20:47:12.595418', '2025-09-04 20:47:12.595418', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (74, 'ACTIVO', '2025-09-04 20:51:39.724943', '2025-09-04 20:51:39.724943', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (75, 'ACTIVO', '2025-09-04 20:53:12.278344', '2025-09-04 20:53:12.278344', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (76, 'ACTIVO', '2025-09-04 20:54:31.699604', '2025-09-04 20:54:31.699604', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (77, 'ACTIVO', '2025-09-04 20:59:42.559176', '2025-09-04 20:59:42.559176', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (78, 'ACTIVO', '2025-09-04 21:13:42.236081', '2025-09-04 21:13:42.236081', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (79, 'ACTIVO', '2025-09-04 21:27:53.556121', '2025-09-04 21:27:53.556121', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (80, 'ACTIVO', '2025-09-04 21:30:52.202145', '2025-09-04 21:30:52.202145', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (81, 'ACTIVO', '2025-09-04 21:32:19.678847', '2025-09-04 21:32:19.678847', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (82, 'ACTIVO', '2025-09-04 21:38:42.036377', '2025-09-04 21:38:42.036377', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (83, 'ACTIVO', '2025-09-04 21:39:50.691989', '2025-09-04 21:39:50.691989', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (84, 'ACTIVO', '2025-09-04 21:41:18.789293', '2025-09-04 21:41:18.788292', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (85, 'ACTIVO', '2025-09-04 21:43:00.042704', '2025-09-04 21:43:00.042704', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (86, 'ACTIVO', '2025-09-04 21:54:22.4656', '2025-09-04 21:54:22.464579', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (119, 'ACTIVO', '2025-09-05 10:44:19.737043', '2025-09-05 10:44:19.737043', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (120, 'ACTIVO', '2025-09-05 10:57:34.206888', '2025-09-05 10:57:34.206888', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (121, 'ACTIVO', '2025-09-05 11:24:58.124003', '2025-09-05 11:24:58.124003', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (122, 'ACTIVO', '2025-09-05 11:30:44.274946', '2025-09-05 11:30:44.274946', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (123, 'ACTIVO', '2025-09-05 12:28:45.330262', '2025-09-05 12:28:45.330262', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (124, 'ACTIVO', '2025-09-05 12:34:13.575949', '2025-09-05 12:34:13.575949', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (125, 'ACTIVO', '2025-09-05 12:41:16.136491', '2025-09-05 12:41:16.136491', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (126, 'ACTIVO', '2025-09-05 13:09:32.588143', '2025-09-05 13:09:32.588143', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (127, 'ACTIVO', '2025-09-05 13:13:14.117302', '2025-09-05 13:13:14.117302', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (128, 'ACTIVO', '2025-09-05 13:34:43.013908', '2025-09-05 13:34:43.013908', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (129, 'ACTIVO', '2025-09-05 13:37:31.074599', '2025-09-05 13:37:31.074599', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (130, 'ACTIVO', '2025-09-05 13:45:01.437216', '2025-09-05 13:45:01.437216', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (131, 'ACTIVO', '2025-09-05 13:46:32.754946', '2025-09-05 13:46:32.754946', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (132, 'ACTIVO', '2025-09-05 14:01:10.681357', '2025-09-05 14:01:10.681357', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (133, 'ACTIVO', '2025-09-05 14:07:45.636652', '2025-09-05 14:07:45.636652', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (134, 'ACTIVO', '2025-09-05 14:12:21.16431', '2025-09-05 14:12:21.16431', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (135, 'ACTIVO', '2025-09-05 14:20:57.013582', '2025-09-05 14:20:57.013582', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (136, 'ACTIVO', '2025-09-05 14:27:27.496775', '2025-09-05 14:27:27.496775', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (137, 'ACTIVO', '2025-09-05 14:31:54.714818', '2025-09-05 14:31:54.714818', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (138, 'ACTIVO', '2025-09-05 14:36:58.942497', '2025-09-05 14:36:58.942497', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (139, 'ACTIVO', '2025-09-05 14:51:03.748222', '2025-09-05 14:51:03.748222', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (140, 'ACTIVO', '2025-09-05 15:00:50.539654', '2025-09-05 15:00:50.539654', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (141, 'ACTIVO', '2025-09-05 15:07:32.51298', '2025-09-05 15:07:32.51298', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (142, 'ACTIVO', '2025-09-05 15:15:49.421809', '2025-09-05 15:15:49.421809', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (143, 'ACTIVO', '2025-09-05 15:17:12.949782', '2025-09-05 15:17:12.949782', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (144, 'ACTIVO', '2025-09-05 15:20:20.912622', '2025-09-05 15:20:20.912622', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (145, 'ACTIVO', '2025-09-05 15:38:42.206601', '2025-09-05 15:38:42.206601', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (146, 'ACTIVO', '2025-09-05 15:40:15.570834', '2025-09-05 15:40:15.570834', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (147, 'ACTIVO', '2025-09-05 15:41:51.285794', '2025-09-05 15:41:51.285794', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (148, 'ACTIVO', '2025-09-05 15:44:38.306342', '2025-09-05 15:44:38.306342', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (149, 'ACTIVO', '2025-09-05 15:46:18.598713', '2025-09-05 15:46:18.598713', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (150, 'ACTIVO', '2025-09-05 15:54:34.46913', '2025-09-05 15:54:34.46913', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (151, 'ACTIVO', '2025-09-05 15:58:22.109337', '2025-09-05 15:58:22.109337', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (152, 'ACTIVO', '2025-09-05 16:05:19.269663', '2025-09-05 16:05:19.269663', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (153, 'ACTIVO', '2025-09-05 16:06:03.89266', '2025-09-05 16:06:03.89266', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (154, 'ACTIVO', '2025-09-05 20:00:48.472178', '2025-09-05 20:00:48.472178', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (155, 'ACTIVO', '2025-09-05 20:05:51.656829', '2025-09-05 20:05:51.656829', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (156, 'ACTIVO', '2025-09-05 20:33:11.91494', '2025-09-05 20:33:11.91494', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (157, 'ACTIVO', '2025-09-05 20:39:39.406764', '2025-09-05 20:39:39.406764', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (158, 'ACTIVO', '2025-09-05 20:42:14.84086', '2025-09-05 20:42:14.84086', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (159, 'ACTIVO', '2025-09-05 20:46:05.69388', '2025-09-05 20:46:05.69388', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (160, 'ACTIVO', '2025-09-05 20:49:22.815789', '2025-09-05 20:49:22.815789', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (161, 'ACTIVO', '2025-09-06 07:05:43.947466', '2025-09-06 07:05:43.947466', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (162, 'ACTIVO', '2025-09-06 07:07:07.964008', '2025-09-06 07:07:07.964008', 'janalisis', 'janalisis', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (163, 'ACTIVO', '2025-09-06 07:34:32.040662', '2025-09-06 07:34:32.040662', 'janalisis', 'janalisis', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (164, 'ACTIVO', '2025-09-06 07:35:58.913109', '2025-09-06 07:35:58.913109', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (165, 'ACTIVO', '2025-09-08 09:03:12.060518', '2025-09-08 09:03:12.059518', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (166, 'ACTIVO', '2025-09-08 09:59:15.356519', '2025-09-08 09:59:15.356519', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (167, 'ACTIVO', '2025-09-08 10:03:47.298818', '2025-09-08 10:03:47.298818', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (168, 'ACTIVO', '2025-09-08 10:33:32.85597', '2025-09-08 10:33:32.854705', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (169, 'ACTIVO', '2025-09-08 10:52:10.993638', '2025-09-08 10:52:10.993638', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (170, 'ACTIVO', '2025-09-08 13:38:23.076434', '2025-09-08 13:38:23.076434', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (171, 'ACTIVO', '2025-09-08 14:00:14.236992', '2025-09-08 14:00:14.236992', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (172, 'ACTIVO', '2025-09-08 14:25:52.716898', '2025-09-08 14:25:52.716898', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (173, 'ACTIVO', '2025-09-08 14:41:35.043103', '2025-09-08 14:41:35.043103', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (174, 'ACTIVO', '2025-09-08 15:14:18.977257', '2025-09-08 15:14:18.977257', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (175, 'ACTIVO', '2025-09-08 15:22:20.921096', '2025-09-08 15:22:20.921096', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (176, 'ACTIVO', '2025-09-08 15:44:42.555181', '2025-09-08 15:44:42.555181', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (177, 'ACTIVO', '2025-09-08 15:47:53.154978', '2025-09-08 15:47:53.154978', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (178, 'ACTIVO', '2025-09-08 15:57:55.592583', '2025-09-08 15:57:55.592583', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (179, 'ACTIVO', '2025-09-08 16:10:26.112378', '2025-09-08 16:10:26.112378', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (180, 'ACTIVO', '2025-09-08 16:29:21.012107', '2025-09-08 16:29:21.012107', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (181, 'ACTIVO', '2025-09-08 18:30:56.615282', '2025-09-08 18:30:56.615282', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (182, 'ACTIVO', '2025-09-08 19:00:20.765342', '2025-09-08 19:00:20.765342', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (183, 'ACTIVO', '2025-09-08 19:04:18.645573', '2025-09-08 19:04:18.645573', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (184, 'ACTIVO', '2025-09-08 19:08:57.401875', '2025-09-08 19:08:57.401875', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (185, 'ACTIVO', '2025-09-08 19:17:41.469543', '2025-09-08 19:17:41.469543', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (186, 'ACTIVO', '2025-09-08 19:24:47.696581', '2025-09-08 19:24:47.696581', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (187, 'ACTIVO', '2025-09-08 19:35:17.265132', '2025-09-08 19:35:17.265132', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (188, 'ACTIVO', '2025-09-08 19:40:49.331397', '2025-09-08 19:40:49.331397', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (189, 'ACTIVO', '2025-09-08 19:53:40.022473', '2025-09-08 19:53:40.022473', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (190, 'ACTIVO', '2025-09-08 20:02:56.686475', '2025-09-08 20:02:56.686475', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (191, 'ACTIVO', '2025-09-09 18:56:19.400027', '2025-09-09 18:56:19.400027', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (192, 'ACTIVO', '2025-09-09 19:00:07.827279', '2025-09-09 19:00:07.827279', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (193, 'ACTIVO', '2025-09-09 19:22:00.506836', '2025-09-09 19:22:00.506836', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (194, 'ACTIVO', '2025-09-11 18:52:04.894908', '2025-09-11 18:52:04.89391', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (195, 'ACTIVO', '2025-09-11 19:05:50.302211', '2025-09-11 19:05:50.302211', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (196, 'ACTIVO', '2025-09-12 15:36:59.601564', '2025-09-12 15:36:59.601564', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (197, 'ACTIVO', '2025-09-12 15:44:04.421791', '2025-09-12 15:44:04.421791', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (198, 'ACTIVO', '2025-09-12 15:51:23.550897', '2025-09-12 15:51:23.550897', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (199, 'ACTIVO', '2025-09-12 15:59:44.427989', '2025-09-12 15:59:44.426978', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (200, 'ACTIVO', '2025-09-12 16:24:24.823863', '2025-09-12 16:24:24.823863', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (201, 'ACTIVO', '2025-09-12 16:29:12.572605', '2025-09-12 16:29:12.572605', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (202, 'ACTIVO', '2025-09-12 16:50:20.395799', '2025-09-12 16:50:20.395799', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (203, 'ACTIVO', '2025-09-12 16:51:42.344905', '2025-09-12 16:51:42.344905', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (204, 'ACTIVO', '2025-09-12 16:53:21.24498', '2025-09-12 16:53:21.24498', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (205, 'ACTIVO', '2025-09-13 07:05:11.655379', '2025-09-13 07:05:11.655379', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (206, 'ACTIVO', '2025-09-13 07:07:54.766293', '2025-09-13 07:07:54.766293', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (207, 'ACTIVO', '2025-09-13 07:12:11.119819', '2025-09-13 07:12:11.119819', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (208, 'ACTIVO', '2025-09-13 07:24:05.047551', '2025-09-13 07:24:05.047551', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (209, 'ACTIVO', '2025-09-13 07:28:54.880505', '2025-09-13 07:28:54.880505', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (210, 'ACTIVO', '2025-09-13 07:33:20.885415', '2025-09-13 07:33:20.884877', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (211, 'ACTIVO', '2025-09-13 07:36:22.762105', '2025-09-13 07:36:22.762105', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (212, 'ACTIVO', '2025-09-13 07:52:55.26139', '2025-09-13 07:52:55.26139', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (213, 'ACTIVO', '2025-09-13 07:57:34.210671', '2025-09-13 07:57:34.210671', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (214, 'ACTIVO', '2025-09-13 08:29:05.646964', '2025-09-13 08:29:05.646964', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (215, 'ACTIVO', '2025-09-18 09:51:32.018658', '2025-09-18 09:51:32.018658', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (216, 'ACTIVO', '2025-09-18 09:53:28.122844', '2025-09-18 09:53:28.122844', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (217, 'ACTIVO', '2025-09-18 09:55:37.608987', '2025-09-18 09:55:37.608987', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (218, 'ACTIVO', '2025-09-18 09:58:10.916214', '2025-09-18 09:58:10.916214', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (219, 'ACTIVO', '2025-09-18 10:01:43.5618', '2025-09-18 10:01:43.5618', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (220, 'ACTIVO', '2025-09-18 10:16:50.850152', '2025-09-18 10:16:50.850152', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (221, 'ACTIVO', '2025-09-18 12:16:48.370745', '2025-09-18 12:16:48.370745', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (222, 'ACTIVO', '2025-09-18 12:22:04.202295', '2025-09-18 12:22:04.202295', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (223, 'ACTIVO', '2025-09-18 13:14:32.050391', '2025-09-18 13:14:32.050391', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (224, 'ACTIVO', '2025-09-18 13:28:42.514358', '2025-09-18 13:28:42.514358', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (225, 'ACTIVO', '2025-09-18 14:37:20.128353', '2025-09-18 14:37:20.128353', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (226, 'ACTIVO', '2025-09-18 15:25:31.476421', '2025-09-18 15:25:31.476421', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (227, 'ACTIVO', '2025-09-18 15:37:40.948871', '2025-09-18 15:37:40.948871', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (228, 'ACTIVO', '2025-09-18 15:57:01.568099', '2025-09-18 15:57:01.568099', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (229, 'ACTIVO', '2025-09-18 16:03:17.064576', '2025-09-18 16:03:17.064576', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (230, 'ACTIVO', '2025-09-18 19:51:17.408364', '2025-09-18 19:51:17.408364', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (231, 'ACTIVO', '2025-09-18 20:00:10.579163', '2025-09-18 20:00:10.579163', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (232, 'ACTIVO', '2025-09-18 20:12:50.44188', '2025-09-18 20:12:50.44188', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (233, 'ACTIVO', '2025-09-18 20:16:42.936952', '2025-09-18 20:16:42.936952', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (234, 'ACTIVO', '2025-09-18 20:20:00.860631', '2025-09-18 20:20:00.860631', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (235, 'ACTIVO', '2025-09-18 20:25:04.484728', '2025-09-18 20:25:04.484728', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (236, 'ACTIVO', '2025-09-18 20:34:43.623223', '2025-09-18 20:34:43.623223', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (237, 'ACTIVO', '2025-09-18 20:41:15.679963', '2025-09-18 20:41:15.679963', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (238, 'ACTIVO', '2025-09-18 20:47:56.047651', '2025-09-18 20:47:56.046652', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (239, 'ACTIVO', '2025-09-18 20:50:58.275334', '2025-09-18 20:50:58.275334', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (240, 'ACTIVO', '2025-09-18 20:56:02.459526', '2025-09-18 20:56:02.459526', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (241, 'ACTIVO', '2025-09-18 21:04:07.806993', '2025-09-18 21:04:07.806993', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (242, 'ACTIVO', '2025-09-18 21:07:49.569972', '2025-09-18 21:07:49.569972', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (243, 'ACTIVO', '2025-09-18 21:09:55.293614', '2025-09-18 21:09:55.293614', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (244, 'ACTIVO', '2025-09-18 21:13:01.303265', '2025-09-18 21:13:01.303265', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (245, 'ACTIVO', '2025-09-18 21:20:11.358377', '2025-09-18 21:20:11.358377', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (246, 'ACTIVO', '2025-09-18 21:23:08.569254', '2025-09-18 21:23:08.569254', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (247, 'ACTIVO', '2025-09-19 08:11:10.449733', '2025-09-19 08:11:10.449733', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (248, 'ACTIVO', '2025-09-19 08:16:36.131414', '2025-09-19 08:16:36.131414', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (249, 'ACTIVO', '2025-09-19 08:23:06.810437', '2025-09-19 08:23:06.810437', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (250, 'ACTIVO', '2025-09-19 08:37:24.808333', '2025-09-19 08:37:24.808333', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (251, 'ACTIVO', '2025-09-19 08:45:02.400822', '2025-09-19 08:45:02.400822', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (252, 'ACTIVO', '2025-09-19 08:49:04.70774', '2025-09-19 08:49:04.70774', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (253, 'ACTIVO', '2025-09-19 08:50:58.597913', '2025-09-19 08:50:58.597913', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (254, 'ACTIVO', '2025-09-19 08:54:11.017163', '2025-09-19 08:54:11.017163', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (255, 'ACTIVO', '2025-09-19 08:56:53.152353', '2025-09-19 08:56:53.152353', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (256, 'ACTIVO', '2025-09-19 09:11:40.213625', '2025-09-19 09:11:40.213625', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (257, 'ACTIVO', '2025-09-19 09:21:46.085349', '2025-09-19 09:21:46.085349', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (258, 'ACTIVO', '2025-09-19 09:47:54.097895', '2025-09-19 09:47:54.097895', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (259, 'ACTIVO', '2025-09-19 09:57:50.068242', '2025-09-19 09:57:50.067236', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (260, 'ACTIVO', '2025-09-19 10:05:50.363383', '2025-09-19 10:05:50.363383', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (261, 'ACTIVO', '2025-09-19 10:15:09.275117', '2025-09-19 10:15:09.275117', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (262, 'ACTIVO', '2025-09-19 10:32:15.997784', '2025-09-19 10:32:15.997784', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (263, 'ACTIVO', '2025-09-19 11:06:20.25367', '2025-09-19 11:06:20.25367', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (264, 'ACTIVO', '2025-09-19 12:46:31.092365', '2025-09-19 12:46:31.092365', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (265, 'ACTIVO', '2025-09-19 12:51:36.952393', '2025-09-19 12:51:36.952393', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (266, 'ACTIVO', '2025-09-19 13:11:31.078376', '2025-09-19 13:11:31.078376', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (267, 'ACTIVO', '2025-09-19 13:14:19.477065', '2025-09-19 13:14:19.477065', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (268, 'ACTIVO', '2025-09-19 13:27:47.84844', '2025-09-19 13:27:47.84844', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (269, 'ACTIVO', '2025-09-19 13:27:54.459891', '2025-09-19 13:27:54.459891', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (270, 'ACTIVO', '2025-09-19 13:30:34.230767', '2025-09-19 13:30:34.229756', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (271, 'ACTIVO', '2025-09-19 13:37:49.33969', '2025-09-19 13:37:49.33969', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (272, 'ACTIVO', '2025-09-19 13:51:49.682697', '2025-09-19 13:51:49.682697', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (273, 'ACTIVO', '2025-09-19 14:09:06.800904', '2025-09-19 14:09:06.800904', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (274, 'ACTIVO', '2025-09-19 14:12:58.17443', '2025-09-19 14:12:58.17443', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (275, 'ACTIVO', '2025-09-19 14:14:56.537779', '2025-09-19 14:14:56.537779', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (276, 'ACTIVO', '2025-09-19 14:18:31.049088', '2025-09-19 14:18:31.049088', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (277, 'ACTIVO', '2025-09-19 14:46:56.619635', '2025-09-19 14:46:56.619635', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (278, 'ACTIVO', '2025-09-19 14:49:00.837763', '2025-09-19 14:49:00.837763', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (279, 'ACTIVO', '2025-09-19 14:54:47.180423', '2025-09-19 14:54:47.179422', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (280, 'ACTIVO', '2025-09-19 15:14:58.089879', '2025-09-19 15:14:58.089879', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (281, 'ACTIVO', '2025-09-19 15:19:23.649384', '2025-09-19 15:19:23.649384', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (282, 'ACTIVO', '2025-09-19 15:26:04.030959', '2025-09-19 15:26:04.030959', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (283, 'ACTIVO', '2025-09-19 15:37:40.592046', '2025-09-19 15:37:40.592046', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (284, 'ACTIVO', '2025-09-19 15:45:53.319226', '2025-09-19 15:45:53.319226', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (285, 'ACTIVO', '2025-09-19 15:51:33.091737', '2025-09-19 15:51:33.091737', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (286, 'ACTIVO', '2025-09-19 15:59:03.012258', '2025-09-19 15:59:03.012258', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (287, 'ACTIVO', '2025-09-19 16:12:51.366343', '2025-09-19 16:12:51.366343', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (288, 'ACTIVO', '2025-09-19 16:16:04.537104', '2025-09-19 16:16:04.537104', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (289, 'ACTIVO', '2025-09-20 06:59:03.988105', '2025-09-20 06:59:03.988105', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (290, 'ACTIVO', '2025-09-20 07:00:37.625592', '2025-09-20 07:00:37.625592', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (291, 'ACTIVO', '2025-09-20 07:03:44.295953', '2025-09-20 07:03:44.295953', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (292, 'ACTIVO', '2025-09-20 07:09:12.387549', '2025-09-20 07:09:12.387549', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (293, 'ACTIVO', '2025-09-20 07:14:17.35231', '2025-09-20 07:14:17.35231', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (294, 'ACTIVO', '2025-09-20 07:20:32.61372', '2025-09-20 07:20:32.61372', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (295, 'ACTIVO', '2025-09-20 07:25:34.582297', '2025-09-20 07:25:34.582297', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (296, 'ACTIVO', '2025-09-20 07:31:04.574675', '2025-09-20 07:31:04.574675', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (297, 'ACTIVO', '2025-09-20 07:42:12.13672', '2025-09-20 07:42:12.13672', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (298, 'ACTIVO', '2025-09-20 08:02:55.239337', '2025-09-20 08:02:55.239337', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (299, 'ACTIVO', '2025-09-22 14:11:58.680478', '2025-09-22 14:11:58.680478', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (300, 'ACTIVO', '2025-09-22 14:29:10.4018', '2025-09-22 14:29:10.4018', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (301, 'ACTIVO', '2025-09-22 14:53:43.7676', '2025-09-22 14:53:43.7676', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (302, 'ACTIVO', '2025-09-22 15:28:24.676968', '2025-09-22 15:28:24.676968', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (303, 'ACTIVO', '2025-09-22 15:48:56.631873', '2025-09-22 15:48:56.631873', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (304, 'ACTIVO', '2025-09-22 15:50:19.881748', '2025-09-22 15:50:19.881748', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (305, 'ACTIVO', '2025-09-22 15:51:54.327528', '2025-09-22 15:51:54.327528', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (306, 'ACTIVO', '2025-09-22 16:56:17.861066', '2025-09-22 16:56:17.860032', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (307, 'ACTIVO', '2025-09-22 16:58:15.47971', '2025-09-22 16:58:15.47971', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (308, 'ACTIVO', '2025-09-22 17:05:39.254647', '2025-09-22 17:05:39.254647', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (309, 'ACTIVO', '2025-09-22 17:12:03.314295', '2025-09-22 17:12:03.314295', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (310, 'ACTIVO', '2025-09-22 17:18:07.373504', '2025-09-22 17:18:07.373504', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (311, 'ACTIVO', '2025-09-22 17:21:27.839392', '2025-09-22 17:21:27.839392', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (312, 'ACTIVO', '2025-09-22 17:29:39.702988', '2025-09-22 17:29:39.702988', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (313, 'ACTIVO', '2025-09-23 09:10:44.621376', '2025-09-23 09:10:44.621376', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (314, 'ACTIVO', '2025-09-23 11:25:58.579096', '2025-09-23 11:25:58.579096', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (315, 'ACTIVO', '2025-09-23 11:57:33.869868', '2025-09-23 11:57:33.869868', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (316, 'ACTIVO', '2025-09-23 12:35:52.951249', '2025-09-23 12:35:52.951249', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (317, 'ACTIVO', '2025-09-23 13:03:11.978404', '2025-09-23 13:03:11.978404', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (318, 'ACTIVO', '2025-09-23 13:36:57.409797', '2025-09-23 13:36:57.409797', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (319, 'ACTIVO', '2025-09-23 13:42:44.086568', '2025-09-23 13:42:44.086568', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (320, 'ACTIVO', '2025-09-23 13:44:30.662087', '2025-09-23 13:44:30.662087', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (321, 'ACTIVO', '2025-09-23 14:22:05.70031', '2025-09-23 14:22:05.699308', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (322, 'ACTIVO', '2025-09-23 14:27:58.793231', '2025-09-23 14:27:58.793231', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (323, 'ACTIVO', '2025-09-23 14:44:24.537766', '2025-09-23 14:44:24.537766', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (324, 'ACTIVO', '2025-09-23 15:02:06.219102', '2025-09-23 15:02:06.219102', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (325, 'ACTIVO', '2025-09-23 15:16:20.163976', '2025-09-23 15:16:20.163976', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (326, 'ACTIVO', '2025-09-23 15:28:11.287147', '2025-09-23 15:28:11.287147', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (327, 'ACTIVO', '2025-09-23 15:59:48.975402', '2025-09-23 15:59:48.974874', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (328, 'ACTIVO', '2025-09-23 16:17:48.628271', '2025-09-23 16:17:48.628271', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (329, 'ACTIVO', '2025-09-23 16:31:19.110468', '2025-09-23 16:31:19.110468', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (330, 'ACTIVO', '2025-09-23 16:42:16.933548', '2025-09-23 16:42:16.933548', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (331, 'ACTIVO', '2025-09-23 16:53:41.653185', '2025-09-23 16:53:41.653185', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (332, 'ACTIVO', '2025-09-23 16:55:37.708235', '2025-09-23 16:55:37.707216', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (333, 'ACTIVO', '2025-09-23 16:56:34.076182', '2025-09-23 16:56:34.076182', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (334, 'ACTIVO', '2025-09-23 16:58:18.973559', '2025-09-23 16:58:18.973559', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (335, 'ACTIVO', '2025-09-23 17:07:18.692455', '2025-09-23 17:07:18.692455', 'mcaja', 'mcaja', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (336, 'ACTIVO', '2025-09-23 17:07:54.342065', '2025-09-23 17:07:54.342065', 'mcaja', 'mcaja', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (337, 'ACTIVO', '2025-09-23 17:08:51.688136', '2025-09-23 17:08:51.688136', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (338, 'ACTIVO', '2025-09-25 10:50:06.077306', '2025-09-25 10:50:06.077306', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (339, 'ACTIVO', '2025-09-25 10:55:58.290025', '2025-09-25 10:55:58.290025', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (340, 'ACTIVO', '2025-09-25 11:07:58.800363', '2025-09-25 11:07:58.800363', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (341, 'ACTIVO', '2025-09-25 16:15:00.446409', '2025-09-25 16:15:00.446409', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (342, 'ACTIVO', '2025-09-25 19:37:25.224853', '2025-09-25 19:37:25.224853', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (343, 'ACTIVO', '2025-09-25 19:58:02.234161', '2025-09-25 19:58:02.234161', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (344, 'ACTIVO', '2025-09-25 19:59:46.094016', '2025-09-25 19:59:46.094016', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (345, 'ACTIVO', '2025-09-25 20:04:20.332306', '2025-09-25 20:04:20.332306', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (346, 'ACTIVO', '2025-09-26 10:01:50.949422', '2025-09-26 10:01:50.949422', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (347, 'ACTIVO', '2025-09-26 10:19:19.720791', '2025-09-26 10:19:19.720791', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (348, 'ACTIVO', '2025-09-26 10:52:17.667008', '2025-09-26 10:52:17.667008', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (349, 'ACTIVO', '2025-09-26 10:55:34.222932', '2025-09-26 10:55:34.222932', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (350, 'ACTIVO', '2025-09-26 10:58:39.772365', '2025-09-26 10:58:39.772365', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (351, 'ACTIVO', '2025-09-26 11:09:08.678197', '2025-09-26 11:09:08.678197', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (352, 'ACTIVO', '2025-09-26 11:11:21.084039', '2025-09-26 11:11:21.084039', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (353, 'ACTIVO', '2025-09-26 11:13:33.686249', '2025-09-26 11:13:33.686249', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (354, 'ACTIVO', '2025-09-26 11:37:06.996434', '2025-09-26 11:37:06.996434', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (355, 'ACTIVO', '2025-09-26 11:45:59.976915', '2025-09-26 11:45:59.976915', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (356, 'ACTIVO', '2025-09-26 11:57:57.538899', '2025-09-26 11:57:57.538899', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (357, 'ACTIVO', '2025-09-26 12:00:51.407236', '2025-09-26 12:00:51.407236', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (358, 'ACTIVO', '2025-09-26 13:08:51.212905', '2025-09-26 13:08:51.212905', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (359, 'ACTIVO', '2025-09-26 13:22:12.879451', '2025-09-26 13:22:12.879451', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (360, 'ACTIVO', '2025-09-26 13:27:10.943764', '2025-09-26 13:27:10.943764', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (361, 'ACTIVO', '2025-09-26 13:45:26.656782', '2025-09-26 13:45:26.656782', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (362, 'ACTIVO', '2025-09-26 13:59:09.275052', '2025-09-26 13:59:09.275052', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (363, 'ACTIVO', '2025-09-26 14:14:58.739757', '2025-09-26 14:14:58.739757', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (364, 'ACTIVO', '2025-09-26 14:20:02.980466', '2025-09-26 14:20:02.980466', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (365, 'ACTIVO', '2025-09-26 14:22:55.802468', '2025-09-26 14:22:55.802468', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (366, 'ACTIVO', '2025-09-26 14:25:50.442869', '2025-09-26 14:25:50.441868', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (367, 'ACTIVO', '2025-09-26 14:31:22.388855', '2025-09-26 14:31:22.388855', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (368, 'ACTIVO', '2025-09-26 14:47:53.15513', '2025-09-26 14:47:53.15513', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (369, 'ACTIVO', '2025-09-26 16:45:25.48254', '2025-09-26 16:45:25.48254', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (370, 'ACTIVO', '2025-09-26 16:51:07.897767', '2025-09-26 16:51:07.897767', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (371, 'ACTIVO', '2025-09-26 19:03:10.598153', '2025-09-26 19:03:10.598153', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (372, 'ACTIVO', '2025-09-26 19:15:32.926057', '2025-09-26 19:15:32.925526', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (373, 'ACTIVO', '2025-09-26 19:26:08.311222', '2025-09-26 19:26:08.311222', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'N');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (374, 'ACTIVO', '2025-09-26 19:26:15.48621', '2025-09-26 19:26:15.48621', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (375, 'ACTIVO', '2025-09-26 19:39:56.108639', '2025-09-26 19:39:56.108639', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (376, 'ACTIVO', '2025-09-27 12:45:03.859584', '2025-09-27 12:45:03.859584', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (377, 'ACTIVO', '2025-09-27 13:56:44.682233', '2025-09-27 13:56:44.682233', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (378, 'ACTIVO', '2025-09-27 14:50:30.279779', '2025-09-27 14:50:30.279779', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (379, 'ACTIVO', '2025-09-27 14:59:48.675358', '2025-09-27 14:59:48.675358', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (380, 'ACTIVO', '2025-09-28 13:50:19.182488', '2025-09-28 13:50:19.182488', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (381, 'ACTIVO', '2025-09-28 13:54:42.911005', '2025-09-28 13:54:42.911005', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (382, 'ACTIVO', '2025-09-28 13:57:21.103385', '2025-09-28 13:57:21.103385', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (383, 'ACTIVO', '2025-09-28 14:01:10.683919', '2025-09-28 14:01:10.682921', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (384, 'ACTIVO', '2025-09-28 14:02:33.967768', '2025-09-28 14:02:33.967768', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (385, 'ACTIVO', '2025-09-28 14:04:12.426318', '2025-09-28 14:04:12.426318', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (386, 'ACTIVO', '2025-09-28 14:07:13.830259', '2025-09-28 14:07:13.8286', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (419, 'ACTIVO', '2025-09-29 09:33:58.861787', '2025-09-29 09:33:58.861787', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (420, 'ACTIVO', '2025-09-29 09:44:47.111267', '2025-09-29 09:44:47.111267', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (421, 'ACTIVO', '2025-09-29 10:02:24.47956', '2025-09-29 10:02:24.47956', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (422, 'ACTIVO', '2025-09-29 10:06:28.720386', '2025-09-29 10:06:28.720386', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (423, 'ACTIVO', '2025-09-29 10:11:35.472217', '2025-09-29 10:11:35.472217', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (424, 'ACTIVO', '2025-09-29 10:13:34.595559', '2025-09-29 10:13:34.595559', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (425, 'ACTIVO', '2025-09-29 13:47:31.315784', '2025-09-29 13:47:31.315784', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (426, 'ACTIVO', '2025-09-29 15:27:29.812029', '2025-09-29 15:27:29.812029', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (427, 'ACTIVO', '2025-09-29 15:34:19.971131', '2025-09-29 15:34:19.971131', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (428, 'ACTIVO', '2025-09-29 15:55:48.112115', '2025-09-29 15:55:48.112115', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (429, 'ACTIVO', '2025-09-29 16:01:36.641935', '2025-09-29 16:01:36.641935', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (430, 'ACTIVO', '2025-09-29 16:03:02.693735', '2025-09-29 16:03:02.693735', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (431, 'ACTIVO', '2025-09-29 16:05:55.735233', '2025-09-29 16:05:55.735233', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (432, 'ACTIVO', '2025-09-29 16:07:28.158732', '2025-09-29 16:07:28.158732', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (433, 'ACTIVO', '2025-09-29 16:08:51.310262', '2025-09-29 16:08:51.310262', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (434, 'ACTIVO', '2025-09-29 16:11:39.647392', '2025-09-29 16:11:39.647392', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (435, 'ACTIVO', '2025-09-29 16:18:39.973999', '2025-09-29 16:18:39.973999', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (436, 'ACTIVO', '2025-09-29 16:30:35.362142', '2025-09-29 16:30:35.362142', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (437, 'ACTIVO', '2025-09-29 16:32:22.596308', '2025-09-29 16:32:22.596308', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (438, 'ACTIVO', '2025-09-29 16:33:50.844343', '2025-09-29 16:33:50.844343', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (439, 'ACTIVO', '2025-09-29 16:37:30.927273', '2025-09-29 16:37:30.927273', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (440, 'ACTIVO', '2025-09-29 16:38:50.555444', '2025-09-29 16:38:50.555444', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (441, 'ACTIVO', '2025-09-29 16:43:28.459154', '2025-09-29 16:43:28.459154', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (442, 'ACTIVO', '2025-09-29 16:55:13.961608', '2025-09-29 16:55:13.961608', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (443, 'ACTIVO', '2025-09-29 17:11:08.168197', '2025-09-29 17:11:08.168197', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (444, 'ACTIVO', '2025-09-29 17:12:41.049583', '2025-09-29 17:12:41.049583', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (445, 'ACTIVO', '2025-09-29 17:23:43.675818', '2025-09-29 17:23:43.675818', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (446, 'ACTIVO', '2025-09-29 17:49:46.358037', '2025-09-29 17:49:46.358037', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (447, 'ACTIVO', '2025-09-29 18:03:35.863395', '2025-09-29 18:03:35.863395', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (448, 'ACTIVO', '2025-09-29 18:08:38.753141', '2025-09-29 18:08:38.753141', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (449, 'ACTIVO', '2025-09-29 18:31:16.087972', '2025-09-29 18:31:16.087972', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (450, 'ACTIVO', '2025-09-29 18:39:29.411094', '2025-09-29 18:39:29.411094', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (451, 'ACTIVO', '2025-09-29 19:11:28.16308', '2025-09-29 19:11:28.16308', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (452, 'ACTIVO', '2025-09-29 19:32:28.803629', '2025-09-29 19:32:28.803629', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (453, 'ACTIVO', '2025-09-29 19:35:57.686122', '2025-09-29 19:35:57.686122', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (454, 'ACTIVO', '2025-09-29 19:41:49.640283', '2025-09-29 19:41:49.640283', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (455, 'ACTIVO', '2025-09-30 08:38:37.479142', '2025-09-30 08:38:37.479142', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (456, 'ACTIVO', '2025-09-30 10:24:43.55824', '2025-09-30 10:24:43.557685', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (457, 'ACTIVO', '2025-09-30 10:26:45.958567', '2025-09-30 10:26:45.958567', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (458, 'ACTIVO', '2025-09-30 10:57:56.236048', '2025-09-30 10:57:56.236048', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (459, 'ACTIVO', '2025-09-30 11:01:59.15699', '2025-09-30 11:01:59.15699', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (460, 'ACTIVO', '2025-09-30 11:06:08.556771', '2025-09-30 11:06:08.556771', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (461, 'ACTIVO', '2025-09-30 11:32:19.414399', '2025-09-30 11:32:19.414399', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (462, 'ACTIVO', '2025-09-30 12:02:16.516985', '2025-09-30 12:02:16.516985', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (463, 'ACTIVO', '2025-09-30 12:11:47.034762', '2025-09-30 12:11:47.034762', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (464, 'ACTIVO', '2025-09-30 12:19:01.439684', '2025-09-30 12:19:01.439684', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (465, 'ACTIVO', '2025-09-30 12:23:17.285038', '2025-09-30 12:23:17.285038', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (466, 'ACTIVO', '2025-09-30 12:25:29.52117', '2025-09-30 12:25:29.52117', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (467, 'ACTIVO', '2025-09-30 19:10:06.971439', '2025-09-30 19:10:06.971439', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (468, 'ACTIVO', '2025-09-30 19:27:33.061247', '2025-09-30 19:27:33.061247', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (469, 'ACTIVO', '2025-09-30 19:28:57.246483', '2025-09-30 19:28:57.245926', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (470, 'ACTIVO', '2025-09-30 20:01:32.985557', '2025-09-30 20:01:32.985557', 'fvazquez', 'fvazquez', '127.0.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (471, 'ACTIVO', '2025-09-30 20:04:44.303681', '2025-09-30 20:04:44.303681', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (472, 'ACTIVO', '2025-09-30 20:08:03.642422', '2025-09-30 20:08:03.641875', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (473, 'ACTIVO', '2025-09-30 20:16:52.407254', '2025-09-30 20:16:52.407254', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (474, 'ACTIVO', '2025-09-30 20:19:43.546896', '2025-09-30 20:19:43.546896', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (475, 'ACTIVO', '2025-09-30 20:26:03.506592', '2025-09-30 20:26:03.506592', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (476, 'ACTIVO', '2025-09-30 20:27:08.147652', '2025-09-30 20:27:08.147652', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (477, 'ACTIVO', '2025-09-30 20:32:20.809087', '2025-09-30 20:32:20.809087', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (478, 'ACTIVO', '2025-09-30 20:37:11.291242', '2025-09-30 20:37:11.291242', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (479, 'ACTIVO', '2025-10-03 13:32:45.995521', '2025-10-03 13:32:45.995508', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (480, 'ACTIVO', '2025-10-03 13:42:53.258476', '2025-10-03 13:42:53.258461', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (481, 'ACTIVO', '2025-10-04 10:41:49.134518', '2025-10-04 10:41:49.134508', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (482, 'ACTIVO', '2025-10-04 06:51:08.127062', '2025-10-04 06:51:08.127062', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (483, 'ACTIVO', '2025-10-04 06:55:49.898138', '2025-10-04 06:55:49.89713', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (484, 'ACTIVO', '2025-10-04 07:29:53.510019', '2025-10-04 07:29:53.510019', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (485, 'ACTIVO', '2025-10-04 07:51:04.100341', '2025-10-04 07:51:04.100341', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (486, 'ACTIVO', '2025-10-09 19:44:54.450656', '2025-10-09 19:44:54.450656', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (487, 'ACTIVO', '2025-10-09 20:49:50.093564', '2025-10-09 20:49:50.093564', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (488, 'ACTIVO', '2025-10-09 20:59:04.844621', '2025-10-09 20:59:04.844621', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (489, 'ACTIVO', '2025-10-09 21:03:01.560177', '2025-10-09 21:03:01.560177', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (490, 'ACTIVO', '2025-10-09 21:07:46.775898', '2025-10-09 21:07:46.775898', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (491, 'ACTIVO', '2025-10-09 21:16:04.858036', '2025-10-09 21:16:04.858036', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (492, 'ACTIVO', '2025-10-10 13:55:42.880603', '2025-10-10 13:55:42.880598', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (493, 'ACTIVO', '2025-10-10 11:09:25.370364', '2025-10-10 11:09:25.370364', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (494, 'ACTIVO', '2025-10-10 11:27:28.973534', '2025-10-10 11:27:28.973534', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (495, 'ACTIVO', '2025-10-10 11:30:08.94425', '2025-10-10 11:30:08.94425', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (496, 'ACTIVO', '2025-10-10 11:40:13.191215', '2025-10-10 11:40:13.191215', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (497, 'ACTIVO', '2025-10-10 11:43:22.368794', '2025-10-10 11:43:22.368794', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (498, 'ACTIVO', '2025-10-10 14:47:28.47802', '2025-10-10 14:47:28.478015', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (499, 'ACTIVO', '2025-10-10 14:50:35.297194', '2025-10-10 14:50:35.297188', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (500, 'ACTIVO', '2025-10-12 21:24:36.319958', '2025-10-12 21:24:36.319951', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (501, 'ACTIVO', '2025-10-12 21:52:33.5547', '2025-10-12 21:52:33.554559', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (502, 'ACTIVO', '2025-10-12 22:01:58.083413', '2025-10-12 22:01:58.083409', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (503, 'ACTIVO', '2025-10-20 18:08:54.980596', '2025-10-20 18:08:54.980596', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (504, 'ACTIVO', '2025-10-20 21:22:21.92979', '2025-10-20 21:22:21.929643', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (505, 'ACTIVO', '2025-10-20 18:46:25.254209', '2025-10-20 18:46:25.254209', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (506, 'ACTIVO', '2025-10-20 18:46:51.697419', '2025-10-20 18:46:51.697419', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (507, 'ACTIVO', '2025-10-20 21:50:35.157193', '2025-10-20 21:50:35.157186', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (508, 'ACTIVO', '2025-10-20 22:02:03.260149', '2025-10-20 22:02:03.260125', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (509, 'ACTIVO', '2025-10-20 22:49:24.106641', '2025-10-20 22:49:24.106449', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (510, 'ACTIVO', '2025-10-20 19:55:01.000755', '2025-10-20 19:55:01.000755', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (511, 'ACTIVO', '2025-10-20 20:08:25.407298', '2025-10-20 20:08:25.407298', 'fvazquez', 'fvazquez', '0:0:0:0:0:0:0:1', 'S');
INSERT INTO public.bs_access_log (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, ip_address, success) VALUES (512, 'ACTIVO', '2025-10-20 23:11:31.787934', '2025-10-20 23:11:31.787929', 'fvazquez', 'fvazquez', '172.20.0.1', 'S');


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
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (60, 'Chequeras', 'Chequeras', 6, 'ITEM', 'DEFINICION', '/faces/pages/cliente/tesoreria/definicion/TesChequeras.xhtml', 10, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (61, 'Libro Ventas', 'Libro de Ventas', 6, 'ITEM', 'REPORTES', '/faces/pages/cliente/ventas/reportes/VenLibroVentas.xhtml', 11, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (62, 'Compras por fecha', 'Compras por Fecha', 0, 'ITEM', 'REPORTES', '/faces/pages/cliente/compras/reportes/ComComprasPorFecha.xhtml', 14, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (63, 'Libro Compras', 'Libro de Compras', 3, 'ITEM', 'REPORTES', '/faces/pages/cliente/compras/reportes/ComLibroCompras.xhtml', 14, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (64, 'Pagos por fecha', 'Pagos por Fechas', 7, 'ITEM', 'REPORTES', '/faces/pages/cliente/tesoreria/reportes/TesPagosPorFecha.xhtml', 10, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (65, 'Extracto por Cliente', 'Extracto por cliente', 8, 'ITEM', 'REPORTES', '/faces/pages/cliente/cobranzas/reportes/CobExtractoPorCliente.xhtml', 8, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (66, 'Conciliacion Bancaria', 'Conciliacion Bancaria por Fecha', 8, 'ITEM', 'REPORTES', '/faces/pages/cliente/tesoreria/reportes/TesConciliacionBancariaPorFecha.xhtml', 10, NULL);
INSERT INTO public.bs_menu (id, label, nombre, nro_orden, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu) VALUES (67, 'Extracto de Bancos', 'Extracto de Bancos', 9, 'ITEM', 'REPORTES', '/faces/pages/cliente/tesoreria/reportes/TesExtractoDeBancos.xhtml', 10, NULL);


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
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (73, 'ACTIVO', '2025-09-18 09:52:01.851857', '2025-09-18 09:52:01.851857', NULL, 'pi pi-fw pi-ellipsis-v', 17, NULL, 'MENU', 'Chequeras', 60, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (74, 'ACTIVO', '2025-09-22 15:29:20.432704', '2025-09-22 15:29:20.432704', NULL, 'pi pi-fw pi-ellipsis-v', 22, NULL, 'MENU', 'Libro de Ventas', 61, 11);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (75, 'ACTIVO', '2025-09-22 16:03:36.481815', '2025-09-22 16:03:36.481815', NULL, 'pi pi-fw pi-ellipsis-v', 59, NULL, 'MENU', 'Compras por Fecha', 62, 14);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (76, 'ACTIVO', '2025-09-22 16:04:14.390979', '2025-09-22 16:04:14.390979', NULL, 'pi pi-fw pi-ellipsis-v', 59, NULL, 'MENU', 'Libro de Compras', 63, 14);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (77, 'ACTIVO', '2025-09-23 13:37:45.520055', '2025-09-23 13:37:45.520055', NULL, 'pi pi-fw pi-ellipsis-v', 19, NULL, 'MENU', 'Pagos por Fechas', 64, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (78, 'ACTIVO', '2025-09-28 13:51:06.197137', '2025-09-28 13:51:06.197137', NULL, 'pi pi-fw pi-ellipsis-v', 13, NULL, 'MENU', 'Extracto por cliente', 65, 8);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (79, 'ACTIVO', '2025-09-30 08:39:47.097006', '2025-09-30 08:39:47.097006', NULL, 'pi pi-fw pi-ellipsis-v', 19, NULL, 'MENU', 'Conciliacion Bancaria por Fecha', 66, 10);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo) VALUES (80, 'ACTIVO', '2025-09-30 19:10:49.670031', '2025-09-30 19:10:49.670031', NULL, 'pi pi-fw pi-ellipsis-v', 19, NULL, 'MENU', 'Extracto de Bancos', 67, 10);


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
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, codigo, icon, nombre, nro_orden, path) VALUES (13, 'INACTIVO', '2025-10-20 18:46:38.584106', '2023-11-29 09:12:32.676719', 'fvazquez', 'STO', 'pi pi-shopping-bag', 'STOCK', 7, 'stock');


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

INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (45, NULL, '2025-09-01 19:27:14.569957', '2025-09-01 19:27:14.569957', 'fvazquez', 'PERMISOS', 6, 5, 'S', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (8, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 17, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (9, NULL, '2023-11-23 11:51:21.950434', '2023-11-23 11:51:21.950434', NULL, 'PERMISOS', 21, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (10, NULL, '2023-11-24 15:29:43.718738', '2023-11-24 15:29:43.718738', NULL, 'PERMISOS', 22, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (11, NULL, '2023-11-24 16:54:52.131547', '2023-11-24 16:54:52.131547', NULL, 'PERMISOS', 23, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (12, NULL, '2023-11-27 10:33:34.230844', '2023-11-27 10:33:34.230844', NULL, 'PERMISOS', 24, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (13, NULL, '2023-11-30 16:52:29.634115', '2023-11-30 16:52:29.634115', NULL, 'PERMISOS', 25, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (14, NULL, '2023-11-30 16:52:51.769645', '2023-11-30 16:52:51.769645', NULL, 'PERMISOS', 26, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (15, NULL, '2023-12-01 11:17:03.421675', '2023-12-01 11:17:03.421675', NULL, 'PERMISOS', 27, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (16, NULL, '2023-12-01 11:17:14.116104', '2023-12-01 11:17:14.116104', NULL, 'PERMISOS', 28, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (19, NULL, '2023-12-12 18:01:33.25567', '2023-12-12 18:01:33.25567', NULL, 'PERMISOS', 34, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (20, NULL, '2023-12-12 18:01:46.00111', '2023-12-12 18:01:46.00111', NULL, 'PERMISOS', 35, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (21, NULL, '2023-12-12 18:01:59.948197', '2023-12-12 18:01:59.948197', NULL, 'PERMISOS', 36, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (4, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 3, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (3, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 1, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (6, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 6, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (5, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 5, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (22, NULL, '2023-12-15 14:28:38.729036', '2023-12-15 14:28:38.729036', 'fvazquez', 'PERMISOS', 37, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (23, NULL, '2023-12-27 10:46:00.953943', '2023-12-27 10:46:00.953943', 'fvazquez', 'PERMISOS', 38, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (24, NULL, '2023-12-27 10:46:33.184631', '2023-12-27 10:46:33.184631', 'fvazquez', 'PERMISOS', 39, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (25, NULL, '2023-12-27 15:23:39.717078', '2023-12-27 15:23:39.717078', 'fvazquez', 'PERMISOS', 40, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (26, NULL, '2023-12-28 15:51:14.130045', '2023-12-28 15:51:14.130045', 'fvazquez', 'PERMISOS', 41, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (27, NULL, '2023-12-28 15:51:23.954357', '2023-12-28 15:51:23.954357', 'fvazquez', 'PERMISOS', 42, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (28, NULL, '2024-01-02 17:15:37.563449', '2024-01-02 17:15:37.563449', 'fvazquez', 'PERMISOS', 43, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (29, NULL, '2024-01-02 17:15:44.727419', '2024-01-02 17:15:44.727419', 'fvazquez', 'PERMISOS', 44, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (30, NULL, '2024-01-04 14:20:54.989778', '2024-01-04 14:20:54.989778', 'fvazquez', 'PERMISOS', 45, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (31, NULL, '2024-01-10 15:28:41.518061', '2024-01-10 15:28:41.518061', 'fvazquez', 'PERMISOS', 46, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (32, NULL, '2024-01-12 19:33:02.007685', '2024-01-12 19:33:02.007685', 'fvazquez', 'PERMISOS', 47, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (33, NULL, '2024-01-12 19:33:16.864186', '2024-01-12 19:33:16.864186', 'fvazquez', 'PERMISOS', 48, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (34, NULL, '2024-01-12 23:34:55.585819', '2024-01-12 23:34:55.585819', 'fvazquez', 'PERMISOS', 49, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (35, NULL, '2024-01-15 16:44:48.73731', '2024-01-15 16:44:48.73731', 'fvazquez', 'PERMISOS', 50, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (36, NULL, '2024-01-18 15:24:34.353535', '2024-01-18 15:24:34.353535', 'fvazquez', 'PERMISOS', 51, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (37, NULL, '2024-01-22 12:05:51.580568', '2024-01-22 12:05:51.580568', 'fvazquez', 'PERMISOS', 52, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (38, NULL, '2024-02-12 12:11:27.075193', '2024-02-12 12:11:27.075193', 'fvazquez', 'PERMISOS', 53, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (39, NULL, '2024-02-13 08:38:51.666126', '2024-02-13 08:38:51.666126', 'fvazquez', 'PERMISOS', 54, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (40, NULL, '2024-02-13 10:33:26.581093', '2024-02-13 10:33:26.581093', 'fvazquez', 'PERMISOS', 55, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (41, NULL, '2025-07-28 19:40:20.440131', '2025-07-28 19:40:20.440131', 'fvazquez', 'PERMISOS', 56, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (42, NULL, '2025-07-30 15:48:10.932604', '2025-07-30 15:48:10.932604', 'fvazquez', 'PERMISOS', 57, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (43, NULL, '2025-07-31 15:59:37.819788', '2025-07-31 15:59:37.819788', 'fvazquez', 'PERMISOS', 58, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (44, NULL, '2025-08-01 13:40:22.292648', '2025-08-01 13:40:22.292648', 'fvazquez', 'PERMISOS', 59, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (68, 'ACTIVO', '2025-09-02 16:20:32.24295', '2025-09-02 16:20:32.24295', 'fvazquez', 'PERMISOS', 56, 9, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (47, NULL, '2025-09-01 19:30:39.573501', '2025-09-01 19:30:39.573501', 'fvazquez', 'PERMISOS', 40, 5, 'S', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (46, NULL, '2025-09-01 19:30:16.238875', '2025-09-01 19:30:16.238875', 'fvazquez', 'PERMISOS', 27, 5, 'S', 'N', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (69, 'ACTIVO', '2025-09-02 16:20:59.638892', '2025-09-02 16:20:59.638892', 'fvazquez', 'PERMISOS', 47, 9, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (7, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', NULL, 'PERMISOS', 18, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (48, 'ACTIVO', '2025-09-02 14:18:30.602924', '2025-09-02 14:18:30.602924', 'fvazquez', 'PERMISOS', 45, 6, 'S', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (49, 'ACTIVO', '2025-09-02 14:19:05.444332', '2025-09-02 14:19:05.444332', 'fvazquez', 'PERMISOS', 40, 6, 'N', 'N', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (50, 'ACTIVO', '2025-09-02 14:19:27.639271', '2025-09-02 14:19:27.639271', 'fvazquez', 'PERMISOS', 27, 6, 'N', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (51, 'ACTIVO', '2025-09-02 15:55:03.647037', '2025-09-02 15:55:03.647037', 'fvazquez', 'PERMISOS', 27, 7, 'S', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (52, 'ACTIVO', '2025-09-02 15:55:28.07608', '2025-09-02 15:55:28.07608', 'fvazquez', 'PERMISOS', 42, 7, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (53, 'ACTIVO', '2025-09-02 15:56:30.052966', '2025-09-02 15:56:30.052966', 'fvazquez', 'PERMISOS', 46, 7, 'S', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (54, 'ACTIVO', '2025-09-02 15:56:46.997267', '2025-09-02 15:56:46.997267', 'fvazquez', 'PERMISOS', 58, 7, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (55, 'ACTIVO', '2025-09-02 15:57:44.392586', '2025-09-02 15:57:44.392586', 'fvazquez', 'PERMISOS', 28, 7, 'S', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (56, 'ACTIVO', '2025-09-02 15:58:17.852899', '2025-09-02 15:58:10.600863', 'fvazquez', 'PERMISOS', 50, 7, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (57, 'ACTIVO', '2025-09-02 16:11:44.608406', '2025-09-02 16:11:44.608406', 'fvazquez', 'PERMISOS', 47, 8, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (58, 'ACTIVO', '2025-09-02 16:12:11.776367', '2025-09-02 16:12:11.776367', 'fvazquez', 'PERMISOS', 56, 8, 'S', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (59, 'ACTIVO', '2025-09-02 16:13:04.911619', '2025-09-02 16:13:04.911619', 'fvazquez', 'PERMISOS', 52, 8, 'S', 'S', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (60, 'ACTIVO', '2025-09-02 16:13:34.185845', '2025-09-02 16:13:34.185845', 'fvazquez', 'PERMISOS', 59, 8, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (61, 'ACTIVO', '2025-09-02 16:14:24.497495', '2025-09-02 16:14:24.497495', 'fvazquez', 'PERMISOS', 51, 8, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (62, 'ACTIVO', '2025-09-02 16:14:55.30392', '2025-09-02 16:14:55.30392', 'fvazquez', 'PERMISOS', 52, 9, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (63, 'ACTIVO', '2025-09-02 16:15:08.205119', '2025-09-02 16:15:08.205119', 'fvazquez', 'PERMISOS', 59, 9, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (64, 'ACTIVO', '2025-09-02 16:15:23.994566', '2025-09-02 16:15:23.994566', 'fvazquez', 'PERMISOS', 48, 9, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (65, 'ACTIVO', '2025-09-02 16:18:08.640393', '2025-09-02 16:18:08.640393', 'fvazquez', 'PERMISOS', 51, 9, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (66, 'ACTIVO', '2025-09-02 16:18:44.905064', '2025-09-02 16:18:44.905064', 'fvazquez', 'PERMISOS', 57, 9, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (70, 'ACTIVO', '2025-09-18 09:52:27.367201', '2025-09-18 09:52:27.367201', 'fvazquez', 'PERMISOS', 60, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (71, 'ACTIVO', '2025-09-22 15:29:37.76353', '2025-09-22 15:29:37.76353', 'fvazquez', 'PERMISOS', 61, 1, 'S', 'S', 'S');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (72, 'ACTIVO', '2025-09-22 16:04:37.432219', '2025-09-22 16:04:37.432219', 'fvazquez', 'PERMISOS', 62, 1, 'N', 'N', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (73, 'ACTIVO', '2025-09-22 16:04:46.896185', '2025-09-22 16:04:46.895574', 'fvazquez', 'PERMISOS', 63, 1, 'N', 'N', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (74, 'ACTIVO', '2025-09-23 13:38:07.235995', '2025-09-23 13:38:07.235995', 'fvazquez', 'PERMISOS', 64, 1, 'N', 'N', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (75, 'ACTIVO', '2025-09-28 13:51:21.546189', '2025-09-28 13:51:21.545608', 'fvazquez', 'PERMISOS', 65, 1, 'N', 'N', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (76, 'ACTIVO', '2025-09-30 08:39:58.822152', '2025-09-30 08:39:58.822152', 'fvazquez', 'PERMISOS', 66, 1, 'N', 'N', 'N');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, descripcion, id_bs_menu, id_bs_rol, puede_crear, puede_editar, puede_eliminar) VALUES (77, 'ACTIVO', '2025-09-30 19:11:07.623038', '2025-09-30 19:11:07.623038', 'fvazquez', 'PERMISOS', 67, 1, 'N', 'N', 'N');


--
-- Data for Name: bs_persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (7, 'ACTIVO', '2023-11-27 17:29:16.776996', '2023-11-27 17:29:16.776996', NULL, '44444', 'ffff@gm.com', '1990-11-14', NULL, 'Roberto', 'Roberto Gimenez Benitez', 'Gimenez', 'Benitez', 'CI', 'FISICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (8, 'ACTIVO', '2023-11-28 16:56:20.157804', '2023-11-28 16:56:20.157804', NULL, '55555', 'AAA@GMAIL.COM', '2000-10-21', NULL, 'ALBERTO', 'ALBERTO FERNANDEZ LOPEZ', 'FERNANDEZ', 'LOPEZ', 'CI', 'FISICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (3, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '4864105', 'fernandorafa@live.com', '1991-10-21', NULL, 'fernando', 'fernnado vazquez', 'vazquez', 'lopez', 'CI', 'FISICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (6, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '888888', 'dddd@dd.com', '1991-10-21', NULL, 'paula', 'paula vazquez', 'vazquez', 'lopez', 'CI', 'FISICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (5, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', NULL, '777777', 'ooo@ooo.com', '1991-10-21', NULL, 'luis', 'luis vazquez', 'vazquez', 'lopez', 'CI', 'FISICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (12, 'ACTIVO', '2025-09-01 19:32:39.324359', '2025-09-01 19:32:39.324359', 'fvazquez', '90909090', 'aaa@aaa.com', '1991-10-15', NULL, 'andres', 'andres comercial ', 'comercial', '', 'CI', 'FISICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (13, 'ACTIVO', '2025-09-01 19:35:13.038404', '2025-09-01 19:35:13.038404', 'fvazquez', '10101010', 'bbb@bbb.com', '1990-05-10', NULL, 'jorge', 'jorge analisis ', 'analisis', '', 'CI', 'FISICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (14, 'ACTIVO', '2025-09-02 15:52:16.818732', '2025-09-02 15:52:16.818732', 'fvazquez', '20202020', 'iii@iii.com', '2000-03-27', NULL, 'maria', 'maria caja ', 'caja', '', 'CI', 'JURIDICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (15, 'ACTIVO', '2025-09-02 15:53:02.226956', '2025-09-02 15:53:02.226956', 'fvazquez', '50505050', 'uuu@uuu.com', '1985-10-25', NULL, 'antonio', 'antonio auxiliar ', 'auxiliar', '', 'CI', 'JURIDICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (16, 'ACTIVO', '2025-09-02 15:53:38.058033', '2025-09-02 15:53:38.058033', 'fvazquez', '78787878', 'www@www.com', '1995-09-10', NULL, 'elizabeth', 'elizabeth tesorero ', 'tesorero', '', 'CI', 'JURIDICA', 'N');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (10, 'ACTIVO', '2024-01-12 20:00:17.136873', '2024-01-12 20:00:17.136873', 'fvazquez', '800099927-8', 'itau@itau.com.py', '2024-01-23', NULL, 'BANCO ITAU S.A.', 'BANCO ITAU S.A.  ', 'BANCO ITAU S.A.  ', 'BANCO ITAU S.A.  ', 'CI', 'FISICA', 'S');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (11, 'ACTIVO', '2024-02-13 16:52:03.090551', '2024-02-13 16:52:03.090474', 'fvazquez', '800029172-9', 'FFF@FFF.COM', '2024-02-01', NULL, ' BANCO CONTINENTAL BANCO CONTINENTAL', ' BANCO CONTINENTAL BANCO CONTINENTAL', 'BANCO CONTINENTAL', 'BANCO CONTINENTAL', 'CI', 'FISICA', 'S');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, tipo_documento, tipo_persona, es_banco) VALUES (17, 'ACTIVO', '2025-10-20 21:24:00.756395', '2025-10-20 21:24:00.756387', 'fvazquez', '9098746', 'claudia.zaracho@gmail.com', '1992-01-01', NULL, 'CLAUDIA PATRICIA', 'CLAUDIA PATRICIA ZARACHO LOPEZ', 'ZARACHO', 'LOPEZ', 'CI', 'FISICA', 'N');


--
-- Data for Name: bs_reset_password_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_reset_password_token (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, expires_at, token, validated) VALUES (26, 'ACTIVO', '2025-10-20 18:07:47.570125', '2025-10-20 18:07:47.570125', 'fvazquez', 'fvazquez', '2025-10-20 18:22:47.53647', '513791', 'S');


--
-- Data for Name: bs_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (1, 'ACTIVO', '2023-09-05 16:16:21.69327', '2023-09-05 16:16:21.69327', 'fvazquez', 'ADMINISTRADOR');
INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (3, 'ACTIVO', '2023-09-05 16:16:21.69327', '2023-09-05 16:16:21.69327', 'fvazquez', 'INVITADO');
INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (5, 'ACTIVO', '2025-09-01 19:16:42.175688', '2025-09-01 19:16:42.175688', 'fvazquez', 'COMERCIAL');
INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (6, 'ACTIVO', '2025-09-01 19:16:50.124226', '2025-09-01 19:16:50.124226', 'fvazquez', 'ANALISIS');
INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (7, 'ACTIVO', '2025-09-01 19:16:56.387161', '2025-09-01 19:16:56.387161', 'fvazquez', 'CAJA');
INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (8, 'ACTIVO', '2025-09-01 19:17:09.807592', '2025-09-01 19:17:09.807592', 'fvazquez', 'AUX_TESORERIA');
INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, nombre) VALUES (9, 'ACTIVO', '2025-09-01 19:17:20.934025', '2025-09-01 19:17:20.934025', 'fvazquez', 'TESORERO');


--
-- Data for Name: bs_talonarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id, proximo_numero) VALUES (8, 'ACTIVO', '2025-07-31 17:07:38.193451', '2025-07-31 17:07:38.193451', 'fvazquez', 4, 7, 1.00);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id, proximo_numero) VALUES (6, 'ACTIVO', '2024-01-16 09:23:26.311944', '2024-01-16 09:23:26.311944', 'fvazquez', 3, 4, 4.00);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id, proximo_numero) VALUES (7, 'ACTIVO', '2024-01-22 16:28:54.537469', '2024-01-22 16:28:54.537469', 'fvazquez', 3, 5, 4.00);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id, proximo_numero) VALUES (5, 'ACTIVO', '2025-09-29 10:20:00.901719', '2024-01-10 20:04:52.046571', 'fvazquez', 3, 2, 2.00);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id, proximo_numero) VALUES (3, 'ACTIVO', '2025-10-20 21:26:11.058123', '2024-01-05 16:51:03.274948', 'fvazquez', 3, 3, 6.00);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id, proximo_numero) VALUES (2, 'ACTIVO', '2025-10-20 19:58:57.818435', '2024-01-02 17:28:26.527748', 'fvazquez', 2, 1, 5.00);


--
-- Data for Name: bs_timbrados; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_timbrados (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_establecimiento, cod_expedicion, fecha_vigencia_desde, fecha_vigencia_hasta, ind_autoimpresor, nro_desde, nro_hasta, nro_timbrado, bs_empresa_id) VALUES (4, 'ACTIVO', '2025-07-31 17:07:08.335736', '2025-07-31 17:07:08.335736', 'fvazquez', '001', '001', '2025-07-31', '2026-10-30', 'N', 1.00, 999999.00, 18882717.00, 1);
INSERT INTO public.bs_timbrados (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_establecimiento, cod_expedicion, fecha_vigencia_desde, fecha_vigencia_hasta, ind_autoimpresor, nro_desde, nro_hasta, nro_timbrado, bs_empresa_id) VALUES (3, 'ACTIVO', '2024-01-05 16:48:54.262894', '2024-01-05 16:48:54.262894', 'fvazquez', '001', '001', '2024-01-01', '2026-12-31', 'N', 1.00, 999999.00, 12345678.00, 1);
INSERT INTO public.bs_timbrados (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_establecimiento, cod_expedicion, fecha_vigencia_desde, fecha_vigencia_hasta, ind_autoimpresor, nro_desde, nro_hasta, nro_timbrado, bs_empresa_id) VALUES (2, 'ACTIVO', '2024-01-02 17:23:52.428487', '2024-01-02 17:23:40.71023', 'fvazquez', '001', '002', '2024-01-02', '2026-01-31', 'N', 1.00, 999.00, 1234567.00, 1);


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

INSERT INTO public.bs_tipo_valor (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion, usa_efectivo, bs_empresa_id, id_bs_modulo) VALUES (4, 'ACTIVO', '2025-09-18 10:04:59.567081', '2025-09-18 10:04:59.567081', 'fvazquez', 'CHE', 'CHEQUE', 'N', 1, 10);
INSERT INTO public.bs_tipo_valor (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion, usa_efectivo, bs_empresa_id, id_bs_modulo) VALUES (5, 'ACTIVO', '2025-09-18 10:17:16.151973', '2025-09-18 10:17:16.151973', 'fvazquez', 'EFE', 'EFECTIVO', 'S', 1, 10);
INSERT INTO public.bs_tipo_valor (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion, usa_efectivo, bs_empresa_id, id_bs_modulo) VALUES (1, 'ACTIVO', '2023-11-30 17:05:15.727047', '2023-11-30 17:05:15.727047', 'fvazquez', 'EFE', 'EFECTIVO', 'S', 1, 8);
INSERT INTO public.bs_tipo_valor (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion, usa_efectivo, bs_empresa_id, id_bs_modulo) VALUES (2, 'ACTIVO', '2023-11-30 17:09:37.933158', '2023-11-30 17:09:37.933158', 'fvazquez', 'CHE', 'CHEQUE', 'N', 1, 8);


--
-- Data for Name: bs_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (10, 'ACTIVO', '2025-09-02 16:05:02.479849', '2025-09-02 16:05:02.479849', 'fvazquez', 'aauxiliar', '$2a$10$/rbePhRav0xvYFZNxH5wfugJLa.ihx0E2lk1fQHkooavBafNIn82.', 1, 15, 8, NULL, 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (11, 'ACTIVO', '2025-09-02 16:05:37.186838', '2025-09-02 16:05:37.186838', 'fvazquez', 'etesorero', '$2a$10$/..hgbWahMZ.o8MiuAAsE.Kcyr/UxzveUqvtjzl9sNfXL8HI9qbI.', 1, 16, 9, NULL, 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (9, 'ACTIVO', '2025-09-23 17:07:54.468653', '2025-09-02 15:54:09.964182', 'fvazquez', 'mcaja', '$2a$10$QuGUxkKFz1Va1m.ic7VoAuF9tWMmcl02XJBtiUa9PVNR3t3CuHRlC', 1, 14, 7, '2025-09-23 17:22:54.467293', 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (1, 'ACTIVO', '2025-10-20 18:08:22.152455', '2023-09-07 13:28:08.054202', 'fvazquez', 'fvazquez', '$2a$10$u8wwQhCj0wBBfhHPEr4Lruo1pjZt8FINdC9ZndEYJoSbWUhHrtWE6', 1, 3, 1, NULL, 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (7, 'ACTIVO', '2025-09-01 19:36:01.943817', '2025-09-01 19:36:01.943817', 'fvazquez', 'acomercial', '$2a$10$KLj8syjzy4ymJhA/8an60OmoXelwjt39fBkWm8eX9uVfaGCw1tkNy', 1, 12, 5, NULL, 0);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_usuario, password, bs_empresa_id, id_bs_persona, id_bs_rol, bloqueado_hasta, intentos_fallidos) VALUES (8, 'ACTIVO', '2025-09-02 14:17:26.97486', '2025-09-02 14:17:26.97486', 'fvazquez', 'janalisis', '$2a$10$e23ArWLezkis/ouDYn8z3uQdFLxkNm8kSrUR0tlfUYkkZ7orT9wOq', 1, 13, 6, NULL, 0);


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
INSERT INTO public.cob_clientes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cliente, bs_empresa_id, id_bs_persona) VALUES (22, 'ACTIVO', '2025-09-13 08:29:36.90808', '2025-09-13 08:29:36.90808', 'fvazquez', '44', 1, 13);
INSERT INTO public.cob_clientes (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cliente, bs_empresa_id, id_bs_persona) VALUES (23, 'ACTIVO', '2025-10-20 21:24:19.622812', '2025-10-20 21:24:19.622799', 'fvazquez', '64', 1, 17);


--
-- Data for Name: cob_cobradores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cobradores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cobrador, bs_empresa_id, id_bs_persona) VALUES (2, 'ACTIVO', '2023-12-01 11:30:01.723144', '2023-12-01 11:30:01.723144', NULL, '1', 1, 3);
INSERT INTO public.cob_cobradores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_cobrador, bs_empresa_id, id_bs_persona) VALUES (3, 'ACTIVO', '2023-12-01 12:22:18.62225', '2023-12-01 12:22:18.62225', NULL, '2', 1, 6);


--
-- Data for Name: cob_cobros_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cobros_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, fecha_valor, fecha_vencimiento, id_comprobante, ind_depositado, monto_cuota, nro_comprobante_completo, nro_orden, nro_valor, tipo_comprobante, bs_empresa_id, bs_tipo_valor_id, tes_deposito_id, ind_conciliado, bs_persona_juridica) VALUES (10, 'ACTIVO', '2025-09-13 07:58:06.954545', '2024-01-18 11:14:53.80722', 'fvazquez', '2024-01-19', '2024-01-18', '2024-01-18', 7, 'S', 12500.00, '001-001-000000003', 1, '0', 'RECIBO', 1, 1, 30, 'S', NULL);
INSERT INTO public.cob_cobros_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, fecha_valor, fecha_vencimiento, id_comprobante, ind_depositado, monto_cuota, nro_comprobante_completo, nro_orden, nro_valor, tipo_comprobante, bs_empresa_id, bs_tipo_valor_id, tes_deposito_id, ind_conciliado, bs_persona_juridica) VALUES (16, 'ACTIVO', '2025-09-12 16:54:38.502483', '2025-09-08 16:11:06.626785', 'system', '2025-09-08', '2025-09-08', '2025-09-08', 8, 'S', 109959.29, '001-001-000000004', 1, '8882737', 'RECIBO', 1, 2, 32, 'N', 10);
INSERT INTO public.cob_cobros_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, fecha_valor, fecha_vencimiento, id_comprobante, ind_depositado, monto_cuota, nro_comprobante_completo, nro_orden, nro_valor, tipo_comprobante, bs_empresa_id, bs_tipo_valor_id, tes_deposito_id, ind_conciliado, bs_persona_juridica) VALUES (15, 'ACTIVO', '2025-10-04 08:01:56.164083', '2024-01-25 19:44:24.332655', 'fvazquez', '2024-01-25', '2024-01-25', '2024-01-25', 16, 'S', 150000.00, '001-001-000000001', 1, '0', 'FACTURA', 1, 1, 31, 'S', 10);


--
-- Data for Name: cob_habilitaciones_cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_habilitaciones_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_apertura, fecha_cierre, hora_apertura, hora_cierre, ind_cerrado, nro_habilitacion, bs_usuario_id, bs_cajas_id, ind_impreso) VALUES (8, 'ACTIVO', '2023-12-29 15:51:53.335839', '2023-12-29 15:51:37.190834', 'fvazquez', '2023-12-29 15:51:32.93391', '2023-12-29 15:51:53.314767', '15:51:32', '15:51:53', 'S', 1.00, 1, 17, 'N');
INSERT INTO public.cob_habilitaciones_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_apertura, fecha_cierre, hora_apertura, hora_cierre, ind_cerrado, nro_habilitacion, bs_usuario_id, bs_cajas_id, ind_impreso) VALUES (9, 'ACTIVO', '2025-09-25 20:00:36.616077', '2024-01-15 16:48:58.618427', 'fvazquez', '2024-01-15 16:48:00', '2025-09-25 20:00:36.587616', '16:48:56', '20:00:36', 'S', 2.00, 1, 17, 'N');
INSERT INTO public.cob_habilitaciones_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_apertura, fecha_cierre, hora_apertura, hora_cierre, ind_cerrado, nro_habilitacion, bs_usuario_id, bs_cajas_id, ind_impreso) VALUES (10, 'ACTIVO', '2025-07-29 12:12:49.134149', '2025-07-29 12:12:49.134149', 'fvazquez', '2025-07-29 12:12:47.286193', NULL, '12:12:47', NULL, 'N', 3.00, 1, 17, 'S');


--
-- Data for Name: cob_recibos_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, ind_cobrado, ind_impreso, monto_total_recibo, nro_recibo, nro_recibo_completo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id) VALUES (5, 'ACTIVO', '2024-01-16 14:39:55.275965', '2024-01-16 14:39:55.275965', 'fvazquez', '2024-01-16', 'N', 'N', 329877.86, 1, '001-001-000000001', 'dede', 1, 6, 1, 3, 10);
INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, ind_cobrado, ind_impreso, monto_total_recibo, nro_recibo, nro_recibo_completo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id) VALUES (8, 'ACTIVO', '2025-09-08 16:11:06.449384', '2025-09-08 15:16:10.128646', 'fvazquez', '2025-09-08', 'S', 'S', 109959.29, 4, '001-001-000000004', 'cobro de cuota de prueba', 1, 6, 1, 3, 10);
INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, ind_cobrado, ind_impreso, monto_total_recibo, nro_recibo, nro_recibo_completo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id) VALUES (7, 'ACTIVO', '2024-01-18 11:14:53.620988', '2024-01-18 11:14:53.620988', 'fvazquez', '2024-01-18', 'N', 'S', 12500.00, 3, '001-001-000000003', 'PRUEBA DE COBRO', 1, 6, 1, 3, 10);
INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, ind_cobrado, ind_impreso, monto_total_recibo, nro_recibo, nro_recibo_completo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id) VALUES (6, 'ACTIVO', '2024-01-16 14:40:47.031068', '2024-01-16 14:40:47.031068', 'fvazquez', '2024-01-16', 'N', 'S', 989633.58, 2, '001-001-000000002', 'dede', 1, 6, 1, 3, 10);


--
-- Data for Name: cob_recibos_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (8, 1, 0, 26, 329877.86, 1, 5, 26);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (9, 1, 0, 27, 329877.86, 1, 6, 27);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (10, 1, 0, 28, 329877.86, 2, 6, 28);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (11, 1, 1, 39, 12500.00, 1, 7, 39);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (12, 1, 0, 64, 109959.29, 1, 8, 64);


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
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (65, 'ACTIVO', '2025-09-08 14:43:33.223209', '2025-09-08 14:43:33.223209', 'fvazquez', '2025-11-15', 9, 98, 109959.29, '4.00', 2, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (66, 'ACTIVO', '2025-09-08 14:43:33.225368', '2025-09-08 14:43:33.225368', 'fvazquez', '2025-12-15', 9, 99, 109959.29, '4.00', 3, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (67, 'ACTIVO', '2025-09-08 14:43:33.228216', '2025-09-08 14:43:33.228216', 'fvazquez', '2026-01-15', 9, 100, 109959.29, '4.00', 4, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (68, 'ACTIVO', '2025-09-08 14:43:33.23037', '2025-09-08 14:43:33.23037', 'fvazquez', '2026-02-15', 9, 101, 109959.29, '4.00', 5, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (69, 'ACTIVO', '2025-09-08 14:43:33.232296', '2025-09-08 14:43:33.232296', 'fvazquez', '2026-03-15', 9, 102, 109959.29, '4.00', 6, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (70, 'ACTIVO', '2025-09-08 14:43:33.235081', '2025-09-08 14:43:33.235081', 'fvazquez', '2026-04-15', 9, 103, 109959.29, '4.00', 7, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (71, 'ACTIVO', '2025-09-08 14:43:33.237751', '2025-09-08 14:43:33.237751', 'fvazquez', '2026-05-15', 9, 104, 109959.29, '4.00', 8, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (72, 'ACTIVO', '2025-09-08 14:43:33.240399', '2025-09-08 14:43:33.240399', 'fvazquez', '2026-06-15', 9, 105, 109959.29, '4.00', 9, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (73, 'ACTIVO', '2025-09-08 14:43:33.243602', '2025-09-08 14:43:33.243602', 'fvazquez', '2026-07-15', 9, 106, 109959.29, '4.00', 10, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (74, 'ACTIVO', '2025-09-08 14:43:33.246834', '2025-09-08 14:43:33.246834', 'fvazquez', '2026-08-15', 9, 107, 109959.29, '4.00', 11, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (75, 'ACTIVO', '2025-09-08 14:43:33.263509', '2025-09-08 14:43:33.263509', 'fvazquez', '2026-09-15', 9, 108, 109959.29, '4.00', 12, 109959.29, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (64, 'ACTIVO', '2025-09-08 14:43:33.136522', '2025-09-08 14:43:33.136522', 'fvazquez', '2025-10-15', 9, 97, 109959.29, '4.00', 1, 0.00, 'DESEMBOLSO', 1, 1);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (76, 'ACTIVO', '2025-09-13 08:34:07.981892', '2025-09-13 08:34:07.981892', 'fvazquez', '2025-09-13', 10, 109, 109959.29, '5.00', 1, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (77, 'ACTIVO', '2025-09-13 08:34:08.051543', '2025-09-13 08:34:08.051543', 'fvazquez', '2025-10-13', 10, 110, 109959.29, '5.00', 2, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (78, 'ACTIVO', '2025-09-13 08:34:08.060379', '2025-09-13 08:34:08.060379', 'fvazquez', '2025-11-13', 10, 111, 109959.29, '5.00', 3, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (79, 'ACTIVO', '2025-09-13 08:34:08.068953', '2025-09-13 08:34:08.068953', 'fvazquez', '2025-12-13', 10, 112, 109959.29, '5.00', 4, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (80, 'ACTIVO', '2025-09-13 08:34:08.078056', '2025-09-13 08:34:08.077381', 'fvazquez', '2026-01-13', 10, 113, 109959.29, '5.00', 5, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (81, 'ACTIVO', '2025-09-13 08:34:08.087095', '2025-09-13 08:34:08.086452', 'fvazquez', '2026-02-13', 10, 114, 109959.29, '5.00', 6, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (82, 'ACTIVO', '2025-09-13 08:34:08.098604', '2025-09-13 08:34:08.098604', 'fvazquez', '2026-03-13', 10, 115, 109959.29, '5.00', 7, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (83, 'ACTIVO', '2025-09-13 08:34:08.110269', '2025-09-13 08:34:08.110269', 'fvazquez', '2026-04-13', 10, 116, 109959.29, '5.00', 8, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (84, 'ACTIVO', '2025-09-13 08:34:08.121129', '2025-09-13 08:34:08.120509', 'fvazquez', '2026-05-13', 10, 117, 109959.29, '5.00', 9, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (85, 'ACTIVO', '2025-09-13 08:34:08.131602', '2025-09-13 08:34:08.131602', 'fvazquez', '2026-06-13', 10, 118, 109959.29, '5.00', 10, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (86, 'ACTIVO', '2025-09-13 08:34:08.143944', '2025-09-13 08:34:08.143353', 'fvazquez', '2026-07-13', 10, 119, 109959.29, '5.00', 11, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (87, 'ACTIVO', '2025-09-13 08:34:08.155355', '2025-09-13 08:34:08.154724', 'fvazquez', '2026-08-13', 10, 120, 109959.29, '5.00', 12, 109959.29, 'DESEMBOLSO', 1, 5);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (100, 'ACTIVO', '2025-10-20 19:58:57.983335', '2025-10-20 19:58:57.983335', 'fvazquez', '2025-10-31', 11, 121, 219918.57, '5.00', 1, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (101, 'ACTIVO', '2025-10-20 19:58:57.989558', '2025-10-20 19:58:57.98905', 'fvazquez', '2025-11-30', 11, 122, 219918.57, '5.00', 2, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (102, 'ACTIVO', '2025-10-20 19:58:57.991728', '2025-10-20 19:58:57.991728', 'fvazquez', '2025-12-31', 11, 123, 219918.57, '5.00', 3, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (103, 'ACTIVO', '2025-10-20 19:58:57.993346', '2025-10-20 19:58:57.993346', 'fvazquez', '2026-01-31', 11, 124, 219918.57, '5.00', 4, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (104, 'ACTIVO', '2025-10-20 19:58:57.995571', '2025-10-20 19:58:57.995571', 'fvazquez', '2026-02-28', 11, 125, 219918.57, '5.00', 5, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (105, 'ACTIVO', '2025-10-20 19:58:58.00123', '2025-10-20 19:58:58.00123', 'fvazquez', '2026-03-31', 11, 126, 219918.57, '5.00', 6, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (106, 'ACTIVO', '2025-10-20 19:58:58.005183', '2025-10-20 19:58:58.005183', 'fvazquez', '2026-04-30', 11, 127, 219918.57, '5.00', 7, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (107, 'ACTIVO', '2025-10-20 19:58:58.007328', '2025-10-20 19:58:58.007328', 'fvazquez', '2026-05-31', 11, 128, 219918.57, '5.00', 8, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (108, 'ACTIVO', '2025-10-20 19:58:58.009482', '2025-10-20 19:58:58.009482', 'fvazquez', '2026-06-30', 11, 129, 219918.57, '5.00', 9, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (109, 'ACTIVO', '2025-10-20 19:58:58.012166', '2025-10-20 19:58:58.012166', 'fvazquez', '2026-07-31', 11, 130, 219918.57, '5.00', 10, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (110, 'ACTIVO', '2025-10-20 19:58:58.016267', '2025-10-20 19:58:58.016267', 'fvazquez', '2026-08-31', 11, 131, 219918.57, '5.00', 11, 219918.57, 'DESEMBOLSO', 1, 23);
INSERT INTO public.cob_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, id_cuota, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, cob_cliente_id) VALUES (111, 'ACTIVO', '2025-10-20 19:58:58.020081', '2025-10-20 19:58:58.020081', 'fvazquez', '2026-09-30', 11, 132, 219918.57, '5.00', 12, 219918.57, 'DESEMBOLSO', 1, 23);


--
-- Data for Name: com_facturas_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.com_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, ind_pagado, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, com_proveedor_id, nro_timbrado) VALUES (5, 'ACTIVO', '2025-09-08 16:29:59.155995', '2025-09-08 16:29:59.155995', 'fvazquez', '2025-09-08', 'N', 0.00, 15000.00, 13636.36, 1363.64, '001-001-00008871', 'prueba', 'FACTURA', 1, 1, 987658.00);
INSERT INTO public.com_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, ind_pagado, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, com_proveedor_id, nro_timbrado) VALUES (6, 'ACTIVO', '2025-09-13 08:39:55.931898', '2025-09-13 08:39:55.931898', 'fvazquez', '2025-09-13', 'N', 0.00, 15000.00, 13636.36, 1363.64, '001-002-00012123', 'dede', 'FACTURA', 1, 4, 987765.00);


--
-- Data for Name: com_facturas_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.com_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, com_facturas_cabecera_id, sto_articulo_id) VALUES (5, 'ACTIVO', '2025-09-08 16:29:59.286451', '2025-09-08 16:29:59.285902', 'fvazquez', 1, 'IVA10', 0.00, 13636.36, 1363.64, 15000.00, 1, 15000.00, 5, 6);
INSERT INTO public.com_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, com_facturas_cabecera_id, sto_articulo_id) VALUES (6, 'ACTIVO', '2025-09-13 08:39:56.049351', '2025-09-13 08:39:56.049351', 'fvazquez', 1, 'IVA10', 0.00, 13636.36, 1363.64, 15000.00, 1, 15000.00, 6, 6);


--
-- Data for Name: com_proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.com_proveedores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_proveedor, bs_empresa_id, bs_persona_id) VALUES (1, 'ACTIVO', '2024-01-12 19:49:38.255322', '2024-01-12 19:49:38.255322', 'fvazquez', '1', 1, 7);
INSERT INTO public.com_proveedores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_proveedor, bs_empresa_id, bs_persona_id) VALUES (3, 'ACTIVO', '2025-09-08 13:47:16.277883', '2025-09-08 13:47:16.277883', 'fvazquez', '2', 1, 14);
INSERT INTO public.com_proveedores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_proveedor, bs_empresa_id, bs_persona_id) VALUES (4, 'ACTIVO', '2025-09-13 08:38:42.78936', '2025-09-13 08:38:42.78936', 'fvazquez', '22', 1, 13);


--
-- Data for Name: com_saldos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.com_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, com_proveedor_id) VALUES (6, 'ACTIVO', '2025-09-08 16:29:59.40519', '2025-09-08 16:29:59.40519', 'fvazquez', '2025-09-08', 5, 15000.00, '001-001-00008871', 1, 15000.00, 'FACTURA', 1, 1);
INSERT INTO public.com_saldos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vencimiento, id_comprobante, monto_cuota, nro_comprobante_completo, nro_cuota, saldo_cuota, tipo_comprobante, bs_empresa_id, com_proveedor_id) VALUES (7, 'ACTIVO', '2025-09-13 08:39:56.12842', '2025-09-13 08:39:56.12842', 'fvazquez', '2025-09-13', 6, 15000.00, '001-002-00012123', 1, 0.00, 'FACTURA', 1, 4);


--
-- Data for Name: cre_desembolso_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_pagare_impreso, ind_contrato_impreso, ind_proforma_impreso) VALUES (10, 'ACTIVO', '2025-09-13 08:32:30.441944', '2025-09-13 08:32:30.441944', 'fvazquez', '2025-09-13', 'N', 'S', 1000000.00, 1319511.43, 199555.85, 119955.58, 5.00, 35.00, 3.00, 1, 3, 7, 3, 'S', 'S', 'S');
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_pagare_impreso, ind_contrato_impreso, ind_proforma_impreso) VALUES (9, 'ACTIVO', '2025-09-08 14:42:00.549254', '2025-09-08 14:42:00.549254', 'fvazquez', '2025-09-08', 'S', 'S', 1000000.00, 1319511.43, 199555.85, 119955.58, 4.00, 35.00, 3.00, 1, 3, 6, 3, 'S', 'S', 'S');
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_pagare_impreso, ind_contrato_impreso, ind_proforma_impreso) VALUES (4, 'ACTIVO', '2024-01-08 17:01:53.678368', '2024-01-05 17:43:13.47727', 'fvazquez', '2024-01-05', 'S', 'N', 2000000.04, 2700000.12, 636363.60, 63636.48, 1.00, 35.00, 3.00, 1, 3, 2, 3, 'N', 'N', 'N');
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_pagare_impreso, ind_contrato_impreso, ind_proforma_impreso) VALUES (6, 'ACTIVO', '2024-01-15 17:15:11.455102', '2024-01-11 19:44:11.11461', 'fvazquez', '2024-01-11', 'S', 'S', 3000000.00, 3958534.30, 598667.54, 359866.75, 3.00, 35.00, 3.00, 1, 3, 4, 3, 'S', 'S', 'N');
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_pagare_impreso, ind_contrato_impreso, ind_proforma_impreso) VALUES (5, 'ACTIVO', '2024-01-09 10:38:28.692587', '2024-01-09 10:37:52.65986', 'fvazquez', '2024-01-10', 'S', 'N', 2000000.00, 2652199.06, 411090.05, 241109.01, 2.00, 36.00, 3.00, 1, 3, 3, 3, 'S', 'S', 'N');
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, ind_facturado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_pagare_impreso, ind_contrato_impreso, ind_proforma_impreso) VALUES (11, 'ACTIVO', '2025-10-20 21:26:11.129843', '2025-10-20 21:26:11.129827', 'fvazquez', '2025-10-20', 'S', 'S', 2000000.00, 2639022.87, 399111.70, 239911.17, 5.00, 35.00, 3.00, 1, 3, 8, 3, 'S', 'S', 'S');


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
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (97, 'ACTIVO', '2025-09-08 14:42:00.591039', '2025-09-08 14:42:00.590694', 'fvazquez', 1, '2025-10-15', 70796.32, 109959.29, 29166.67, 9996.30, 1, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (98, 'ACTIVO', '2025-09-08 14:42:00.597229', '2025-09-08 14:42:00.597229', 'fvazquez', 1, '2025-11-15', 72861.21, 109959.29, 27101.77, 9996.30, 2, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (99, 'ACTIVO', '2025-09-08 14:42:00.602182', '2025-09-08 14:42:00.602182', 'fvazquez', 1, '2025-12-15', 74986.33, 109959.29, 24976.66, 9996.30, 3, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (100, 'ACTIVO', '2025-09-08 14:42:00.607004', '2025-09-08 14:42:00.607004', 'fvazquez', 1, '2026-01-15', 77173.43, 109959.29, 22789.55, 9996.30, 4, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (101, 'ACTIVO', '2025-09-08 14:42:00.719052', '2025-09-08 14:42:00.719052', 'fvazquez', 1, '2026-02-15', 79424.33, 109959.29, 20538.66, 9996.30, 5, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (102, 'ACTIVO', '2025-09-08 14:42:00.723253', '2025-09-08 14:42:00.723253', 'fvazquez', 1, '2026-03-15', 81740.87, 109959.29, 18222.12, 9996.30, 6, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (103, 'ACTIVO', '2025-09-08 14:42:00.727041', '2025-09-08 14:42:00.727041', 'fvazquez', 1, '2026-04-15', 84124.98, 109959.29, 15838.01, 9996.30, 7, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (104, 'ACTIVO', '2025-09-08 14:42:00.729758', '2025-09-08 14:42:00.729758', 'fvazquez', 1, '2026-05-15', 86578.62, 109959.29, 13384.37, 9996.30, 8, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (105, 'ACTIVO', '2025-09-08 14:42:00.735293', '2025-09-08 14:42:00.735293', 'fvazquez', 1, '2026-06-15', 89103.83, 109959.29, 10859.16, 9996.30, 9, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (106, 'ACTIVO', '2025-09-08 14:42:00.739744', '2025-09-08 14:42:00.739744', 'fvazquez', 1, '2026-07-15', 91702.69, 109959.29, 8260.29, 9996.30, 10, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (107, 'ACTIVO', '2025-09-08 14:42:00.743557', '2025-09-08 14:42:00.743011', 'fvazquez', 1, '2026-08-15', 94377.36, 109959.29, 5585.63, 9996.30, 11, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (108, 'ACTIVO', '2025-09-08 14:42:00.746243', '2025-09-08 14:42:00.746243', 'fvazquez', 1, '2026-09-15', 97130.03, 109959.29, 2832.96, 9996.30, 12, 9, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (109, 'ACTIVO', '2025-09-13 08:32:30.514758', '2025-09-13 08:32:30.514758', 'fvazquez', 1, '2025-09-13', 70796.32, 109959.29, 29166.67, 9996.30, 1, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (110, 'ACTIVO', '2025-09-13 08:32:30.55893', '2025-09-13 08:32:30.55893', 'fvazquez', 1, '2025-10-13', 72861.21, 109959.29, 27101.77, 9996.30, 2, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (111, 'ACTIVO', '2025-09-13 08:32:30.564977', '2025-09-13 08:32:30.564421', 'fvazquez', 1, '2025-11-13', 74986.33, 109959.29, 24976.66, 9996.30, 3, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (112, 'ACTIVO', '2025-09-13 08:32:30.57091', '2025-09-13 08:32:30.570329', 'fvazquez', 1, '2025-12-13', 77173.43, 109959.29, 22789.55, 9996.30, 4, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (113, 'ACTIVO', '2025-09-13 08:32:30.577623', '2025-09-13 08:32:30.577623', 'fvazquez', 1, '2026-01-13', 79424.33, 109959.29, 20538.66, 9996.30, 5, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (114, 'ACTIVO', '2025-09-13 08:32:30.585502', '2025-09-13 08:32:30.585502', 'fvazquez', 1, '2026-02-13', 81740.87, 109959.29, 18222.12, 9996.30, 6, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (115, 'ACTIVO', '2025-09-13 08:32:30.594481', '2025-09-13 08:32:30.594481', 'fvazquez', 1, '2026-03-13', 84124.98, 109959.29, 15838.01, 9996.30, 7, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (116, 'ACTIVO', '2025-09-13 08:32:30.603152', '2025-09-13 08:32:30.603152', 'fvazquez', 1, '2026-04-13', 86578.62, 109959.29, 13384.37, 9996.30, 8, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (117, 'ACTIVO', '2025-09-13 08:32:30.61167', '2025-09-13 08:32:30.61167', 'fvazquez', 1, '2026-05-13', 89103.83, 109959.29, 10859.16, 9996.30, 9, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (118, 'ACTIVO', '2025-09-13 08:32:30.619518', '2025-09-13 08:32:30.619518', 'fvazquez', 1, '2026-06-13', 91702.69, 109959.29, 8260.29, 9996.30, 10, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (119, 'ACTIVO', '2025-09-13 08:32:30.627423', '2025-09-13 08:32:30.627423', 'fvazquez', 1, '2026-07-13', 94377.36, 109959.29, 5585.63, 9996.30, 11, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (120, 'ACTIVO', '2025-09-13 08:32:30.635352', '2025-09-13 08:32:30.635043', 'fvazquez', 1, '2026-08-13', 97130.03, 109959.29, 2832.96, 9996.30, 12, 10, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (121, 'ACTIVO', '2025-10-20 21:26:11.236339', '2025-10-20 21:26:11.236329', 'fvazquez', 1, '2025-10-31', 141592.64, 219918.57, 58333.33, 19992.60, 1, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (122, 'ACTIVO', '2025-10-20 21:26:11.258732', '2025-10-20 21:26:11.258724', 'fvazquez', 1, '2025-11-30', 145722.43, 219918.57, 54203.55, 19992.60, 2, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (123, 'ACTIVO', '2025-10-20 21:26:11.260445', '2025-10-20 21:26:11.260438', 'fvazquez', 1, '2025-12-31', 149972.66, 219918.57, 49953.31, 19992.60, 3, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (124, 'ACTIVO', '2025-10-20 21:26:11.261866', '2025-10-20 21:26:11.261861', 'fvazquez', 1, '2026-01-31', 154346.87, 219918.57, 45579.11, 19992.60, 4, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (125, 'ACTIVO', '2025-10-20 21:26:11.26331', '2025-10-20 21:26:11.263304', 'fvazquez', 1, '2026-02-28', 158848.65, 219918.57, 41077.32, 19992.60, 5, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (126, 'ACTIVO', '2025-10-20 21:26:11.268798', '2025-10-20 21:26:11.268791', 'fvazquez', 1, '2026-03-31', 163481.74, 219918.57, 36444.24, 19992.60, 6, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (127, 'ACTIVO', '2025-10-20 21:26:11.271441', '2025-10-20 21:26:11.27142', 'fvazquez', 1, '2026-04-30', 168249.95, 219918.57, 31676.02, 19992.60, 7, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (128, 'ACTIVO', '2025-10-20 21:26:11.273528', '2025-10-20 21:26:11.27352', 'fvazquez', 1, '2026-05-31', 173157.24, 219918.57, 26768.73, 19992.60, 8, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (129, 'ACTIVO', '2025-10-20 21:26:11.275404', '2025-10-20 21:26:11.275399', 'fvazquez', 1, '2026-06-30', 178207.66, 219918.57, 21718.31, 19992.60, 9, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (130, 'ACTIVO', '2025-10-20 21:26:11.276977', '2025-10-20 21:26:11.276972', 'fvazquez', 1, '2026-07-31', 183405.39, 219918.57, 16520.59, 19992.60, 10, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (131, 'ACTIVO', '2025-10-20 21:26:11.278388', '2025-10-20 21:26:11.278384', 'fvazquez', 1, '2026-08-31', 188754.71, 219918.57, 11171.26, 19992.60, 11, 11, 4);
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, fecha_vencimiento, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id) VALUES (132, 'ACTIVO', '2025-10-20 21:26:11.279596', '2025-10-20 21:26:11.279592', 'fvazquez', 1, '2026-09-30', 194260.06, 219918.57, 5665.92, 19992.60, 12, 11, 4);


--
-- Data for Name: cre_motivos_prestamos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (1, 'ACTIVO', '2023-12-27 11:13:34.866513', '2023-12-27 11:12:56.302497', 'fvazquez', '01', 'VIVIENDA');
INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (2, 'ACTIVO', '2023-12-27 11:14:06.851146', '2023-12-27 11:14:06.851146', 'fvazquez', '02', 'VEHICULO');
INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (3, 'ACTIVO', '2023-12-27 11:14:16.114921', '2023-12-27 11:14:16.114921', 'fvazquez', '03', 'CONSUMO');


--
-- Data for Name: cre_solicitudes_creditos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (5, 'ACTIVO', '2024-12-16 12:16:03.804271', '2024-12-16 12:15:48.919972', 'fvazquez', '2024-12-16', 'S', 'N', 1500000.00, 1500000.00, 12, '2024-12-31', 1, 4, 3, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (7, 'ACTIVO', '2025-09-13 08:31:02.354973', '2025-09-13 08:30:53.47476', 'fvazquez', '2025-09-13', 'S', 'N', 1000000.00, 1000000.00, 12, '2025-09-13', 1, 5, 2, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (8, 'ACTIVO', '2025-10-20 21:25:32.939748', '2025-10-20 21:24:59.715118', 'fvazquez', '2025-10-20', 'S', 'S', 2000000.00, 2000000.00, 12, '2025-10-31', 1, 23, 1, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (6, 'ACTIVO', '2025-09-06 07:43:13.930113', '2025-09-06 07:42:20.659993', 'fvazquez', '2025-09-06', 'S', 'S', 1000000.00, 2000000.00, 12, '2025-10-15', 1, 1, 3, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (2, 'ACTIVO', '2023-12-27 17:56:54.625092', '2023-12-27 17:56:04.757176', 'fvazquez', '2023-12-27', 'S', 'S', 2000000.00, 2500000.00, 12, '2023-12-31', 1, 4, 2, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (4, 'ACTIVO', '2024-01-11 17:11:35.156332', '2024-01-11 17:00:06.956275', 'fvazquez', '2024-01-11', 'S', 'S', 3000000.00, 3000000.00, 12, '2024-01-31', 1, 1, 2, 1);
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, ind_autorizado, ind_desembolsado, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id) VALUES (3, 'ACTIVO', '2023-12-29 15:53:05.571648', '2023-12-29 15:52:53.899229', 'fvazquez', '2023-12-29', 'S', 'S', 2000000.00, 2000000.00, 12, '2023-12-31', 1, 5, 1, 1);


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

INSERT INTO public.sto_articulos_existencias (id, existencia, existencia_anterior, sto_articulo_id) VALUES (1, 0.00, 2.00, 1);
INSERT INTO public.sto_articulos_existencias (id, existencia, existencia_anterior, sto_articulo_id) VALUES (2, -1.00, 1.00, 3);
INSERT INTO public.sto_articulos_existencias (id, existencia, existencia_anterior, sto_articulo_id) VALUES (5, 5.00, 5.00, 6);


--
-- Data for Name: tes_bancos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_bancos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, saldo_cuenta, cod_banco, bs_empresa_id, bs_moneda_id, bs_persona_id) VALUES (4, 'ACTIVO', '2025-07-30 19:09:03.970342', '2025-07-30 19:09:03.970342', 'fvazquez', 13000.00, '88287271819', 1, 1, 11);
INSERT INTO public.tes_bancos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, saldo_cuenta, cod_banco, bs_empresa_id, bs_moneda_id, bs_persona_id) VALUES (3, 'ACTIVO', '2024-01-12 20:13:53.773426', '2024-01-12 20:13:53.773426', 'fvazquez', 15000.00, '8000299281', 1, 2, 10);
INSERT INTO public.tes_bancos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, saldo_cuenta, cod_banco, bs_empresa_id, bs_moneda_id, bs_persona_id) VALUES (1, 'ACTIVO', '2024-01-12 20:12:51.442285', '2024-01-12 20:12:51.442285', 'fvazquez', 17000.00, '8000299281', 1, 1, 10);


--
-- Data for Name: tes_bancos_saldos_historicos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_bancos_saldos_historicos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, egresos, fecha_saldo, ingresos, saldo_final, saldo_inicial, bs_empresa_id, tes_banco_id) VALUES (1, 'ACTIVO', NULL, NULL, NULL, 0.00, '2025-01-01', 0.00, 5000000.00, 5000000.00, 1, 1);
INSERT INTO public.tes_bancos_saldos_historicos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, egresos, fecha_saldo, ingresos, saldo_final, saldo_inicial, bs_empresa_id, tes_banco_id) VALUES (2, 'ACTIVO', '2025-10-10 18:19:42.047264', '2025-10-10 18:19:42.047174', NULL, 0.00, '2025-10-10', 0.00, 13000.00, 13000.00, 1, 4);
INSERT INTO public.tes_bancos_saldos_historicos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, egresos, fecha_saldo, ingresos, saldo_final, saldo_inicial, bs_empresa_id, tes_banco_id) VALUES (3, 'ACTIVO', '2025-10-10 18:19:42.17491', '2025-10-10 18:19:42.174906', NULL, 0.00, '2025-10-10', 0.00, 15000.00, 15000.00, 1, 3);
INSERT INTO public.tes_bancos_saldos_historicos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, egresos, fecha_saldo, ingresos, saldo_final, saldo_inicial, bs_empresa_id, tes_banco_id) VALUES (4, 'ACTIVO', '2025-10-10 18:19:42.180561', '2025-10-10 18:19:42.180558', NULL, 0.00, '2025-10-10', 0.00, 17000.00, 17000.00, 1, 1);


--
-- Data for Name: tes_chequeras; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_chequeras (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vigencia_desde, fecha_vigencia_hasta, nro_desde, nro_hasta, proximo_numero, bs_empresa_id, bs_tipo_valor_id, tes_banco_id) VALUES (3, 'ACTIVO', '2025-09-18 12:23:40.129035', '2025-09-18 12:23:40.129035', 'fvazquez', '2025-09-01', '2025-09-15', 21, 30, 23.00, 1, 4, 4);
INSERT INTO public.tes_chequeras (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_vigencia_desde, fecha_vigencia_hasta, nro_desde, nro_hasta, proximo_numero, bs_empresa_id, bs_tipo_valor_id, tes_banco_id) VALUES (2, 'ACTIVO', '2025-09-20 08:05:44.974626', '2025-09-18 12:23:09.837898', 'fvazquez', '2025-09-01', '2025-09-30', 1, 20, 21.00, 1, 4, 1);


--
-- Data for Name: tes_conciliaciones_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_conciliaciones_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_valor, ind_conciliado, monto_valor, nro_valor, observacion, bs_empresa_id, bs_tipo_valor_id, cob_cobros_valores_id, tipo_operacion, tes_pagos_valores_id) VALUES (12, 'ACTIVO', '2025-09-13 07:58:06.80614', '2025-09-13 07:58:06.80614', 'fvazquez', '2024-01-18', 'S', 12500.00, '0', 'CONCILIADO', 1, 1, 10, NULL, NULL);
INSERT INTO public.tes_conciliaciones_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_valor, ind_conciliado, monto_valor, nro_valor, observacion, bs_empresa_id, bs_tipo_valor_id, cob_cobros_valores_id, tipo_operacion, tes_pagos_valores_id) VALUES (17, 'ACTIVO', '2025-10-04 08:01:55.929711', '2025-10-04 08:01:55.929711', 'fvazquez', '2024-01-25', 'S', 150000.00, '0', 'CONCILIADO', 1, 1, 15, 'INGRESOS', NULL);
INSERT INTO public.tes_conciliaciones_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_valor, ind_conciliado, monto_valor, nro_valor, observacion, bs_empresa_id, bs_tipo_valor_id, cob_cobros_valores_id, tipo_operacion, tes_pagos_valores_id) VALUES (18, 'ACTIVO', '2025-10-04 08:01:56.084394', '2025-10-04 08:01:56.084394', 'fvazquez', '2024-02-10', 'S', 3000000.00, '178383892', 'CONCILIADO', 1, 4, NULL, 'EGRESOS', 2);


--
-- Data for Name: tes_debitos_creditos_bancarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_debitos_creditos_bancarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_debito, monto_total_entrada, monto_total_salida, observacion, bs_empresa_id, bs_moneda_id, cob_habilitacion_id, tes_banco_id_entrante, tes_banco_id_saliente) VALUES (2, 'ACTIVO', '2025-07-30 21:08:49.864606', '2025-07-30 21:08:49.864606', 'fvazquez', '2025-07-30', 50000.00, 50000.00, 'obervacion', 1, 1, 10, 4, 1);
INSERT INTO public.tes_debitos_creditos_bancarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_debito, monto_total_entrada, monto_total_salida, observacion, bs_empresa_id, bs_moneda_id, cob_habilitacion_id, tes_banco_id_entrante, tes_banco_id_saliente) VALUES (3, 'ACTIVO', '2025-09-11 18:54:05.895593', '2025-09-11 18:54:05.895593', 'fvazquez', '2025-09-11', 10000.00, 10000.00, 'pruaba', 1, 1, 10, 4, 1);


--
-- Data for Name: tes_depositos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (27, 'ANULADO', '2024-01-19 17:25:01.955941', '2024-01-19 17:23:31.602884', 'fvazquez', '2024-01-19', 12500.00, 99988877, 'PRUEBA DEFINITIVA', 1, 9, 1);
INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (30, 'ACTIVO', '2024-01-19 17:33:57.522029', '2024-01-19 17:33:57.522029', 'fvazquez', '2024-01-19', 12500.00, 88991736, 'PRUEBA DE VALIDACION', 1, 9, 1);
INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (31, 'ACTIVO', '2024-01-25 19:45:03.171802', '2024-01-25 19:45:03.171802', 'fvazquez', '2024-01-25', 150000.00, 881819, 'prueba', 1, 9, 1);
INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (32, 'ACTIVO', '2025-09-08 16:15:45.265922', '2025-09-08 16:15:45.265922', 'fvazquez', '2025-09-08', 109959.29, 345678, 'prueba de deposito', 1, 10, 1);


--
-- Data for Name: tes_pago_comprobante_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pago_comprobante_detalle (id, id_cuota_saldo, monto_pagado, nro_orden, tipo_comprobante, tes_pagos_cabecera_id) VALUES (2, 6, 3000000.00, 1, 'DESEMBOLSO', 3);
INSERT INTO public.tes_pago_comprobante_detalle (id, id_cuota_saldo, monto_pagado, nro_orden, tipo_comprobante, tes_pagos_cabecera_id) VALUES (3, 6, 3000000.00, 1, 'DESEMBOLSO', 4);
INSERT INTO public.tes_pago_comprobante_detalle (id, id_cuota_saldo, monto_pagado, nro_orden, tipo_comprobante, tes_pagos_cabecera_id) VALUES (4, 9, 1000000.00, 1, 'DESEMBOLSO', 5);
INSERT INTO public.tes_pago_comprobante_detalle (id, id_cuota_saldo, monto_pagado, nro_orden, tipo_comprobante, tes_pagos_cabecera_id) VALUES (9, 7, 15000.00, 1, 'FACTURA', 10);


--
-- Data for Name: tes_pagos_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pagos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, beneficiario, fecha_pago, id_beneficiario, ind_autorizado, ind_impreso, monto_total_pago, nro_pago, nro_pago_completo, observacion, tipo_operacion, bs_empresa_id, bs_talonario_id, cob_habilitacion_id) VALUES (3, 'ACTIVO', '2024-02-10 21:04:13.873714', '2024-02-10 21:04:13.873714', 'fvazquez', 'fernnado vazquez', '2024-02-10', 1, 'N', 'S', 3000000.00, 1, '001-001-000000001', 'prueba de desembolso', 'DESEMBOLSO', 1, 7, 9);
INSERT INTO public.tes_pagos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, beneficiario, fecha_pago, id_beneficiario, ind_autorizado, ind_impreso, monto_total_pago, nro_pago, nro_pago_completo, observacion, tipo_operacion, bs_empresa_id, bs_talonario_id, cob_habilitacion_id) VALUES (4, 'ACTIVO', '2025-09-06 07:53:33.381808', '2025-09-06 07:53:33.381808', 'fvazquez', 'fernnado vazquez', '2025-09-06', 1, 'N', 'N', 3000000.00, 2, '001-001-000000002', 'desembolso de credito de prueba', 'DESEMBOLSO', 1, 7, 10);
INSERT INTO public.tes_pagos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, beneficiario, fecha_pago, id_beneficiario, ind_autorizado, ind_impreso, monto_total_pago, nro_pago, nro_pago_completo, observacion, tipo_operacion, bs_empresa_id, bs_talonario_id, cob_habilitacion_id) VALUES (5, 'ACTIVO', '2025-09-08 14:45:28.709233', '2025-09-08 14:45:28.709233', 'fvazquez', 'fernnado vazquez', '2025-09-08', 1, 'N', 'S', 1000000.00, 3, '001-001-000000003', 'entrega de valor', 'DESEMBOLSO', 1, 7, 10);
INSERT INTO public.tes_pagos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, beneficiario, fecha_pago, id_beneficiario, ind_autorizado, ind_impreso, monto_total_pago, nro_pago, nro_pago_completo, observacion, tipo_operacion, bs_empresa_id, bs_talonario_id, cob_habilitacion_id) VALUES (10, 'ACTIVO', '2025-09-13 08:41:52.315763', '2025-09-13 08:41:52.315763', 'fvazquez', 'jorge analisis ', '2025-09-13', 4, 'N', 'S', 15000.00, 4, '001-001-000000004', 'pagos', 'FACTURA', 1, 7, 10);


--
-- Data for Name: tes_pagos_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pagos_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_entrega, fecha_valor, fecha_vencimiento, ind_entregado, monto_cuota, nro_orden, nro_valor, tipo_operacion, bs_empresa_id, bs_tipo_valor_id, tes_banco_id, tes_pagos_cabecera_id, ind_conciliado) VALUES (3, 'ACTIVO', '2025-09-06 07:53:33.562319', '2025-09-06 07:53:33.562319', NULL, NULL, '2025-09-06', '2025-09-06', NULL, 3000000.00, 1, '1234567', 'DESEMBOLSO', 1, 2, 3, 4, 'N');
INSERT INTO public.tes_pagos_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_entrega, fecha_valor, fecha_vencimiento, ind_entregado, monto_cuota, nro_orden, nro_valor, tipo_operacion, bs_empresa_id, bs_tipo_valor_id, tes_banco_id, tes_pagos_cabecera_id, ind_conciliado) VALUES (9, 'ACTIVO', '2025-09-13 08:41:52.672499', '2025-09-13 08:41:52.672499', NULL, NULL, '2025-09-13', '2025-09-13', NULL, 15000.00, 1, '456789', 'FACTURA', 1, 2, 1, 10, 'N');
INSERT INTO public.tes_pagos_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_entrega, fecha_valor, fecha_vencimiento, ind_entregado, monto_cuota, nro_orden, nro_valor, tipo_operacion, bs_empresa_id, bs_tipo_valor_id, tes_banco_id, tes_pagos_cabecera_id, ind_conciliado) VALUES (4, 'ACTIVO', '2025-09-08 14:45:29.072305', '2025-09-08 14:45:29.072305', NULL, NULL, '2025-09-08', '2025-09-08', NULL, 1000000.00, 1, '12345678', 'DESEMBOLSO', 1, 2, 1, 5, 'S');
INSERT INTO public.tes_pagos_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_entrega, fecha_valor, fecha_vencimiento, ind_entregado, monto_cuota, nro_orden, nro_valor, tipo_operacion, bs_empresa_id, bs_tipo_valor_id, tes_banco_id, tes_pagos_cabecera_id, ind_conciliado) VALUES (2, 'ACTIVO', '2025-10-04 08:01:56.232239', '2024-02-10 21:04:13.917314', 'fvazquez', NULL, '2024-02-10', '2024-02-10', NULL, 3000000.00, 1, '178383892', 'DESEMBOLSO', 1, 2, 1, 3, 'S');


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

INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (20, 'ACTIVO', '2025-09-13 08:34:07.850284', '2025-09-13 08:34:07.850284', 'fvazquez', '2025-09-13', 10, 'N', 'S', 0.00, 319511.43, 290464.94, 29046.49, 3, '001-002-000000003', 'desemb', 'DESEMBOLSO', 1, 2, 5, 10, 2, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (16, 'ACTIVO', '2024-01-25 19:44:24.289558', '2024-01-25 18:56:55.811218', 'fvazquez', '2024-01-25', NULL, 'S', 'S', 0.00, 150000.00, 136363.64, 13636.36, 1, '001-001-000000001', 'prueba de impresion', 'FACTURA', 1, 5, 1, 10, 1, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (19, 'ACTIVO', '2025-09-08 14:43:32.953457', '2025-09-08 14:43:32.953457', 'fvazquez', '2025-09-08', 9, 'N', 'S', 0.00, 319511.43, 290464.94, 29046.49, 2, '001-002-000000002', 'desembolso del credito', 'DESEMBOLSO', 1, 2, 1, 10, 6, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (17, 'ACTIVO', '2025-07-31 19:46:08.736989', '2025-07-31 19:46:08.736989', 'fvazquez', '2025-07-31', NULL, 'N', 'S', 0.00, 23550.00, 22428.57, 1121.43, 1, '001-002-000000001', 'Prueba de nota de credito', 'FACTURA', 1, 2, 1, 10, 2, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (21, 'ACTIVO', '2025-09-29 10:20:01.422254', '2025-09-29 10:20:01.422254', 'fvazquez', '2025-09-29', NULL, 'N', 'S', 0.00, 15000.00, 13636.36, 1363.64, 1, '001-001-000000001', 'factura contado de prueba', 'FACTURA', 1, 5, 1, 10, 1, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (18, 'ACTIVO', '2025-08-01 09:54:38.102919', '2025-08-01 09:54:38.102919', 'fvazquez', '2025-08-01', 17, 'N', 'S', 0.00, 23550.00, 22428.57, 1121.43, 1, '001-001-000000001', 'observacion', 'NCR', 1, 8, 1, 10, 5, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (22, 'ANULADO', '2025-10-20 22:21:33.160299', '2025-10-20 22:02:59.101168', 'fvazquez', '2025-10-20', 11, 'N', 'S', 0.00, 639022.87, 580929.88, 58092.99, 3, '001-002-000000003', 'desembolso de prueba', 'DESEMBOLSO', 1, 2, 23, 10, 4, 1);
INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, ind_impreso, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_habilitacion_caja_id, ven_condicion_venta_id, ven_vendedor_id) VALUES (23, 'ACTIVO', '2025-10-20 19:58:57.921263', '2025-10-20 19:58:57.921263', 'fvazquez', '2025-10-20', 11, 'N', 'S', 0.00, 639022.87, 580929.88, 58092.99, 4, '001-002-000000004', 'desembolso ', 'DESEMBOLSO', 1, 2, 23, 10, 4, 1);


--
-- Data for Name: ven_facturas_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (17, 'ACTIVO', '2024-01-25 18:56:55.903752', '2024-01-25 18:56:55.903752', 'fvazquez', 1, 'IVA10', 0.00, 136363.64, 13636.36, 150000.00, 1, 150000.00, 1, 16);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (18, 'ACTIVO', '2025-07-31 19:46:09.050055', '2025-07-31 19:46:09.050055', 'fvazquez', 1, 'IVA5', 0.00, 22428.57, 1121.43, 23550.00, 1, 23550.00, 3, 17);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (19, NULL, '2025-08-01 09:54:38.275046', '2025-08-01 09:54:38.275046', NULL, 1, 'IVA5', 0.00, 22428.57, 1121.43, 23550.00, 1, 23550.00, 3, 18);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (20, 'ACTIVO', '2025-09-08 14:43:33.082284', '2025-09-08 14:43:33.082284', 'fvazquez', 1, 'IVA10', 0.00, 290464.94, 29046.49, 319511.43, 1, 319511.43, 5, 19);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (21, 'ACTIVO', '2025-09-13 08:34:07.891323', '2025-09-13 08:34:07.891323', 'fvazquez', 1, 'IVA10', 0.00, 290464.94, 29046.49, 319511.43, 1, 319511.43, 5, 20);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (22, 'ACTIVO', '2025-09-29 10:20:01.575751', '2025-09-29 10:20:01.575751', 'fvazquez', 1, 'IVA10', 0.00, 13636.36, 1363.64, 15000.00, 1, 15000.00, 6, 21);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (23, 'ACTIVO', '2025-10-20 22:02:59.23828', '2025-10-20 22:02:59.238273', 'fvazquez', 1, 'IVA10', 0.00, 580929.88, 58092.99, 639022.87, 1, 639022.87, 5, 22);
INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (24, 'ACTIVO', '2025-10-20 19:58:57.93877', '2025-10-20 19:58:57.93877', 'fvazquez', 1, 'IVA10', 0.00, 580929.88, 58092.99, 639022.87, 1, 639022.87, 5, 23);


--
-- Data for Name: ven_vendedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_vendedores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_vendedor, bs_empresa_id, id_bs_persona) VALUES (1, 'ACTIVO', '2023-12-12 18:05:35.672767', '2023-12-12 18:05:35.672767', NULL, '1', 1, 6);


--
-- Name: bs_access_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_access_log_id_seq', 512, true);


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

SELECT pg_catalog.setval('public.bs_menu_id_seq', 67, true);


--
-- Name: bs_menu_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_menu_item_id_seq', 80, true);


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

SELECT pg_catalog.setval('public.bs_permiso_rol_id_seq', 77, true);


--
-- Name: bs_persona_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_persona_id_seq', 17, true);


--
-- Name: bs_reset_password_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_reset_password_token_id_seq', 26, true);


--
-- Name: bs_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_rol_id_seq', 9, true);


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

SELECT pg_catalog.setval('public.bs_tipo_valor_id_seq', 5, true);


--
-- Name: bs_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_usuario_id_seq', 11, true);


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

SELECT pg_catalog.setval('public.cob_clientes_id_seq', 23, true);


--
-- Name: cob_cobradores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cobradores_id_seq', 5, true);


--
-- Name: cob_cobros_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cobros_valores_id_seq', 16, true);


--
-- Name: cob_habilitaciones_cajas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_habilitaciones_cajas_id_seq', 10, true);


--
-- Name: cob_recibos_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_recibos_cabecera_id_seq', 8, true);


--
-- Name: cob_recibos_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_recibos_detalle_id_seq', 12, true);


--
-- Name: cob_saldos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_saldos_id_seq', 111, true);


--
-- Name: com_facturas_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_facturas_cabecera_id_seq', 6, true);


--
-- Name: com_facturas_detalles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_facturas_detalles_id_seq', 6, true);


--
-- Name: com_proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_proveedores_id_seq', 4, true);


--
-- Name: com_saldos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_saldos_id_seq', 7, true);


--
-- Name: cre_desembolso_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_desembolso_cabecera_id_seq', 11, true);


--
-- Name: cre_desembolso_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_desembolso_detalle_id_seq', 132, true);


--
-- Name: cre_motivos_prestamos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_motivos_prestamos_id_seq', 4, true);


--
-- Name: cre_solicitudes_creditos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_solicitudes_creditos_id_seq', 8, true);


--
-- Name: cre_tipo_amortizaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_tipo_amortizaciones_id_seq', 4, true);


--
-- Name: seq_cod_cliente; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cod_cliente', 83, true);


--
-- Name: seq_cod_cobrador; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cod_cobrador', 42, true);


--
-- Name: seq_cod_proveedor; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cod_proveedor', 41, true);


--
-- Name: seq_cod_vendedor; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cod_vendedor', 21, true);


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
-- Name: tes_bancos_saldos_historicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_bancos_saldos_historicos_id_seq', 4, true);


--
-- Name: tes_chequeras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_chequeras_id_seq', 3, true);


--
-- Name: tes_conciliaciones_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_conciliaciones_valores_id_seq', 18, true);


--
-- Name: tes_debitos_creditos_bancarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_debitos_creditos_bancarios_id_seq', 3, true);


--
-- Name: tes_depositos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_depositos_id_seq', 32, true);


--
-- Name: tes_pago_comprobante_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pago_comprobante_detalle_id_seq', 9, true);


--
-- Name: tes_pagos_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pagos_cabecera_id_seq', 10, true);


--
-- Name: tes_pagos_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pagos_valores_id_seq', 9, true);


--
-- Name: ven_condicion_ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_condicion_ventas_id_seq', 6, true);


--
-- Name: ven_facturas_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_facturas_cabecera_id_seq', 23, true);


--
-- Name: ven_facturas_detalles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_facturas_detalles_id_seq', 24, true);


--
-- Name: ven_vendedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_vendedores_id_seq', 3, true);


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
-- Name: tes_bancos_saldos_historicos tes_bancos_saldos_historicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos_saldos_historicos
    ADD CONSTRAINT tes_bancos_saldos_historicos_pkey PRIMARY KEY (id);


--
-- Name: tes_bancos_saldos_historicos tes_bancos_saldos_historicos_uk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos_saldos_historicos
    ADD CONSTRAINT tes_bancos_saldos_historicos_uk UNIQUE (tes_banco_id, fecha_saldo);


--
-- Name: tes_bancos tes_bancos_unique_persona_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos
    ADD CONSTRAINT tes_bancos_unique_persona_empresa UNIQUE (cod_banco, bs_moneda_id, bs_empresa_id, bs_persona_id);


--
-- Name: tes_chequeras tes_chequeras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_chequeras
    ADD CONSTRAINT tes_chequeras_pkey PRIMARY KEY (id);


--
-- Name: tes_chequeras tes_chequeras_unq_activa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_chequeras
    ADD CONSTRAINT tes_chequeras_unq_activa UNIQUE (bs_empresa_id, tes_banco_id, bs_tipo_valor_id, estado);


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
-- Name: tes_conciliaciones_valores trg_marcar_valor_no_conciliado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_marcar_valor_no_conciliado AFTER DELETE ON public.tes_conciliaciones_valores FOR EACH ROW EXECUTE FUNCTION public.marcar_valor_no_conciliado();

ALTER TABLE public.tes_conciliaciones_valores DISABLE TRIGGER trg_marcar_valor_no_conciliado;


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
-- Name: tes_bancos_saldos_historicos fk5aeesk9avbbi044g58lhxbkuo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos_saldos_historicos
    ADD CONSTRAINT fk5aeesk9avbbi044g58lhxbkuo FOREIGN KEY (tes_banco_id) REFERENCES public.tes_bancos(id);


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
-- Name: tes_chequeras fk9a8qe1oi36n6mdtpj1qrdn2l3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_chequeras
    ADD CONSTRAINT fk9a8qe1oi36n6mdtpj1qrdn2l3 FOREIGN KEY (bs_tipo_valor_id) REFERENCES public.bs_tipo_valor(id);


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
-- Name: tes_conciliaciones_valores fka00lotff012aqjjq0c8y8ujm1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_conciliaciones_valores
    ADD CONSTRAINT fka00lotff012aqjjq0c8y8ujm1 FOREIGN KEY (tes_pagos_valores_id) REFERENCES public.tes_pagos_valores(id);


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
-- Name: cob_cobros_valores fkiefw0p3ocg8lp0vh7i17rukrx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_cobros_valores
    ADD CONSTRAINT fkiefw0p3ocg8lp0vh7i17rukrx FOREIGN KEY (bs_persona_juridica) REFERENCES public.bs_persona(id);


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
-- Name: tes_bancos_saldos_historicos fkm4ithbvh6mssapp8bjywv8jye; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_bancos_saldos_historicos
    ADD CONSTRAINT fkm4ithbvh6mssapp8bjywv8jye FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


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
    ADD CONSTRAINT fkna4v690hqe0bqyv3l02029d81 FOREIGN KEY (cre_desembolso_cabecera_id) REFERENCES public.cre_desembolso_cabecera(id) ON DELETE CASCADE;


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
-- Name: tes_chequeras fkp0aw19mm5tjs4gokqqu8rxpie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_chequeras
    ADD CONSTRAINT fkp0aw19mm5tjs4gokqqu8rxpie FOREIGN KEY (bs_empresa_id) REFERENCES public.bs_empresas(id);


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
-- Name: tes_chequeras fktllpomuinoyey25isue9y1ghv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tes_chequeras
    ADD CONSTRAINT fktllpomuinoyey25isue9y1ghv FOREIGN KEY (tes_banco_id) REFERENCES public.tes_bancos(id);


--
-- Name: cob_recibos_detalle fkwebc0cfneqph5f2r5g4hft1t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cob_recibos_detalle
    ADD CONSTRAINT fkwebc0cfneqph5f2r5g4hft1t FOREIGN KEY (cob_saldo_id) REFERENCES public.cob_saldos(id);


--
-- PostgreSQL database dump complete
--

