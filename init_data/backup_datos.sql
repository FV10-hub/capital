--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: bs_persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, usuario_modificacion) VALUES (7, 'ACTIVO', '2023-11-27 17:29:16.776996', '2023-11-27 17:29:16.776996', '44444', 'ffff@gm.com', '1990-11-14', NULL, 'Roberto', 'Roberto Gimenez Benitez', 'Gimenez', 'Benitez', NULL);
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, usuario_modificacion) VALUES (8, 'ACTIVO', '2023-11-28 16:56:20.157804', '2023-11-28 16:56:20.157804', '55555', 'AAA@GMAIL.COM', '2000-10-21', NULL, 'ALBERTO', 'ALBERTO FERNANDEZ LOPEZ', 'FERNANDEZ', 'LOPEZ', NULL);
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, usuario_modificacion) VALUES (5, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', '777777', '', '1991-10-21', NULL, 'luis', 'luis vazquez', 'vazquez', 'lopez', NULL);
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, usuario_modificacion) VALUES (3, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', '4864105', 'fernandorafa@live.com', '1991-10-21', NULL, 'fernando', 'fernnado vazquez', 'vazquez', 'lopez', NULL);
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, usuario_modificacion) VALUES (6, 'ACTIVO', '2023-09-06 13:34:16.163056', '2023-09-06 13:34:16.163056', '888888', '', '1991-10-21', NULL, 'paula', 'paula vazquez', 'vazquez', 'lopez', NULL);
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, usuario_modificacion) VALUES (10, 'ACTIVO', '2024-01-12 20:00:17.136873', '2024-01-12 20:00:17.136873', '800099927-8', 'itau@itau.com.py', '2024-01-23', NULL, 'BANCO ITAU S.A.', 'BANCO ITAU S.A.  ', '', '', 'fvazquez');
INSERT INTO public.bs_persona (id, estado, fecha_modificacion, fecha_creacion, documento, email, fec_nacimiento, imagen, nombre, nombre_completo, primer_apellido, segundo_apellido, usuario_modificacion) VALUES (11, 'ACTIVO', '2024-02-13 16:52:03.090551', '2024-02-13 16:52:03.090474', '800029172-9', 'FFF@FFF.COM', '2024-02-01', NULL, '', ' BANCO CONTINENTAL BANCO CONTINENTAL', 'BANCO CONTINENTAL', 'BANCO CONTINENTAL', 'fvazquez');


--
-- Data for Name: bs_empresas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_empresas (id, estado, fecha_modificacion, fecha_creacion, direc_empresa, nombre_fantasia, bs_personas_id, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-11-24 16:58:47.235596', '2023-11-24 16:58:47.235596', 'Asuncion, Barrio Carmelitas', 'CAPITAL CREDITOS S.A.', 3, NULL);


--
-- Name: bs_empresas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_empresas_id_seq', 6, true);


--
-- Data for Name: bs_iva; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_iva (id, estado, fecha_modificacion, fecha_creacion, cod_iva, descripcion, porcentaje, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-11-24 15:31:55.768829', '2023-11-24 15:31:55.768829', 'IVA10', 'IVA 10', 10.00, NULL);
INSERT INTO public.bs_iva (id, estado, fecha_modificacion, fecha_creacion, cod_iva, descripcion, porcentaje, usuario_modificacion) VALUES (2, 'ACTIVO', '2023-11-24 15:32:33.140511', '2023-11-24 15:32:33.140511', 'IVA5', 'IVA 5', 21.00, NULL);
INSERT INTO public.bs_iva (id, estado, fecha_modificacion, fecha_creacion, cod_iva, descripcion, porcentaje, usuario_modificacion) VALUES (4, 'ACTIVO', '2024-01-25 19:53:16.738656', '2024-01-25 19:53:16.737648', 'EX', 'EXENTA', 0.00, 'fvazquez');


--
-- Name: bs_iva_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_iva_id_seq', 4, true);


--
-- Data for Name: bs_modulo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, codigo, icon, nombre, nro_orden, path, usuario_modificacion) VALUES (8, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'COB', 'pi pi-fw pi-phone', 'COBRANZAS', 2, 'cobranzas', NULL);
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, codigo, icon, nombre, nro_orden, path, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'BS', 'pi pi-fw pi-cog', 'MODULO BASE', 1, 'base', NULL);
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, codigo, icon, nombre, nro_orden, path, usuario_modificacion) VALUES (10, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'TES', 'pi pi-fw pi-chart-bar', 'TESORERIA', 5, 'tesoreria', NULL);
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, codigo, icon, nombre, nro_orden, path, usuario_modificacion) VALUES (9, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'CRE', 'pi pi-fw pi-wallet', 'CREDITOS', 4, 'creditos', NULL);
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, codigo, icon, nombre, nro_orden, path, usuario_modificacion) VALUES (12, 'INACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'CON', 'pi pi-fw pi-euro', 'CONTABILIDAD', 6, 'contabilidad', NULL);
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, codigo, icon, nombre, nro_orden, path, usuario_modificacion) VALUES (11, 'ACTIVO', '2023-09-12 11:00:20.633517', '2023-09-12 11:00:20.633517', 'VEN', 'pi pi-fw pi-chart-line', 'VENTAS', 3, 'ventas', NULL);
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, codigo, icon, nombre, nro_orden, path, usuario_modificacion) VALUES (13, 'ACTIVO', '2023-11-29 09:12:32.676719', '2023-11-29 09:12:32.676719', 'STO', 'pi pi-shopping-bag', 'STOCK', 7, 'stock', NULL);
INSERT INTO public.bs_modulo (id, estado, fecha_modificacion, fecha_creacion, codigo, icon, nombre, nro_orden, path, usuario_modificacion) VALUES (14, 'ACTIVO', '2024-01-12 19:31:47.085795', '2024-01-12 19:31:47.085795', 'COM', 'pi pi-shopping-cart', 'COMPRAS', 8, 'compras', 'fvazquez');


