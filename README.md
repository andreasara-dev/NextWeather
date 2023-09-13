# NextWeather
iOS Weather SwiftUI app

<img src="https://github.com/andreasara-dev/NextWeather/blob/main/Demo/Demo.gif" width="300" height="700" alt="example">

A simple app that shows weather forecasts regarding the current location of the user.

The app has two main views contained in a tab view:

- A Weather View that shows the current weather, the daily forecasts for the upcoming 7 days and those for the upcoming 24 hours.
- A practice MapView that shows our current position on the map.

In WeatherView is present a search bar for digit a name of a city and retrieve its forecasts.

### Technical details

- **SwiftUI** for User Interface,
- **CoreLocation** for detect the user location, 
- **MapKit** for view the map,
- **Network** for check if the user is connected,
- **Combine** for setting the API call,
- **Settings.bundle** for insert the app settings in the system Settings app of the device

The free API service is from: https://open-meteo.com/<br>
The app icon was created from: https://www.canva.com/

---

Una semplice app per visionare il meteo della zona in cui ti trovi o di una località precisa.

L’app ha due view principali contenute in una tab view:

- Una Weather View mostra il meteo corrente, le previsioni giornaliere di 7 giorni e quelle delle successive 24 ore.

- Una pratica MapView per vedere la nostra posizione sulla mappa.

Nella Weather View è presente una barra di ricerca per digitare il nome di una città e recuperarne le previsioni meteorologiche.

### Dettagli tecnici

- **SwiftUI** per la User Interface,
- **CoreLocation** per determinare la posizione dell’utente,
- **MapKit** per la visualizzazione della mappa,
- **Network** per verificare se si è connessi a internet, in modo da effettuare la chiamata API,
- **Combine** per impostare la chiamata API,
- **Settings.bundle** per selezionare i gradi Fahrenheit o Celsius direttamente dall’app di sistema Impostazioni del device

Il servizio API utilizzato è quello gratuito di: https://open-meteo.com/<br>
L’icona dell’app è stata creata grazie a Canva: https://www.canva.com/
