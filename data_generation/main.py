from faker import Faker     # for generating fake data
from datetime import datetime, timedelta
from generating_snapshots import time_snapshot_inserts
from generating_updates import time_snapshot_updates

fake = Faker('pl_PL')  # fake data as if from Poland

if __name__ == '__main__':
    # defining snapshot spans
    snap1_start = datetime(2005, 1, 1)
    snap1_end = datetime(2020, 12, 31)

    snap2_start = datetime(2021, 2, 1)  # month later
    snap2_end = datetime(2025, 12, 31)

    nums1 = [400000, 5000, 3000, 2000, 800000, 800000, 1000000, 900000, 200000, 900000, 300000, 800000] # amounts for tables
    print("generating snapshot 1")
    time_snapshot_inserts("snapshot1", snap1_start, snap1_end, nums1) # generating .bulk files for the first snapshot

    nums2_inserts = []
    nums2_updates = []
    print("generating snapshot 2")
    time_snapshot_inserts("snapshot2", snap2_start, snap2_end, nums2_inserts) # generating .bulk files for the second snapshot
    time_snapshot_updates("snapshot2", snap2_start, snap2_end, nums2_updates) # generating .bulk files for the second snapshot
