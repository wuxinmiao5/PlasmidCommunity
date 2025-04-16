ARGS=`getopt -o ha:s:c:d:m:f:o: --long getMode:,plasmid_seq:,fastani:,discutoff:,membercutoff:,membership_info:,output_tag: -n "$0" -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

eval set -- "${ARGS}"

while true
do
    case "$1" in
	-h|--help)
      echo "Usage: plasmidCommunity.sh -h"
      echo -e "\n" 
      echo "Three modes are provided for analysis: silhouetteCurve, getCommunity and pan:"
      echo "for silhouetteCurve mode: "
      echo "Usage: plasmidCommunity.sh -a silhouetteCurve -s input_plasmid_seq -o output_tag"
      echo "-a|--input_Mode the mode chosen for analysis: silhouetteCurve, getCommunity or pan"
      echo "-s|--input_plasmid_seq the path of a directory containing plasmids genomes"
      echo "-o|--outputtag the output tag"
      echo -e "\n"
      echo "for getCommunity mode: "
      echo "Usage: plasmidCommunity.sh -a getCommunity -c fastani -d discutoff -m membershipcutoff -o output_tag"
      echo "-a|--input_Mode the mode chosen for analysis: silhouetteCurve, getCommunity or pan"
      echo "-c|--fastani the fastani result for input, it's the result saved by silhouetteCurve"
	    echo "-d|--discutoff the distance cutoff to generate community"
      echo "-m|--membershipcutoff the minimum of community size"
      echo "-o|--outputtag the output tag"
      echo -e "\n"
      echo "for pan mode: "
      echo "Usage: plasmidCommunity.sh -a pan -s input_plasmid_seq -f input_membership -m membershipcutoff -o output_tag"
      echo "-a|--input_Mode the mode chosen for analysis: silhouetteCurve, getCommunity or pan"
      echo "-s|--input_plasmid_seq the path of a directory containing plasmids genomes"
      echo "-f|--input_membership the membership file of the network nodes"
      echo "-m|--membershipcutoff the minimum of community size"
      echo "-o|--outputtag the output tag"
		  echo -e "\n"     	   
	    exit 1
	    ;;
        -a|--getMode)
	    forgetMode=$2
            shift 2
	   				;;
        -s|--plasmid_seq)
	    forplasmid_seq=$2
            shift 2
            ;;
        -c|--fastani)
	    forfastani=$2
            shift 2
            ;;
        -d|--discutoff)
	    fordiscutoff=$2
            shift 2
            ;;
        -m|--membercutoff)
	    formembercutoff=$2
            shift 2
            ;;
        -f|--membership_info)
	    formembership_info=$2
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
getbase=`dirname $0`
if [ $forgetMode = "silhouetteCurve" ]; then
	Rscript ${getbase}/plasmidCommunity.R $forgetMode $forplasmid_seq $foroutput_tag
elif [ $forgetMode = "getCommunity" ]; then
  Rscript ${getbase}/plasmidCommunity.R $forgetMode $forfastani $fordiscutoff $formembercutoff $foroutput_tag 
elif [ $forgetMode = "pan" ]; then
	Rscript ${getbase}/plasmidCommunity.R $forgetMode $forplasmid_seq $formembership_info $formembercutoff $foroutput_tag
fi