--
-- Data for Name: bs_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (41, 'Caja', 'Cajas por Usuario', 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCaja.xhtml', 8, NULL, 4);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (42, 'habilitacion caja', 'Habilitacion de Caja', 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobHabilitacionCaja.xhtml', 8, NULL, 5);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (43, 'talonario', 'Talonarios', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTalonario.xhtml', 1, NULL, 14);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (44, 'timbrado', 'Timbrados', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTimbrado.xhtml', 1, NULL, 15);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (45, 'desembolso credito', 'Desembolso de Credito', 'ITEM', 'MOVIMIENTOS', '/pages/cliente/creditos/movimientos/CreDesembolsoCredito.xhtml', 9, NULL, 4);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (46, 'Facturas', 'Facturacion', 'ITEM', 'MOVIMIENTOS', '/pages/cliente/ventas/movimientos/VenFacturas.xhtml', 11, NULL, 3);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (47, 'proveedor', 'Proveedores', 'ITEM', 'DEFINICION', '/pages/cliente/compras/definicion/ComProveedor.xhtml', 14, NULL, 1);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (48, 'banco', 'Bancos', 'ITEM', 'DEFINICION', '/pages/cliente/tesoreria/definicion/TesBanco.xhtml', 10, NULL, 1);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (49, 'ajuste inventario', 'Ajustes de Inventarios', 'ITEM', 'MOVIMIENTOS', '/pages/cliente/stock/movimientos/StoAjusteInventario.xhtml', 13, NULL, 2);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (50, 'recibos', 'Recibos', 'ITEM', 'MOVIMIENTOS', '/pages/cliente/cobranzas/movimientos/CobRecibos.xhtml', 8, NULL, 6);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (51, 'deposito', 'Depositos', 'ITEM', 'MOVIMIENTOS', '/pages/cliente/tesoreria/movimientos/TesDeposito.xhtml', 10, NULL, 2);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (3, 'Modulos', 'Modulos', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsModulo.xhrml', 1, NULL, 1);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (1, 'Usuarios', 'Usuarios', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsUsuario.xhtml', 1, NULL, 6);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (6, 'Personas', 'Personas', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsPersona.xhtml', 1, NULL, 5);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (5, 'Roles', 'Roles', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsRol.xhtml', 1, NULL, 2);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (18, 'Permisos por Pantalla', 'Permisos por Pantalla', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsPermisoRol.xhrml', 1, NULL, 4);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (17, 'Menus', 'Menus', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsMenu.xhrml', 1, NULL, 3);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (22, 'Impuestos', 'Impuestos', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsIva.xhtml', 1, NULL, 9);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (21, 'Monedas', 'Monedas', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsMoneda.xhtml', 1, NULL, 10);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (24, 'Parametros Generales', 'Parametros Generales', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsParametro.xhtml', 1, NULL, 8);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (26, 'Tipos de Comprobantes', 'Tipos de Comprobantes', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTipoComprobante.xhrml', 1, NULL, 12);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (25, 'Tipos de Valores', 'Tipos de Valores', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsTipoValor.xhrml', 1, NULL, 11);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (28, 'Cobrador', 'Cobrador', 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCobrador.xhtml', 8, NULL, 2);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (27, 'Clientes', 'Clientes', 'ITEM', 'DEFINICION', '/pages/cliente/cobranzas/definicion/CobCliente.xhtml', 8, NULL, 1);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (23, 'Empresas', 'Empresas', 'ITEM', 'DEFINICION', '/pages/cliente/base/definicion/BsEmpresa.xhtml', 1, NULL, 7);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (52, 'pago', 'Pagos/Desembolsos', 'ITEM', 'MOVIMIENTOS', '/pages/cliente/tesoreria/movimientos/TesPago.xhtml', 10, NULL, 3);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (53, 'ventas por fecha', 'Ventas por Fecha y Cliente', 'ITEM', 'REPORTES', '/pages/cliente/ventas/reportes/VenVentasPorFecha.xhtml', 11, NULL, 4);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (54, 'recibos por fecha', 'Recibos por Fecha y Cliente', 'ITEM', 'REPORTES', '/pages/cliente/cobranzas/reportes/CobRecibosPorFecha.xhtml', 8, NULL, 7);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (55, 'desembolsos por fecha', 'Desembolsos por Fecha y Cliente', 'ITEM', 'REPORTES', '/pages/cliente/creditos/reportes/CreDesembolsosPorFecha.xhtml', 9, NULL, 5);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (35, 'Condicion venta', 'Condicion venta', 'ITEM', 'DEFINICION', '/pages/cliente/ventas/definicion/VenCondicionVenta.xhtml', 11, NULL, 2);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (34, 'Vendedores', 'Vendedores', 'ITEM', 'DEFINICION', '/pages/cliente/ventas/definicion/VenVendedor.xhtml', 11, NULL, 1);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (36, 'Articulos', 'Articulos', 'ITEM', 'DEFINICION', '/pages/cliente/stock/definicion/StoArticulo.xhtml', 13, NULL, 1);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (37, 'Reporte Permisos Rol por Fecha', 'Reporte Permisos Rol por Fecha', 'ITEM', 'REPORTES', '/pages/cliente/base/reportes/BsPermisoRolPorFechaCreacion.xhtml', 1, NULL, 13);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (38, 'Tipo Amortizacion', 'Tipo Amortizacion', 'ITEM', 'DEFINICION', '/pages/cliente/creditos/definicion/CreTipoAmortizacion.xhtml', 9, NULL, 1);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (39, 'Motivo Prestamo', 'Motivo Prestamo', 'ITEM', 'DEFINICION', '/pages/cliente/creditos/definicion/CreMotivoPrestamo.xhtml', 9, NULL, 2);
INSERT INTO public.bs_menu (id, label, nombre, tipo_menu, tipo_menu_agrupador, url, id_bs_modulo, id_sub_menu, nro_orden) VALUES (40, 'Solicitud de Credito', 'Solicitud de Credito', 'ITEM', 'MOVIMIENTOS', '/pages/cliente/creditos/movimientos/CreSolicitudCredito.xhtml', 9, NULL, 3);


--
-- Name: bs_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_menu_id_seq', 55, true);


