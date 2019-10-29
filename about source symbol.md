# 情報源(source)
M個の記号が選ばれ，確率に従ってそれらの記号が順に出力される．これは
**離散的M元情報源**と呼ぶ．記号を情報源記号(source symbol)と呼ぶ．

```
情報源Sのモデルを
a1, a2, ..., aM
それらに対応する正規確率を
p1, p2, ..., pM
```
のように書く．
この記述は

```
S =
 | a1,  a2,  a3, a4 |
 |1/8, 3/8, 3/8, 1/8|
```

# 情報量(information content)
正規確率Pの情報源記号を受け取った時，その情報量をIとすると

```
I = -lg P [bit]
```

# 情報源のエントロピー(average information content, entropy)

M元情報源Sのエントロピーは

```
H(S) = -sum(i=1, M)( p_i lg p_i)
```

