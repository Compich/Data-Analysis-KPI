# Инициализация всего необходимого для предобработки
from nltk.tokenize.punkt import PunktSentenceTokenizer, PunktParameters
from nltk.tokenize import RegexpTokenizer
import csv
import io


def get_stop_words(language):
    stopwords = []
    filename = 'stop_words_ru.csv'
    if language == 'ukrainian':
        filename = 'stop_words_ua.csv'
    with io.open(filename, 'r', encoding="utf-8") as file:
        for row in csv.reader(file):
            stopwords.append(row[0])
    return stopwords


def get_abbreviation(language):
    if language == 'ukrainian':
        return ['тис', 'грн', 'т.я', 'вул', 'cек', 'хв', 'обл', 'кв', 'пл', 'напр', 'гл', 'і.о', 'зам']
    return ['тыс', 'руб', 'т.е', 'ул', 'д', 'сек', 'мин', 'т.к', 'т.н', 'т.о', 'ср', 'обл', 'кв', 'пл',
            'напр', 'гл', 'и.о', 'им', 'зам', 'гл', 'т.ч']


punkt_param_ru = PunktParameters()
abbreviation_ru = get_abbreviation('russian')
punkt_param_ru.abbrev_types = set(abbreviation_ru)
sent_tokenizer_ru = PunktSentenceTokenizer(punkt_param_ru).tokenize
stop_words_ru = get_stop_words('russian')

punkt_param_ua = PunktParameters()
abbreviation_ua = get_abbreviation('ukrainian')
punkt_param_ua.abbrev_types = set(abbreviation_ua)
sent_tokenizer_ua = PunktSentenceTokenizer(punkt_param_ru).tokenize
stop_words_ua = get_stop_words('ukrainian')

word_tokenizer = RegexpTokenizer(r'\w+')

