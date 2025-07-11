/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.session;

import javax.annotation.PreDestroy;
import javax.faces.bean.SessionScoped;
import org.apache.commons.collections4.CollectionUtils;
import org.primefaces.model.menu.DefaultMenuItem;
import org.primefaces.model.menu.DefaultMenuModel;
import org.primefaces.model.menu.DefaultSubMenu;
import org.primefaces.model.menu.MenuModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.MenuDto;
import py.com.capital.CapitaCreditos.entities.base.BsMenu;
import py.com.capital.CapitaCreditos.entities.base.BsMenuItem;
import py.com.capital.CapitaCreditos.entities.base.BsModulo;
import py.com.capital.CapitaCreditos.entities.base.BsUsuario;
import py.com.capital.CapitaCreditos.services.LoginService;
import py.com.capital.CapitaCreditos.services.base.BsMenuItemService;
import py.com.capital.CapitaCreditos.services.base.BsModuloService;

import java.util.List;
import java.util.Objects;

/**
 * @author DevPredator Clase que mantendra la informacion en la sesion del
 *         usuario.
 */
@Component
@Scope("session")
public class MenuBean {

	// Objetos personalizado
	private List<BsModulo> moduloList;
	private List<MenuDto> menuListFromDB;
	private BsUsuario usuarioLogueado;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	private LoginService loginServiceImpl;

	@Autowired
	private BsModuloService bsModuloServiceImpl;

	@Autowired
	private BsMenuItemService bsMenuItemServiceImpl;

	private MenuModel model;
	private DefaultSubMenu subMenuModulo;
	// TODO: esto debe tener el inicio del ID para los estilos css
	private static String MENU_ID_BASE = "m_";
	// TODO: esto debe tener el inicio del ID para los estilos css
	private static String SUB_MENU_ID_BASE = "m_sm";
	private int indexForIdAgrupador;
	private int indexForIdAgrupadorItemSubMenu;
	private int indexForIdAgrupadorItem;
	
	@PreDestroy
	private void destroy(){
		this.model = null;
		this.subMenuModulo = null;
	}

