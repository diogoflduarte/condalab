# condalab (fork)

Handy MATLAB utility to switch between conda environments **from within MATLAB**

This is a fork of the original repo (https://github.com/sg-s/condalab.git).

Changes include:
  - adding the conda path can be done without prompt (see installation)
  - setting the environment (equivalent of conda activate) now makes the python executable to be the one in the active environment (setting 'PATH' var in matlab), instead of being the conda python (not sure if this was a bug or feature in the upstream repo)
  - new method deactivate() removes the environment path from 'PATH' (equivalent of conda deactivate)


In theory this should allow you to switch between conda versions setting a different base folder (conda.addBaseCondaPath(conda_path)). Beware that this is not recommended and defeats the purpose of anaconda


## Installation

Grab this repo. Chuck it somewhere on your path. 
You can paste the code below into your startup.m file (adjust conda_path accordingly)

```matlab
conda_path = '/anaconda3/bin'; % your conda install path here. avoid slashes
% or backslashes at the end
conda.addBaseCondaPath(conda_path)
```
## Usage

#### Step 1
To view all your conda environments (i.e., the equivalent of `conda env list`)

```matlab
conda.getenv()

% You'll see something like this:
asimov          /Users/sg-s/anaconda3/envs/asimov
mctsne          /Users/sg-s/anaconda3/envs/mctsne
*tensorflow     /Users/sg-s/anaconda3/envs/tensorflow
root            /Users/sg-s/anaconda3

```

and the `*` indicates the currently active environment


#### Step 2
To switch between environments (i.e., `source activate env`)

```matlab
conda.setenv('env_name')
```

#### Step 2 (__NEW FEATURE__)
Supports deactivating the conda envs, *a la* terminal / commmand line:

```matlab
conda.deactivate()
```

This might be useful if you're switching between envs or making sure you're not running in a wrong env

Have fun :wink:
