tree = "( (S (NP (PRP I)) (VP (VBP want) (S (VP (TO to) (VP (VB change) (NP (DT the) (NN world)))))) (. .)) )"
sentence="change NP"

from livescript import lseval

print lseval("""
parseSexp = require './parse_sexp.js'
return parseSexp('""" + tree + """')
""")

#def matchSubtree(tree, sentence)