--
-- Data for Name: bs_menu_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (8, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (9, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (2, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', 'pi pi-fw pi-ellipsis-v', 1, '2', 'MENU', 'Modulos', 3, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (3, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', 'pi pi-fw pi-ellipsis-v', 1, '3', 'MENU', 'Persona', 6, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (4, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', 'pi pi-fw pi-ellipsis-v', 1, '5', 'MENU', 'Roles', 5, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (5, 'ACTIVO', '2023-09-07 15:50:37.3643', '2023-09-07 15:50:37.3643', 'pi pi-fw pi-ellipsis-v', 1, '7', 'MENU', 'Usuarios', 1, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (11, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (12, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (13, 'ACTIVO', '2023-09-12 11:00:20.634787', '2023-09-12 11:00:20.634787', 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (14, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 9, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (15, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 9, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (16, 'ACTIVO', '2023-09-12 11:07:39.391324', '2023-09-12 11:07:39.391324', 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 9, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (17, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 10, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (18, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 10, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (19, 'ACTIVO', '2023-09-12 11:08:05.35026', '2023-09-12 11:08:05.35026', 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 10, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (20, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 11, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (21, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 11, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (22, 'ACTIVO', '2023-09-12 11:08:24.480826', '2023-09-12 11:08:24.480826', 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 11, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (23, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 12, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (24, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 12, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (25, 'ACTIVO', '2023-09-12 11:08:43.801027', '2023-09-12 11:08:43.801027', 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 12, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (27, 'ACTIVO', '2023-09-12 13:38:42.593191', '2023-09-12 13:38:42.593191', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Permisos por Pantalla', 18, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (26, 'ACTIVO', '2023-09-12 13:31:52.496447', '2023-09-12 13:31:52.496447', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Menus', 17, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (28, 'ACTIVO', '2023-11-23 11:49:39.706615', '2023-11-23 11:49:39.706615', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Monedas', 21, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (29, 'ACTIVO', '2023-11-24 15:29:19.649737', '2023-11-24 15:29:19.649737', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Impuestos', 22, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (30, 'ACTIVO', '2023-11-24 16:54:32.841298', '2023-11-24 16:54:32.841298', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Empresas', 23, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (31, 'ACTIVO', '2023-11-27 10:33:13.73056', '2023-11-27 10:33:13.73056', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Parametros Generales', 24, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (32, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 13, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (33, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 13, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (34, 'ACTIVO', '2023-11-29 09:12:32.718588', '2023-11-29 09:12:32.718588', 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 13, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (35, 'ACTIVO', '2023-11-30 16:50:59.51816', '2023-11-30 16:50:59.51816', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Tipos de Valores', 25, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (36, 'ACTIVO', '2023-11-30 16:51:34.092384', '2023-11-30 16:51:34.092384', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Tipos de Comprobantes', 26, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (37, 'ACTIVO', '2023-12-01 11:15:49.877244', '2023-12-01 11:15:49.877244', 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Clientes', 27, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (38, 'ACTIVO', '2023-12-01 11:16:28.895258', '2023-12-01 11:16:28.895258', 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Cobrador', 28, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (65, 'ACTIVO', '2024-01-22 12:05:39.357153', '2024-01-22 12:05:39.357153', 'pi pi-fw pi-ellipsis-v', 18, NULL, 'MENU', 'Pagos/Desembolsos', 52, 10, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (44, 'ACTIVO', '2023-12-12 17:55:18.715526', '2023-12-12 17:55:18.715526', 'pi pi-fw pi-ellipsis-v', 20, NULL, 'MENU', 'Vendedores', 34, 11, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (45, 'ACTIVO', '2023-12-12 17:59:18.370812', '2023-12-12 17:59:18.370812', 'pi pi-fw pi-ellipsis-v', 20, NULL, 'MENU', 'Condicion venta', 35, 11, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (46, 'ACTIVO', '2023-12-12 18:00:14.048414', '2023-12-12 18:00:14.048414', 'pi pi-fw pi-ellipsis-v', 32, NULL, 'MENU', 'Articulos', 36, 13, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (47, 'ACTIVO', '2023-12-15 14:28:00.440027', '2023-12-15 14:28:00.440027', 'pi pi-fw pi-ellipsis-v', 9, NULL, 'MENU', 'Reporte Permisos Rol por Fecha', 37, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (48, 'ACTIVO', '2023-12-27 10:45:07.453953', '2023-12-27 10:45:07.453953', 'pi pi-fw pi-ellipsis-v', 14, NULL, 'MENU', 'Tipo Amortizacion', 38, 9, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (49, 'ACTIVO', '2023-12-27 10:45:44.742158', '2023-12-27 10:45:44.742158', 'pi pi-fw pi-ellipsis-v', 14, NULL, 'MENU', 'Motivo Prestamo', 39, 9, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (50, 'ACTIVO', '2023-12-27 15:23:23.074387', '2023-12-27 15:23:23.074387', 'pi pi-fw pi-ellipsis-v', 15, NULL, 'MENU', 'Solicitud de Credito', 40, 9, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (51, 'ACTIVO', '2023-12-28 15:47:02.363933', '2023-12-28 15:47:02.363933', 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Cajas por Usuario', 41, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (52, 'ACTIVO', '2023-12-28 15:48:50.792045', '2023-12-28 15:48:50.792045', 'pi pi-fw pi-ellipsis-v', 11, NULL, 'MENU', 'Habilitacion de Caja', 42, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (53, 'ACTIVO', '2024-01-02 17:15:09.117451', '2024-01-02 17:15:09.117451', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Talonarios', 43, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (54, 'ACTIVO', '2024-01-02 17:15:25.935552', '2024-01-02 17:15:25.935552', 'pi pi-fw pi-ellipsis-v', 1, NULL, 'MENU', 'Timbrados', 44, 1, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (55, 'ACTIVO', '2024-01-04 14:20:34.987513', '2024-01-04 14:20:34.987513', 'pi pi-fw pi-ellipsis-v', 15, NULL, 'MENU', 'Desembolso de Credito', 45, 9, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (56, 'ACTIVO', '2024-01-10 15:28:27.608602', '2024-01-10 15:28:27.608602', 'pi pi-fw pi-ellipsis-v', 21, NULL, 'MENU', 'Facturacion', 46, 11, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (57, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', 'pi pi-fw pi-list', NULL, NULL, 'DEFINICION', 'Definiciones', NULL, 14, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (58, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', 'pi pi-fw pi-box', NULL, NULL, 'MOVIMIENTOS', 'Movimientos', NULL, 14, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (59, 'ACTIVO', '2024-01-12 19:31:47.210674', '2024-01-12 19:31:47.210674', 'pi pi-fw pi-print', NULL, NULL, 'REPORTES', 'Reportes', NULL, 14, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (60, 'ACTIVO', '2024-01-12 19:32:22.264846', '2024-01-12 19:32:22.264846', 'pi pi-fw pi-ellipsis-v', 57, NULL, 'MENU', 'Proveedores', 47, 14, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (61, 'ACTIVO', '2024-01-12 19:32:47.387516', '2024-01-12 19:32:47.387516', 'pi pi-fw pi-ellipsis-v', 17, NULL, 'MENU', 'Bancos', 48, 10, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (62, 'ACTIVO', '2024-01-12 23:34:38.56794', '2024-01-12 23:34:38.56794', 'pi pi-fw pi-ellipsis-v', 33, NULL, 'MENU', 'Ajustes de Inventarios', 49, 13, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (63, 'ACTIVO', '2024-01-15 16:44:38.482895', '2024-01-15 16:44:38.482895', 'pi pi-fw pi-ellipsis-v', 12, NULL, 'MENU', 'Recibos', 50, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (64, 'ACTIVO', '2024-01-18 15:24:21.817528', '2024-01-18 15:24:21.817528', 'pi pi-fw pi-ellipsis-v', 18, NULL, 'MENU', 'Depositos', 51, 10, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (66, 'ACTIVO', '2024-02-12 12:11:15.227474', '2024-02-12 12:11:15.227474', 'pi pi-fw pi-ellipsis-v', 22, NULL, 'MENU', 'Ventas por Fecha y Cliente', 53, 11, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (67, 'ACTIVO', '2024-02-13 08:38:38.543221', '2024-02-13 08:38:38.543221', 'pi pi-fw pi-ellipsis-v', 13, NULL, 'MENU', 'Recibos por Fecha y Cliente', 54, 8, NULL);
INSERT INTO public.bs_menu_item (id, estado, fecha_modificacion, fecha_creacion, icon, id_menu_item, nro_orden, tipo_menu, titulo, id_bs_menu, id_bs_modulo, usuario_modificacion) VALUES (68, 'ACTIVO', '2024-02-13 10:31:29.805258', '2024-02-13 10:31:29.805258', 'pi pi-fw pi-ellipsis-v', 16, NULL, 'MENU', 'Desembolsos por Fecha y Cliente', 55, 9, NULL);


--
-- Name: bs_menu_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_menu_item_id_seq', 68, true);


--
-- Name: bs_modulo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_modulo_id_seq', 14, true);


--
-- Data for Name: bs_moneda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_moneda (id, estado, fecha_modificacion, fecha_creacion, cod_moneda, decimales, descripcion, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-11-23 15:30:46.655571', '2023-11-23 15:30:46.655571', 'GS', 0, 'GUARANIES', NULL);
INSERT INTO public.bs_moneda (id, estado, fecha_modificacion, fecha_creacion, cod_moneda, decimales, descripcion, usuario_modificacion) VALUES (2, 'ACTIVO', '2023-11-23 15:31:02.869325', '2023-11-23 15:31:02.869325', 'USD', 2, 'DOLARES', NULL);


--
-- Name: bs_moneda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_moneda_id_seq', 5, true);


--
-- Data for Name: bs_parametros; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, descripcion, parametro, valor, bs_modulo_id, bs_empresa_id, usuario_modificacion) VALUES (2, 'ACTIVO', '2023-11-27 10:44:52.649203', '2023-11-27 10:44:52.649203', 'Parametro de prueba', 'BSPARAMETRO', 'valor_prueba', 8, 1, NULL);
INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, descripcion, parametro, valor, bs_modulo_id, bs_empresa_id, usuario_modificacion) VALUES (3, 'ACTIVO', '2024-01-04 16:44:15.211679', '2024-01-04 16:44:15.211679', 'Parametro para la taza anual', 'TAZANUAL', '35', 9, 1, 'fvazquez');
INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, descripcion, parametro, valor, bs_modulo_id, bs_empresa_id, usuario_modificacion) VALUES (4, 'ACTIVO', '2024-01-04 16:44:49.039995', '2024-01-04 16:44:49.039995', 'Parametro para taza mora', 'TAZAMORA', '3', 9, 1, 'fvazquez');
INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, descripcion, parametro, valor, bs_modulo_id, bs_empresa_id, usuario_modificacion) VALUES (5, 'ACTIVO', '2024-01-05 11:38:13.821259', '2024-01-05 11:38:13.819816', 'Articulo utilizado para cuotas de creditos', 'CUO', 'CUO', 9, 1, 'fvazquez');
INSERT INTO public.bs_parametros (id, estado, fecha_modificacion, fecha_creacion, descripcion, parametro, valor, bs_modulo_id, bs_empresa_id, usuario_modificacion) VALUES (6, 'ACTIVO', '2024-01-11 16:59:13.972738', '2024-01-11 16:59:13.972738', 'CONDICION VENTA PARA DESEMBOLSO', 'CREDES', 'CREDES', 11, 1, 'fvazquez');


--
-- Name: bs_parametros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_parametros_id_seq', 6, true);


--
-- Data for Name: bs_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, nombre, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-09-05 16:16:21.69327', '2023-09-05 16:16:21.69327', 'USER', NULL);
INSERT INTO public.bs_rol (id, estado, fecha_modificacion, fecha_creacion, nombre, usuario_modificacion) VALUES (3, 'ACTIVO', '2023-09-05 16:16:21.69327', '2023-09-05 16:16:21.69327', 'ADMIN', NULL);


--
-- Data for Name: bs_permiso_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (8, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', 'PERMISOS', 17, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (9, NULL, '2023-11-23 11:51:21.950434', '2023-11-23 11:51:21.950434', 'PERMISOS', 21, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (10, NULL, '2023-11-24 15:29:43.718738', '2023-11-24 15:29:43.718738', 'PERMISOS', 22, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (11, NULL, '2023-11-24 16:54:52.131547', '2023-11-24 16:54:52.131547', 'PERMISOS', 23, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (12, NULL, '2023-11-27 10:33:34.230844', '2023-11-27 10:33:34.230844', 'PERMISOS', 24, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (13, NULL, '2023-11-30 16:52:29.634115', '2023-11-30 16:52:29.634115', 'PERMISOS', 25, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (14, NULL, '2023-11-30 16:52:51.769645', '2023-11-30 16:52:51.769645', 'PERMISOS', 26, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (15, NULL, '2023-12-01 11:17:03.421675', '2023-12-01 11:17:03.421675', 'PERMISOS', 27, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (16, NULL, '2023-12-01 11:17:14.116104', '2023-12-01 11:17:14.116104', 'PERMISOS', 28, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (19, NULL, '2023-12-12 18:01:33.25567', '2023-12-12 18:01:33.25567', 'PERMISOS', 34, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (20, NULL, '2023-12-12 18:01:46.00111', '2023-12-12 18:01:46.00111', 'PERMISOS', 35, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (21, NULL, '2023-12-12 18:01:59.948197', '2023-12-12 18:01:59.948197', 'PERMISOS', 36, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (4, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', 'PERMISOS', 3, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (3, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', 'PERMISOS', 1, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (6, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', 'PERMISOS', 6, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (5, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', 'PERMISOS', 5, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (7, NULL, '2023-09-12 16:13:00.043005', '2023-09-12 16:13:00.043005', 'PERMISOS', 18, 1, NULL);
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (22, NULL, '2023-12-15 14:28:38.729036', '2023-12-15 14:28:38.729036', 'PERMISOS', 37, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (23, NULL, '2023-12-27 10:46:00.953943', '2023-12-27 10:46:00.953943', 'PERMISOS', 38, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (24, NULL, '2023-12-27 10:46:33.184631', '2023-12-27 10:46:33.184631', 'PERMISOS', 39, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (25, NULL, '2023-12-27 15:23:39.717078', '2023-12-27 15:23:39.717078', 'PERMISOS', 40, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (26, NULL, '2023-12-28 15:51:14.130045', '2023-12-28 15:51:14.130045', 'PERMISOS', 41, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (27, NULL, '2023-12-28 15:51:23.954357', '2023-12-28 15:51:23.954357', 'PERMISOS', 42, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (28, NULL, '2024-01-02 17:15:37.563449', '2024-01-02 17:15:37.563449', 'PERMISOS', 43, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (29, NULL, '2024-01-02 17:15:44.727419', '2024-01-02 17:15:44.727419', 'PERMISOS', 44, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (30, NULL, '2024-01-04 14:20:54.989778', '2024-01-04 14:20:54.989778', 'PERMISOS', 45, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (31, NULL, '2024-01-10 15:28:41.518061', '2024-01-10 15:28:41.518061', 'PERMISOS', 46, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (32, NULL, '2024-01-12 19:33:02.007685', '2024-01-12 19:33:02.007685', 'PERMISOS', 47, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (33, NULL, '2024-01-12 19:33:16.864186', '2024-01-12 19:33:16.864186', 'PERMISOS', 48, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (34, NULL, '2024-01-12 23:34:55.585819', '2024-01-12 23:34:55.585819', 'PERMISOS', 49, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (35, NULL, '2024-01-15 16:44:48.73731', '2024-01-15 16:44:48.73731', 'PERMISOS', 50, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (36, NULL, '2024-01-18 15:24:34.353535', '2024-01-18 15:24:34.353535', 'PERMISOS', 51, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (37, NULL, '2024-01-22 12:05:51.580568', '2024-01-22 12:05:51.580568', 'PERMISOS', 52, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (38, NULL, '2024-02-12 12:11:27.075193', '2024-02-12 12:11:27.075193', 'PERMISOS', 53, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (39, NULL, '2024-02-13 08:38:51.666126', '2024-02-13 08:38:51.666126', 'PERMISOS', 54, 1, 'fvazquez');
INSERT INTO public.bs_permiso_rol (id, estado, fecha_modificacion, fecha_creacion, descripcion, id_bs_menu, id_bs_rol, usuario_modificacion) VALUES (40, NULL, '2024-02-13 10:33:26.581093', '2024-02-13 10:33:26.581093', 'PERMISOS', 55, 1, 'fvazquez');


--
-- Name: bs_permiso_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_permiso_rol_id_seq', 40, true);


--
-- Name: bs_persona_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_persona_id_seq', 11, true);


--
-- Name: bs_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_rol_id_seq', 3, true);


--
-- Data for Name: bs_timbrados; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_timbrados (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_establecimiento, cod_expedicion, fecha_vigencia_desde, fecha_vigencia_hasta, ind_autoimpresor, nro_desde, nro_hasta, nro_timbrado, bs_empresa_id) VALUES (2, 'ACTIVO', '2024-01-02 17:23:52.428487', '2024-01-02 17:23:40.71023', 'fvazquez', '001', '002', '2024-01-02', '2024-01-31', 'N', 1.00, 999.00, 1234567.00, 1);
INSERT INTO public.bs_timbrados (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_establecimiento, cod_expedicion, fecha_vigencia_desde, fecha_vigencia_hasta, ind_autoimpresor, nro_desde, nro_hasta, nro_timbrado, bs_empresa_id) VALUES (3, 'ACTIVO', '2024-01-05 16:48:54.262894', '2024-01-05 16:48:54.262894', 'fvazquez', '001', '001', '2024-01-01', '2024-12-31', 'N', 1.00, 999999.00, 12345678.00, 1);


--
-- Data for Name: bs_tipo_comprobantes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id, usuario_modificacion) VALUES (3, 'ACTIVO', '2024-01-05 16:48:14.975214', '2024-01-05 16:48:14.975214', 'DES', 'DESEMBOLSO', 'S', NULL, 1, 9, 'fvazquez');
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id, usuario_modificacion) VALUES (1, 'ACTIVO', '2024-01-10 20:04:19.190016', '2023-11-30 17:18:44.250534', 'CRE', 'CREDITO', 'S', NULL, 1, 11, 'fvazquez');
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id, usuario_modificacion) VALUES (4, 'ACTIVO', '2024-01-16 09:23:16.25807', '2024-01-16 09:23:16.25807', 'REC', 'RECIBOS', 'N', NULL, 1, 8, 'fvazquez');
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id, usuario_modificacion) VALUES (2, 'ACTIVO', '2024-01-10 20:04:04.092481', '2023-11-30 17:19:17.294537', 'CON', 'CONTADO', 'N', NULL, 1, 11, 'fvazquez');
INSERT INTO public.bs_tipo_comprobantes (id, estado, fecha_modificacion, fecha_creacion, cod_tip_comprobante, descripcion, ind_saldo, ind_stock, bs_empresa_id, bs_modulo_id, usuario_modificacion) VALUES (5, 'ACTIVO', '2024-01-22 16:28:43.614046', '2024-01-22 16:28:43.614046', 'PAG', 'PAGOS', 'S', NULL, 1, 10, 'fvazquez');


--
-- Data for Name: bs_talonarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (2, 'ACTIVO', '2024-01-02 17:28:26.527748', '2024-01-02 17:28:26.527748', 'fvazquez', 2, 1);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (3, 'ACTIVO', '2024-01-05 16:51:03.274948', '2024-01-05 16:51:03.274948', 'fvazquez', 3, 3);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (5, 'ACTIVO', '2024-01-10 20:04:52.046571', '2024-01-10 20:04:52.046571', 'fvazquez', 3, 2);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (6, 'ACTIVO', '2024-01-16 09:23:26.311944', '2024-01-16 09:23:26.311944', 'fvazquez', 3, 4);
INSERT INTO public.bs_talonarios (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, bs_timbrado_id, bs_tipo_comprobante_id) VALUES (7, 'ACTIVO', '2024-01-22 16:28:54.537469', '2024-01-22 16:28:54.537469', 'fvazquez', 3, 5);


--
-- Name: bs_talonarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_talonarios_id_seq', 7, true);


--
-- Name: bs_timbrados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_timbrados_id_seq', 3, true);


--
-- Name: bs_tipo_comprobantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_tipo_comprobantes_id_seq', 5, true);


--
-- Data for Name: bs_tipo_valor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_tipo_valor (id, estado, fecha_modificacion, fecha_creacion, cod_tipo, descripcion, usa_efectivo, bs_empresa_id, id_bs_modulo, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-11-30 17:05:15.727047', '2023-11-30 17:05:15.727047', 'EFE', 'EFECTIVO', 'S', 1, 8, NULL);
INSERT INTO public.bs_tipo_valor (id, estado, fecha_modificacion, fecha_creacion, cod_tipo, descripcion, usa_efectivo, bs_empresa_id, id_bs_modulo, usuario_modificacion) VALUES (2, 'ACTIVO', '2023-11-30 17:09:37.933158', '2023-11-30 17:09:37.933158', 'CHE', 'CHEQUE', 'N', 1, 8, NULL);


--
-- Name: bs_tipo_valor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_tipo_valor_id_seq', 3, true);


--
-- Data for Name: bs_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, cod_usuario, password, id_bs_persona, id_bs_rol, bs_empresa_id, usuario_modificacion) VALUES (4, 'ACTIVO', '2023-11-27 17:29:54.032836', '2023-11-27 17:29:54.032836', 'rgimenez', 'oqgJiaeLzGWnEayCcEI6XeycqqhKVVznqZdi78Ep0OaL6XA0q0cP+XZ1/sY4OHmP', 7, 1, 1, NULL);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, cod_usuario, password, id_bs_persona, id_bs_rol, bs_empresa_id, usuario_modificacion) VALUES (5, 'ACTIVO', '2023-11-28 17:09:33.989613', '2023-11-28 17:09:33.989613', 'afernandez', 'un8ovPVuGDRyVA9KUkGZCGKgpNR0PfihZuJfPLHHQtfw9e97ZniQIpWZDtbHJ+aO', 8, 1, 1, NULL);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, cod_usuario, password, id_bs_persona, id_bs_rol, bs_empresa_id, usuario_modificacion) VALUES (3, 'ACTIVO', '2023-09-07 13:28:08.054202', '2023-09-07 13:28:08.054202', 'PRAFAELLA', 'un8ovPVuGDRyVA9KUkGZCGKgpNR0PfihZuJfPLHHQtfw9e97ZniQIpWZDtbHJ+aO', 6, 3, 1, NULL);
INSERT INTO public.bs_usuario (id, estado, fecha_modificacion, fecha_creacion, cod_usuario, password, id_bs_persona, id_bs_rol, bs_empresa_id, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-09-07 13:28:08.054202', '2023-09-07 13:28:08.054202', 'fvazquez', 'un8ovPVuGDRyVA9KUkGZCGKgpNR0PfihZuJfPLHHQtfw9e97ZniQIpWZDtbHJ+aO', 3, 1, 1, NULL);


--
-- Name: bs_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bs_usuario_id_seq', 5, true);


--
-- Data for Name: cob_cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_caja, bs_empresa_id, bs_usuario_id) VALUES (17, 'ACTIVO', '2023-12-29 15:51:26.367354', '2023-12-29 15:51:26.367354', 'fvazquez', 'FVAZQUEZ', 1, 1);


--
-- Name: cob_cajas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cajas_id_seq', 26, true);


--
-- Data for Name: cob_clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_clientes (id, estado, fecha_modificacion, fecha_creacion, cod_cliente, bs_empresa_id, id_bs_persona, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-12-01 11:23:36.837974', '2023-12-01 11:23:36.837974', 'FV10', 1, 3, NULL);
INSERT INTO public.cob_clientes (id, estado, fecha_modificacion, fecha_creacion, cod_cliente, bs_empresa_id, id_bs_persona, usuario_modificacion) VALUES (4, 'ACTIVO', '2023-12-01 11:57:11.658446', '2023-12-01 11:57:11.658446', 'LUIs', 1, 5, NULL);
INSERT INTO public.cob_clientes (id, estado, fecha_modificacion, fecha_creacion, cod_cliente, bs_empresa_id, id_bs_persona, usuario_modificacion) VALUES (5, 'ACTIVO', '2023-12-29 15:51:05.052154', '2023-12-29 15:51:05.052154', 'eded', 1, 8, 'fvazquez');


--
-- Name: cob_clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_clientes_id_seq', 5, true);


--
-- Data for Name: cob_cobradores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cobradores (id, estado, fecha_modificacion, fecha_creacion, cod_cobrador, bs_empresa_id, id_bs_persona, usuario_modificacion) VALUES (2, 'ACTIVO', '2023-12-01 11:30:01.723144', '2023-12-01 11:30:01.723144', 'FV10COB', 1, 3, NULL);
INSERT INTO public.cob_cobradores (id, estado, fecha_modificacion, fecha_creacion, cod_cobrador, bs_empresa_id, id_bs_persona, usuario_modificacion) VALUES (3, 'ACTIVO', '2023-12-01 12:22:18.62225', '2023-12-01 12:22:18.62225', 'pau', 1, 6, NULL);


--
-- Name: cob_cobradores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cobradores_id_seq', 3, true);


--
-- Data for Name: cob_habilitaciones_cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_habilitaciones_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_apertura, fecha_cierre, hora_apertura, hora_cierre, ind_cerrado, nro_habilitacion, bs_usuario_id, bs_cajas_id) VALUES (8, 'ACTIVO', '2023-12-29 15:51:53.335839', '2023-12-29 15:51:37.190834', 'fvazquez', '2023-12-29 15:51:32.93391', '2023-12-29 15:51:53.314767', '15:51:32', '15:51:53', 'S', 1.00, 1, 17);
INSERT INTO public.cob_habilitaciones_cajas (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_apertura, fecha_cierre, hora_apertura, hora_cierre, ind_cerrado, nro_habilitacion, bs_usuario_id, bs_cajas_id) VALUES (9, 'ACTIVO', '2024-01-19 18:28:37.647924', '2024-01-15 16:48:58.618427', 'fvazquez', '2024-01-15 16:48:56.191648', NULL, '16:48:56', NULL, 'N', 2.00, 1, 17);


--
-- Data for Name: tes_bancos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_bancos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, saldo_cuenta, cod_banco, bs_empresa_id, bs_moneda_id, bs_persona_id) VALUES (3, 'ACTIVO', '2024-01-12 20:13:53.773426', '2024-01-12 20:13:53.773426', 'fvazquez', 15000.00, '8000299281', 1, 2, 10);
INSERT INTO public.tes_bancos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, saldo_cuenta, cod_banco, bs_empresa_id, bs_moneda_id, bs_persona_id) VALUES (1, 'ACTIVO', '2024-01-12 20:12:51.442285', '2024-01-12 20:12:51.442285', 'fvazquez', 13665000.00, '8000299281', 1, 1, 10);


--
-- Data for Name: tes_depositos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (27, 'ANULADO', '2024-01-19 17:25:01.955941', '2024-01-19 17:23:31.602884', 'fvazquez', '2024-01-19', 12500.00, 99988877, 'PRUEBA DEFINITIVA', 1, 9, 1);
INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (30, 'ACTIVO', '2024-01-19 17:33:57.522029', '2024-01-19 17:33:57.522029', 'fvazquez', '2024-01-19', 12500.00, 88991736, 'PRUEBA DE VALIDACION', 1, 9, 1);
INSERT INTO public.tes_depositos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, monto_total_deposito, nro_boleta, observacion, bs_empresa_id, cob_habilitacion_id, tes_banco_id) VALUES (31, 'ACTIVO', '2024-01-25 19:45:03.171802', '2024-01-25 19:45:03.171802', 'fvazquez', '2024-01-25', 150000.00, 881819, 'prueba', 1, 9, 1);


--
-- Data for Name: cob_cobros_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_cobros_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, fecha_valor, fecha_vencimiento, id_comprobante, ind_depositado, monto_cuota, nro_comprobante_completo, nro_orden, nro_valor, tipo_comprobante, bs_empresa_id, bs_tipo_valor_id, tes_deposito_id) VALUES (10, 'ACTIVO', '2024-01-19 17:33:57.560512', '2024-01-18 11:14:53.80722', 'fvazquez', '2024-01-19', '2024-01-18', '2024-01-18', 7, 'S', 12500.00, '001-001-000000003', 1, '0', 'RECIBO', 1, 1, 30);
INSERT INTO public.cob_cobros_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_deposito, fecha_valor, fecha_vencimiento, id_comprobante, ind_depositado, monto_cuota, nro_comprobante_completo, nro_orden, nro_valor, tipo_comprobante, bs_empresa_id, bs_tipo_valor_id, tes_deposito_id) VALUES (15, 'ACTIVO', '2024-01-25 19:45:03.19408', '2024-01-25 19:44:24.332655', 'fvazquez', '2024-01-25', '2024-01-25', '2024-01-25', 16, 'S', 150000.00, '001-001-000000001', 1, '0', 'FACTURA', 1, 1, 31);


--
-- Name: cob_cobros_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_cobros_valores_id_seq', 15, true);

--
-- Name: cob_habilitaciones_cajas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_habilitaciones_cajas_id_seq', 9, true);


--
-- Data for Name: cob_recibos_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, monto_total_recibo, nro_recibo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id, nro_recibo_completo, ind_impreso, ind_cobrado) VALUES (6, 'ACTIVO', '2024-01-16 14:40:47.031068', '2024-01-16 14:40:47.031068', 'fvazquez', '2024-01-16', 989633.58, 2, 'dede', 1, 6, 1, 3, 9, '001-001-000000002', 'N', 'N');
INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, monto_total_recibo, nro_recibo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id, nro_recibo_completo, ind_impreso, ind_cobrado) VALUES (5, 'ACTIVO', '2024-01-16 14:39:55.275965', '2024-01-16 14:39:55.275965', 'fvazquez', '2024-01-16', 329877.86, 1, 'dede', 1, 6, 1, 3, 9, '001-001-000000001', 'N', 'N');
INSERT INTO public.cob_recibos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_recibo, monto_total_recibo, nro_recibo, observacion, bs_empresa_id, bs_talonario_id, cob_cliente_id, cob_cobrador_id, cob_habilitacion_id, nro_recibo_completo, ind_impreso, ind_cobrado) VALUES (7, 'ACTIVO', '2024-01-18 11:14:53.620988', '2024-01-18 11:14:53.620988', 'fvazquez', '2024-01-18', 12500.00, 3, 'PRUEBA DE COBRO', 1, 6, 1, 3, 9, '001-001-000000003', 'S', 'N');


--
-- Name: cob_recibos_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_recibos_cabecera_id_seq', 7, true);


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


--
-- Data for Name: cob_recibos_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (8, 1, 0, 26, 329877.86, 1, 5, 26);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (9, 1, 0, 27, 329877.86, 1, 6, 27);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (10, 1, 0, 28, 329877.86, 2, 6, 28);
INSERT INTO public.cob_recibos_detalle (id, cantidad, dias_atraso, id_cuota_saldo, monto_pagado, nro_orden, cob_recibos_cabecera_id, cob_saldo_id) VALUES (11, 1, 1, 39, 12500.00, 1, 7, 39);


--
-- Name: cob_recibos_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_recibos_detalle_id_seq', 11, true);


--
-- Name: cob_saldos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cob_saldos_id_seq', 50, true);


--
-- Data for Name: com_proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.com_proveedores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_proveedor, bs_empresa_id, bs_persona_id) VALUES (1, 'ACTIVO', '2024-01-12 19:49:38.255322', '2024-01-12 19:49:38.255322', 'fvazquez', 'PP', 1, 7);


--
-- Name: com_proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.com_proveedores_id_seq', 2, true);


--
-- Data for Name: cre_motivos_prestamos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (1, 'ACTIVO', '2023-12-27 11:13:34.866513', '2023-12-27 11:12:56.302497', 'fvazquez', '01', 'VIVIENDA');
INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (2, 'ACTIVO', '2023-12-27 11:14:06.851146', '2023-12-27 11:14:06.851146', 'fvazquez', '02', 'VEHICULO');
INSERT INTO public.cre_motivos_prestamos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_motivo, descripcion) VALUES (3, 'ACTIVO', '2023-12-27 11:14:16.114921', '2023-12-27 11:14:16.114921', 'fvazquez', '03', 'CONSUMO');


--
-- Data for Name: ven_vendedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_vendedores (id, estado, fecha_modificacion, fecha_creacion, cod_vendedor, bs_empresa_id, id_bs_persona, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-12-12 18:05:35.672767', '2023-12-12 18:05:35.672767', 'VEN', 1, 6, NULL);


--
-- Data for Name: cre_solicitudes_creditos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id, ind_autorizado, ind_desembolsado) VALUES (3, 'ACTIVO', '2023-12-29 15:53:05.571648', '2023-12-29 15:52:53.899229', 'fvazquez', '2023-12-29', 2000000.00, 2000000.00, 12, '2023-12-31', 1, 5, 1, 1, 'S', 'S');
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id, ind_autorizado, ind_desembolsado) VALUES (2, 'ACTIVO', '2023-12-27 17:56:54.625092', '2023-12-27 17:56:04.757176', 'fvazquez', '2023-12-27', 2000000.00, 2500000.00, 12, '2023-12-31', 1, 4, 2, 1, 'S', 'S');
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id, ind_autorizado, ind_desembolsado) VALUES (4, 'ACTIVO', '2024-01-11 17:11:35.156332', '2024-01-11 17:00:06.956275', 'fvazquez', '2024-01-11', 3000000.00, 3000000.00, 12, '2024-01-31', 1, 1, 2, 1, 'S', 'S');
INSERT INTO public.cre_solicitudes_creditos (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_solicitud, monto_aprobado, monto_solicitado, plazo, primer_vencimiento, bs_empresa_id, cob_cliente_id, cre_motivos_prestamos_id, ven_vendedor_id, ind_autorizado, ind_desembolsado) VALUES (5, 'ACTIVO', '2024-12-16 12:16:03.804271', '2024-12-16 12:15:48.919972', 'fvazquez', '2024-12-16', 1500000.00, 1500000.00, 12, '2024-12-31', 1, 4, 3, 1, 'S', 'N');


--
-- Data for Name: cre_tipo_amortizaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_tipo_amortizaciones (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion) VALUES (2, 'ACTIVO', '2023-12-27 11:01:12.871061', '2023-12-27 11:01:12.871061', 'fvazquez', 'AME', 'AMERICANO');
INSERT INTO public.cre_tipo_amortizaciones (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion) VALUES (3, 'ACTIVO', '2023-12-27 11:01:21.438394', '2023-12-27 11:01:21.438394', 'fvazquez', 'FRA', 'FRANCES');
INSERT INTO public.cre_tipo_amortizaciones (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cod_tipo, descripcion) VALUES (4, 'ACTIVO', '2023-12-27 11:01:31.830206', '2023-12-27 11:01:31.830206', 'fvazquez', 'ALE', 'ALEMAN');


--
-- Data for Name: cre_desembolso_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_facturado) VALUES (5, 'ACTIVO', '2024-01-09 10:38:28.692587', '2024-01-09 10:37:52.65986', 'fvazquez', '2024-01-10', 'S', 2000000.00, 2652199.06, 411090.05, 241109.01, 2.00, 36.00, 3.00, 1, 3, 3, 3, 'N');
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_facturado) VALUES (4, 'ACTIVO', '2024-01-08 17:01:53.678368', '2024-01-05 17:43:13.47727', 'fvazquez', '2024-01-05', 'S', 2000000.04, 2700000.12, 636363.60, 63636.48, 1.00, 35.00, 3.00, 1, 3, 2, 3, 'N');
INSERT INTO public.cre_desembolso_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_desembolso, ind_desembolsado, monto_total_capital, monto_total_credito, monto_total_interes, monto_total_iva, nro_desembolso, taza_anual, taza_mora, bs_empresa_id, bs_talonario_id, cre_solicitud_credito_id, cre_tipo_amortizacion_id, ind_facturado) VALUES (6, 'ACTIVO', '2024-01-15 17:15:11.455102', '2024-01-11 19:44:11.11461', 'fvazquez', '2024-01-11', 'S', 3000000.00, 3958534.30, 598667.54, 359866.75, 3.00, 35.00, 3.00, 1, 3, 4, 3, 'S');


--
-- Name: cre_desembolso_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cre_desembolso_cabecera_id_seq', 6, true);


--
-- Data for Name: sto_articulos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-12-12 18:54:58.587664', '2023-12-12 18:54:58.587664', 'ART', 'ARTICULO', 'S', 150000.00, 1, 1, NULL);
INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id, usuario_modificacion) VALUES (4, 'ACTIVO', '2024-01-05 11:53:54.082811', '2024-01-05 11:53:54.082811', 'CUO', 'CUOTAS', 'N', 1000.00, 1, 1, 'fvazquez');
INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id, usuario_modificacion) VALUES (5, 'ACTIVO', '2024-01-10 19:31:52.519536', '2024-01-10 19:31:52.519536', 'DES', 'DESEMBOLSO', 'N', 1000.00, 1, 1, 'fvazquez');
INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id, usuario_modificacion) VALUES (3, 'ACTIVO', '2023-12-12 19:00:41.15117', '2023-12-12 19:00:41.15117', 'ART 2', 'ARTICULO 2', 'S', 23550.00, 1, 2, NULL);
INSERT INTO public.sto_articulos (id, estado, fecha_modificacion, fecha_creacion, cod_articulo, descripcion, ind_inventariable, precio_unitario, bs_empresa_id, bs_iva_id, usuario_modificacion) VALUES (6, 'ACTIVO', '2024-01-11 14:00:59.656862', '2024-01-11 14:00:59.656862', 'ART 3', 'ARTICULO 3', 'S', 15000.00, 1, 1, 'fvazquez');


--
-- Data for Name: cre_desembolso_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (37, 'ACTIVO', '2024-01-05 17:43:13.479691', '2024-01-05 17:43:13.479691', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 1, 4, 4, '2023-12-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (38, 'ACTIVO', '2024-01-05 17:43:13.480688', '2024-01-05 17:43:13.480688', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 2, 4, 4, '2024-01-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (39, 'ACTIVO', '2024-01-05 17:43:13.481695', '2024-01-05 17:43:13.481695', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 3, 4, 4, '2024-02-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (40, 'ACTIVO', '2024-01-05 17:43:13.484016', '2024-01-05 17:43:13.484016', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 4, 4, 4, '2024-03-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (41, 'ACTIVO', '2024-01-05 17:43:13.484834', '2024-01-05 17:43:13.484834', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 5, 4, 4, '2024-04-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (42, 'ACTIVO', '2024-01-05 17:43:13.486832', '2024-01-05 17:43:13.486832', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 6, 4, 4, '2024-05-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (43, 'ACTIVO', '2024-01-05 17:43:13.488834', '2024-01-05 17:43:13.488834', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 7, 4, 4, '2024-06-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (44, 'ACTIVO', '2024-01-05 17:43:13.490403', '2024-01-05 17:43:13.490403', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 8, 4, 4, '2024-07-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (45, 'ACTIVO', '2024-01-05 17:43:13.492538', '2024-01-05 17:43:13.492538', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 9, 4, 4, '2024-08-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (46, 'ACTIVO', '2024-01-05 17:43:13.494078', '2024-01-05 17:43:13.494078', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 10, 4, 4, '2024-09-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (47, 'ACTIVO', '2024-01-05 17:43:13.496431', '2024-01-05 17:43:13.496431', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 11, 4, 4, '2024-10-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (48, 'ACTIVO', '2024-01-05 17:43:13.497932', '2024-01-05 17:43:13.497423', 'fvazquez', 1, 166666.67, 225000.00, 53030.30, 5303.04, 12, 4, 4, '2024-11-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (49, 'ACTIVO', '2024-01-09 10:37:52.714117', '2024-01-09 10:37:52.714117', 'fvazquez', 1, 140924.17, 221016.59, 60000.00, 20092.42, 1, 5, 4, '2023-12-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (50, 'ACTIVO', '2024-01-09 10:37:52.721635', '2024-01-09 10:37:52.721635', 'fvazquez', 1, 145151.90, 221016.59, 55772.27, 20092.42, 2, 5, 4, '2024-01-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (51, 'ACTIVO', '2024-01-09 10:37:52.723046', '2024-01-09 10:37:52.723046', 'fvazquez', 1, 149506.45, 221016.59, 51417.72, 20092.42, 3, 5, 4, '2024-02-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (52, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 153991.65, 221016.59, 46932.52, 20092.42, 4, 5, 4, '2024-03-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (53, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 158611.40, 221016.59, 42312.78, 20092.42, 5, 5, 4, '2024-04-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (54, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 163369.74, 221016.59, 37554.43, 20092.42, 6, 5, 4, '2024-05-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (55, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 168270.83, 221016.59, 32653.34, 20092.42, 7, 5, 4, '2024-06-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (56, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 173318.95, 221016.59, 27605.22, 20092.42, 8, 5, 4, '2024-07-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (57, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 178518.52, 221016.59, 22405.65, 20092.42, 9, 5, 4, '2024-08-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (58, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 183874.08, 221016.59, 17050.09, 20092.42, 10, 5, 4, '2024-09-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (59, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 189390.30, 221016.59, 11533.87, 20092.42, 11, 5, 4, '2024-10-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (60, 'ACTIVO', '2024-01-09 10:37:52.72563', '2024-01-09 10:37:52.72563', 'fvazquez', 1, 195072.01, 221016.59, 5852.16, 20092.42, 12, 5, 4, '2024-11-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (61, 'ACTIVO', '2024-01-11 19:44:11.179159', '2024-01-11 19:44:11.178643', 'fvazquez', 1, 212388.96, 329877.86, 87500.00, 29988.90, 1, 6, 4, '2024-01-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (62, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, 218583.64, 329877.86, 81305.32, 29988.90, 2, 6, 4, '2024-02-29');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (63, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, 224959.00, 329877.86, 74929.97, 29988.90, 3, 6, 4, '2024-03-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (64, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, 231520.30, 329877.86, 68368.66, 29988.90, 4, 6, 4, '2024-04-30');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (65, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, 238272.98, 329877.86, 61615.99, 29988.90, 5, 6, 4, '2024-05-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (66, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, 245222.60, 329877.86, 54666.36, 29988.90, 6, 6, 4, '2024-06-30');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (67, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, 252374.93, 329877.86, 47514.03, 29988.90, 7, 6, 4, '2024-07-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (68, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, 259735.87, 329877.86, 40153.10, 29988.90, 8, 6, 4, '2024-08-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (69, 'ACTIVO', '2024-01-11 19:44:11.183593', '2024-01-11 19:44:11.183593', 'fvazquez', 1, 267311.50, 329877.86, 32577.47, 29988.90, 9, 6, 4, '2024-09-30');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (70, 'ACTIVO', '2024-01-11 19:44:11.194903', '2024-01-11 19:44:11.194903', 'fvazquez', 1, 275108.08, 329877.86, 24780.88, 29988.90, 10, 6, 4, '2024-10-31');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (71, 'ACTIVO', '2024-01-11 19:44:11.194903', '2024-01-11 19:44:11.194903', 'fvazquez', 1, 283132.07, 329877.86, 16756.90, 29988.90, 11, 6, 4, '2024-11-30');
INSERT INTO public.cre_desembolso_detalle (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, monto_capital, monto_cuota, monto_interes, monto_iva, nro_cuota, cre_desembolso_cabecera_id, sto_articulo_id, fecha_vencimiento) VALUES (72, 'ACTIVO', '2024-01-11 19:44:11.197894', '2024-01-11 19:44:11.197894', 'fvazquez', 1, 291390.08, 329877.86, 8498.88, 29988.90, 12, 6, 4, '2024-12-31');


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
-- Data for Name: sto_ajuste_inventarios_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: sto_ajuste_inventarios_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_ajuste_inventarios_cabecera_id_seq', 12, true);


--
-- Data for Name: sto_ajuste_inventarios_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: sto_ajuste_inventarios_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_ajuste_inventarios_detalle_id_seq', 12, true);


--
-- Data for Name: sto_articulos_existencias; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sto_articulos_existencias (id, sto_articulo_id, existencia, existencia_anterior) VALUES (2, 3, 1.00, 1.00);
INSERT INTO public.sto_articulos_existencias (id, sto_articulo_id, existencia, existencia_anterior) VALUES (5, 6, 4.00, 5.00);
INSERT INTO public.sto_articulos_existencias (id, sto_articulo_id, existencia, existencia_anterior) VALUES (1, 1, 0.00, 2.00);


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

SELECT pg_catalog.setval('public.tes_bancos_id_seq', 3, true);


--
-- Name: tes_depositos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_depositos_id_seq', 31, true);


--
-- Data for Name: tes_pagos_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pagos_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, beneficiario, fecha_pago, id_beneficiario, ind_autorizado, ind_impreso, monto_total_pago, nro_pago, nro_pago_completo, observacion, tipo_operacion, bs_empresa_id, bs_talonario_id, cob_habilitacion_id) VALUES (3, 'ACTIVO', '2024-02-10 21:04:13.873714', '2024-02-10 21:04:13.873714', 'fvazquez', 'fernnado vazquez', '2024-02-10', 1, 'N', 'S', 3000000.00, 1, '001-001-000000001', 'prueba de desembolso', 'DESEMBOLSO', 1, 7, 9);


--
-- Data for Name: tes_pago_comprobante_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pago_comprobante_detalle (id, id_cuota_saldo, monto_pagado, nro_orden, tipo_comprobante, tes_pagos_cabecera_id) VALUES (2, 6, 3000000.00, 1, 'DESEMBOLSO', 3);


--
-- Name: tes_pago_comprobante_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pago_comprobante_detalle_id_seq', 2, true);


--
-- Name: tes_pagos_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pagos_cabecera_id_seq', 3, true);


--
-- Data for Name: tes_pagos_valores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tes_pagos_valores (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_entrega, fecha_valor, fecha_vencimiento, ind_entregado, monto_cuota, nro_orden, nro_valor, tipo_operacion, bs_empresa_id, bs_tipo_valor_id, tes_banco_id, tes_pagos_cabecera_id) VALUES (2, 'ACTIVO', '2024-02-10 21:04:13.917314', '2024-02-10 21:04:13.917314', NULL, NULL, '2024-02-10', '2024-02-10', NULL, 3000000.00, 1, '178383892', 'DESEMBOLSO', 1, 2, 1, 3);


--
-- Name: tes_pagos_valores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tes_pagos_valores_id_seq', 2, true);


--
-- Data for Name: ven_condicion_ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_condicion_ventas (id, estado, fecha_modificacion, fecha_creacion, cod_condicion, descripcion, intervalo, plazo, bs_empresa_id, usuario_modificacion) VALUES (1, 'ACTIVO', '2023-12-12 18:16:54.954645', '2023-12-12 18:16:54.954645', 'CON', 'CONTADO', 0.00, 1.00, 1, NULL);
INSERT INTO public.ven_condicion_ventas (id, estado, fecha_modificacion, fecha_creacion, cod_condicion, descripcion, intervalo, plazo, bs_empresa_id, usuario_modificacion) VALUES (2, 'ACTIVO', '2023-12-12 18:17:53.259151', '2023-12-12 18:17:53.259151', 'CRE', 'CREDITO', 30.00, 12.00, 1, NULL);
INSERT INTO public.ven_condicion_ventas (id, estado, fecha_modificacion, fecha_creacion, cod_condicion, descripcion, intervalo, plazo, bs_empresa_id, usuario_modificacion) VALUES (4, 'ACTIVO', '2024-01-11 16:58:23.31292', '2024-01-11 16:58:23.31292', 'CREDES', 'CREDITO DESEMBOLSO', 30.00, 1.00, 1, 'fvazquez');


--
-- Name: ven_condicion_ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_condicion_ventas_id_seq', 4, true);


--
-- Data for Name: ven_facturas_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_facturas_cabecera (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, fecha_factura, id_comprobante, ind_cobrado, monto_total_exenta, monto_total_factura, monto_total_gravada, monto_total_iva, nro_factura, nro_factura_completo, observacion, tipo_factura, bs_empresa_id, bs_talonario_id, cob_cliente_id, ven_vendedor_id, ven_condicion_venta_id, ind_impreso, cob_habilitacion_caja_id) VALUES (16, 'ACTIVO', '2024-01-25 19:44:24.289558', '2024-01-25 18:56:55.811218', 'fvazquez', '2024-01-25', NULL, 'S', 0.00, 150000.00, 136363.64, 13636.36, 1, '001-001-000000001', 'prueba de impresion', 'FACTURA', 1, 5, 1, 1, 1, 'S', 9);


--
-- Name: ven_facturas_cabecera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_facturas_cabecera_id_seq', 16, true);


--
-- Data for Name: ven_facturas_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_facturas_detalles (id, estado, fecha_modificacion, fecha_creacion, usuario_modificacion, cantidad, cod_iva, monto_exento, monto_gravado, monto_iva, monto_linea, nro_orden, precio_unitario, sto_articulo_id, ven_facturas_cabecera_id) VALUES (17, 'ACTIVO', '2024-01-25 18:56:55.903752', '2024-01-25 18:56:55.903752', 'fvazquez', 1, 'IVA10', 0.00, 136363.64, 13636.36, 150000.00, 1, 150000.00, 1, 16);


--
-- Name: ven_facturas_detalles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_facturas_detalles_id_seq', 17, true);


--
-- Name: ven_vendedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_vendedores_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--

