  PlasmidCommunity

  PlasmidCommunity is a software for plasmid community classification and analysis based on genomic similarity networks. It establishes a framework for plasmid classification by setting thresholds for sequence similarity among plasmids, categorizing them accordingly, and constructing networks to predict the ability of each community to acquire new genes. For detailed information, please refer to the documentation.
      
This package is essentially the same as that used in our paper, with only minor modifications to enhance user-friendliness. If you have any inquiries, questions, bug reports, or other feedback, please contact us via the following means:

Wu Xinmiao：wuxinmiao2024@163.com，Li Zhenpeng：lizhenpeng@icdc.cn


INSTALLATION
QUICK TUTORIAL

You are assumed to know how to use a shell or command prompt, as well as some basic knowledge of R. denotes the shell prompt (so don't type it in!).$

Linux Command Line Version:
Viewing the Help Documentation:
First, navigate to the directory where the plasmid sequences in fasta format need to be placed for classification. The directory is named ./plasmids.
To display the specific parameters and usage of the software, enter the command (./2.silhouetteCurve.sh -h) into the Linux terminal.


$./2.silhouetteCurve.sh -h

Silhouette Coefficient Module and Usage of Its Parameters:
./2.silhouetteCurve.sh --fastani "./fastani_output.txt" --output_tag test

--fastani: This parameter includes the absolute path to the folder containing the plasmid sequences that were analyzed using FastANI.

--output_tag: This parameter specifies the label for the output result files.

Entering the command (./3.getCommunity.sh -h) into the Linux terminal will display the specific parameters and usage instructions for the software.


$./3.getCommunity.sh -h

Obtaining Communities, Drawing Network Graphs, and Usage of Parameters:

./3.getCommunity.sh --fastani “treedist” --discutoff 0.13 --membercutoff  5 --output_tag test

--fastani  Select fastani data

--discutoff  Select the value of the profile coefficient

--membercutoff  Set the minimum number of community clustering plasmids

--output_tag  Output result file label


Entering the command (../4.pan.sh -h) into the Linux terminal will display the specific parameters and usage instructions for the software.

$./4.pan.sh -h

Obtaining Communities, Drawing Network Graphs, and Usage of Parameters:

./4.pan.sh -h --plasmid_seq “./plasmids” --membership_info “./membership_info.txt” --membercutoff  5 --output_tag test

--plasmid_seq  Select plasmid sequence folder information

--membership_info  Select the text information corresponding to the plasmid and the community

--membercutoff  Set the minimum number of community clustering plasmids

--output_tag  Output result file label


![image](https://github.com/user-attachments/assets/7ea6cfcf-c973-4955-bcc4-cce39f46b7a5)
