/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.controllers.base.definicion;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.primefaces.PrimeFaces;
import org.primefaces.event.SelectEvent;
import org.primefaces.model.LazyDataModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import py.com.capital.CapitaCreditos.entities.base.BsMenu;
import py.com.capital.CapitaCreditos.entities.base.BsModulo;
import py.com.capital.CapitaCreditos.exception.ExceptionUtils;
import py.com.capital.CapitaCreditos.presentation.utils.ApplicationConstant;
import py.com.capital.CapitaCreditos.presentation.utils.CommonUtils;
import py.com.capital.CapitaCreditos.presentation.utils.GenericLazyDataModel;
import py.com.capital.CapitaCreditos.services.base.BsMenuService;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import org.joinfaces.autoconfigure.viewscope.ViewScope;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * descomentar si por algun motivo se necesita trabajar directo con spring
 * //@Component y // @Autowired
 */
@Component
@Scope(ViewScope.SCOPE_VIEW)
public class BsMenuController {

	/**
	 * Objeto que permite mostrar los mensajes de LOG en la consola del servidor o
	 * en un archivo externo.
	 */
	private static final Logger LOGGER = LogManager.getLogger(BsMenuController.class);

	private BsMenu bsMenu, bsMenuSelected;
	private LazyDataModel<BsMenu> lazyModel;
	private List<BsModulo> lazyModelModulo;
	private List<String> tipoList;
	private List<String> tipoListAgrupador;
	private List<BsMenu> subMenuList;
	private boolean isSubmenu;
	private String tipoMenu;
	private boolean esNuegoRegistro;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	// @Autowired
	private BsMenuService bsMenuServiceImpl;

	@Autowired
	private BsModuloService bsModuloServiceImpl;
	
	@PostConstruct
	public void init() {
		this.cleanFields();

	}

	public void cleanFields() {
		this.bsMenu = null;
		this.bsMenuSelected = null;
		this.lazyModel = null;
		this.lazyModelModulo = null;
		this.isSubmenu = true;
		this.tipoMenu = null;
		this.esNuegoRegistro = true;
		this.tipoList = List.of("SUBMENU", "ITEM");
		this.tipoListAgrupador = List.of("DEFINICION", "MOVIMIENTOS", "REPORTES");
		this.subMenuList = null;
	}

	// GETTERS & SETTERS
	public BsMenu getBsMenu() {

		if (Objects.isNull(bsMenu)) {
			this.bsMenu = new BsMenu();
			this.bsMenu.setBsModulo(new BsModulo());
			// this.bsMenu.setSubMenuPadre(new BsMenu());
		}
		return bsMenu;
	}

	public void setBsMenu(BsMenu bsMenu) {
		this.bsMenu = bsMenu;
	}

	public BsMenu getBsMenuSelected() {

		if (Objects.isNull(bsMenuSelected)) {
			this.bsMenuSelected = new BsMenu();
			this.bsMenuSelected.setBsModulo(new BsModulo());
			// this.bsMenuSelected.setSubMenuPadre(new BsMenu());
		}

		return bsMenuSelected;
	}

	public void setBsMenuSelected(BsMenu bsMenuSelected) {
		if (!Objects.isNull(bsMenuSelected)) {
			this.bsMenu = bsMenuSelected;
			this.esNuegoRegistro = false;
		}
		this.bsMenuSelected = bsMenuSelected;
	}

	public BsMenuService getBsMenuServiceImpl() {
		return bsMenuServiceImpl;
	}

	public void setBsMenuServiceImpl(BsMenuService bsMenuServiceImpl) {
		this.bsMenuServiceImpl = bsMenuServiceImpl;
	}

	public LazyDataModel<BsMenu> getLazyModel() {
		if (Objects.isNull(lazyModel)) {
			lazyModel = new GenericLazyDataModel<BsMenu>(bsMenuServiceImpl.buscarTodosLista());
		}

		return lazyModel;
	}

	public void setLazyModel(LazyDataModel<BsMenu> lazyModel) {
		this.lazyModel = lazyModel;
	}

	public BsModuloService getBsModuloServiceImpl() {
		return bsModuloServiceImpl;
	}

	public void setBsModuloServiceImpl(BsModuloService bsModuloServiceImpl) {
		this.bsModuloServiceImpl = bsModuloServiceImpl;
	}

	public List<BsModulo> getLazyModelModulo() {
		if (Objects.isNull(lazyModelModulo)) {
			lazyModelModulo = this.bsModuloServiceImpl.buscarTodosLista();
		}

		return lazyModelModulo;
	}

	public void setLazyModelModulo(List<BsModulo> lazyModelModulo) {
		this.lazyModelModulo = lazyModelModulo;
	}

	public List<String> getTipoList() {
		return tipoList;
	}

	public void setTipoList(List<String> tipoList) {
		this.tipoList = tipoList;
	}

	public List<BsMenu> getSubMenuList() {
		if (!Objects.isNull(this.bsMenu.getBsModulo().getId())) {
			if (CollectionUtils.isEmpty(subMenuList)) {
				subMenuList = bsMenuServiceImpl.buscarTodosLista().stream()
						.filter(menu -> this.bsMenu.getBsModulo().getId() == menu.getBsModulo().getId())
						.collect(Collectors.toList());
			}
		} else {
			subMenuList = bsMenuServiceImpl.buscarTodosLista();
		}

		return subMenuList;
	}

