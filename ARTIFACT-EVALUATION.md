# Artifact Appendix

Paper title: **Time-Efficient Locally Relevant Geo-Location Privacy Protection**

Artifacts HotCRP Id: **10**

Requested Badge: **Available**

## Description
This repository contains the source code related to the methodologies and experiments presented in the paper titled **"Time-Efficient Locally Relevant Geo-Location Privacy Protection"**.

The file **`main.m`** implements the data perturbation algorithm **LR-Geo** proposed in the paper. This algorithm facilitates geo-obfuscation by focusing on locally relevant locations for each user, optimizing location privacy while maintaining computational efficiency through **linear programming (LP)**. It also incorporates the **Benders' decomposition technique** to efficiently solve large-scale LP problems, as discussed in the paper.


### Security/Privacy Issues and Ethical Concerns
There is no security issue and ethical concerns. 

## Environment 
The code was developed and tested using **MATLAB R2024a** with the **Optimization Toolbox** installed. The toolbox includes the [**`linprog`**](https://www.mathworks.com/help/optim/ug/linprog.html) function for linear programming.

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
Commit-ID: cd06aa4d0a8b73a53f96e59d58b686ddb2492f5c
