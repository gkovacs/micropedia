#!/usr/bin/env python3

from urllib.request import urlopen
from urllib.parse import urlencode
#import json

import sys
from collections import defaultdict

import redis
import json
r = redis.StrictRedis(host='localhost', port=6379, db=0)
import goslate
import time
import random

gs = goslate.Goslate(goslate.WRITING_NATIVE_AND_ROMAN)

def translate_from_english_nocache_raw(text, targetlang):
  time.sleep(1.0 + 4.0 * random.random())
  return list(gs.translate(text, targetlang))

def translate_from_english_raw(text, targetlang):
  key = 'gst_en2' + targetlang + '_' + text
  cachedval = r.get(key)
  if cachedval:
    return json.loads(cachedval.decode('utf-8'))
  translation = translate_from_english_nocache_raw(text, targetlang)
  r.set(key, json.dumps(translation, separators=(',', ':')))
  return translation

def translate_from_english(text, targetlang):
  translation = translate_from_english_raw(text, targetlang)
  if len(translation) > 1 and translation[1]:
    return translation[0]
  return translation[0]

vocablist = [x['sentence'] for x in json.load(open('cards_notrans.json'))]
translations = {}

srclang = 'en'
targetlang = 'zh-CN' # 'zh-CN' 'ko' 'ja' 'ko' 'vi'
for word in vocablist:
  word = word.strip()
  translation = translate_from_english(word, targetlang)
  translations[word] = translation
  print(word, '|', translation)

json.dump(translations, open('translations.json'), indent=4)