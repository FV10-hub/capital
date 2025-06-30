/**
 * 
 */
package py.com.capital.CapitaCreditos.services.base;

import py.com.capital.CapitaCreditos.entities.base.BsMenuItem;

import java.util.List;

/**
 * 
 */
public interface BsMenuItemService {
	
	List<BsMenuItem> findMenuAgrupado(Long idModulo);
	List<BsMenuItem> findMenuItemAgrupado(Long idMenuItemAgrupador);
}