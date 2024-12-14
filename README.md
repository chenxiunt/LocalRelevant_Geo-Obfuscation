# **Paper Title: Time-Efficient Locally Relevant Geo-Location Privacy Protection**

## **Description**
This repository contains the source code related to the methodologies and experiments presented in the paper titled **"Time-Efficient Locally Relevant Geo-Location Privacy Protection"**.

The file **`main.m`** implements the data perturbation algorithm **LR-Geo** proposed in the paper. This algorithm facilitates geo-obfuscation by focusing on locally relevant locations for each user, optimizing location privacy while maintaining computational efficiency through **linear programming (LP)**. It also incorporates the **Benders' decomposition technique** to efficiently solve large-scale LP problems, as discussed in the paper.

---

## **How to Run the Code**
To execute the code:

1. Ensure **MATLAB** is installed on your local computer.
2. Open MATLAB and run **`main.m`**.
3. Customize the parameters of the algorithm (simulation environment) in **lines 14–23** of **`main.m`**:

   - `LR_LOC_SIZE` — Total number of locations
   - `OBF_RANGE` — Radius of the obfuscation range (assumes a circular area)
   - `EXP_RANGE` — Radius within which the exponential mechanism is not applied
   - `NEIGHBOR_THRESHOLD = 0.5` — Neighbor threshold (`η`)
   - `NR_DEST` — Number of destinations (spatial tasks)
   - `NR_USER` — Number of users (agents)
   - `NR_LOC` — Total number of locations

4. After running **`main.m`**, the following results are stored in `.mat` files:
   - **`cost.mat`**: Utility loss caused by the LR-Geo algorithm
   - **`cost_lower.mat`**: Lower bound of the utility loss
   - **`nr_iterations.mat`**: Number of iterations in Benders' decomposition
   - **`computation_time.mat`**: Computation time of the LR-Geo algorithm
   - **`nr_violations.mat`**: Number of Geo-indistinguishability violations
   - **`violation_mag.mat`**: Magnitude of Geo-indistinguishability violations
   - 
---

## **Environment**
The code was developed and tested using **MATLAB R2024a** with the **Optimization Toolbox** installed. The toolbox includes the [**`linprog`**](https://www.mathworks.com/help/optim/ug/linprog.html) function for linear programming.

### **Supported Operating Systems**
- **Windows 10/11**
- **macOS Monterey/Ventura**
- **Ubuntu Linux 20.04/22.04**

### **Recommended Hardware Requirements**
- **Processor**: Dual-core CPU or higher
- **Memory**: 8 GB RAM (16 GB recommended for larger datasets)
- **Disk Space**: 2 GB of free space for MATLAB installation and artifact files

---

## **Citation**
If you use this code in your research, please cite our paper using the following BibTeX entry:

```bibtex
@INPROCEEDINGS{Qiu_PETS2025,
  author={Qiu, Chenxi and Liu, *Ruiyao and Pappachan, Primal and Squicciarini, Anna and Xie, *Xinpeng},
  booktitle={Proceedings of the 25th Privacy Enhancing Technologies Symposium (PETS)}, 
  title={[A] Time-Efficient Locally Relevant Geo-Location Privacy Protection}, 
  year={2025},
}
