#!/usr/bin/env bash

echo original parameters=[$@]

#-o或--options选项后面是可接受的短选项，如ab:c::，表示可接受的短选项为-a -b -c，
#其中-a选项不接参数，-b选项后必须接参数，-c选项的参数为可选的
#-l或--long选项后面是可接受的长选项，用逗号分开，冒号的意义同短选项。
#-n选项 后接选项解析错误时提示的脚本名字
ARGS=`getopt -o hd:i:m:o: --long input_plasmid_seq:,input_membership:,membercutoff:,output_tag: -n "$0" -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

echo ARGS=[$ARGS]
#将规范化后的命令行参数分配至位置参数（$1,$2,...)
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

