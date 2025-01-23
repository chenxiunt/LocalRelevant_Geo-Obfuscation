# Artifact Appendix

Paper title: **Time-Efficient Locally Relevant Geo-Location Privacy Protection**

Artifacts HotCRP Id: **10**

Requested Badge: **Available**

## Description
This repository contains the source code related to the methodologies and experiments presented in the paper titled **"Time-Efficient Locally Relevant Geo-Location Privacy Protection"**.

The file **`main.m`** implements the data perturbation algorithm **LR-Geo** proposed in the paper. This algorithm facilitates geo-obfuscation by focusing on locally relevant locations for each user, optimizing location privacy while maintaining computational efficiency through **linear programming (LP)**. It also incorporates the **Benders' decomposition technique** to efficiently solve large-scale LP problems, as discussed in the paper.


### Security/Privacy Issues and Ethical Concerns
There are no security or ethical concerns.


## Environment 
The code was developed and tested using **MATLAB R2024a** with the **Optimization Toolbox** and **Statistics and Machine Learning Toolbox** installed. The toolboxes include the [**`linprog`**](https://www.mathworks.com/help/optim/ug/linprog.html) function for linear programming and [random number generation functions]([https://www.mathworks.com/help/optim/ug/linprog.html](https://www.mathworks.com/help/matlab/random-number-generation.html)).

### **Supported Operating Systems**
- **Windows 10/11**
- **macOS Monterey/Ventura**
- **Ubuntu Linux 20.04/22.04**

### **Recommended Hardware Requirements**
- **Processor**: Dual-core CPU or higher
- **Memory**: 8 GB RAM (16 GB recommended for larger datasets)
- **Disk Space**: 2 GB of free space for MATLAB installation and artifact files


### Accessibility
The source code for the artifact can be accessed via a persistent repository hosted on GitHub at the following link: https://github.com/chenxiunt/LocalRelevant_Geo-Obfuscation.
Commit-ID: 14581cd51d0f398764a663d925050c95ee34fc51
