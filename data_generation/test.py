from faker import Faker
from generating_inserts import *

fake = Faker('en_US')

word_len = list(map(len, fake.get_words_list()))
print(max(word_len)) #14

#generate_POSTEPOWANIE_insert()
date1 = datetime(2005, 1, 1)
date2 = datetime(2020, 12, 31)
print(list(generate_PRACOWNIK_insert(3, date1, date2)))
