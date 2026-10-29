# PostalHub

App Flutter que consulta la API de geocodificación de Open-Meteo para buscar poblaciones por código postal o nombre.

## Funcionalidades

- Búsqueda por código postal o nombre de población.
- Lista de resultados con nombre, provincia y comunidad.
- Detalle de población con todos los datos, códigos postales (Wrap + Chip) y tiempo actual.
- Búsquedas recientes (5 últimas que han encontrado resultados).
- Estados: inicial, cargando, resultados, no encontrado, error con reintento.

## Estructura

```
lib/
  main.dart
  models/        # Place, SearchResponse, WeatherResponse, Current, CurrentUnits
  screens/       # SearchScreen, PlaceDetailScreen
  styles/        # AppStyles
  widgets/       # PlaceCard, InfoCard, RecentSearches
```

## Reflexión

Me costó un poco acostumbrarme a trabajar con datos opcionales del JSON: Sant Pere de Reixac no tiene `population` ni `postcodes`, y si no se marcan como opcionales la app peta. Una vez entendido, el resto fue sobre ruedas. Me sorprendió lo cómodo que es `FutureBuilder` para gestionar los estados de carga y error del tiempo sin bloquear el resto del detalle. Si volviera a empezar, separaría mejor la capa de servicio (API) de los widgets y añadiría tests unitarios para los modelos. En general, he aprendido a conectar una app a una API real, parsear JSON y mostrar los estados al usuario.