package py.com.capital.CapitaCreditos.presentation.utils;

/**
 * @author fvazquez
 */
public final class ApplicationConstant {

	public static final String MENU_ITEM_ICON_DEFAULT = "pi pi-fw pi-angle-right";
	public static final String PATH_BASE_MENU_CLIENTE = "/faces/pages/cliente";

	public static final String PATH_IMAGEN_EMPRESA;
	public static final String SUB_REPORT_DIR;

	public static final String IMAGEN_EMPRESA_NAME = "empresa.png";

	// Parámetros básicos de reportes
	public static final String REPORT_PARAM_IMAGEN_PATH = "imagenPath";
	public static final String REPORT_PARAM_NOMBRE_IMAGEN = "nombreImagen";
	public static final String REPORT_PARAM_IMPRESO_POR = "impresoPor";
	public static final String REPORT_PARAM_DIA_HORA = "DiaHora";
	public static final String REPORT_PARAM_DESC_EMPRESA = "descEmpresa";
	public static final String SUB_PARAM_REPORT_DIR = "subreport_dir";

	static {
		String os = System.getProperty("os.name").toLowerCase();

		if (os.contains("win")) {
			PATH_IMAGEN_EMPRESA = "D:\\reportes\\imagenes\\";
			SUB_REPORT_DIR = "D:\\reportes\\subreport\\";
		} else {
			PATH_IMAGEN_EMPRESA = "/app/jasper/imagenes/";
			SUB_REPORT_DIR = "/app/jasper/subreport/";
		}
	}

	private ApplicationConstant() {
		// Evita instanciacion
	}
}

