### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 8c6bcfb6-a597-4139-afd3-d239efbb13e7
html"""
<style>
	main {
		margin: 0 auto;
		max-width: 2000px;
    	padding-left: max(160px, 10%);
    	padding-right: max(160px, 10%);
	}
</style>
"""

# ╔═╡ 4a059976-8c17-11ec-20da-01784e520c36
md"""# Método de Newton

En muchas aplicaciones matemáticas, es de gran utilidad encontrar valores para los cuales una función arbitraria se anula, conocidos como las  _raíces_ de dicha función. Por ejemplo, si en un tiro parabólico podemos encontrar el valor de tiempo (positivo) en el que la función de posición vertical (altura) es igual a cero, entonces podemos determinar en qué momento la "partícula" toca el "suelo".

Más generalmente, puede ser muy útil saber para qué valores de una variable independiente $x$ una función $f$ es igual a algún valor arbitrario $b$; sin embargo, esto se puede reducir al problema anterior, pues

$$f(x) = b \quad \iff \quad f(x) - b = 0,$$

por lo que encontrar estos valores equivale a encontrar las raíces de la función $g(x) = f(x)-b$.

El _método de Newton_ (o _de Newton-Raphson_) es un método numérico iterativo capaz de encontrar raíces de una función **utilizando su derivada**, pues se sustenta en el hecho de que una función continua (la solución que buscamos para nuestro método numérico) y derivable (una suposición extra) se puede aproximar en distancias cortas como una línea recta. Este método toma como entrada un valor numérico que _sospechamos_ que podría ser una raíz -o _estar cerca_ de una raíz- de la función en cuestión y devuelve el valor aproximado de una raíz de la función.

"""

# ╔═╡ 83d0773d-4327-421c-9b54-f2d83c2a85dd
md""" ## Derivación matemática del método de Newton

Sean $f:\mathbb{R}\to\mathbb{R}$ una función derivable (y, por ende, continua), $x^\ast$ el valor exacto de una raíz de $f$ y $x_0$ una "adivinanza" de una raíz de $f$, que suponemos muy cercana al valor de $x^\ast$.

Definiendo a

$$\delta := x^\ast - x_0$$

tenemos trivialmente que

$$x^\ast = x_0 + \delta;$$

sin embargo, nuestro problema radica en que _no conocemos el valor de_ $x^\ast$ (pues, de lo contrario, no tendríamos necesidad de implementar este método numérico), por lo que no podemos calcular el valor de $\delta$. Por lo tanto, intentaremos _aproximar_ el valor de $\delta$ y, con ello, obtener una _aproximación_ de $x^\ast$.

Recordemos que queremos encontrar a $x^\ast$ tal que $f(x^\ast) = 0.$ Sustituyendo, tenemos que

$$f(x_0 + \delta) = 0.$$

Como **suponemos que $f$ es derivable** y que $x_0$ **es muy cercano a** $x^\ast$ -y que, por ende, el valor de $\delta$ es muy pequeño-, podemos expandir la ecuación anterior en una serie de Taylor alrededor de $x_0$.

"""

# ╔═╡ 00fe1fa8-855b-4287-99ca-b1839155f908
md"""

**Recordatorio** Si una función $f$ es derivable en un punto $a$ y $x$ es un valor cercano a $a$, entonces

$$f(x) = \sum_{k=0}^\infty \frac{f^k(a)(x-a)^k}{k!},$$

donde $f^k$ es la $k$-ésima derivada de $f$ y, en particular, $f^0=f$. 

Sustituyendo $x = x^\ast = x_0+\delta$ y $a=x_0$, tenemos que

$$f(x_0+\delta) = f(x_0) + f'(x_0)\delta + \dots = 0.$$

Tomando los dos primeros términos de la serie, tenemos que

$$f(x_0) + f'(x_0)\delta \approx 0,$$

de donde obtenemos la aproximación

$$\delta \approx -\frac{f(x_0)}{f'(x_0)}.$$

Por lo tanto, por definición de $\delta$, se sigue que

$$x^\ast \approx x_0 -\frac{f(x_0)}{f'(x_0)}.$$

"""

