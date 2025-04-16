#!/usr/bin/env bash

#echo original parameters=[$@]

#-o��--optionsѡ������ǿɽ��ܵĶ�ѡ���ab:c::����ʾ�ɽ��ܵĶ�ѡ��Ϊ-a -b -c��
#����-aѡ��Ӳ�����-bѡ������Ӳ�����-cѡ��Ĳ���Ϊ��ѡ��
#-l��--longѡ������ǿɽ��ܵĳ�ѡ��ö��ŷֿ���ð�ŵ�����ͬ��ѡ�
#-nѡ�� ���ѡ���������ʱ��ʾ�Ľű�����
ARGS=`getopt -o ha:d:m:o: --long fastani:,discutoff:,membercutoff:,output_tag: -n "$0" -- "$@"`
if [ $? != 0 ]; then4
    echo "Terminating..."
    exit 1
fi

#echo ARGS=[$ARGS]
#���淶����������в���������λ�ò�����$1,$2,...)
eval set -- "${ARGS}"
#echo formatted parameters=[$@]

while true
do
    case "$1" in
	-h|--help)
     echo "Usage: getCommunity.sh -a fastani -d discutoff -m membercutoff -o output_tag"
	   echo "-a|--fastani the fastani result for input, it's the result saved by silhouetteCurve process"
	   echo "-d|--discutoff the distance cutoff to generate community"
     echo "-m|--membershipcutoff the minimum of community size"
	   echo "-o|--outputtag the output tag"
	    exit 1
	    ;;
        -a|--fastani)
            #echo "Option a";
	    forfastani=$2
            shift 2
            ;;
            -d|--discutoff)
            #echo "Option a";
	    fordiscutoff=$2
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

getbase=`dirname $0`
Rscript ${getbase}/getCommunity.R $forfastani $fordiscutoff $formembercutoff $foroutput_tag