	private void ListarMenu(BsUsuario user) {
		try {
			this.menuListFromDB = this.loginServiceImpl.consultarMenuPorUsuario(user.getId());
			this.moduloList = this.bsModuloServiceImpl.buscarModulosActivosLista();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private MenuModel construirMenu() {
		this.model = new DefaultMenuModel();
		// TODO: MAIN SUBMENU
		var mainSubMenu = DefaultSubMenu.builder().label("MENU PRINCIPAL").id(MENU_ID_BASE + "main")
				.icon("pi pi-fw pi-sitemap").build();
		DefaultMenuItem dashboard = DefaultMenuItem.builder().id("main1").icon("pi pi-fw pi-home").value("DASHBOARD")
				.outcome("/pages/commons/dashboard.xhtml")
				// .command("#{menuView.update}")
				// .update("messages")
				.build();
		mainSubMenu.getElements().add(dashboard);
		this.moduloList.stream().forEach(modulosActivo -> {
			// TODO: MENU
			String idPadre = SUB_MENU_ID_BASE + modulosActivo.getId();
			this.subMenuModulo = DefaultSubMenu.builder().expanded(true).id(idPadre).label(modulosActivo.getNombre())
					.icon(modulosActivo.getIcon()).build();
			// TODO: REVISAR ESTA CONDICION POR UQE DEBE TRAER TODOS LOS MODULOS
			if (poseePermisoSobreModuloActual(modulosActivo)) {
				List<BsMenuItem> listaAgrupadores = this.bsMenuItemServiceImpl.findMenuAgrupado(modulosActivo.getId());
				if (CollectionUtils.isNotEmpty(listaAgrupadores)) {
					indexForIdAgrupador = 0;
					listaAgrupadores.stream().forEach(agrupador -> {
						// TODO: DEFINICIONES, REPORTES, MOVIMIENTOS
						indexForIdAgrupador++;
						var idAgrupador = idPadre + indexForIdAgrupador;
						DefaultSubMenu subMenuAgrupador = DefaultSubMenu.builder().id(idAgrupador)
								.label(agrupador.getTitulo()).icon(agrupador.getIcon()).build();

						//Aca ordeno el menu por que aca recorre los menus por iteAgrupador
						List<BsMenuItem> listaItemDelAgrupador = this.bsMenuItemServiceImpl
								.findMenuItemAgrupado(agrupador.getId());
						if (CollectionUtils.isNotEmpty(listaItemDelAgrupador)) {
							indexForIdAgrupadorItemSubMenu = 0;
							listaItemDelAgrupador.stream().forEach((itemDelAgrupador) -> {
								if (poseePermisoSobreMenuActual(itemDelAgrupador.getBsMenu())) {
									indexForIdAgrupadorItemSubMenu++;
									// TODO: aca pregunto si es menu o item
									if ("SUBMENU".equalsIgnoreCase(itemDelAgrupador.getBsMenu().getTipoMenu())) {
										String idPadreSiEsSubMenu = idAgrupador + indexForIdAgrupadorItemSubMenu;
										DefaultSubMenu subMenu = DefaultSubMenu.builder().id(idPadreSiEsSubMenu)
												.label(agrupador.getTitulo()).icon(agrupador.getIcon()).build();
										System.out.println("SUBMENU TIPO :::: " + agrupador.getTitulo());
										List<BsMenuItem> listaHijosDelSubMenu = this.bsMenuItemServiceImpl
												.findMenuItemAgrupado(itemDelAgrupador.getId());
										if (CollectionUtils.isNotEmpty(listaItemDelAgrupador)) {
											indexForIdAgrupadorItem = 0;
											listaHijosDelSubMenu.stream().forEach(hijosDelSubMenu -> {
												if (poseePermisoSobreMenuActual(hijosDelSubMenu.getBsMenu())) {
													indexForIdAgrupadorItem++;
													DefaultMenuItem itemHijo = DefaultMenuItem.builder()
															.id(idPadreSiEsSubMenu + indexForIdAgrupadorItem)
															.value(itemDelAgrupador.getTitulo())
															.icon(itemDelAgrupador.getIcon())
															.outcome(itemDelAgrupador.getBsMenu().getUrl())
															.style("white-space: normal;")
															// .command("#{menuView.update}")
															// .update("messages")
															.build();
													subMenu.getElements().add(itemHijo);
												}

											});
										}
										// TODO: aca puedo validar que si no tiene hijos no construya el menuagrupador
										subMenuAgrupador.getElements().add(subMenu);
									} else {
										DefaultMenuItem item = DefaultMenuItem.builder()
												.id(idAgrupador + indexForIdAgrupadorItemSubMenu)
												.value(itemDelAgrupador.getTitulo()).icon(itemDelAgrupador.getIcon())
												.outcome(itemDelAgrupador.getBsMenu().getUrl())
												// .command("#{menuView.update}")
												// .update("messages")
												.build();
										subMenuAgrupador.getElements().add(item);
									}
								}
							});
						}
						// TODO: ACA LE AGREGO EL GRUPO AL MODULO
						subMenuModulo.getElements().add(subMenuAgrupador);
					});
					mainSubMenu.getElements().add(this.subMenuModulo);
				}

			} else {
				mainSubMenu.getElements().add(subMenuModulo);
			}
		});
		this.model.getElements().add(mainSubMenu);
		return this.model;
	}

	private boolean poseePermisoSobreModuloActual(BsModulo modulo) {
		return this.menuListFromDB.stream()
				.anyMatch(menuItem -> menuItem.getMenuItem().getBsModulo().getId() == modulo.getId());
	}

	private boolean poseePermisoSobreMenuActual(BsMenu menu) {
		return this.menuListFromDB.stream()
				.anyMatch(menuItem -> menuItem.getMenuItem().getBsMenu().getId() == menu.getId());
	}

	private MenuModel construirMenuEstatido() {
		model = new DefaultMenuModel();

		// First submenu
		DefaultSubMenu firstSubmenu = DefaultSubMenu.builder().id("m_sm1").label("Options").expanded(true).build();

		DefaultMenuItem item = DefaultMenuItem.builder().id("m_sm11").value("Save (Non-Ajax)").icon("pi pi-save")
				.ajax(false)
				// .command("#{menuView.save}")
				// .update("messages")
				.build();
		firstSubmenu.getElements().add(item);

		item = DefaultMenuItem.builder().id("m_sm12").value("Update").icon("pi pi-refresh")
				// .command("#{menuView.update}")
				// .update("messages")
				.build();
		firstSubmenu.getElements().add(item);

		item = DefaultMenuItem.builder().id("m_sm13").value("Delete").icon("pi pi-times")
				// .command("#{menuView.delete}")
				// .update("messages")
				.build();
		firstSubmenu.getElements().add(item);

		model.getElements().add(firstSubmenu);

		// Second submenu
		DefaultSubMenu secondSubmenu = DefaultSubMenu.builder().id("m_sm2").label("Navigations").expanded(false)
				.build();

		item = DefaultMenuItem.builder().id("m_sm21").value("Website").url("http://www.primefaces.org")
				.icon("pi pi-external-link").build();
		secondSubmenu.getElements().add(item);

		item = DefaultMenuItem.builder().id("m_sm22").value("Internal").icon("pi pi-upload")
				.command("#{menuView.redirect}").build();
		secondSubmenu.getElements().add(item);

		model.getElements().add(secondSubmenu);
		return model;
	}

	public MenuModel getModel() {
		if (CollectionUtils.isNotEmpty(menuListFromDB) && CollectionUtils.isNotEmpty(moduloList)) {
			// this.construirMenu();
			model = this.construirMenu();
		}
		return model;
	}

	public void setModel(MenuModel model) {
		this.model = model;
	}

	public BsUsuario getUsuarioLogueado() {

		return usuarioLogueado;
	}

	public void setUsuarioLogueado(BsUsuario usuarioLogueado) {
		if (!Objects.isNull(usuarioLogueado)) {
			ListarMenu(usuarioLogueado);
		}
		this.usuarioLogueado = usuarioLogueado;
	}

	public LoginService getLoginServiceImpl() {
		return loginServiceImpl;
	}

	public void setLoginServiceImpl(LoginService loginServiceImpl) {
		this.loginServiceImpl = loginServiceImpl;
	}

	public BsModuloService getBsModuloServiceImpl() {
		return bsModuloServiceImpl;
	}

	public void setBsModuloServiceImpl(BsModuloService bsModuloServiceImpl) {
		this.bsModuloServiceImpl = bsModuloServiceImpl;
	}

	public BsMenuItemService getBsMenuItemServiceImpl() {
		return bsMenuItemServiceImpl;
	}

	public void setBsMenuItemServiceImpl(BsMenuItemService bsMenuItemServiceImpl) {
		this.bsMenuItemServiceImpl = bsMenuItemServiceImpl;
	}

}
