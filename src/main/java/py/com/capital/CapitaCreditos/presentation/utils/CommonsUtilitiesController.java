package py.com.capital.CapitaCreditos.presentation.utils;

import javax.faces.bean.SessionScoped;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import py.com.capital.CapitaCreditos.entities.base.BsTalonario;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobCaja;
import py.com.capital.CapitaCreditos.entities.cobranzas.CobHabilitacionCaja;
import py.com.capital.CapitaCreditos.presentation.session.SessionBean;
import py.com.capital.CapitaCreditos.services.base.BsParametroService;
import py.com.capital.CapitaCreditos.services.base.BsTalonarioService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobCajaService;
import py.com.capital.CapitaCreditos.services.cobranzas.CobHabilitacionCajaService;

import java.util.List;

/*
* 5 ene. 2024 - Elitebook
*/
@Component
@Scope("session")
public class CommonsUtilitiesController {

	@Autowired
	private BsParametroService bsParametroServiceImpl;

	@Autowired
	private BsTalonarioService bsTalonarioServiceImpl;

	@Autowired
	private CobCajaService cobCajaServiceImpl;

	@Autowired
	private CobHabilitacionCajaService cobHabilitacionCajaServiceImpl;

	private CobCaja cobCajaSelected;

	/**
	 * Propiedad de la logica de negocio inyectada con JSF y Spring.
	 */
	@Autowired
	private SessionBean sessionBean;

	// METODOS
	public String getValorParametro(String nombreParametro, long moduloId) {
		String valorParametro = this.bsParametroServiceImpl.buscarParametro(nombreParametro,
				this.sessionBean.getUsuarioLogueado().getBsEmpresa().getId(), moduloId);

		return valorParametro;
	}

	public Long getIdEmpresaLogueada() {
		return this.sessionBean.getUsuarioLogueado().getBsEmpresa().getId();
	}

	public String getCodUsuarioLogueada() {
		return this.sessionBean.getUsuarioLogueado().getCodUsuario();
	}
	
	public CobCaja getCajaUsuarioLogueado() {
		this.cobCajaSelected = this.cobCajaServiceImpl.usuarioTieneCaja(this.sessionBean.getUsuarioLogueado().getId());
		return this.cobCajaSelected;
	}

	public boolean validarSiTengaHabilitacionAbierta() {
		this.cobCajaSelected = getCajaUsuarioLogueado();
		String valor = this.cobHabilitacionCajaServiceImpl
				.validaHabilitacionAbierta(this.sessionBean.getUsuarioLogueado().getId(), this.cobCajaSelected.getId());

		return valor.equalsIgnoreCase("N");

	}

	public CobHabilitacionCaja getHabilitacionAbierta() {
		this.cobCajaSelected = getCajaUsuarioLogueado();
		CobHabilitacionCaja valor = this.cobHabilitacionCajaServiceImpl.retornarHabilitacionAbierta(
				this.sessionBean.getUsuarioLogueado().getBsEmpresa().getId(),
				this.sessionBean.getUsuarioLogueado().getId(), this.cobCajaSelected.getId());

		return valor;

	}

	// GETTERS Y SETTERS
	public BsParametroService getBsParametroServiceImpl() {
		return bsParametroServiceImpl;
	}

	public List<BsTalonario> bsTalonarioPorModuloLista(Long IdEmpresa, Long IdModulo) {
		return this.bsTalonarioServiceImpl.buscarBsTalonarioPorModuloLista(IdEmpresa, IdModulo);
	}

	public void setBsParametroServiceImpl(BsParametroService bsParametroServiceImpl) {
		this.bsParametroServiceImpl = bsParametroServiceImpl;
	}

	public SessionBean getSessionBean() {
		return sessionBean;
	}

	public void setSessionBean(SessionBean sessionBean) {
		this.sessionBean = sessionBean;
	}

	public BsTalonarioService getBsTalonarioServiceImpl() {
		return bsTalonarioServiceImpl;
	}

	public void setBsTalonarioServiceImpl(BsTalonarioService bsTalonarioServiceImpl) {
		this.bsTalonarioServiceImpl = bsTalonarioServiceImpl;
	}

	public CobCajaService getCobCajaServiceImpl() {
		return cobCajaServiceImpl;
	}

	public void setCobCajaServiceImpl(CobCajaService cobCajaServiceImpl) {
		this.cobCajaServiceImpl = cobCajaServiceImpl;
	}

	public CobHabilitacionCajaService getCobHabilitacionCajaServiceImpl() {
		return cobHabilitacionCajaServiceImpl;
	}

	public void setCobHabilitacionCajaServiceImpl(CobHabilitacionCajaService cobHabilitacionCajaServiceImpl) {
		this.cobHabilitacionCajaServiceImpl = cobHabilitacionCajaServiceImpl;
	}

}