# ╔═╡ 30ff22cd-0cf3-4471-adc2-144b967e5659
md"""

Ahora que tenemos una primera aproximación de $x^\ast$ que **es más cercana a** $x^\ast$ que nuestra adivinanza inicial $x_0$, podemos aplicarle el mismo razonamiento a esta primera aproximación para encontrar una _segunda aproximación_ del valor $x^\ast$. Es decir, definimos

$$x_1 = x_0 -\frac{f(x_0)}{f'(x_0)}$$

y, aplicando los mismos argumentos, obtenemos

$$x_2 = x_1 -\frac{f(x_1)}{f'(x_1)}.$$

De aquí viene la naturaleza _iterativa_ del método de Newton.

**Ejercicio** Sean $i\geq0$ y $x_i$ la aproximación de $x^\ast$ después de $i$ iteraciones del método de Newton (la $0$-ésima iteración corresponde al valor de entrada). Encuentra una fórmula para la aproximación de $x_{i+1}$ en términos de $x_i$.

_Tu respuesta va aquí._
"""

# ╔═╡ f53ef69d-f387-4cdb-b054-f9c599e2a73a
md"""
$x_i=x_i-\frac{f(x_i)}{f'(x_i)}$
"""

# ╔═╡ 87922902-a3c1-4647-ab3a-eefec1721d4c
md"""## Implementación

**Ejercicio** Crea una función `newton` que tome como argumentos a `f`, `f`$^\prime$, `x0` y `n`, donde
* `f` es una función,
* `f`$^\prime$ es su derivada,
* `x0` es una aproximación inicial a una raíz de `f`, y
* `n` es el número de iteraciones del método de Newton,

y devuelva la aproximación de una raíz de `f` después de `n` iteraciones.

**Sugerencia** Utiliza un ciclo iterativo `for`.

**Nota** Para obtener el nombre de función `f`$^\prime$ al escribir código de Julia, escribie `f\prime` y usa la auto completación con la tecla `<TAB>`. Esto es necesario pues `f'` no es un nombre válido en Julia.

"""

# ╔═╡ 3e465541-c692-4bd2-8a7f-38a883587fd2
# Tu código (comentado) va aquí :D
function newton(f, f′, x0, n) #dar de alta función
	for i in 1:n 
		x0=x0-f(x0)/f′(x0) #aplicacion de la expresion anterior
	end
	return x0 #devuelve x0
end

# ╔═╡ 073a5c83-490e-494e-a9c9-b4484f3cf17b
newton(sin, cos, 1, 50)

# ╔═╡ 1c0b0804-6ff3-464e-b0a2-44b0312e2615
md"**Ejercicio** Crea una función `newtonRecursiva` que tome los mismos argumentos que `newton`, pero implemente el método de Newton utilizando un ciclo _recursivo_.
"

# ╔═╡ 4c3d53f3-c8a3-4fd4-b549-93ae3ad5b3ed
# Tu código (comentado) va aquí :D
function newtonRecursiva(f, f′, x0, n1-1)#dar de alta función
if n1 == 0 #si NO hay iteracion
	return x01 #devuelve 1ra aprox	
else 
	 x0 = x0 - f(x0) / f′(x0)
	return newtonRecursiva(f, f′, x0, n1-1) #devuelve la funcion  
end
end

# ╔═╡ 04f246b4-1b88-40dc-b4fe-fcf732fe4eed
newtonRecursiva(sin, cos, 1, 5)

# ╔═╡ fa7a3432-9f19-4c80-b241-0f80c4c5dae6
md"""

**Ejercicio** Crea una función `newtonDistancia` que tome los argumentos `f`, `f`$^\prime$, `x0` y, en vez de `n`, tome un nuevo argumento $\varepsilon$ y realice iteraciones del método de Newton hasta que dos aproximaciones consecutivas del método tengan una distancia menor a $\varepsilon$. 

**Nota** Recordando que la distancia entre dos números reales se define como el _valor absoluto_ de la diferencia entre ellos, ¿qué sucedería si ejecutáramos una función como la anterior ingresando un valor $\varepsilon\leq0$? Por ello, haz que tu función `newtonDistancia` imprima un mensaje de error si el valor ingresado de $\varepsilon$ es menor o igual a cero.

"""

