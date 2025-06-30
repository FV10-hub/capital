package py.com.capital.CapitaCreditos.services;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

public interface CommonService<E> {

	public Iterable<E> findAll();
	public Page<E> findAll(Pageable pageable);
	public Optional<E> findById(Long id);
	public E save(E entity);
	public List<E> saveAll(List<E> entities);
	public List<E> deleteAll(List<E> entities);
	public void deleteById(Long id);

}