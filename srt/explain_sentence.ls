{parseSexp} = require('./parse_sexp')

sexp = parseSexp '( (S (NP (NN Word) (NN processing)) (VP (VBZ is) (NP (NP (DT a) (JJ complex) (NN task)) (SBAR (WHNP (WDT that)) (S (VP (VBZ touches) (PP (IN on) (NP (NP (JJ many) (NNS goals)) (PP (IN of) (NP (JJ human-computer) (NN interaction)))))))))) (. .)) )'

console.log parseSexp(parseSexp(parseSexp(sexp.childrentree[0]).childrentree[1]).childrentree[1])
