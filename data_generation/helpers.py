import csv
import random
from datetime import timedelta

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

def write_update_file(filename, updates):
    # writes them to a single sql file
    with open(f"{filename}.sql", 'a', encoding='utf-8') as file:
        for update in updates:
            file.write(update + "\n")