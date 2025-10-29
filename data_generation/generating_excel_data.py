import random
import uuid

from faker import Faker     # for generating fake data

from data_generation.helpers import generate_random_date

fake = Faker('pl_PL')  # fake data as if from Poland

def generate_excel_entry(postepowania_ids, start_date, end_date, docs_per_post=15):
    dane_dokumentu = []
    counter = 1  # lp.

    for id in postepowania_ids:
        for _ in range(docs_per_post):
            extension = random.choice([".pdf", ".docx", ".xlsx", ".txt", ".pptx", ".csv"])
            record = {
                "Numer porządkowy": counter,
                "Nazwa dokumentu": f"{fake.word().capitalize()}{extension}",
                "ID postępowania": id,
                "Typ dokumentu": random.choice(['Umowa', 'Raport', 'Faktura', 'Notatka', 'Protokoł', 'Zaswiadczenie', 'Zawiadomienie', 'Inne']),
                "Autor dokumentu": fake.last_name(),    # maybe bigger chances of matching? idk
                "Data dostarczenia dokumentu": generate_random_date(start_date, end_date),
                "Najważniejsze informacje": ", ".join(fake.words(nb=5))
            }
            dane_dokumentu.append(record)
            counter += 1
    return dane_dokumentu