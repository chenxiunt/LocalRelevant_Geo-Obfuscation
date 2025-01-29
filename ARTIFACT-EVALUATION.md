# Artifact Appendix

Paper title: **Time-Efficient Locally Relevant Geo-Location Privacy Protection**

Artifacts HotCRP Id: **10**

Requested Badge: **Available**

## Description
This repository contains the source code related to the methodologies and experiments presented in the paper titled **"Time-Efficient Locally Relevant Geo-Location Privacy Protection"**.

The file **`main.m`** implements the data perturbation algorithm **LR-Geo** proposed in the paper. This algorithm facilitates geo-obfuscation by focusing on locally relevant locations for each user, optimizing location privacy while maintaining computational efficiency through **linear programming (LP)**. It also incorporates the **Benders' decomposition technique** to efficiently solve large-scale LP problems, as discussed in the paper.

### Security/Privacy Issues and Ethical Concerns
There are no security or ethical concerns.

## Basic Requirements
### **Recommended Hardware Requirements**
- **Processor**: Dual-core CPU or higher
- **Memory**: 8 GB RAM (16 GB recommended for larger datasets)
- **Disk Space**: 2 GB of free space for MATLAB installation and artifact files

### **Supported Operating Systems**
- **Windows 10/11**
- **macOS Monterey/Ventura**
- **Ubuntu Linux 20.04/22.04**

### Estimated Time and Storage Consumption
Provide an estimated value for the time the evaluation will take and the space on the disk it will consume. 
This helps reviewers to schedule the evaluation in their time plan and to see if everything is running as intended.
More specifically, a reviewer, who knows that the evaluation might take 10 hours, does not expect an error if, after 1 hour, the computer is still calculating things.

## Environment 

### Accessibility
The source code for the artifact can be accessed via a persistent repository hosted on GitHub at the following link: https://github.com/chenxiunt/LocalRelevant_Geo-Obfuscation.
Commit-ID: 14581cd51d0f398764a663d925050c95ee34fc51

### Set up the environment (Only for Functional and Reproduced badges)
The code was developed and tested using **MATLAB R2024a** with the **Optimization Toolbox** and **Statistics and Machine Learning Toolbox** installed. The toolboxes include the [**`linprog`**](https://www.mathworks.com/help/optim/ug/linprog.html) function for linear programming and the [**`randsample`**](https://www.mathworks.com/help/stats/randsample.html) function for random sample.


### Testing the Environment (Only for Functional and Reproduced badges)
```bash
simplified_experiment
```
for an simplified experiment 
and 
```bash
main
```
for the original experiment

## Artifact Evaluation (Only for Functional and Reproduced badges)
### The computation time of perturbation matrix 
#### Main Result 1: Computation time (displayed as "LR-Geo" in Table 1)
LR-Geo has higher computational time compared to Laplace and ExpMech, it significantly outperforms both LP and ConstOPT in terms of efficiency (described in the first paragraph of Section 5.2.1). 

#### Main Result 2: Cost (displayed as "LR-Geo" in Table 2)
LR-Geo significantly reduces the expected cost compared to Laplace and ExpMech (described in the first paragraph of Section 5.3.1). 

### Experiments 
List each experiment the reviewer has to execute. Describe:
 - How to execute it in detailed steps.
 - What the expected result is.
 - How long it takes and how much space it consumes on disk. (approximately)
 - Which claim and results does it support, and how.

#### Experiment 1: Computation time
To run the simplified version of the experiment, run the following code 
```bash
simplified_experiment
```
and the results are stored in the file "computation_time.mat". 



#### Experiment 2: Cost
To run the simplified version of the experiment, run the following code 
```bash
simplified_experiment
```
and the results are stored in the file "cost.mat". 

## Limitations (Only for Functional and Reproduced badges)
Describe which tables and results are included or are not reproducible with the provided artifact.
Provide an argument why this is not included/possible.

