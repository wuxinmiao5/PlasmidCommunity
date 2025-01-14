#!/usr/bin/env bash

#echo original parameters=[$@]

#-o��--optionsѡ������ǿɽ��ܵĶ�ѡ���ab:c::����ʾ�ɽ��ܵĶ�ѡ��Ϊ-a -b -c��
#����-aѡ��Ӳ�����-bѡ������Ӳ�����-cѡ��Ĳ���Ϊ��ѡ��
#-l��--longѡ������ǿɽ��ܵĳ�ѡ��ö��ŷֿ���ð�ŵ�����ͬ��ѡ�
#-nѡ�� ���ѡ���������ʱ��ʾ�Ľű�����
ARGS=`getopt -o ha:o: --long fastani:,output_tag: -n "$0" -- "$@"`
if [ $? != 0 ]; then
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
        echo "Usage: cutoffselection.sh -p prefix -t treefile"
	    echo "-p|--prefix the prefix of the output file"
	    echo "-t|--treefile the input treefile, the treefile should be nwk format"
	    exit 1
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
#
echo $forfastani,$foroutput_tag
#
#Rscript cutoffselection.R 666 /home/micro/LZP/PanCoreSample/VCsample/VCtreef/parsnp.tree
#Rscript cutoffselection.R $forfastani $foroutput_tag
