import csv
import random
import uuid
from datetime import timedelta

from faker import Faker     # for generating fake data
fake = Faker('pl_PL')  # fake data as if from Poland

# ---------- HELPER METHODS ----------
def generate_random_date(start_date, end_date):
    diff = end_date - start_date
    random_date = start_date + timedelta(days=random.randint(0, diff.days)) # diff.days - number of days between start and end dates
    return random_date.date()

def random_decimal(min_val, max_val, dec_places=2):
    return round(random.uniform(min_val, max_val), dec_places)

def write_bulk_file(filename, rows):
    with open(f"{filename}.bulk", 'w', newline='', encoding='utf-8') as file:   # overwrites existing file
        writer = csv.writer(file, delimiter='|', quoting=csv.QUOTE_MINIMAL) # values surrounded by "" only when they have special characters
        for row in rows:
            writer.writerow(row)

def write_update_file(filename, updates, mode='a'):
    # writes them to a single sql file
    with open(f"{filename}.sql", mode, encoding='utf-8') as file:
        for update in updates:
            file.write(update + "\n")

def write_excel_file(filename, dane):
    fieldnames = list(dane[0].keys())
    with open(f"{filename}.csv", mode="w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()    # idk if this should have the header or not
        writer.writerows(dane)


def generate_unique_pesel(all_pesels):
    while True:
        pesel = fake.pesel()
        if pesel not in all_pesels:
            all_pesels.add(pesel)
            return pesel

def generate_unique_id(existing_ids):
    while True:
        new_id = uuid.uuid4().hex[:20]
        if new_id not in existing_ids:
            existing_ids.add(new_id)
            return new_id

def splitting_id_pool(pracownik_ids, num_ag):
    num_an = len(pracownik_ids) - num_ag
    # random.shuffle(pracownik_ids)
    agent_ids = pracownik_ids[:num_ag]
    analityk_ids = pracownik_ids[num_ag:num_ag+num_an]

    return agent_ids, analityk_ids