	public void setSubMenuList(List<BsMenu> subMenuList) {
		this.subMenuList = subMenuList;
	}

	public boolean getIsSubmenu() {
		return isSubmenu;
	}

	public void setIsSubmenu(boolean isSubmenu) {
		this.isSubmenu = isSubmenu;
	}

	public String getTipoMenu() {
		return tipoMenu;
	}

	public void setTipoMenu(String tipoMenu) {
		if ("SUBMENU".equalsIgnoreCase(tipoMenu)) {
			this.isSubmenu = false;
		} else {
			this.isSubmenu = true;
		}
		this.bsMenu.setTipoMenu(tipoMenu);
		this.tipoMenu = tipoMenu;
	}

	public List<String> getTipoListAgrupador() {
		return tipoListAgrupador;
	}

	public void setTipoListAgrupador(List<String> tipoListAgrupador) {
		this.tipoListAgrupador = tipoListAgrupador;
	}

	public boolean isEsNuegoRegistro() {
		return esNuegoRegistro;
	}

	public void setEsNuegoRegistro(boolean esNuegoRegistro) {
		this.esNuegoRegistro = esNuegoRegistro;
	}

	// METODOS
	public void guardar() {
		try {
			if (bsMenu.getTipoMenuAgrupador().length() < 3) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
						"Debe seleccionar un agrupador de menu.");
				return;
			}
			if (Objects.isNull(bsMenu.getBsModulo()) || Objects.isNull(bsMenu.getBsModulo().getId())) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "Debe seleccionar un Modulo.");
				return;
			}
			try {
				String pathAbsoluto = construirPathAbsoluto(bsMenu);
				bsMenu.setUrl(pathAbsoluto);
			} catch (NullPointerException e) {
				LOGGER.error("Ocurrio un error al Guardar", e);
				e.printStackTrace(System.err);
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "El path no se puede construir.");
				return;
			}

			if (!Objects.isNull(bsMenuServiceImpl.guardar(bsMenu))) {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se guardo correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo insertar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().executeScript("PF('manageMenutDialog').hide()");
			PrimeFaces.current().ajax().update("form:messages", "form:dt-menu");
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al Guardar", e);
			e.printStackTrace(System.err);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!",
					e.getMessage().substring(0, e.getMessage().length()) + "...");
		}

	}

	public void deleteMenu() {
		try {
			if (!Objects.isNull(this.bsMenuSelected)) {
				this.bsMenuServiceImpl.eliminar(this.bsMenuSelected.getId());
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_INFO, "¡EXITOSO!",
						"El registro se elimino correctamente.");
			} else {
				CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", "No se pudo eliminar el registro.");
			}
			this.cleanFields();
			PrimeFaces.current().ajax().update("form:messages", "form:dt-menu");
		} catch (Exception e) {
			LOGGER.error("Ocurrio un error al eliminar", e);
			// e.printStackTrace(System.err);
			String mensajeAmigable = ExceptionUtils.obtenerMensajeUsuario(e);
			CommonUtils.mostrarMensaje(FacesMessage.SEVERITY_ERROR, "¡ERROR!", mensajeAmigable);
			PrimeFaces.current().ajax().update("form:messages", "form:dt-menu");
		}

	}

	public void onRowSelectSubMenu(SelectEvent<BsMenu> event) {
		if (!Objects.isNull(event.getObject())) {
			this.bsMenu.setSubMenuPadre(event.getObject());
			this.bsMenuSelected = null;
			PrimeFaces.current().ajax().update("form:manage-menu");
			PrimeFaces.current().executeScript("PF('dlgSubMenus').hide()");

		}

	}

	public void onModuloChange() {
		this.getSubMenuList();

	}

	private String construirPathAbsoluto(BsMenu menu) {
		String pathAgrupador = menu.getTipoMenuAgrupador().toLowerCase();
		String pathModulo = this.bsModuloServiceImpl.buscarTodosLista().stream()
				.filter(modulo -> modulo.getId() == menu.getBsModulo().getId()).map(mod -> mod.getPath()).findFirst()
				.orElse(null);
		String codModulo = this.bsModuloServiceImpl.buscarTodosLista().stream()
				.filter(modulo -> modulo.getId() == menu.getBsModulo().getId())
				.map(mod -> mod.getCodigo()).findFirst()
				.orElse(null);
		if (pathModulo == null || codModulo == null) {
			throw new NullPointerException("El campo pathModulo no puede ser nulo");
		}
		String path = String.join("/", ApplicationConstant.PATH_BASE_MENU_CLIENTE, pathModulo, pathAgrupador,
				construirNombrePanralla(codModulo.concat(" " + menu.getLabel()) ));
		return path;
	}

	public static String construirNombrePanralla(String input) {
		String[] palabras = input.split("\\s");

		StringBuilder resultadoBuilder = new StringBuilder();
		for (String palabra : palabras) {
			if (!palabra.isEmpty()) {
				resultadoBuilder.append(Character.toUpperCase(palabra.charAt(0)));
				resultadoBuilder.append(palabra.substring(1).toLowerCase());
			}
		}
		resultadoBuilder.append(".xhtml");
		return resultadoBuilder.toString();
	}

}
