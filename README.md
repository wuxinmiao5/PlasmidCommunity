# PlasmidCommunity: A Software Suite for Klebsiella pneumoniae Plasmid Classification Framework, Assignment, and Transmission Risk Prediction

PlasmidCommunity is an open-source software suite designed to empower researchers in understanding Klebsiella pneumoniae plasmid biology through three analysis modules: classification, community assignment, and transmission risk prediction. Leveraging genomic similarity networks and advanced algorithms, this toolkit addresses critical challenges in tracking plasmid evolution, host interactions, and antimicrobial resistance dissemination.

## Support and Feedback

If you have any inquiries, questions, bug reports, or other feedback, please contact us via the following means:

- **Xinmiao Wu**: wuxinmiao2024@163.com  
- **Zhenpeng Li**: lizhenpeng@icdc.cn  

We appreciate your feedback and are committed to improving PlasmidCommunity to better serve the research community.

---
## Prerequisites

Before using PlasmidCommunity, ensure that you have the following prerequisites installed and configured:

### 1. System Requirements
- **Linux Environment**: The software is designed to run on a Linux-based operating system. Familiarity with the Linux command line is required.

### 2. R Environment 
- **R Programming Language**: Install R on your system. Basic knowledge of R is necessary for certain parts of the analysis.
- **Required R Packages**: Install the necessary R packages using the following commands: 
```R
install.packages(c("readr", "readxl", "tidymodels", "tidyverse", "Biostrings", "seqinr"))
```

### 3. External Tools
- **FastANI**: Ensure fastANI is installed and accessible in your system’s PATH. It is used for sequence similarity analysis.
- **Prodigal**: Install Prodigal for gene prediction. Download and install from Prodigal GitHub.
- **BLAST**: Install BLAST for sequence alignment. Download and install from NCBI BLAST.

