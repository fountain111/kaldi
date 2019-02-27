#!/bin/bash

mkdir -p data/local/dict

#一大片的拷贝

# 单词-发音格式文件
cp input/lexicon_nosil.txt data/local/dict/lexicon_words.txt

# 发音字典,格式为 单词 - 发音， 左边为单词，右边为发音,如  YES Y  ,SIL代表静音，也有音素
# lexiconp.txt是在lexicon的基础上增加了发音概率，虽然这里没有处理这个文件，这个文件里的发音概率都设置成了1
cp input/lexicon.txt data/local/dict/lexicon.txt

#====
#这个文件里记载了非语言学音素 # grep： 查找指令 ，-v选项表示反向查找，
#意思是，查找phones.txt的内容， 凡是不含 SIL 的行，会被重定向输出 （ > ）到 nonsilence_phones.txt
#====


cat input/phones.txt | grep -v SIL > data/local/dict/nonsilence_phones.txt

#建立两个文件.不是特别清楚在什么地方需要这种格式的文件.可能是包含静音，非语言学，如噪声，笑声等音素。
echo "SIL" > data/local/dict/silence_phones.txt

echo "SIL" > data/local/dict/optional_silence.txt

echo "Dictionary preparation succeeded"
