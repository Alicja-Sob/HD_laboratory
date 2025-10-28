import logging
logging.basicConfig(level=logging.INFO)

from faker import Faker     # for generating fake data
from datetime import datetime, timedelta
from generating_snapshots import generating_time_snapshot

fake = Faker('pl_PL')  # fake data as if from Poland

if __name__ == '__main__':
    # defining snapshot spans
    snap1_start = datetime(2005, 1, 1)
    snap1_end = datetime(2020, 12, 31)

    snap2_start = datetime(2021, 2, 1)  # month later
    snap2_end = datetime(2025, 12, 31)

    nums1 = [400000, 5000, 3000, 2000, 800000, 800000, 1000000, 900000, 200000, 900000, 300000, 800000] # amounts for tables
    nums2_updates = [1000, 500, 300, 600, 1000, 2000, 100, 500, 1000]

    logging.info("\tGENERATING SNAPSHOT 1")
    # updates are generated from snapshot1 data this way
    generating_time_snapshot("snapshot1", snap1_start, snap1_end, nums1, nums2_updates, True) # generating .bulk files for the first snapshot
    logging.info("\tdone GENERATING SNAPSHOT 1")

    nums2_inserts = [10000, 1000, 500, 200, 50000, 50000, 100000, 150000, 10000, 140000, 40000, 100000]
    logging.info("\tGENERATING SNAPSHOT 2")
    generating_time_snapshot("snapshot2", snap2_start, snap2_end, nums2_inserts) # generating .bulk files for the second snapshot
    logging.info("\tdone GENERATING SNAPSHOT 2")
