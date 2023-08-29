from pymorphy2 import MorphAnalyzer
import numpy
from numpy.linalg import svd
from TextPreprocessor import sent_tokenizer_ru, word_tokenizer, stop_words_ru, sent_tokenizer_ua, stop_words_ua
import math


def create_dictionary(text, morph, stop_words):
    words = set(morph.parse(word)[0].normalized for word in word_tokenizer.tokenize(
        text.lower()) if word not in stop_words)
    return dict((w, i) for i, w in enumerate(words))


def create_matrix(text, sent_tokenizer, morph, dictionary):
    sentences = sent_tokenizer(text)

    words_count = len(dictionary)
    sentences_count = len(sentences)

    matrix = numpy.zeros((words_count, sentences_count))
    for col, sentence in enumerate(sentences):
        for word in word_tokenizer.tokenize(sentence.lower()):
            word = morph.parse(word)[0].normalized
            if word in dictionary:
                row = dictionary[word]
                matrix[row, col] += 1
    rows, cols = matrix.shape
    if rows and cols:
        word_count = numpy.sum(matrix) 
        for row in range(rows):
            unique_word_count = numpy.sum(matrix[row, :])
            for col in range(cols):
                if matrix[row, col]:
                    matrix[row, col] = unique_word_count/word_count
    else:
        matrix = numpy.zeros((1, 1))
    return matrix


def compute_ranks(matrix, n):
    u_m, sigma, v_m = svd(matrix, full_matrices=False)
    powered_sigma = tuple(s**2 if i < n else 0.0 for i, s in enumerate(sigma))
    ranks = []
    for column_vector in v_m.T:
        rank = sum(s*v**2 for s, v in zip(powered_sigma, column_vector))
        ranks.append(math.sqrt(rank))
    return ranks


def summarize(text, language, n=5):
    morph = MorphAnalyzer()
    sent_tokenizer = sent_tokenizer_ru
    stop_words = stop_words_ru

    if language == 'ukrainian':
        morph = MorphAnalyzer(lang='uk')
        sent_tokenizer = sent_tokenizer_ua
        stop_words = stop_words_ua

    d = create_dictionary(text, morph, stop_words)
    m = create_matrix(text, sent_tokenizer, morph, d)
    r = compute_ranks(m, n)
    sentences = sent_tokenizer(text)
    rank_sort = sorted(((i, r[i], s) for i, s in enumerate(
        sentences)), key=lambda x: r[x[0]], reverse=True)
    top_n = sorted(rank_sort[:n])
    return ' '.join(x[2] for x in top_n)


# sanity check
print(summarize("Полиция лишь сняла отпечатки пальцев и на этом всё. Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше. Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше. Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше. Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше.Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше.Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше.", 'russian', 2))
print(summarize("Його зупинила охорона і мешканці комплексу, з якими він вступив у бійку та погрожував. Після приїзду поліції нетверезий водій представився їм співробітником СБУ, помічником першого заступника Голови СБУ. Назвав своє прізвище - Саглай. Поліції пообіцяв, що все порєшає, і за водіння у нетверезому вигляді і умисне знищення майна йому абсолютно нічого не буде. Нічого не буде. Не буде. Нічого. ", 'ukrainian', 2))
