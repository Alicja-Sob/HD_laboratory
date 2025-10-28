import os
import logging

from generating_inserts import *
from generating_updates import *
from helpers import *

logging.basicConfig(level=logging.INFO)

fake = Faker('pl_PL')  # fake data as if from Poland

"""
Each table in a seperate bulk file but all updates in one sql file
"""

def generating_time_snapshot(snapshot, start_date, end_date, nums, nums_updates = None, updates = False):
    folder = os.makedirs(os.path.join("snapshots", snapshot), exist_ok=True) or os.path.join("snapshots", snapshot)

    # ---------- generating KLIENT table ----------
    klient_rows = list(generate_KLIENT_insert(nums[0], start_date, end_date))    #400k
    write_bulk_file(os.path.join(folder, "Klient_inserts"), klient_rows)
    klient_ids = [row[0] for row in klient_rows] # for later foreign keys
    logging.info("done writing KLIENT inserts to file")

    # ---------- generating PRACOWNIK table ----------
    pracownik_rows = list(generate_PRACOWNIK_insert(nums[1], start_date, end_date)) # 5k (that is... a lot?? i have no idea what a reasonable amount would be here xd)
    write_bulk_file(os.path.join(folder, "Pracownik_inserts"), pracownik_rows)
    pracownik_ids = [row[0] for row in pracownik_rows] # for later foreign keys
    logging.info("done writing PRACCOWNIK inserts to file")

    # ---------- generating AGENT table ----------
    agent_rows = list(generate_AGENT_insert(nums[2], pracownik_ids)) # 3k
    write_bulk_file(os.path.join(folder, "Agent_inserts"), agent_rows)
    agent_ids = [row[0] for row in agent_rows] # for later foreign keys
    logging.info("done writing AGENT inserts to file")

    # ---------- generating ANALITYK table ----------
    analityk_rows = list(generate_ANALITYK_insert(nums[3], pracownik_ids)) # 2k
    write_bulk_file(os.path.join(folder, "Analityk_inserts"), analityk_rows)
    analityk_ids = [row[0] for row in analityk_rows] # for later foreign keys
    logging.info("done writing ANALITYK inserts to file")

    # ---------- generating POLISA table ----------
    polisa_rows = list(generate_POLISA_insert(nums[4], start_date, end_date, klient_ids, agent_ids)) # 800k (should this be more? less?)
    write_bulk_file(os.path.join(folder, "Polisa_inserts"), polisa_rows)
    polisa_ids = [row[0] for row in polisa_rows] # for later foreign keys
    logging.info("done writing POLISA inserts to file")

    # ---------- generating ZDARZENIE table ----------
    zdarzenie_rows = list(generate_ZDARZENIE_insert(nums[5], start_date, end_date)) # 800k
    write_bulk_file(os.path.join(folder, "Zdarzenie_inserts"), zdarzenie_rows)
    zdarzenie_ids = [row[0] for row in zdarzenie_rows] # for later foreign keys
    logging.info("done writing ZDARZENIE inserts to file")

    # ---------- generating POSTEPOWANIE table ----------
    postepowanie_rows = list(generate_POSTEPOWANIE_insert(nums[6], start_date, end_date, polisa_ids, zdarzenie_ids)) # 1mln
    write_bulk_file(os.path.join(folder, "Postepowanie_inserts"), postepowanie_rows)
    postepowanie_ids = [row[0] for row in postepowanie_rows] # for later foreign keys
    logging.info("done writing POSTEPOWANIE inserts to file")

    # ---------- generating POSTEPOWANIE_ANALITYK table ----------
    post_an_rows = list(generate_POSTEPOWANIE_ANALITYK_insert(nums[7], analityk_ids, postepowanie_ids)) # 900k FIXME: idk how many should be here
    write_bulk_file(os.path.join(folder, "Pol_An_inserts"), post_an_rows)
    logging.info("done writing POSTEPOWANIE-ANALITYK inserts to file")

    # ---------- generating ODWOLANIE table ----------
    odwolanie_rows = list(generate_ODWOLANIE_insert(nums[8], start_date, end_date, postepowanie_ids)) # 200k
    write_bulk_file(os.path.join(folder, "Odwolanie_inserts"), odwolanie_rows)
    odwolanie_ids = [row[0] for row in odwolanie_rows]
    logging.info("done writing ODWOLANIE inserts to file")

    # ---------- generating ODSZKODOWANIE table ----------
    odszkodowanie_rows = list(generate_ODSZKODOWANIE_insert(nums[9], postepowanie_ids)) # 900k
    write_bulk_file(os.path.join(folder, "Odszkodowanie_inserts"), odszkodowanie_rows)
    odszkodowanie_ids = [row[0] for row in odszkodowanie_rows] # for later foreign keys
    logging.info("done writing ODSZKODOWANIE inserts to file")

    # ---------- generating NAPRAWY table ----------
    naprawy_rows = list(generate_NAPRAWY_insert(nums[10], start_date, end_date, odszkodowanie_ids)) # 300k
    write_bulk_file(os.path.join(folder, "Naprawy_inserts"), naprawy_rows)
    naprawy_ids = [row[0] for row in naprawy_rows]
    logging.info("done writing NAPRAWY inserts to file")

    # ---------- generating PLATNOSC table ----------
    platnosc_rows = list(generate_PLATNOSC_insert(nums[11], start_date, end_date, odszkodowanie_ids)) #800k
    write_bulk_file(os.path.join(folder, "Platnosc_inserts"), platnosc_rows)
    platnosc_ids = [row[0] for row in platnosc_rows]
    logging.info("done writing PLATNOSC inserts to file")

    # ------------------ generating updates for a snapshot ------------------
    if updates: # FIXME load to snapshot 2 folder and not snapshot1.. or just no folder?
        write_update_file(os.path.join("snapshots", "updates"), generate_KLIENT_updates(nums_updates[0], klient_ids), mode='w')
        write_update_file(os.path.join("snapshots", "updates"), generate_AGENT_updates(nums_updates[1], agent_ids))
        write_update_file(os.path.join("snapshots", "updates"), generate_ANALITYK_updates(nums_updates[2], analityk_ids))
        write_update_file(os.path.join("snapshots", "updates"), generate_PRACOWNIK_updates(nums_updates[3], pracownik_ids))
        write_update_file(os.path.join("snapshots", "updates"), generate_POLISA_updates(nums_updates[4], polisa_ids))
        write_update_file(os.path.join("snapshots", "updates"), generate_PLATNOSC_updates(nums_updates[5], platnosc_ids))
        write_update_file(os.path.join("snapshots", "updates"), generate_NAPRAWY_updates(nums_updates[6], naprawy_ids))
        write_update_file(os.path.join("snapshots", "updates"), generate_ODSZKODOWANIE_updates(nums_updates[7], odszkodowanie_ids))
        write_update_file(os.path.join("snapshots", "updates"), generate_ODWOLANIE_updates(nums_updates[8], odwolanie_ids))
        logging.info("Done writing updates to file")
