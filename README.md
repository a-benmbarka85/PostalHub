# PostalHub

Aplicación Flutter que consulta la API de geocodificación de Open-Meteo para buscar poblaciones por código postal o nombre.

## Funcionalidades

- Búsqueda por código postal o nombre de población.
- Lista de resultados con nombre, provincia y comunidad autónoma.
- Detalle de la población con todos sus datos, coordenadas y códigos postales.
- Tiempo actual en el detalle (temperatura, viento y estado del cielo).
- Búsquedas recientes (las 5 últimas que han encontrado resultados).
- Estados de la búsqueda: inicial, cargando, resultados, no encontrado y error.

## Estructura del proyecto

```
lib/
  main.dart
  models/
    place.dart
    search_response.dart
    weather_response.dart
    current.dart
    current_units.dart
  screens/
    search_screen.dart
    place_detail_screen.dart
  styles/
    app_styles.dart
  widgets/
    place_card.dart
    info_card.dart
    recent_searches.dart
```

## Dependencias

- `http`

## Ejecución

```
flutter pub get
flutter run
```

## Reflexión

El mayor reto fue manejar los campos opcionales del JSON, ya que no todas las poblaciones incluyen `population` ni `postcodes`. Una vez resuelto con tipos opcionales, el resto fluyó bien. El uso de `FutureBuilder` para el tiempo resultó muy cómodo para gestionar carga y error sin afectar al resto del detalle. Si volviera a empezar, separaría la capa de acceso a la API de las pantallas y añadiría tests para los modelos. En general, he aprendido a conectar una app a una API real, parsear JSON y mostrar los distintos estados al usuario.