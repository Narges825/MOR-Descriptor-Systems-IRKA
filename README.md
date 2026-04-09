# MOR-Descriptor-Systems-IRKA

## Overview

This project implements and evaluates variants of the  
**Iterative Rational Krylov Algorithm (IRKA)** for model order reduction of large-scale descriptor systems (DAEs) arising from circuit models.

The objective is to construct reduced-order models (ROMs) that accurately approximate the transfer function of the original full-order models (FOMs), while significantly reducing computational complexity.

This work was developed as part of a seminar on  
**Model Reduction and Numerical Simulation**.

---

## Implemented Algorithms

The repository contains multiple IRKA-based implementations designed for descriptor systems with singular matrices.

### `IRKA_D.m` — Standard Descriptor IRKA

This function implements the classical IRKA method for descriptor systems where the matrix **E** is singular.

Characteristics:

- Standard IRKA formulation for DAEs
- No explicit handling of the polynomial part
- Serves as a baseline implementation
- Useful for comparison with modified approaches

Limitations:

- High-frequency errors grow significantly
- Polynomial part mismatch leads to unbounded approximation errors

---

### `IRKA_WCF.m` — IRKA with Spectral Projectors (**Primary Contribution**)

This function represents the **main contribution of the project**.

It implements IRKA using **spectral projectors** to properly handle the polynomial part of the transfer function.

Objectives:

- Match the polynomial part of the transfer function
- Maintain bounded errors at high frequencies
- Improve numerical stability of reduced-order models

Key Features:

- Uses spectral projector-based formulation
- Improves high-frequency behavior
- Reduces instability caused by improper polynomial matching
- Designed specifically for descriptor systems with singular **E**

This implementation forms the core methodological contribution of the project.

---

### `main_IRKA.m` — Execution Script

This script controls the numerical experiments and executes the IRKA workflow.

Responsibilities:

- Loads spectral initialization data
- Generates system matrices
- Calls selected IRKA implementations
- Performs convergence iterations
- Produces performance plots
- Evaluates frequency-domain errors

This file serves as the main entry point for running simulations.

---

## Numerical Methods Used

The following techniques were implemented and evaluated:

- Standard IRKA for descriptor systems
- IRKA with spectral projector-based polynomial matching
- Projection-based model order reduction
- Frequency-domain transfer function approximation
- Error analysis between FOM and ROM
- Convergence monitoring of interpolation points

All algorithmic steps, iteration logic, and numerical experiments were implemented in **MATLAB**.

System matrices and auxiliary routines for projection matrix computation were provided by the original authors of the reference work.

---

## Numerical Experiments

Experiments were conducted using large-scale descriptor systems derived from circuit models.

### Standard IRKA (`IRKA_D.m`)

The classical IRKA method was applied first.

Observations:

- The approximation error increased rapidly with frequency
- Errors reached magnitudes up to approximately **10⁸**
- This indicates a mismatch in the polynomial part of the transfer function

Conclusion:

Standard IRKA is not sufficient for descriptor systems requiring accurate high-frequency behavior.

---

### Modified IRKA with Spectral Projectors (`IRKA_WCF.m`)

A modified IRKA approach using spectral projectors was implemented.

Observations:

- Approximation error was significantly reduced (approximately **1**)
- Errors remained bounded at high frequencies
- Remaining deviations are likely due to numerical inaccuracies in projection matrix computation

Conclusion:

Polynomial matching using spectral projectors substantially improves stability and accuracy.

---

## Example Configuration

Typical experiment parameters:

- Original system dimension: **n ≈ 1499**
- Reduced model dimension: **r ≈ 20**
- System type: Descriptor systems from circuit models
- Frequency range: Wide-band frequency-domain evaluation

---

## Execution & Requirements

To run the simulations, the following proprietary components  
(provided by the original authors) are required:

- `rcl_ind2.m`  
  System generator for circuit descriptor models

- `Bode_500_10_1e8_1e-8.mat`  
  Pre-computed spectral data used for initialization

### Steps to Run

1. Ensure proprietary files are available in the MATLAB path
2. Place repository files in the working directory
3. Run:

```matlab
main_IRKA

## Discussion of Results

The numerical results show that the reduced-order model (ROM) does not
fully match the behavior of the full-order model (FOM), particularly at
higher frequencies.

This mismatch is primarily caused by inaccuracies in the computation of
the spectral projectors used in the modified IRKA implementation.

Since the spectral projectors are not computed exactly, the polynomial
part of the transfer function is not matched perfectly between the FOM
and the ROM. As a result:

- The polynomial part of the transfer function differs between FOM and ROM
- High-frequency behavior is not reproduced accurately
- The ROM error increases in frequency regions where polynomial matching is critical

These observations highlight the sensitivity of interpolatory projection
methods to the numerical accuracy of spectral projector computation.
