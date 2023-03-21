Mail profesoru:

...
Napisao bih skriptu naziva Write-ToDo koja bi služila korisnicima zapisuju natuknice.
TO-DO popis prikazivao bi se svaki puta kada se pokrene računalo ukoliko stavke postoje, na način da bi se otvorio zasebni PowerShell terminal koji bi prikazivao stavke i dao određene opcije manipulacije s njima.

Generalno, napravio bih to na sljedeći način:

    Naredbom Write-ToDo -Message "poruka" sprema se "poruka" u direktorij unutar skripte
    Naredbom Check-ToDo otvarao bi se popis na sličan način kao u "ViM" text editoru. Odnosno, prikazao bi se popis stavki sa mogućnošću pisanja jednostavnih naredbi. Primjer naredbi bio bi dodavanje novih stavki, brisanje, označavanje stavke obavljenom i slično
    U skripti Write-ToDo dodatno bih postavio provjeru - ako postoji barem jedna neodrađena TO-DO stavka, tada se postavlja pokretanje naredbe Check-ToDo u startup direktorij Windowsa. Ukoliko takve stavke ne postoje, tada se miče pokretanje prilikom startupa.
    Na taj način bi se prilikom pokretanja Windowsa prikazivao popis naredbe Check-ToDo, ukoliko postoje neodrađene stavke.
    
...
