package py.com.capital.CapitaCreditos.entities.base;

import javax.persistence.*;

import java.time.LocalDateTime;

/**
* Aug 30, 2023-5:26:37 PM-fvazquez
**/
@Entity
@Table(name = "bs_moneda", uniqueConstraints = @UniqueConstraint(name= "bs_moneda_unique_codigo" ,columnNames = {"cod_moneda"}))
public class BsMoneda extends Common {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
		
    @Column(name = "descripcion")
    private String descripcion;
    
    @Column(name = "decimales")
    private Integer decimales;
    
    @Column(name = "cod_moneda")
    private String codMoneda;
	
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

	public BsMoneda() {
		super();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Integer getDecimales() {
		return decimales;
	}

	public void setDecimales(Integer decimales) {
		this.decimales = decimales;
	}

	public String getCodMoneda() {
		return codMoneda;
	}

	public void setCodMoneda(String codMoneda) {
		this.codMoneda = codMoneda;
	}	
	

}