# ╔═╡ cf003fbc-229a-4ba9-b36f-ee524c9213d9
# Tu código (comentado) va aquí :D
begin
	function newtonDistancia(f, f′, x0, ε)#dar de alta función
	x1=x0 - f(x0) / f′(x0) #aplicacion de la expresion anterior
	while abs(x1-x0)>ε
	x0=x1
	x1=x1 - f(x1) / f′(x1) #aplicacion de la expresion anterior para x1
	end 
	return x1 #devuelve x1
	end
end

# ╔═╡ 5326b327-625c-46ad-b311-89e9acae6629
newtonDistancia(sin, cos, 1, 8)

# ╔═╡ 0e62f809-0899-40e2-948c-b3d9eff1360c
md"""### Derivación numérica

La derivada de una función en un punto (suponiendo que existe) también se puede aproximar numéricamente.

Sea $f:\mathbb{R}\to\mathbb{R}$ una función derivable en un punto $x$. Entonces, la derivada de $f$ en $x$ se define como

$$f^\prime(x) = \lim_{h\to0}\frac{f(x+h)-f(x)}{h}.$$

Dado que dividir entre números muy pequeños (cercanos a cero) en una computadora puede causar errores de precisión muy grandes y $h$ es un valor totalmente arbitrario, podemos sustituir a la "variable muda" $h$ por $\frac{1}{h}$ directamente para obtener

$$f^\prime(x) = \lim_{\frac{1}{h}\to0}\frac{f(x+\frac{1}{h})-f(x)}{\frac{1}{h}}$$

o, equivalentemente,

$$f^\prime(x) = \lim_{h\to\infty} h \bigg( f\bigg(x+\frac{1}{h}\bigg)-f(x) \bigg).$$

Por lo tanto, si $h$ es un valor muy grande, tenemos que

$$f^\prime(x) \approx h \bigg(f\bigg(x+\frac{1}{h}\bigg)-f(x)\bigg). \quad (\ast)$$

"""

# ╔═╡ 30651437-7953-4527-b6aa-1fa7d2a25026
md"""**Ejercicio** Crea una función `derivadaNumérica` que tome argumentos `f`, `x` y `h`, donde
* `f` es una función,
* `x` es un punto del dominio de `f`, y
* `h` es un valor grande,
y calcule una aproximación de $f^\prime(x)$ usando el valor `h`.

**Sugerencia** Puedes crear esta función en una sola línea (sin usar la sintáxis que utiliza la _keyword_ `function`).
"""

# ╔═╡ 356bdd92-50c0-4410-bd83-6c34e8951313
# Tu código (comentado) va aquí :D
function derivadaNumérica(f2, x2, h2)#dar de alta función
	derivada= h2 * (f2(x2 + (1/h2)) - f2(x2)) #aplicamos la expresión anterior
end

# ╔═╡ 41b8ee90-84f5-4be8-a4bc-7cdf4597544b
derivadaNumérica(cos, 1 ,10)

# ╔═╡ 83fd7001-0fdb-4be4-b781-12bf8da68820
md"**Ejercicio** Crea una variación de la función `newton` llamada `newtonDN` que implemente el método de Newton calculando la **derivada numérica** de `f` en vez de tener a la derivada de `f` como argumento.

**Sugerencia** Usa la función `derivadaNumérica`."

# ╔═╡ 32e2d48e-0fa1-45f5-b6b2-7b9214c2e265
# Tu código (comentado) va aquí :D
function newtonDN(f1, x0, h1, n1)
for i in 1:n1
	g=derivadaNumérica(f2, x2, h2)
	x0 -= f1(x0)/g
end
	return x0
end

# ╔═╡ 5027e956-9c8c-436d-a019-b9b367ab021e
md"""**Ejercicio** Crea parámetros interactivos 
* `x0` en el rango `-10:0.1:10`, para la "adivinanza" inicial;
* `h` en `1000:1000:1000000`, para la aproximación de las derivadas numéricas como en la ecuación $(\ast)$;
* `n` en `1:1000`, para el número de iteraciones del método de Newton;
y utilízalos para crear una gráfica de la función
"""

