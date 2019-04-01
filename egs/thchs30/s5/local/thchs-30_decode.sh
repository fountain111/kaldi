#!/bin/bash
#Copyright 2016  Tsinghua University (Author: Dong Wang, Xuewei Zhang).  Apache 2.0.

#decoding wrapper for thchs30 recipe
#run from ../

nj=8
mono=false

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.

. ./path.sh ## Source the tools/utils (import the queue.pl)

. utils/parse_options.sh || exit 1;

echo "para"
echo $1

# 1是step/decode.sh,2是exp/mono,3是data/mfcc
decoder=$1
srcdir=$2
datadir=$3


if [ $mono = true ];then
  echo  "using monophone to generate graph"
  opt="--mono"
fi

#decode word，先做图，
utils/mkgraph.sh $opt data/graph/lang $srcdir $srcdir/graph_word  || exit 1;


#解码
$decoder --cmd "$decode_cmd" --nj $nj $srcdir/graph_word $datadir/test $srcdir/decode_test_word || exit 1



#decode phone
utils/mkgraph.sh $opt data/graph_phone/lang $srcdir $srcdir/graph_phone  || exit 1;
$decoder --cmd "$decode_cmd" --nj $nj $srcdir/graph_phone $datadir/test_phone $srcdir/decode_test_phone || exit 1


