import random
from faker import Faker     # for generating fake data

from helpers import random_decimal

fake = Faker('pl_PL')  # fake data as if from Poland

# ---------- GENERATING UPDATES ----------
# The issue is those updates (esp the status ones) one really make sense - they are generated at random after all.
# Do they even need to make a lot of sense?

def generate_KLIENT_updates(num, ids):
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Klient SET Nazwisko = '{fake.last_name()}' WHERE PESEL = '{id}';")
    return updates

def generate_AGENT_updates(num, ids):
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Agent SET Placowka = '{fake.city()}' WHERE ID_agenta = '{id}';")
    return updates

def generate_ANALITYK_updates(num, ids):
    possible_departments = ['analiza i bi', 'ryzyko', 'roszczenia', 'operacje', 'finanse', 'IT', 'zgodnosc', 'prawo']
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Analityk SET Zespol = '{random.choice(possible_departments)}', Zespol = '{fake.bothify(text='?????-#####')}'WHERE ID_analityka = '{id}';")
    return updates

def generate_PRACOWNIK_updates(num, ids):
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Pracownik SET Nazwisko = '{fake.last_name()}' WHERE ID_pracownika = '{id}';")
    return updates

def generate_POLISA_updates(num, ids):
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Polisa SET Premium = '{random_decimal(100, 10000)}' WHERE ID_polisy = '{id}';")
    return updates

def generate_PLATNOSC_updates(num, ids):
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Platnosc SET _Status = '{random.choice(['oczekuje', 'wykonana', 'zrealizowana', 'wstrzymana', 'anulowana', 'nieudana'])}' WHERE ID_platnosci = '{id}';")
    return updates

def generate_NAPRAWY_updates(num, ids):
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Naprawy SET Wykonawca = '{fake.company()}' WHERE ID_naprawy = '{id}';")
    return updates

def generate_ODSZKODOWANIE_updates(num, ids):
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Odszkodowanie SET _Status = '{random.choice(['oczekuje', 'zrealizowane', 'anulowane', 'opoznione', 'w toku'])}' WHERE ID_odszkodowania = '{id}';")
    return updates

def generate_ODWOLANIE_updates(num, ids):
    updates = []
    for id in random.sample(ids, min(num, len(ids))):
        updates.append(f"UPDATE Odwolanie SET _Status = '{random.choice(['przyjete', 'przetwarzane', 'zakonczone'])}' WHERE ID_odwolania = '{id}';")
    return updates