### 4. Data Availability:​​
- **The comprehensive database containing 7,232 complete plasmid sequences of Klebsiella pneumoniae has been deposited in the ScienceDB platform (https://www.science-db.cn/).**  All data are publicly accessible via (https://cstr.cn/31253.47.sciencedb.23175.011A8CD2) under an open-access license (GNU GPL).
- **Pre-trained Models.** Ensure the following pre-trained models are available:
'binaryModel.Rdata' for binary classification.
'threeClassModel.Rdata' for three-class classification.
- **Reference Protein Database**: Provide a reference protein database (model3.fasta) for BLAST analysis.

### Key Notes:
Ensure all tools are properly installed and accessible in your system’s PATH.
Place all input files in the correct directories as specified in the documentation.

---

# PlasmidCommunity: Plasmid Community Classification and Analysis

## Overview

PlasmidCommunity is a software designed for the classification and analysis of plasmid communities based on genomic similarity networks. It provides a robust framework for plasmid classification by setting thresholds for sequence similarity among plasmids, categorizing them accordingly, and constructing networks to predict the ability of each community to acquire new genes. The modes are provided: Silhouette, getCommunity and pan. This tool is particularly useful for researchers studying plasmid diversity, horizontal gene transfer, and microbial evolution.

The software is based on the methodology described in our paper, with minor modifications to enhance user-friendliness. For detailed information, please refer to the documentation.


## Usage

### 1. Viewing the Help Documentation

To display the specific parameters and usage of the software, navigate to the directory containing the plasmid sequences and enter the following command:

```bash
$ ./PlasmidCommunity/plasmidCommunity.sh -h
```
This command will provide detailed information on how to use the Silhouette Coefficient module and its parameters.

### 2. Silhouette Coefficient computation (Silhouette mode)

The Silhouette Coefficient module is used to analyze the clustering quality of plasmid communities. To run this module, use the following command:

```bash
$ ./PlasmidCommunity/plasmidCommunity.sh -a silhouetteCurve -s input_plasmid_seq -o output_tag
```

**Parameters**:  
- `-a｜getMode`: The input_Mode chosen silhouetteCurve.  
- `-s｜plasmid_seq`: The input_plasmid_seq the path of a directory containing plasmids genomes.  
- `-o｜output_tag`: Outputtag the output tag.  

### 3. Obtaining Communities and plotting the network (getCommunity mode)

To obtain plasmid communities, use the following command:

```bash
$ ./PlasmidCommunity/plasmidCommunity.sh -a getCommunity -c treedist -d 0.13 -m 5 -o output_tag
```

**Parameters**:  
- `-a｜getMode`: The input mode to choose, here is getCommunity.  
- `-c|fastani`: The fastani result for input, it's the result saved by silhouetteCurve.  
- `-d|discutoff`: The distance cutoff to generate community.  
- `-m|membercutoff`: The minimum of community size.  
- `-o｜output_tag`: The output tag.  

### 4. Pan-Genome Analysis (pan mode)

For pan-genome analysis, use the following command:

```bash
$ ./PlasmidCommunity/plasmidCommunity.sh -a pan -s input_plasmid_seq -f "./membership_info.txt" -m 5 -o output_tag"
```

**Parameters**:  
- `-a|getMode`:The input_Mode chosen pan.  
- `-s｜plasmid_seq`: The path of a directory containing plasmids genomes.  
- `-f|membership_info`: The membership file of the network nodes.  
- `-m|membercutoff`: The minimum of community size.  
- `-o｜output_tag`: The output tag.  

---

# assignCommunity: Plasmid Membership Assignment Tool

## Overview

The `assignCommunity` is a tool for assigning plasmid community of Klebsiella pneumoniae based on Average Nucleotide Identity (ANI) using the `fastANI` algorithm. The tool takes a query plasmid and compares it against a collection of known plasmids to determine the most similar plasmid and the community it belongs.

The tool performs the following steps:  
1. **Input Handling**: Accepts paths to the query plasmid and a directory containing a collection of plasmids.  
2. **ANI Calculation**: Uses `fastANI` to compute the ANI between the query plasmid and each plasmid in the collection.  
3. **Membership Assignment**: Identifies the plasmid with the highest ANI to the query and retrieves its community information.  
4. **Output**: Generates a text file containing the query plasmid, the assigned community membership, and the size of the community.  


## Usage

```bash
$ ./assignCommunity/assignCommunity.sh -a /data/lizhenpeng/wuxinmiao/plasmids -q GCA_015356015__CP064244.1.fasta -o output
```

**Parameters**:  
- `-a|allplasmidPath`: The path of the directory containing the plasmid genomes.  
- `-q|queryPlasmidPath`: The query plasmid file. 
- `-o|output_tag`: The prefix of the output file. 

Replace `/data/lizhenpeng/wuxinmiao/plasmids` with the path to the directory containing your plasmid database and `/GCA_015356015__CP064244.1.fasta` with the path to your query plasmid.

**Output**: The script will generate a file named `membershipAssigned.txt` in the current directory, containing the query plasmid, the assigned membership, and the size of the membership group.

---

# PlasmidTransModel: Plasmid Transmission Risk Prediction Models

## Overview

The `PlasmidTransModel` is a tool for Klebsiella pneumoniae plasmid transmission risk prediction using machine learning models.

This tool provides a framework for plasmid transmission risk prediction using machine learning models. It supports two types of classification:  
1. **Binary Classification**: Distinguishing plasmids into two classes.  
2. **Three-Class Classification**: Distinguishing plasmids into three classes.  

The models leverage k-mer frequency analysis and gene feature extraction to predict plasmid classes based on genomic sequences. The models are built using the `tidymodels` framework in R, and the script integrates external tools like `Prodigal` and `BLAST` for gene feature extraction.


## Usage

### 1. Binary Classification

To classify a plasmid into one of two classes, set `modeltype="Binary"`. The script will:  
1. Extract 5-mer frequencies from the input genome.  
2. Use the pre-trained binary classification model to predict the class.  

**Example Command**:

```bash
$ ./PlasmidTransModel/plasmidTransModel.sh -a inputGenome -o output -m Binary
```

**Parameters**:  
- `-a|inputGenome`: The input file in FASTA format.  
- `-o|output_tag`: The prefix of the output file.  
- `-m|modelType`: The model type to be chosen, two types of models can be chosen: `Binary` or `ThreeClass`.  

**Output**:  
The prediction results will be saved in a file named `modelmerge_prediction_2class.txt`.

### 2. Three-Class Classification

To classify a plasmid into one of three classes, set `modeltype="ThreeClass"`. The script will:  
1. Use `Prodigal` to predict genes in the input genome.  
2. Use `BLAST` to match predicted genes against a reference database.  
3. Extract gene features and 5-mer frequencies.  
4. Use the pre-trained three-class classification model to predict the class.  

**Example Command**:

```bash
$ ./PlasmidTransModel/plasmidTransModel.sh -a inputGenome -o output -m ThreeClass
```

**Output**:  
The prediction results will be saved in a file named `modelmerge_prediction_3class.txt`.
