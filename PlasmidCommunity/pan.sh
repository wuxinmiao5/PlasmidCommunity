#!/usr/bin/env bash

echo original parameters=[$@]

#-o��--optionsѡ������ǿɽ��ܵĶ�ѡ���ab:c::����ʾ�ɽ��ܵĶ�ѡ��Ϊ-a -b -c��
#����-aѡ��Ӳ�����-bѡ������Ӳ�����-cѡ��Ĳ���Ϊ��ѡ��
#-l��--longѡ������ǿɽ��ܵĳ�ѡ��ö��ŷֿ���ð�ŵ�����ͬ��ѡ�
#-nѡ�� ���ѡ���������ʱ��ʾ�Ľű�����
ARGS=`getopt -o hd:i:m:o: --long input_plasmid_seq:,input_membership:,membercutoff:,output_tag: -n "$0" -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

echo ARGS=[$ARGS]
#���淶����������в���������λ�ò�����$1,$2,...)
eval set -- "${ARGS}"
echo formatted parameters=[$@]

while true
do
    case "$1" in
	-h|--help)
      echo "Usage: pan.sh -i input_membership -m membershipcutoff -o outputtag"
			echo "-p|--input_plasmid_seq the path of a directory containing plasmids genomes"
	    echo "-i|--input_membership the membership file of the network nodes"
	    echo "-m|--membershipcutoff the minimum of community size"
	    echo "-o|--outputtag the output tag"
	    exit 1
	    ;;
        -i|--input_plasmid_seq)
            #echo "Option a";
	    forinput_plasmid_seq=$2
            shift 2
	   				;;
        -i|--input_membership)
            #echo "Option a";
	    forinput_membership=$2
            shift 2
            ;;
            -m|--membercutoff)
            #echo "Option a";
	    formembercutoff=$2
            shift 2
            ;;
        -o|--output_tag)
            #echo "Option b, argument $2";
	    foroutput_tag=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done
#
getbase=dirname $0
Rscript ${getbase}/pan.R $forinput_plasmid_seq $forinput_membership $formembercutoff $foroutput_tag

