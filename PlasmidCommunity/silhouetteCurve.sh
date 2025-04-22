#!/usr/bin/env bash

#echo original parameters=[$@]

#-o或--options选项后面是可接受的短选项，如ab:c::，表示可接受的短选项为-a -b -c，
#其中-a选项不接参数，-b选项后必须接参数，-c选项的参数为可选的
#-l或--long选项后面是可接受的长选项，用逗号分开，冒号的意义同短选项。
#-n选项 后接选项解析错误时提示的脚本名字
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
