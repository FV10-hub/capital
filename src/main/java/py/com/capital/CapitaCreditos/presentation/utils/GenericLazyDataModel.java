/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.utils;

import jakarta.faces.context.FacesContext;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.collections4.ComparatorUtils;
import org.primefaces.model.FilterMeta;
import org.primefaces.model.LazyDataModel;
import org.primefaces.model.SortMeta;
import org.primefaces.util.LocaleUtils;
import org.springframework.util.ClassUtils;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * esta clase se va encargar de manejar la carga perezosa de los datatables en
 * los html
 */
public class GenericLazyDataModel<T> extends LazyDataModel<T> {

	private static final long serialVersionUID = 1L;

	private List<T> datasource;
	private Field field;

	public GenericLazyDataModel(List<T> datasource) {
		this.datasource = datasource;
	}

	@Override
	public T getRowData(String rowKey) {
		for (T o : datasource) {
			if (getFieldData(o, "id").equals(rowKey))
				return o;
		}
		return null;
	}

	@Override
	public String getRowKey(T entity) {
		// Assuming the entity has a unique identifier
		return String.valueOf(entity.hashCode());
	}

	@Override
	public int count(Map<String, FilterMeta> filterBy) {
		return (int) datasource.stream().filter(o -> filter(FacesContext.getCurrentInstance(), filterBy.values(), o))
				.count();
	}

	@Override
	public List<T> load(int offset, int pageSize, Map<String, SortMeta> sortBy, Map<String, FilterMeta> filterBy) {
		// Aplica el desplazamiento y los filtros
		List<T> data = datasource.stream().skip(offset)
				.filter(o -> filter(FacesContext.getCurrentInstance(), filterBy.values(), o)).limit(pageSize)
				.collect(Collectors.toList());

		// Ordena
		if (!sortBy.isEmpty()) {
			List<Comparator<T>> comparators = sortBy.values().stream()
					.map(o -> new LazySorter<T>(o.getField(), o.getOrder())).collect(Collectors.toList());
			Comparator<T> cp = ComparatorUtils.chainedComparator(comparators); // desde apache
			data.sort(cp);
		}

		return data;
	}

	private boolean filter(FacesContext context, Collection<FilterMeta> filterBy, Object o) {
		boolean matching = false;

		if (filterBy.size() == 0) {
			matching = true;
		}

		for (FilterMeta filter : filterBy) {
			if (filter.getField().equals("globalFilter")) {
				// Filtrar globalmente
				String filterValue = filter.getFilterValue().toString().toLowerCase();

				for (PropertyDescriptor descriptor : PropertyUtils.getPropertyDescriptors(o.getClass())) {
					String propertyName = descriptor.getName();
					if (!propertyName.equals("class")) {
						try {
							Object propertyValue = PropertyUtils.getProperty(o, propertyName);

							if (propertyValue != null) {
								String stringValue = String.valueOf(propertyValue).toLowerCase();

								if (stringValue.contains(filterValue)) {
									matching = true;
									break;
								}
							}
						} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
							// Manejar excepciones según sea necesario
							e.printStackTrace();
						}
					}
				}
			} else {
				// Filtrar por columna específica
				try {
					Object columnValue = CommonUtils.getPropertyValueViaReflection(o, filter.getField());

					if (isNestedProperty(columnValue) && containsValue(columnValue, filter.getFilterValue())) {
						return true; // La propiedad es anidada, verifica su contenido
					} else {
						matching = filter.getConstraint().isMatching(context, columnValue, filter.getFilterValue(),
								LocaleUtils.getCurrentLocale());
					}
				} catch (ReflectiveOperationException | IntrospectionException e) {
					matching = false;
				}
			}

			if (matching) {
				break;
			}
		}

		return matching;
	}

	private boolean isNestedProperty(Object propertyValue) {
		return propertyValue != null && !ClassUtils.isPrimitiveOrWrapper(propertyValue.getClass());
	}

	private boolean containsValue(Object propertyValue, Object filterValue) {
		// Verifica si el valor de la propiedad anidada contiene el valor del filtro
		if (propertyValue != null && filterValue != null) {
			for (PropertyDescriptor descriptor : PropertyUtils.getPropertyDescriptors(propertyValue.getClass())) {
				String propertyName = descriptor.getName();
				if (!propertyName.equals("class")) {
					try {
						Object nestedValue = PropertyUtils.getProperty(propertyValue, propertyName);
						String stringValue = String.valueOf(nestedValue).toLowerCase();

						if (stringValue.contains(String.valueOf(filterValue).toLowerCase())) {
							return true;
						}
					} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
						// Maneja las excepciones según sea necesario
						e.printStackTrace();
					}
				}
			}
		}

		return false;
	}

	public String getFieldData(Object o, String key) {
		String g = null;
		try {
			if (key.contains(".")) {
				for (String s : key.split("\\.")) {
					field = o.getClass().getDeclaredField(s);
					field.setAccessible(true);
					o = field.get(o);
				}
				g = String.valueOf(o);
			} else {
				field = o.getClass().getDeclaredField(key);
				field.setAccessible(true);
				g = String.valueOf(field.get(o));
			}
		} catch (IllegalAccessException | IllegalArgumentException | NoSuchFieldException | SecurityException e) {
			e.printStackTrace(System.out);
		}
		return g;
	}
}
