import csv
import os
import random
from faker import Faker     # for generating fake data
from datetime import datetime, timedelta

fake = Faker('pl_PL')  # fake data as if from Poland

# ---------- GENERATING UPDATES ----------

def time_snapshot_updates(snapshot, start_time, end_time, nums):
    pass