package py.com.capital.CapitaCreditos.entities.stock;

import javax.persistence.*;

import java.io.Serializable;
import java.util.Objects;

/*
* 12 ene. 2024 - Elitebook
*/
@Entity
@Table(name = "sto_ajuste_inventarios_detalle")
public class StoAjusteInventarioDetalle implements Serializable{
	
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "cantidad_fisica")
	private Integer cantidadFisica;

	@Column(name = "cantidad_sistema")
	private Integer cantidadSistema;
	
	@Column(name = "nro_orden")
	private Integer nroOrden;
	
	@ManyToOne
	@JoinColumn(name = "sto_articulo_id")
	private StoArticulo stoArticulo;
	
	@ManyToOne
	@JoinColumn(name = "sto_ajuste_inventarios_cabecera_id")
	private StoAjusteInventarioCabecera stoAjusteInventarioCabecera;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getCantidadFisica() {
		return cantidadFisica;
	}

	public void setCantidadFisica(Integer cantidadFisica) {
		this.cantidadFisica = cantidadFisica;
	}

	public Integer getCantidadSistema() {
		return cantidadSistema;
	}

	public void setCantidadSistema(Integer cantidadSistema) {
		this.cantidadSistema = cantidadSistema;
	}

	public Integer getNroOrden() {
		return nroOrden;
	}

	public void setNroOrden(Integer nroOrden) {
		this.nroOrden = nroOrden;
	}

	public StoArticulo getStoArticulo() {
		return stoArticulo;
	}

	public void setStoArticulo(StoArticulo stoArticulo) {
		this.stoArticulo = stoArticulo;
	}

	public StoAjusteInventarioCabecera getStoAjusteInventarioCabecera() {
		return stoAjusteInventarioCabecera;
	}

	public void setStoAjusteInventarioCabecera(StoAjusteInventarioCabecera stoAjusteInventarioCabecera) {
		this.stoAjusteInventarioCabecera = stoAjusteInventarioCabecera;
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, stoArticulo);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		StoAjusteInventarioDetalle other = (StoAjusteInventarioDetalle) obj;
		return Objects.equals(id, other.id) && Objects.equals(stoArticulo, other.stoArticulo);
	}
	
	

}

