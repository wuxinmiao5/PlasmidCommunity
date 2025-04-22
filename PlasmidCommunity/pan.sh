ARGS=`getopt -o hp:i:m:o: --long help,input_plasmid_seq:,input_membership:,membercutoff:,output_tag: -n "$0" -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

eval set -- "${ARGS}"

while true
do
    case "$1" in
	-h|--help)
      echo "Usage: pan.sh -p input_plasmid_seq -i input_membership -m membershipcutoff -o outputtag"
			echo "-p|--input_plasmid_seq the path of a directory containing plasmids genomes"
	    echo "-i|--input_membership the membership file of the network nodes"
	    echo "-m|--membershipcutoff the minimum of community size"
	    echo "-o|--outputtag the output tag"
	    exit 0
	    ;;
        -p|--input_plasmid_seq)
	    forinput_plasmid_seq=$2
            shift 2
	   				;;
        -i|--input_membership)
	    forinput_membership=$2
            shift 2
            ;;
        -m|--membercutoff)
	    formembercutoff=$2
            shift 2
            ;;
        -o|--output_tag)
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
getbase=`dirname $(which $0)`
Rscript ${getbase}/pan.R $forinput_plasmid_seq $forinput_membership $formembercutoff $foroutput_tag

