from itertools import combinations
from pymorphy2 import MorphAnalyzer
from TextPreprocessor import sent_tokenizer_ru, word_tokenizer, stop_words_ru, sent_tokenizer_ua, stop_words_ua
import math
from TextGraph import rank_graph

def similarity(s1, s2):
    if not len(s1) or not len(s2):
        return 0.0
    return len(s1.intersection(s2))/(math.log(len(s1)+1) + math.log(len(s2)+1))


def text_rank(text, language):
    sentences = []
    words = []

    if (language == 'ukrainian'):
        morph = MorphAnalyzer(lang='uk')
        sentences = sent_tokenizer_ua(text)
        if len(sentences) < 2:
            s = sentences[0]
            return [(1, 0, s)]
        words = [set(morph.parse(word)[0].normalized for word in word_tokenizer.tokenize(sentence.lower())
                    if word not in stop_words_ua) for sentence in sentences]
    else:
        morph = MorphAnalyzer()
        sentences = sent_tokenizer_ru(text)
        if len(sentences) < 2:
            s = sentences[0]
            return [(1, 0, s)]
        words = [set(morph.parse(word)[0].normalized for word in word_tokenizer.tokenize(sentence.lower())
                     if word not in stop_words_ru) for sentence in sentences]

    pairs = combinations(range(len(sentences)), 2)
    scores = [(i, j, similarity(words[i], words[j])) for i, j in pairs]
    scores = filter(lambda x: x[2], scores)
    pr = rank_graph(scores)

    return sorted(((i, pr[i], s) for i, s in enumerate(sentences) if i in pr),
                  key=lambda x: pr[x[0]], reverse=True)


def summarize(text, language, n=5):
    tr = text_rank(text, language)
    top_n = sorted(tr[:n])
    return ' '.join(x[2] for x in top_n)

#sanity check
print(summarize("Полиция лишь сняла отпечатки пальцев и на этом всё. Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше. Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше. Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше. Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше.Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше.Теперь мой совет: чем больше нестандартных противоугоннок - тем лучше.", 'russian', 2))
print(summarize("Його зупинила охорона і мешканці комплексу, з якими він вступив у бійку та погрожував. Після приїзду поліції нетверезий водій представився їм співробітником СБУ, помічником першого заступника Голови СБУ. Назвав своє прізвище - Саглай. Поліції пообіцяв, що все порєшає, і за водіння у нетверезому вигляді і умисне знищення майна йому абсолютно нічого не буде. Нічого не буде. Не буде. Нічого. ", 'ukrainian', 2))