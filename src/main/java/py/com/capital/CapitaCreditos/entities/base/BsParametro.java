/**
 * 
 */
package py.com.capital.CapitaCreditos.entities.base;

import javax.persistence.*;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * 
 */
@Entity
@Table(name = "bs_parametros", 
uniqueConstraints = @UniqueConstraint(name= "bs_parametros_unique_empresa_modulo_parametro" ,
columnNames = {"parametro", "bs_empresa_id","bs_modulo_id"}))
public class BsParametro extends Common {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "parametro")
    private String parametro;
	
    @Column(name = "descripcion")
    private String descripcion;
    
    @Column(name = "valor")
    private String valor;
    
    @ManyToOne
    @JoinColumn(name = "bs_empresa_id", referencedColumnName = "id", nullable = false)
    private BsEmpresa bsEmpresa;
    
    @ManyToOne
    @JoinColumn(name = "bs_modulo_id", referencedColumnName = "id", nullable = false)
    private BsModulo bsModulo;

	@PrePersist
	private void preInsert() {
		this.setEstado("ACTIVO");
		this.setFechaCreacion(LocalDateTime.now());
		this.setFechaActualizacion(LocalDateTime.now());
	}

	@PreUpdate
	private void preUpdate() {
		this.setFechaActualizacion(LocalDateTime.now());
	}
	
	public BsParametro() {
		super();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getParametro() {
		return parametro;
	}

	public void setParametro(String parametro) {
		this.parametro = parametro;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

	public BsModulo getBsModulo() {
		return bsModulo;
	}

	public void setBsModulo(BsModulo bsModulo) {
		this.bsModulo = bsModulo;
	}
	
	public BsEmpresa getBsEmpresa() {
		return bsEmpresa;
	}

	public void setBsEmpresa(BsEmpresa bsEmpresa) {
		this.bsEmpresa = bsEmpresa;
	}

	@Override
	public int hashCode() {
		return Objects.hash(bsEmpresa, bsModulo, id, parametro);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BsParametro other = (BsParametro) obj;
		return Objects.equals(bsEmpresa, other.bsEmpresa) && Objects.equals(bsModulo, other.bsModulo)
				&& Objects.equals(id, other.id) && Objects.equals(parametro, other.parametro);
	}

	
	
	
	
}
