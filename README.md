# condalab (fork)

Handy MATLAB utility to switch between conda environments **from within MATLAB**

This is a fork of the original repo (https://github.com/sg-s/condalab.git) which allows manual setting of conda base directory. Depending on how you install conda / add to the .bashrc, it may not be detected using the original method. In theory tthis should allow you to use different versions of conda by setting a different base folder


## Installation

1. Grab this repo. Chuck it somewhere on your path.
2. Determine where your base `conda` installation by opening a terminal and typing `which conda`. Make a note of that path.
3. Type `conda.init` in your MATLAB terminal. It should prompt you for the path you got in step 2.


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

__If this doesn't work__, it may be because in some systems your conda path is not added to the system path (e.g., a conda path added to the .bashrc under Linux / Mac may not be added by Matlab). If this doesn't work, add it and repeat __step 1__:

```matlab
conda_path = '/anaconda3/bin'; % your conda install path here. avoid slashes
% or backslashes at the end
conda.addBaseCondaPath(conda_path)
```

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