# ╔═╡ 005372a4-35cc-4d81-846e-0aa9b66a6ce5
f = cos # Luego, usa esta celda para reasignar `f`

# ╔═╡ b55c41d7-e1e1-4378-a3de-3371b07ce929
md"""

donde se muestren con una marca todos los puntos $(x_i,f(x_i))$ para cada aproximación sucesiva de la raíz, unidos por líneas rectas. ¿Qué observas para diferentes valores de $x_0$? ¿Qué sucede si le asignas funciones distintas de `cos` a la variable `f`?

**Sugerencia** Usa la función `newtonDN` y un ciclo `for`. Como cada celda de Pluto puede mostrar sólo un deslizador como salida, debes crear una celda individual por cada parámetro interactivo.

"""

# ╔═╡ 8a43221c-8c7c-485f-95fb-3f21b78cf79f
# Tu código (comentado) va aquí :D

# ╔═╡ 9a9b1dae-b120-4baa-8780-64d10f2ac0fe
md"""## Recursos complementarios

* Sección 2.3 "Newton's Method and Its Extensions" de Burden et al, _Numerical Analysis_ (2019).

"""

# ╔═╡ 2bfe89bd-cd59-4358-b0ab-e19c0ae92227
md"""## Créditos

Este _notebook_ está basado parcialmente en los _notebooks_ originales [`0.8 Raices de funciones uni-dimensionales.ipynb`](https://github.com/dpsanders/FisicaComputacional2019_3/blob/master/notebooks/08.%20Raices%20de%20funciones%20uni-dimensionales.ipynb) y [`0.9 El metodo de Newton.ipynb`](https://github.com/dpsanders/FisicaComputacional2019_3/blob/master/notebooks/09.%20El%20metodo%20de%20Newton.ipynb) del repositorio [`FisicaComputacional2019_3`](https://github.com/dpsanders/FisicaComputacional2019_3) del Dr. David Philip Sanders.
"""

# ╔═╡ Cell order:
# ╟─8c6bcfb6-a597-4139-afd3-d239efbb13e7
# ╟─4a059976-8c17-11ec-20da-01784e520c36
# ╟─83d0773d-4327-421c-9b54-f2d83c2a85dd
# ╟─00fe1fa8-855b-4287-99ca-b1839155f908
# ╟─30ff22cd-0cf3-4471-adc2-144b967e5659
# ╟─f53ef69d-f387-4cdb-b054-f9c599e2a73a
# ╟─87922902-a3c1-4647-ab3a-eefec1721d4c
# ╠═3e465541-c692-4bd2-8a7f-38a883587fd2
# ╠═073a5c83-490e-494e-a9c9-b4484f3cf17b
# ╟─1c0b0804-6ff3-464e-b0a2-44b0312e2615
# ╠═4c3d53f3-c8a3-4fd4-b549-93ae3ad5b3ed
# ╠═04f246b4-1b88-40dc-b4fe-fcf732fe4eed
# ╟─fa7a3432-9f19-4c80-b241-0f80c4c5dae6
# ╠═cf003fbc-229a-4ba9-b36f-ee524c9213d9
# ╠═5326b327-625c-46ad-b311-89e9acae6629
# ╟─0e62f809-0899-40e2-948c-b3d9eff1360c
# ╟─30651437-7953-4527-b6aa-1fa7d2a25026
# ╠═356bdd92-50c0-4410-bd83-6c34e8951313
# ╠═41b8ee90-84f5-4be8-a4bc-7cdf4597544b
# ╟─83fd7001-0fdb-4be4-b781-12bf8da68820
# ╠═32e2d48e-0fa1-45f5-b6b2-7b9214c2e265
# ╟─5027e956-9c8c-436d-a019-b9b367ab021e
# ╠═005372a4-35cc-4d81-846e-0aa9b66a6ce5
# ╟─b55c41d7-e1e1-4378-a3de-3371b07ce929
# ╠═8a43221c-8c7c-485f-95fb-3f21b78cf79f
# ╟─9a9b1dae-b120-4baa-8780-64d10f2ac0fe
# ╟─2bfe89bd-cd59-4358-b0ab-e19c0ae92227
