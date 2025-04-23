#!/usr/bin/env bash

#echo original parameters=[$@]

#-o��--optionsѡ������ǿɽ��ܵĶ�ѡ���ab:c::����ʾ�ɽ��ܵĶ�ѡ��Ϊ-a -b -c��
#����-aѡ��Ӳ�����-bѡ������Ӳ�����-cѡ��Ĳ���Ϊ��ѡ��
#-l��--longѡ������ǿɽ��ܵĳ�ѡ��ö��ŷֿ���ð�ŵ�����ͬ��ѡ�
#-nѡ�� ���ѡ���������ʱ��ʾ�Ľű�����
ARGS=`getopt -o ha:o: --long help,fastani:,output_tag: -n "$0" -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

eval set -- "${ARGS}"

while true
do
    case "$1" in
	-h|--help)
      echo "Usage: 2.silhouetteCurve.sh -a fastani -o output_tag"
	    echo "-a|--fastani the path of the directory containg the plasmid genomes"
	    echo "-o|--output_tag the tag of output file"
	    exit 0
	    ;;
        -a|--fastani)
            #echo "Option a";
	    forfastani=$2
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
##
#
getbase=`dirname $(which $0)`
Rscript ${getbase}/silhouetteCurve.R $forfastani $foroutput_tag
