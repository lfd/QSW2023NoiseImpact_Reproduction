# Effects of Imperfections on Quantum Algorithms: A Software Engineering Perspective

## Install Option 1: Install dependencies in python virtual environment (Recommended)
### Prerequisities (Machine Setup)
- Install of python 3.10.6
- Ubuntu 22.04
### Required setup steps
0. Clone this repository
1. Create virtual environment
```bash
python3 -m venv .venv
source .venv/bin/activate
```
2. Install requirementes
```
pip install -r requirements.txt
```
## Install Option 2: Run Docker Container
### Prerequisities
- Installation of Docker engine
### Required setup steps
- Build docker image
``` docker build -t qsw-repro . ```
- Run Container
```docker run --name qsw-repro -it qsw-repro```

## Folder structure and files
- *./backend_data/*
Contains hardware config dictionaries.
- *preprocess_data.ipynb*
  Preparation of (simulated) hardware configurations.
- *run_simulation.py*
  Contains methods for running the simulations.
- *helper_functions.py*
  Includes a number of helper functions.
- *pass_defs.py*
  Contains transpiler passes for custom gates.
- *gate_defs.py*
  Contains custom gates definitions.
- *exec_commands.sh*
  Examples for the command line interface

## How to run simulations 
Simulations are started using the *run_simulation.py* script.
You can use the command line iterface (see [here](#how-to-use-the-cli) or start the *run_simulation.py* script
in an IDE of your choice. In this case you have to set the `run_configuration` dictionary manually (See the comment in the `main` function in *run_simulation.py*)

# How to extend the framework :
## Add your own backend (e.g. based on real or expected future performance of hardware):
1) In *preprocess_data.ipynb*, add your own custom configuration (The last notebook cell does exactly that) 
You may also increase, e.g. the coupling density here.
2) Run the cell and your configuration is prepared and ready to use! 

## Add your own algorithms (purely quantum):
1) Add algorithms specific arguments in *run_simulation.py*:
- Augment the `parse_args` method (See existing code for e.g. grover)
- Add `parse_yourAlg` method (See existing code for e.g. grover)

2) Prepare your quantum circuit (e.g. create a function `your_circuit` that takes a `run_config` as argument and returns your circuit; see e.g. *grover_lib.py*) 

3) In  the run method:
- Add case in `match run_config["algo"]` which sets `circuit=your_circuit`

4) Optional:
- Add custom metrics of success in the 'format_run' method which can be saved later.

## Add your own target function for the variational approximator:
1) Add `case "yourFun"` to `match run_config["fun"]` in the `run_var` method of the *run_simulation.py* script.
(see `case "powx2"`) You can take the existing circuit here or add your own.

2) Add a test case in function `test_var`

3) Edit *helper_functions.py* and add yor function to `target_fun`.

## Add your own, totally different variational circuit.
This is a little bit more tricky. The area of variational circuits is broad and enables researchers to design miriads of algorithms.
Therefore we advice you to inspect our `run_var` method in *run_simulation.py* and then create your own `run_yourName` method.
Note that for our toy example we only measured one qubit for an easy-to-grasp illustration, which is not recommended for more sophisticated designs.

## Notes about parameters:
1) In the code the hardware config is saved in the dictionary `hw_config` and basically contains all hardware specific data as basis gates or coupling maps.
2) The `run_config` dictionary is used to determine the number of qubits or your algorithm etc. Also your noise method can be set here, if you e.g. want to simulate only some level of pauli_x noise.

## How to use the CLI
The command line interface allows you to set your backend (`hw_config`) and parameters of `run_config`. In the file *exec_commands.sh* some examples are shown; We advice you to write your own shell script to avoid manual retyping.
Also our interface allows you start several simulations, e.g. for different numbers of qubits in parallel or several repetions of the same algorithm.
Note that it is your own responsibility to choose these parameters according to your hardware ressources! Be aware that quantum simulation requires a lot of memory.

## Where are my results?
We store every run as a single csv_file in *sim_results/alg_name/filename.csv*. You can merge the csv files and visualize them using a tool of your choice, e.g. some R library of the tidyverse.
Also you may want to inspect the density matrix of your simulations which we store in *density_results/alg_name/filename.csv*. However you'll have to manually activate this in the `save_run` method in the *run_simulation.py* script, because it may occupy too much disk space.

## Acknowledgements
Next to Qiskit, we thank the creators of various useful python libraries, most importantly numpy and pandas.

## License
[Apache License 2.0](LICENSE.txt)

In the files, we used the SPDX standard for easy License identification https://spdx.dev/ ,
where we also explicitely higlight copyright holders and adjustments made, to prior work.
We also include the longer version, where we derived code from other sources.
