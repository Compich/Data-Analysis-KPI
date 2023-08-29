from itertools import combinations
from pymorphy2 import MorphAnalyzer
from TextPreprocessor import sent_tokenizer_ru, word_tokenizer, stop_words_ru, sent_tokenizer_ua, stop_words_ua
import math
from TextGraph import rank_graph
from numpy import dot
from numpy.linalg import norm
from VectorMeasuresCalculator import tfidf, get_cosine, text_to_vector
import LSASummarizer

def similarity(s1, s2):
    n1 = norm(s1)
    n2 = norm(s2)
    if not n1 or not n2:
        return 0.0
    return dot(s1, s2)/(n1*n2)

def text_rank(text, language):
    try:
        sentences = []
        a = []
        if (language == 'ukrainian'):
            morph = MorphAnalyzer(lang='uk')
            sentences = sent_tokenizer_ua(text)
            if len(sentences) < 2:
                s = sentences[0]
                return [(1, 0, s)]
            try:
                a = tfidf(text, language, sent_tokenizer_ua, stop_words_ua)
            except:
                print(text)
        else:
            morph = MorphAnalyzer()
            sentences = sent_tokenizer_ru(text)
            if len(sentences) < 2:
                s = sentences[0]
                return [(1, 0, s)]
            a = tfidf(text, language, sent_tokenizer_ru, stop_words_ru)

        pairs = combinations(range(len(sentences)), 2)
        scores = [(i, j, similarity(a[i, :], a[j, :])) for i, j in pairs]
        scores = filter(lambda x: x[2], scores)

        pr = rank_graph(scores)

        return sorted(((i, pr[i], s) for i, s in enumerate(sentences) if i in pr),
                    key=lambda x: pr[x[0]], reverse=True)  # Сортировка по убыванию ранга тройки
    except:
        return 'ERROR HAPPENED'

def summarize(text, language, n=5):
    try:
        tr = text_rank(text, language)
        top_n = sorted(tr[:n])
        text_rank_result = ' '.join(x[2] for x in top_n)
        lsa_result = LSASummarizer.summarize(text, language, n)
        cosine_text_rank = get_cosine(text_to_vector(text), text_to_vector(text_rank_result))
        cosine_lsa=get_cosine(text_to_vector(text), text_to_vector(lsa_result))
        if cosine_lsa > cosine_text_rank:
            return lsa_result
        return text_rank_result
    except:
        return 'ERROR HAPPENED'
