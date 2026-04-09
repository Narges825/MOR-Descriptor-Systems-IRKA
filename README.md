# MOR-Descriptor-Systems-IRKA

## Overview

This project implements and evaluates the **Iterative Rational Krylov Algorithm (IRKA)** for model order reduction of large-scale descriptor systems (DAEs) arising from circuit models.

The objective is to construct reduced-order models (ROMs) that approximate the transfer function of the original full-order models (FOMs), while reducing computational complexity.

This work was developed as part of a seminar on **Model Reduction and Numerical Simulation**.

---

## Methods

The following approaches were implemented and tested:

* Standard IRKA for descriptor systems (DAEs)
* Modified IRKA with polynomial part matching
* Projection-based model order reduction
* Frequency-domain error analysis
* Comparison of transfer functions of FOM and ROM

All main algorithmic steps, iteration logic, and numerical experiments were implemented in MATLAB.

System matrices and auxiliary routines for projection matrix computation were provided by the original authors of the reference work.

---

## Numerical Experiments

Experiments were conducted using large-scale descriptor systems originating from circuit models.

### Standard IRKA

The classical IRKA method was applied first.

Observations:

* The approximation error increased rapidly with frequency.
* Errors reached magnitudes up to approximately **10^8**.
* This behavior indicates a mismatch in the polynomial part of the transfer function.

These results demonstrate limitations of standard IRKA when applied to descriptor systems.

---

### Modified IRKA with Polynomial Matching

A modified IRKA approach was implemented to improve matching of the polynomial part of the transfer function.

Observations:

* The approximation error was significantly reduced (approximately **1**).
* However, the error increased again for higher frequencies.
* This behavior is likely caused by numerical inaccuracies in the computation of projection matrices.

These results show that polynomial matching improves stability but does not fully resolve high-frequency errors.

---

## Limitations

* Projection matrices were computed using external routines.
* Numerical inaccuracies in spectral data affected stability.
* The reduced-order models did not fully reproduce high-frequency behavior.
* Accurate projection matrix computation for general systems remains an open numerical challenge.

---

## Example Configuration

Typical experiment:

* Original system dimension: **n ≈ 1499**
* Reduced model dimension: **r ≈ 20**
* Descriptor systems from circuit models

---

## Execution & Requirements
To run the simulations, the following proprietary components (provided by the original authors ) are required:
* rcl_ind2.m: System generator for the circuit descriptor models.
* Bode_500_10_1e8_1e-8.mat: Pre-computed spectral data for initialization.
  
Steps (if data is available):Ensure the proprietary files are in the MATLAB path.
2. Run main_IRKA.m to execute the modified IRKA for DAEs.
Note: Since the system matrices are not included for copyright reasons, please refer to the Results section to view the pre-generated performance plots.

---

## Output

The code generates:

* Frequency response plots
* Error plots comparing FOM and ROM
* Convergence behavior of IRKA iterations

---

## References

This project is based on the following work:

Serkan Gugercin, Tatjana Stykel, and Sarah Wyatt
**"Model Reduction of Descriptor Systems by Interpolatory Projection Methods"**

The implemented methods follow the interpolatory model reduction framework described in this paper, including adaptations of IRKA for descriptor systems.

System matrices and auxiliary routines used in the numerical experiments were provided by the original authors.

