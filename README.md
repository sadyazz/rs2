# Upute za pokretanje

Nakon kloniranja repozitorija uraditi sljedeće:

Otvoriti rs2/eCinema u terminalu i pokrenuti komandu: docker-compose up –build
Extractovati: fit-build-2025-09-08-desktop
Pokrenuti ecinema_desktop.exe koji se nalazi u folderu "Release"
Unijeti desktop kredencijale koji se mogu pronaći u ovom readme-u
Prije pokretanja mobilne aplikacije pobrinuti se da aplikacija već ne postoji na android emulatoru, ukoliko postoji, uraditi deinstalaciju iste
Extractovati: fit-build-2025-09-08-mobile
Nakon extractovanja, prevući apk fajl koji se nalazi u folderu "flutter-apk" u emulator i sačekati da se aplikacija instalira
Nakon što je aplikacija instalirana, pokrenuti je i unijet

## Napomene

- Staff korisnici se ne mogu samostalno registrovati, već ih isključivo administrator dodaje putem desktop aplikacije, nakon čega staff korisnik prima email sa svojim login kredencijalima.
- Globalno „Back" dugme implementirano je na način da se kroz glavne ekrane (Dashboard, Movies, Screenings i druge) korisnik kreće pomoću navigacije, dok je pri otvaranju detalja ili dodatnih formi omogućena funkcionalnost koraka nazad.
- Korisnici mogu ostaviti recenziju samo za filmove koje su pogledali. To znači da je potrebno da je QR kod vezan za njihovu rezervaciju skeniran, čime se rezervacija/karta označava kao iskorištena (used). Kada korisnik ponovo uđe u aplikaciju nakon gledanja filma, prikazuje mu se bottom sheet za ostavljanje recenzije samo ako je rezervacija označena kao iskorištena, tj. ukoliko je film pregledan.

## Kredencijali za prijavu

### Administrator (desktop):
- **username:** admin
- **password:** stringst

### Korisnik1 (mobilna aplikacija):
- **username:** user1
- **password:** stringst

### Korisnik2 (mobilna aplikacija):
- **username:** user2
- **password:** stringst

### Staff (mobilna aplikacija):
- **username:** staff
- **password:** stringst

## Stripe kredencijali

### Informacije za plaćanje (za Stripe testiranje)
Koristite sljedeće informacije za testiranje Stripe plaćanja:

- **Broj kartice:** 4242 4242 4242 4242
- **Datum isteka:** Bilo koji budući datum
- **CVC:** Bilo koji trocifreni broj
- **ZIP kod:** Bilo koji petocifreni broj

## RabbitMQ

Rabbitmq je iskorišten za slanje mailova prilikom registracije korisnika na mobilnoj aplikaciji, takodjer se koristi za slanje emailova prilikom kreiranja novog staff korisnika od strane administratora. Novom staff korisniku se putem emaila dostavljaju pristupni podaci, uključujući korisničko ime i privremenu lozinku za prijavu u sistem.
