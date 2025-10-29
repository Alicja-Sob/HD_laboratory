import random
import uuid

from faker import Faker     # for generating fake data
from datetime import datetime, timedelta
from helpers import generate_random_date, random_decimal, generate_unique_pesel, generate_unique_id, splitting_id_pool

fake = Faker('pl_PL')  # fake data as if from Poland

"""
HOW REALISTIC DOES THIS DATA NEED TO BE? CAUSE THIS WOULD INVOLVE MAKING SURE NAPRAWY ARE ONLY FOR CERTAIN TYPES OF ZDARZENIA
AND ALL THE DATES ARE MATCHING BETWEEN LIKE AT LEAST 5 TABLES, THE COMPANY NAMES WOULD HAVE TO BE VETTED BETTER ETC ?! 
"""

# FIXME: THE ID'S ARE NOT ALWAYS UNIQUE for post-analityk table
all_pesels = set()
existing_ids = set()
all_pracownik_ids = set()

# ---------- GENERATING INSERTS ----------
def generate_KLIENT_insert(num, start_date, end_date):
    for _ in range(num):
        pesel = generate_unique_pesel(all_pesels)
        imie = fake.first_name()
        drugie_imie = fake.first_name() if random.random() < 0.25 else ""
        nazwisko = fake.last_name()
        data_urodzenia = generate_random_date(start_date - timedelta(days=68*635), end_date- timedelta(days=18*635))
        yield [pesel, imie, drugie_imie, nazwisko, data_urodzenia]

def generate_PRACOWNIK_insert(num, start_date, end_date):
    for _ in range(num):
        id_pracownika = generate_unique_id(existing_ids) # 20 char long id from random hex characters
        pesel = generate_unique_pesel(all_pesels)
        imie = fake.first_name()
        drugie_imie = fake.first_name() if random.random() < 0.25 else ""
        nazwisko = fake.last_name()
        data_zatrudnienia = generate_random_date(start_date, end_date)
        yield [id_pracownika, pesel, imie, drugie_imie, nazwisko, data_zatrudnienia]

def generate_AGENT_insert(num, pracownik_ids):
    agent_id_pool = splitting_id_pool(pracownik_ids, num)[0]
    #print(agent_id_pool)
    for id in agent_id_pool:
        id_agenta = id    # foreign key
        placowka = fake.city()  # idk if this should be a full address or if just a city is fine
        specjalnosc = random.choice(['majatkowe', 'osobowe', 'komunikacyjne', 'turystyczne']) if random.random() < 0.05 else ""
        yield [id_agenta, placowka, specjalnosc]

def generate_ANALITYK_insert(num, pracownik_ids):
    # idk if these are alright, made them up but idk what type of jobs are there actually in a firm like this
    possible_roles = ['mlodszy analityk danych', 'analityk danych', 'starszy analityk danych', 'analityk biznesowy', 'analityk procesow', 'Kierownik zespolu']
    possible_departments = ['analiza i bi', 'ryzyko', 'roszczenia', 'operacje', 'finanse', 'IT', 'zgodnosc', 'prawo']
    analityk_id_pool = splitting_id_pool(pracownik_ids, len(pracownik_ids) - num)[1]
    for id in analityk_id_pool:
        id_analityka = id
        rola = random.choice(possible_roles)
        dzial = random.choice(possible_departments)
        zespol = fake.bothify(text='?????-#####') # team id cause idk how else to distinguish them
        yield [id_analityka, rola, dzial, zespol]

def generate_POLISA_insert(num, start_date, end_date, klient_ids, agent_ids):
    for _ in range(num):
        id_polisy = generate_unique_id(existing_ids)
        kategoria = random.choice(['majatkowe', 'osobowe', 'komunikacyjne', 'turystyczne'])
        data_rozpoczecia = generate_random_date(start_date, end_date)
        data_zakonczenia = data_rozpoczecia + timedelta(days=random.randint(365, 365 * 5))
        premium = random_decimal(100, 10000)
        klient = random.choice(klient_ids)  # foreign key
        agent = random.choice(agent_ids)    # foreign key
        yield [id_polisy, kategoria, data_rozpoczecia, data_zakonczenia, premium, klient, agent]


