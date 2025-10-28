import os
from generating_inserts import *
from helpers import *

fake = Faker('pl_PL')  # fake data as if from Poland

"""
IM DOING EACH TABLE IN A SEPERATE FILE BUT IDK IF ALL IN ONE WOULD BE BETTER OR WORSE?
"""

def time_snapshot_inserts(snapshot, start_date, end_date, nums):
    folder = os.makedirs(snapshot, exist_ok=True) or snapshot

    # ---------- generating KLIENT table ----------
    klient_rows = list(generate_KLIENT_insert(nums[0], start_date, end_date))    #400k
    write_bulk_file(os.path.join(folder, "Klient_inserts"), klient_rows)
    klient_ids = [row[0] for row in klient_rows] # for later foreign keys

    # ---------- generating PRACOWNIK table ----------
    pracownik_rows = list(generate_PRACOWNIK_insert(nums[1], start_date, end_date)) # 5k (that is... a lot?? i have no idea what a reasonable amount would be here xd)
    write_bulk_file(os.path.join(folder, "Pracownik_inserts"), pracownik_rows)
    pracownik_ids = [row[0] for row in pracownik_rows] # for later foreign keys

    # ---------- generating AGENT table ----------
    agent_rows = list(generate_AGENT_insert(nums[2], pracownik_ids)) # 3k
    write_bulk_file(os.path.join(folder, "Agent_inserts"), agent_rows)
    agent_ids = [row[0] for row in agent_rows] # for later foreign keys

    # ---------- generating ANALITYK table ----------
    analityk_rows = list(generate_ANALITYK_insert(nums[3], pracownik_ids)) # 2k
    write_bulk_file(os.path.join(folder, "Analityk_inserts"), analityk_rows)
    analityk_ids = [row[0] for row in analityk_rows] # for later foreign keys

    # ---------- generating POLISA table ----------
    polisa_rows = list(generate_POLISA_insert(nums[4], start_date, end_date, klient_ids, agent_ids)) # 800k (should this be more? less?)
    write_bulk_file(os.path.join(folder, "Polisa_inserts"), polisa_rows)
    polisa_ids = [row[0] for row in polisa_rows] # for later foreign keys

    # ---------- generating ZDARZENIE table ----------
    zdarzenie_rows = list(generate_ZDARZENIE_insert(nums[5], start_date, end_date)) # 800k
    write_bulk_file(os.path.join(folder, "Zdarzenie_inserts"), zdarzenie_rows)
    zdarzenie_ids = [row[0] for row in zdarzenie_rows] # for later foreign keys

    # ---------- generating POSTEPOWANIE table ----------
    postepowanie_rows = list(generate_POSTEPOWANIE_insert(nums[6], start_date, end_date, polisa_ids, zdarzenie_ids)) # 1mln
    write_bulk_file(os.path.join(folder, "Postepowanie_inserts"), postepowanie_rows)
    postepowanie_ids = [row[0] for row in postepowanie_rows] # for later foreign keys

    # ---------- generating POSTEPOWANIE_ANALITYK table ----------
    post_an_rows = list(generate_POSTEPOWANIE_ANALITYK_insert(nums[7], analityk_ids, postepowanie_ids)) # 900k FIXME: idk how many should be here
    write_bulk_file(os.path.join(folder, "Pol_An_inserts"), post_an_rows)

    # ---------- generating ODWOLANIE table ----------
    odwolanie_rows = list(generate_ODWOLANIE_insert(nums[8], start_date, end_date, postepowanie_ids)) # 200k
    write_bulk_file(os.path.join(folder, "Odwolanie_inserts"), odwolanie_rows)

    # ---------- generating ODSZKODOWANIE table ----------
    odszkodowanie_rows = list(generate_ODSZKODOWANIE_insert(nums[9], postepowanie_ids)) # 900k
    write_bulk_file(os.path.join(folder, "Odszkodowanie_inserts"), odszkodowanie_rows)
    odszkodowanie_ids = [row[0] for row in odszkodowanie_rows] # for later foreign keys

    # ---------- generating NAPRAWY table ----------
    naprawy_rows = list(generate_NAPRAWY_insert(nums[10], start_date, end_date, odszkodowanie_ids)) # 300k
    write_bulk_file(os.path.join(folder, "Naprawy_inserts"), naprawy_rows)

    # ---------- generating PLATNOSC table ----------
    platnosc_rows = list(generate_PLATNOSC_insert(nums[11], start_date, end_date, odszkodowanie_ids)) #800k
    write_bulk_file(os.path.join(folder, "Platnosc_inserts"), platnosc_rows)
