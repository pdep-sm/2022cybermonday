
class Producto {
	
	method costo()
	
	method precio() = self.costo()
	
	method estaEnPromo() = false 
	
	method ahorro() = self.costo() - self.precio() 

}

class ConPromocion inherits  Producto { //Decorator
	//Punto 9 Bonus
	const producto
	var property porcentajeDescuento
	
	override method costo() = producto.costo()
	
	override method precio() = self.costo() * ( 1 - porcentajeDescuento/100)
	
	override method estaEnPromo() = true 
	
}

class Indumentaria inherits Producto {
	
	const talle
	const factorConversion
	
	override method costo() = talle * factorConversion

}

class Electronica inherits Producto {
	
	override method costo() = 
		electronica.constante() * electronica.factorConversion()
	
} 

object electronica {
	const property constante = 15
	var property factorConversion = 10
}


class Decoracion inherits Producto {
	const peso
	const alto
	const ancho
	const materiales = #{}
	
	override method costo() = 
		peso * alto * ancho + self.valorMateriales()
		
	method valorMateriales() = materiales.sum{ mat => mat.valor() }
	
	method agregarMaterial(material) = materiales.add(material)
	
} 

class Material {
	const property valor
}


class Venta {
	const fecha
	const lugar
	const productos = []

	method monto() = productos.sum{ producto => producto.precio() }
	
	method estaEnPromo() = 
		productos.any{ producto => producto.estaEnPromo() }
	
	method fueHechaEn(unaFecha) = fecha == unaFecha
	
	method ahorro() = productos.sum{ producto => producto.ahorro() }
	
	method realizadaEn(unLugar) = unLugar == lugar
}


class Local { // inherits Establecimiento {
	
	const ventas = []
	
	method cantidadDeVentasConPromo() =
		ventas.count{ venta => venta.estaEnPromo() }
		
	method ventasEn(fecha) = 
		ventas.filter{ venta => venta.fueHechaEn(fecha) }
		
	method ahorroEnFecha(fecha) = 
		self.ventasEn(fecha).sum{ venta => venta.ahorro() }
	
	method cantidadDeVentasDe(lugar) =
		self.ventasRealizadasEn(lugar).size() 
		
	method dineroMovido() = ventas.sum{ venta => venta.monto() }
	
	method tieneSoloVentasConPromo(lugar) = 
		self.ventasRealizadasEn(lugar).
			all{ venta => venta.estaEnPromo() }
		
	method ventasRealizadasEn(lugar) =
		ventas.filter{ venta => venta.realizadaEn(lugar) }
	
}

class Shopping { //inherits Establecimiento {
	const locales = #{}
	
	method cantidadDeVentasDe(lugar) =
		locales.sum{ local => local.cantidadDeVentasDe(lugar) }
		
	method dineroMovido() =
		locales.sum{ local => local.dineroMovido() }
	
	method tieneSoloVentasConPromo(lugar) = 
		locales.all{ l => l.tieneSoloVentasConPromo(lugar) }
}


class Empresa {
	const establecimientos = []
	const lugares = #{}
	
	method lugarConMasVentas() =
		lugares.max{ lugar => self.cantidadVentasLugar(lugar) }	
	
	method cantidadVentasLugar(lugar) = 
		establecimientos.sum{ e => e.cantidadDeVentasDe(lugar) }
		
	method algunLugarDeTacanios() = 
		lugares.any{ lugar => self.tieneSoloVentasConPromo(lugar) }
		
	method tieneSoloVentasConPromo(lugar) = 
		establecimientos.all{ e => e.tieneSoloVentasConPromo(lugar) }
		
	
	method lugares() = //podría haber sido, pero no...	
		establecimientos.flatMap{ e => e.lugares() }.asSet()

}
