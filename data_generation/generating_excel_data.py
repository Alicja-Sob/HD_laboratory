import random
import uuid

from faker import Faker     # for generating fake data

from helpers import generate_random_date

fake = Faker('en_US')  # fake data as if from Poland

def generate_excel_entry(postepowania_ids, list_for_excel, max_docs_per_post):
    dane_dokumentu = []
    counter = 1  # lp.

    excel_lookup = {
        entry[2]: (entry[0], entry[1])  # id_postepowania → (start_date, end_date)
        for entry in list_for_excel
    }

    for id in postepowania_ids:
        docs_per_post = random.randint(1, max_docs_per_post)
        start_date, end_date = excel_lookup[id]
        docs_generated = 0

        while docs_generated < docs_per_post:
            curr_author = fake.last_name()
            for _ in range(random.randint(1, docs_per_post)):
                extension = random.choice([".pdf", ".docx", ".xlsx", ".txt", ".pptx", ".csv"])
                record = {
                    "Lp": counter,
                    "Nazwa": f"{fake.word().capitalize()}{extension}",
                    "ID_postepowania": id,
                    "Typ": random.choice(['Umowa', 'Raport', 'Faktura', 'Notatka', 'Protokol', 'Zaswiadczenie', 'Zawiadomienie', 'Inne']),
                    "Autor": curr_author,    # maybe bigger chances of matching? idk
                    "Data_dostarczenia": generate_random_date(start_date, end_date),
                    "Najwazniejsze_informacje": ", ".join(fake.words(nb=5))
                }
                dane_dokumentu.append(record)
                counter += 1
                docs_generated += 1

            if docs_generated >= docs_per_post:
                break
    return dane_dokumentu
