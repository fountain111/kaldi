#!/bin/bash

mkdir -p data/local
local=`pwd`/local
scripts=`pwd`/scripts

export PATH=$PATH:`pwd`/../../../tools/irstlm/bin

echo "Preparing train and test data"

train_base_name=train_yesno
test_base_name=test_yesno

# $1表示第一个参数，比如 prepare_data.sh waves_yesno  ,第一个参数就是waves_yesno
waves_dir=$1

ls -1 $waves_dir > data/local/waves_all.list

cd data/local

# 声音放入训练集 测试集，存放地址是 local/waves.train, 存放的内容是文件名，pl可以用python改写

../../local/create_yesno_waves_test_train.pl waves_all.list waves.test waves.train

# 存放标注和文件名，存放的位置在loacl train_yesno_wav.scp,格式为 0_0_0_0_1_1_1_1 waves_yesno/0_0_0_0_1_1_1_1.wav

../../local/create_yesno_wav_scp.pl ${waves_dir} waves.test > ${test_base_name}_wav.scp


../../local/create_yesno_wav_scp.pl ${waves_dir} waves.train > ${train_base_name}_wav.scp

# 位置在local/train_yesno.txt,标注和现实语言对应,格式为 0_0_0_0_1_1_1_1 NO NO NO NO YES YES YES YES

../../local/create_yesno_txt.pl waves.test > ${test_base_name}.txt

../../local/create_yesno_txt.pl waves.train > ${train_base_name}.txt

# 语言模型 但没有弄明白 里面参数的意义 ，只是个文件，应该是n-gram模型的参数
cp ../../input/task.arpabo lm_tg.arpa

cd ../..

# 拷贝到 data/下，awk是文本处理工具，把文本和人声对应起来，这里是global，最后把uu2spk转成sp2utt格式,也就是人对应声音，和声音对人的两种格式.
# This stage was copied from WSJ example
for x in train_yesno test_yesno; do 
  mkdir -p data/$x
  cp data/local/${x}_wav.scp data/$x/wav.scp
  cp data/local/$x.txt data/$x/text
  cat data/$x/text | awk '{printf("%s global\n", $1);}' > data/$x/utt2spk
  utils/utt2spk_to_spk2utt.pl <data/$x/utt2spk >data/$x/spk2utt
done

