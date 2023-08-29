import re
import math
from pymorphy2 import MorphAnalyzer
from TextPreprocessor import word_tokenizer
from sklearn.feature_extraction.text import TfidfVectorizer
from collections import Counter

class StemTokenizer(object):
    def __init__(self, language):
        self.morph = MorphAnalyzer()
        if language == 'ukrainian':
            self.morph = MorphAnalyzer(lang='uk')

    def __call__(self, doc):
        return [self.morph.parse(t)[0].normalized for t in word_tokenizer.tokenize(doc.lower())]


WORD = re.compile(r'\w+')

def get_cosine(vec1, vec2):
     intersection = set(vec1.keys()) & set(vec2.keys())
     numerator = sum([vec1[x] * vec2[x] for x in intersection])

     sum1 = sum([vec1[x]**2 for x in vec1.keys()])
     sum2 = sum([vec2[x]**2 for x in vec2.keys()])
     denominator = math.sqrt(sum1) * math.sqrt(sum2)

     if not denominator:
        return 0.0
     else:
        return float(numerator) / denominator

def text_to_vector(text):
     words = WORD.findall(text)
     return Counter(words)


def tfidf(text, language, sent_tokenizer, stop_words):
    sentences = sent_tokenizer(text)
    tfidf = TfidfVectorizer(ngram_range=(
        1, 1), stop_words=stop_words, tokenizer=StemTokenizer(language)).fit_transform(sentences)
    a = tfidf.toarray()
    return a