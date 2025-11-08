# Parallel Equations Expansion in TFORM

**Author:** Maciej Kozyra  
**Email:** xkozyra@gmail.com  
This repository is intended for users who want to explore optimizations in TFORM scripts or parallel Bash execution to improve execution time and memory usage.
---
## Overview
This repository provides scripts and resources to perform **parallel expansion of symbolic equations** using **TFORM**. Each symbolic equation is read from a separate, exemplary file `standardEquations_*.frm` and expanded in an individual TFORM process.  

The primary goal is to address performance issues with TFORM expansion compared to **Mathematica’s** parallel expansion method:

```mathematica
ParallelMap[Expand, listOfEquations, Method -> "FinestGrained"]
```
The execution time of this program must be less than 334.939477 seconds, as this is the execution time of the above-mentioned code run in Mathematica for the same equations contained in the standardEquations_*.frm files.

## Repository Structure
.

├── coeffs.frm

├── dvars.frm

├── parallel_tform_running.sh

├── tform_script.frm

├── exec_tform_script_time.txt

└── wkb9/

    └── standardEquations_*.frm
    
## File Descriptions
coeffs.frm – Defines a(x_, y_) coefficients as continued functions in TFORM to specify grouping within equations.

dvars.frm – Defines d(x_, y_) coefficients as continued functions in TFORM for equation grouping.

parallel_tform_running.sh – Bash script to execute multiple TFORM processes in parallel. Each process handles a single equation using tform_script.frm.

tform_script.frm – TFORM script responsible for expanding a single equation and saving the result as expandedEquation_*.m in the wkb9/ directory.

exec_tform_script_time.txt – Log file recording execution times for each run of parallel_tform_running.sh.

wkb9/ – Contains all input equations to expand, named standardEquations_*.frm.

## Usage
To run the parallel expansion, execute the following command in a Linux terminal:
```bash
bash parallel_tform_running.sh 19 ./ wkb9/
```
where:
19 – Number of standardEquations_*.frm files.

./ – Current working directory.

wkb9/ – Directory containing input equation files.

Output: Expanded equations are saved in wkb9/ as expandedEquation_*.m. Execution times are logged in exec_tform_script_time.txt.

## Workflow
I. Input equations are stored in wkb9/ as standardEquations_*.frm.

II. parallel_tform_running.sh launches multiple TFORM processes in parallel.

III. Each process runs tform_script.frm, expanding a single equation.

IV. Results are saved as expandedEquation_*.m.

V. Execution times are logged for performance analysis.

## Performance Notes
I. TFORM processes are independent and can run fully in parallel.

II. The repository is intended to help identify bottlenecks and optimize TFORM scripts and Bash execution.

III. Memory usage and execution time will scale with the number of parallel processes.

## Contributing
Contributions are welcome! If you find improvements for TFORM optimization, Bash scripting, or parallel execution, please open a pull request or an issue.
