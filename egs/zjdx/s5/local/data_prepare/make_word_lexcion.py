#!/usr/bin/env python

import sys

#===
# from L1 Word_2_Pinyin
#      L2 pinying_2_phone
#
#out: lexcion 形成类似thchs30样式的word-phone ,从大词典抽取，也可以自己维护
if __name__ == '__main__':

    pinyin_2_phone = {}
    word_pinyin_file = sys.argv[1] #大词典表
    pinyin_phone_file = sys.argv[2] #大词典表

    for l in open(pinyin_phone_file): # "ZHENG	zh eng"
        cols = l.strip().split('\t')
        assert len(cols) ==2
        pinyin = cols[0]
        phone = cols[1].split()
        pinyin_2_phone[pinyin] = phone
        #print(pinyin_2_phone)
        #break

    for l in open(word_pinyin_file):  # "15	YI_1 WU_3;YAO_1 WU_3"
        cols = l.strip().split('\t')
        assert len(cols)==2
        word = cols[0]
        prons = cols[1].split(';')

        for pron in prons:
            phone_seq = []
            for pinyin in pron.split():
                #print(pinyin)
                base,tone = pinyin.split('_')
                #每个base 对应的phones取出来
                phones = [phone for phone in pinyin_2_phone[base]]
                #phones[-1]= phones[-1]+'_'+tone
                phones[-1]= phones[-1]+tone
                phone_seq.extend(phones)
                #print()
            print(word + '\t' + ' '.join(phone_seq))


