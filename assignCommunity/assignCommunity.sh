ARGS=`getopt -o ha:q:o: --long allplasmidPath:,queryPlasmidPath:,output_tag: -n "$0" -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

eval set -- "${ARGS}"

while true
do
    case "$1" in
	-h|--help)
      echo "Usage: assignCommunity.sh -a allplasmidPath -q queryPlasmidPath -o output_tag"
	    echo "-a|--allplasmidPath the path of the directory containg the plasmid genomes"
	    echo "-q|--queryPlasmidPath the query plasmid file"
	    echo "-o|--output_tag the prefix of the output file"
	    exit 1
	    ;;
        -a|--allplasmidPath)
            #echo "Option a";
	    forallplasmidPath=$2
            shift 2
            ;;
        -q|--queryPlasmidPath)
            #echo "Option a";
	    forqueryPlasmidPath=$2
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
Rscript ${getbase}/assignCommunity.R $forallplasmidPath $forqueryPlasmidPath $foroutput_tag


