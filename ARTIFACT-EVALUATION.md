# Artifact Appendix

Paper title: **Time-Efficient Locally Relevant Geo-Location Privacy Protection**

Artifacts HotCRP Id: **10**

Requested Badge: **Available**

## Description
The source code in this repository is directly related to the methodologies and experiments presented in the paper titled **"Time-Efficient Locally Relevant Geo-Location Privacy Protection"**. Below is a detailed description of how the code aligns with the paper's contributions:

## 1. Locally Relevant Geo-Obfuscation (LR-Geo)
- Implements the core algorithmic framework proposed in the paper, enabling geo-obfuscation by focusing on locally relevant locations for each user.
- Optimizes location privacy while maintaining computational efficiency using linear programming (LP).

## 2. Geo-Indistinguishability Compliance
- Ensures adherence to geo-indistinguishability constraints through:
  - Construction of the Geo-Ind graph to determine locally relevant locations.
  - Application of exponential mechanisms to maintain privacy across users.

## 3. Experimental Validation
- Provides scripts and tools to reproduce the experimental results in the paper, including:
  - Generation of obfuscation matrices.
  - Comparisons of computational efficiency.
  - Evaluations of privacy preservation and utility.

## 4. Benders’ Decomposition
- Implements the Benders' decomposition technique discussed in the paper to solve large-scale LP problems efficiently.

## 5. Real-World Dataset Application
- Supports processing of real-world datasets, such as the Rome, Italy dataset used in the paper, to validate the practical applicability of the proposed methods.

This repository serves as a practical implementation of the concepts introduced in the paper, enabling researchers and practitioners to explore, validate, and extend the methods.

For more details about the implementation, please refer to the documentation within the repository.

### Security/Privacy Issues and Ethical Concerns
There is no security issue and ethical concerns. 

## Environment 
In the following, describe how to access our artifact and all related and necessary data and software components.
Afterward, describe how to set up everything and how to verify that everything is set up correctly.



Here’s the description formatted as a Markdown (.md) file:

markdown
Copy code
# Software and Environment Requirements

The artifact is developed and tested using **MATLAB R2024a**, with the following MATLAB **Optimization Toolbox** installed. 

The artifact is compatible with major operating systems supported by MATLAB, including:
- **Windows 10/11**
- **macOS Monterey/Ventura**
- **Ubuntu Linux 20.04/22.04**

Minimum Hardware Requirements include 
- **Processor**: Dual-core CPU or higher
- **Memory**: 8 GB RAM (16 GB recommended for larger datasets)
- **Disk Space**: 2 GB of free space for MATLAB installation and artifact files

### Accessibility (All badges)
Describe how to access your artifact via persistent sources.
Valid hosting options are institutional and third-party digital repositories.
Do not use personal web pages.
For repositories that evolve over time (e.g., Git Repositories ), specify a specific commit-id or tag to be evaluated.
In case your repository changes during the evaluation to address the reviewer's feedback, please provide an updated link (or commit-id / tag) in a comment.


The source code for the artifact can be accessed via a persistent repository hosted on GitHub at the following link: https://github.com/chenxiunt/LocalRelevant_Geo-Obfuscation.

To ensure reproducibility and consistency during the evaluation process, please refer to the specific commit: [Insert Specific Commit-ID]. This commit represents the exact state of the repository as intended for evaluation.

If the repository needs to be updated to address reviewer feedback, any changes will be committed, and the updated commit ID or tag will be provided in a comment below this description.

Please note that GitHub is a widely recognized third-party repository platform ensuring persistence and accessibility for this artifact.
