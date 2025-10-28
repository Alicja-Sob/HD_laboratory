from faker import Faker     # for generating fake data
from datetime import datetime, timedelta
from generating_snapshots import time_snapshot_inserts
from generating_updates import time_snapshot_updates

fake = Faker('pl_PL')  # fake data as if from Poland

if __name__ == '__main__':
    # defining snapshot spans

