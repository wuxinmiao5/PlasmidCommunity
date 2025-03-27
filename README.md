# PlasmidCommunity: A Software Suite for Klebsiella pneumoniae Plasmid Classification Framework, Assignment, and Transmission Risk Prediction

PlasmidCommunity is an open-source software suite designed to empower researchers in understanding Klebsiella pneumoniae plasmid biology through three analysis modules: classification, community assignment, and transmission risk prediction. Leveraging genomic similarity networks and advanced algorithms, this toolkit addresses critical challenges in tracking plasmid evolution, host interactions, and antimicrobial resistance dissemination.

## Support and Feedback

If you have any inquiries, questions, bug reports, or other feedback, please contact us via the following means:

- **Xinmiao Wu**: wuxinmiao2024@163.com  
- **Zhenpeng Li**: lizhenpeng@icdc.cn  

We appreciate your feedback and are committed to improving PlasmidCommunity to better serve the research community.

---

# PlasmidCommunity: Plasmid Community Classification and Analysis

## Overview

PlasmidCommunity is a software designed for the classification and analysis of plasmid communities based on genomic similarity networks. It provides a robust framework for plasmid classification by setting thresholds for sequence similarity among plasmids, categorizing them accordingly, and constructing networks to predict the ability of each community to acquire new genes. This tool is particularly useful for researchers studying plasmid diversity, horizontal gene transfer, and microbial evolution.

The software is based on the methodology described in our paper, with minor modifications to enhance user-friendliness. For detailed information, please refer to the documentation.

## Prerequisites

Before using PlasmidCommunity, ensure that you have the following prerequisites installed and configured:

- **Linux Environment**: The software is designed to run on a Linux-based operating system. Familiarity with the Linux command line is required.  
- **R Programming Language**: Basic knowledge of R is necessary for certain parts of the analysis.  
- **FastANI**: Ensure that FastANI is installed and properly configured, as it is used for sequence similarity analysis.  
- **Plasmid Sequences**: Prepare the plasmid sequences in FASTA format and place them in the appropriate directory (`./plasmids`).  

## Usage

### 1. Viewing the Help Documentation

To display the specific parameters and usage of the software, navigate to the directory containing the plasmid sequences and enter the following command:

```bash
$ ./2.silhouetteCurve.sh -h
```

This command will provide detailed information on how to use the Silhouette Coefficient module and its parameters.

### 2. Silhouette Coefficient Module

The Silhouette Coefficient module is used to analyze the clustering quality of plasmid communities. To run this module, use the following command:

```bash
$ ./2.silhouetteCurve.sh --fastani "./fastani_output.txt" --output_tag test
```

**Parameters**:  
- `--fastani`: The absolute path to the folder containing the plasmid sequences analyzed using FastANI.  
- `--output_tag`: The label for the output result files.  

### 3. Obtaining Communities and Drawing Network Graphs

To obtain plasmid communities, use the following command:

```bash
$ ./3.getCommunity.sh --fastani "treedist" --discutoff 0.13 --membercutoff 5 --output_tag test
```

**Parameters**:  
- `--fastani`: Select the FastANI data.  
- `--discutoff`: Set the distance threshold for generating plasmid network.  
- `--membercutoff`: Set the minimum number of plasmids for each community.  
- `--output_tag`: The label for the output result files.  

### 4. Pan-Genome Analysis

For pan-genome analysis, use the following command:

```bash
$ ./4.pan.sh --plasmid_seq "./plasmids" --membership_info "./membership_info.txt" --membercutoff 5 --output_tag test
```

**Parameters**:  
- `--plasmid_seq`: The folder containing the plasmid sequences.  
- `--membership_info`: The text file containing the plasmid and community information.  
- `--membercutoff`: Set the minimum number of plasmids for each community.  
- `--output_tag`: The label for the output result files.  

---

# assignCommunity: Plasmid Membership Assignment Tool

