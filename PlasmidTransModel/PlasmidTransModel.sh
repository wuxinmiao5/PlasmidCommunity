#!/usr/bin/env bash

#echo original parameters=[$@]

#-o或--options选项后面是可接受的短选项，如ab:c::，表示可接受的短选项为-a -b -c，
#其中-a选项不接参数，-b选项后必须接参数，-c选项的参数为可选的
#-l或--long选项后面是可接受的长选项，用逗号分开，冒号的意义同短选项。
#-n选项 后接选项解析错误时提示的脚本名字
ARGS=`getopt -o ha:o:m: --long inputGenome:,output_tag:,modelType: -n "$0" -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

#echo ARGS=[$ARGS]
#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${ARGS}"
#echo formatted parameters=[$@]

while true
do
    case "$1" in
	-h|--help)
      echo "Usage: PlasmidTransModel.sh -a inputGenome -o output_tag -m modelType"
	    echo "-a|--inputGenome the input file in fasta format"
	    echo "-o|--output_tag the prefix of the output file"
	    echo "-m|--modelType the model type to be choosen, 
	    		  two types of models can be choosen: Binary or ThreeClass"
	    exit 1
	    ;;
        -a|--inputGenome)
            #echo "Option a";
	    inputGenome=$2
            shift 2
            ;;
        -o|--output_tag)
            #echo "Option b, argument $2";
	    output_tag=$2
            shift 2
            ;;
        -m|--modelType)
            #echo "Option a";
	    modelType=$2
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
echo $inputGenome,$output_tag,$modelType
#
getbase=dirname $0
Rscript ${getbase}/PlasmidTransModel.R $inputGenome $output_tag $modelType