def generate_POSTEPOWANIE_ANALITYK_insert(analitycy, postepowania):
    for pstp in postepowania:
        team_size = random.randint(3, 8)
        selected_team = random.sample(analitycy, team_size)
        for id_analityka in selected_team:
            yield [pstp, id_analityka]

def generate_ZDARZENIE_insert(num, start_date, end_date):
    possible_accidents = ['pozar', 'zalanie', 'wypadek samochodowy', 'upadek', 'wlamanie', 'kradziez', 'atak','uszkodzenie mienia', 'wandalizm', 'inne']
    for _ in range(num):
        id_zdarzenia = generate_unique_id(existing_ids)
        data_zdarzenia = generate_random_date(start_date, end_date) # FIXME: should be before start of postepowanie for this zdarzenie
        lokalizacja = fake.street_address() + ", " + fake.city()
        rodzaj = random.choice(possible_accidents)
        yield [id_zdarzenia, data_zdarzenia, lokalizacja, rodzaj]


def generate_POSTEPOWANIE_insert(num, start_date, end_date, polisy, zdarzenia):
    for _ in range(num):
        id_postepowania = generate_unique_id(existing_ids)
        data_rozpoczecia = generate_random_date(start_date, end_date)   # FIXME: this should to be between the start and end dates of the polisa associated with this!!
        data_zakonczenia = data_rozpoczecia + timedelta(days=random.randint(365, 365 * 5))
        liczba_dokumentow = random.randint(1, 50) # FIXME: this should correspond to the amount of files in the excel
        polisa = random.choice(polisy)
        zdarzenie = random.choice(zdarzenia)
        decyzja = random.choice(['przyznana', 'nie przyznana', 'przyznana czesciowo'])
        yield [id_postepowania, data_rozpoczecia, data_zakonczenia, liczba_dokumentow, polisa, zdarzenie, decyzja]

def generate_ODWOLANIE_insert(num, start_date, end_date, postepowania):
    for _ in range(num):
        postepowanie = random.choice(postepowania)
        id_odwolania = generate_unique_id(existing_ids)
        _status = random.choice(['przyjete', 'przetwarzane', 'zakonczone'])
        data_odwolania = generate_random_date(start_date, end_date) # FIXME: should be after end date of the postepowanie associated
        yield [postepowanie, id_odwolania, _status, data_odwolania]

def generate_ODSZKODOWANIE_insert(num, postepowania):
    for _ in range(num):
        id_odszkodowania = generate_unique_id(existing_ids)
        kwota =  random_decimal(1000, 1000000000)
        postepowanie = random.choice(postepowania)
        _status = random.choice(['oczekuje', 'zrealizowane', 'anulowane', 'opoznione', 'w toku'])
        yield [id_odszkodowania, kwota, postepowanie, _status]

def generate_NAPRAWY_insert(num, start_date, end_date, odszkodowania):
    for _ in range(num):
        id_naprawy = generate_unique_id(existing_ids)
        id_odszkodowania = random.choice(odszkodowania)
        koszt = random_decimal(1000, 1000000000)  # FIXME: ideally this and platnosc should add up do associated odszkodowanie koszt
        data_rozpoczecia = generate_random_date(start_date, end_date)   # FIXME: this should to be between the start and end dates of the postepowanie associated with this!!
        data_zakonczenia = data_rozpoczecia + timedelta(days=random.randint(365, 365 * 5))
        wykonawca = fake.company()
        yield [id_naprawy, id_odszkodowania, koszt, data_rozpoczecia, data_zakonczenia, wykonawca]

def generate_PLATNOSC_insert(num, start_date, end_date, odszkodowania):
    for _ in range(num):
        id_platnosci = generate_unique_id(existing_ids)
        id_odszkodowania = random.choice(odszkodowania)
        metoda_realizacji = random.choice(['przelew', 'gotowka'])
        konto = fake.iban() if metoda_realizacji == 'przelew' else "" # international banking account
        kwota = random_decimal(1000, 1000000000)  # FIXME: ideally this and platnosc should add up do associated odszkodowanie koszt
        data_wykonania = generate_random_date(start_date, end_date)   # FIXME: this should to be between the start and end dates of the postepowanie associated with this!!
        _status = random.choice(['oczekuje', 'wykonana', 'zrealizowana', 'wstrzymana', 'anulowana', 'nieudana'])
        yield [id_platnosci, id_odszkodowania, konto, kwota, metoda_realizacji, data_wykonania, _status]
