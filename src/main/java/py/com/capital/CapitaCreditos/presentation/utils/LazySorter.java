/**
 * 
 */
package py.com.capital.CapitaCreditos.presentation.utils;

import org.primefaces.model.SortOrder;

import java.util.Comparator;

/**
 * 
 */
public class LazySorter<T> implements Comparator<T> {

	private String sortField;
	private SortOrder sortOrder;

	public LazySorter(String sortField, SortOrder sortOrder) {
		this.sortField = sortField;
		this.sortOrder = sortOrder;
	}

	@Override
	public int compare(T object1, T object2) {
		try {
			Object value1 = CommonUtils.getPropertyValueViaReflection(object1, sortField);
			Object value2 = CommonUtils.getPropertyValueViaReflection(object2, sortField);

			int value = ((Comparable) value1).compareTo(value2);

			return SortOrder.ASCENDING.equals(sortOrder) ? value : -1 * value;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