The `assignCommunity` is a tool for assigning plasmid community of Klebsiella pneumoniae based on Average Nucleotide Identity (ANI) using the `fastANI` algorithm. The tool takes a query plasmid and compares it against a collection of known plasmids to determine the most similar plasmid and the community it belongs.

## Overview

The tool performs the following steps:  
1. **Input Handling**: Accepts paths to the query plasmid and a directory containing a collection of plasmids.  
2. **ANI Calculation**: Uses `fastANI` to compute the ANI between the query plasmid and each plasmid in the collection.  
3. **Membership Assignment**: Identifies the plasmid with the highest ANI to the query and retrieves its community information.  
4. **Output**: Generates a text file containing the query plasmid, the assigned community membership, and the size of the community.  

## Prerequisites

- **R**: Ensure R is installed on your system.  
- **R Packages**: Install the required R packages using the following commands:  

```R
install.packages("readr")
install.packages("readxl")
```

- **fastANI**: Ensure `fastANI` is installed and accessible in your system’s PATH.  

## Usage

```bash
$ ./assignCommunity.sh -a /data/lizhenpeng/wuxinmiao/plasmids -q GCA_015356015__CP064244.1.fasta -o output_tag
```

**Parameters**:  
- `--a`: `AllplasmidPath` the path of the directory containing the plasmid genomes.  
- `--q`: `QueryPlasmidPath` the query plasmid file.  
- `--o`: `Output_tag` the prefix of the output file.  

Replace `/data/lizhenpeng/wuxinmiao/plasmids` with the path to the directory containing your plasmid database and `/GCA_015356015__CP064244.1.fasta` with the path to your query plasmid.

**Output**: The script will generate a file named `membershipAssigned.txt` in the current directory, containing the query plasmid, the assigned membership, and the size of the membership group.

---

# PlasmidTransModel: Plasmid Transmission Risk Prediction Models

The `PlasmidTransModel` is a tool for Klebsiella pneumoniae plasmid transmission risk prediction using machine learning models.

## Overview

This tool provides a framework for plasmid transmission risk prediction using machine learning models. It supports two types of classification:  
1. **Binary Classification**: Distinguishing plasmids into two classes.  
2. **Three-Class Classification**: Distinguishing plasmids into three classes.  

The models leverage k-mer frequency analysis and gene feature extraction to predict plasmid classes based on genomic sequences. The models are built using the `tidymodels` framework in R, and the script integrates external tools like `Prodigal` and `BLAST` for gene feature extraction.

## Prerequisites

Before running the script, ensure the following prerequisites are met:  

- **R Environment**: Install R and the required R packages:  

```R
install.packages(c("tidymodels", "tidyverse", "Biostrings", "seqinr"))
```

- **External Tools**:  
  - **Prodigal**: Install Prodigal for gene prediction. Download and install from [Prodigal GitHub](https://github.com/hyattpd/Prodigal).  
  - **BLAST**: Install BLAST for sequence alignment. Download and install from [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi).  

- **Input Files**:  
  - A plasmid genome sequence in FASTA format (e.g., `GCA_015356015__CP064244.1.fasta`).  
  - Pre-trained models (`binaryModel.Rdata` for binary classification and `threeClassModel.Rdata` for three-class classification).  
  - A reference protein database (`model3.fasta`) for BLAST analysis.  

## Usage

### 1. Binary Classification

To classify a plasmid into one of two classes, set `modeltype="Binary"`. The script will:  
1. Extract 5-mer frequencies from the input genome.  
2. Use the pre-trained binary classification model to predict the class.  

**Example Command**:

```bash
$ ./plasmidTransModel.sh -a inputGenome -o output_tag -m Binary
```

**Parameters**:  
- `--a`: `InputGenome` the input file in FASTA format.  
- `--o`: `Output_tag` the prefix of the output file.  
- `--m`: `ModelType` the model type to be chosen, two types of models can be chosen: `Binary` or `ThreeClass`.  

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
$ ./plasmidTransModel.sh -a inputGenome -o output_tag -m ThreeClass
```

**Output**:  
The prediction results will be saved in a file named `modelmerge_prediction_3class.txt`.
```
