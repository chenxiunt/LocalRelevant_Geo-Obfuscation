Paper title: **Time-Efficient Locally Relevant Geo-Location Privacy Protection**

## Description
The source code in this repository is directly related to the methodologies and experiments presented in the paper titled **"Time-Efficient Locally Relevant Geo-Location Privacy Protection"**. 


In "main.m", we implement the data perturbation algorithm "LR-Geo" proposed in the paper, enabling geo-obfuscation by focusing on locally relevant locations for each user. It optimizes location privacy while maintaining computational efficiency using linear programming (LP). It implements the Benders' decomposition technique discussed in the paper to solve large-scale LP problems efficiently.

## Environment 
The artifact is developed and tested using **MATLAB R2024a**, with the MATLAB **Optimization Toolbox** [linprog](https://www.mathworks.com/help/optim/ug/linprog.html) installed. 

The artifact is compatible with major operating systems supported by MATLAB, including:
- **Windows 10/11**
- **macOS Monterey/Ventura**
- **Ubuntu Linux 20.04/22.04**

Minimum Hardware Requirements include 
- **Processor**: Dual-core CPU or higher
- **Memory**: 8 GB RAM (16 GB recommended for larger datasets)
- **Disk Space**: 2 GB of free space for MATLAB installation and artifact files


If you are using our code, please cite our PETS paper. You may use the following BibTex entry:

```
@INPROCEEDINGS{Qiu_PETS2025,
  author={Qiu, Chenxi and Liu, *Ruiyao and Pappachan, Primal and Squicciarini, Anna and Xie, *Xinpeng},
  booktitle={Proceedings of the 25th Privacy Enhancing Technologies Symposium (PETS)}, 
  title={[A] Time-Efficient Locally Relevant Geo-Location Privacy Protection}, 
  year={2025},
  selected1 = {true},
}
