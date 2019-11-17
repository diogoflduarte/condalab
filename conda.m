% conda.m
% a simple MATLAB utility to control conda
% environments on *nix systems
% 
% usage
%
% MATLAB 			   Shell
% ===================================
% conda.getenv         conda env list
% conda.setenv(env)    source activate env
% 
% Srinivas Gorur-Shandilya 

classdef conda


properties
end

methods

end

methods (Static)



	function init()

		try
			getpref('condalab','base_path');
		catch
			str = input('Enter the path to your conda installation:  \n','s');
			str = strrep(str,[filesep 'conda'],'');
			setpref('condalab','base_path',str)
		end



		conda.addBaseCondaPath()

	end


	function addBaseCondaPath(conda_path)

		try
            if nargin<1              
                condalab_base_path = getpref('condalab','base_path');
            else
                setpref('condalab','base_path',conda_path)
                condalab_base_path = getpref('condalab','base_path');
            end
		catch
			conda.init()
			condalab_base_path = getpref('condalab','base_path');
        end

        

		[e,o]=system('which conda');
		if e == 0
			% conda is somewhere on the path, so do nothing
			return
		end

		P = strsplit(getenv('PATH'),pathsep);
		add_to_path = true;
		for i = 1:length(P)
			if strcmp(P{i},condalab_base_path)
				add_to_path = false;
			end
		end
		if add_to_path
			setenv('PATH',[condalab_base_path pathsep getenv('PATH') ]);
		end



	end

	function varargout = getenv()
		conda.addBaseCondaPath;
		[~,envs] = system('conda env list');
		envs = strsplit(envs,'\n');

		p = strsplit(getenv('PATH'),pathsep);

		% remove the asterix because it always is on root
		for i = length(envs):-1:1
			envs{i} = strrep(envs{i},'*',' ');
			if isempty(envs{i})
				continue
			end
			if strcmp(envs{i}(1),'#')
				continue
			end

			this_env = strsplit(envs{i});
			env_names{i} = this_env{1};
			env_paths{i} = this_env{2};


			active_path = 0;
			for j = 1:length(env_paths)
				this_env_path = [env_paths{j} filesep 'bin'];
				if any(strcmp(this_env_path,p))
					active_path = j;
				end
			end

		end

		if nargout 
			varargout{1} = env_names;
			varargout{2} = env_paths;
			varargout{3} = active_path;
		else
			fprintf('\n')
			for i = 1:length(env_names)
				if isempty(env_names{i})
					continue
				end
				if active_path == i
					disp(['*' env_names{i} '     ' env_paths{i}])
				else
					disp([env_names{i} '     ' env_paths{i}])
				end
			end
		end
	end % end getenv

	function setenv(env)
		conda.addBaseCondaPath;
		[~,envs] = system(['conda env list']);
		envs = strsplit(envs,'\n');

		[env_names, env_paths] = conda.getenv;

		% check that envs exists in the list
		assert(any(strcmp(env_names,env)), 'env you want to activate is not valid')


		p = getenv('PATH');
		% delete every conda env path from the path
		p = strsplit(p,pathsep);
		rm_this = false(length(p),1);
		for i = 1:length(p)
			% remove "bin" from the end
			this_path = strtrim(strrep(p{i}, [filesep 'bin'],''));
			if any(strcmp(this_path,env_paths))
				rm_this(i) = true;
			end
		end
		p(rm_this) = [];

		% add the path of the env we want to switch to
		this_env_path = [env_paths{strcmp(env_names,env)} filesep 'bin'];
		p = [this_env_path p];
		p = strjoin(p,pathsep);

		% prepend the base path to this, because apparently
		% conda decides to change everything every 2 months
        
        
        % [Diogo Duarte]
        % I commented the line bellow because under Mac it causes the
        % python executable to be the one under conda's base path, instead
        % of being the one under your virtual environment path!!
% 		p = [getpref('condalab','base_path') pathsep p];

		setenv('PATH', p);

	end % setenv

    function deactivate()
        % removes conda from path
        [env_names, env_paths, active_path] = conda.getenv();
        p = getenv('PATH');
        path_folders = strsplit(p, ':');
        condalab_base_path = getpref('condalab','base_path');
        candidates = strfind(path_folders, env_paths{active_path});
        
        
        binActPth = fullfile(env_paths{active_path}, 'bin');        
        if strcmpi(condalab_base_path, binActPth)
            % this is the condalab folder, no need to take it out
            disp('No envs were deactivated');
            return
        end
        
        idx_to_keep = [];
        noEnvsDeact = 1;
        for ii =1:numel(candidates)
            if ~isempty(candidates{ii}) && ...
                    strcmpi(path_folders(ii), binActPth)
                path_folders{ii} = [];
                noEnvsDeact = 0;
            else
                idx_to_keep = [idx_to_keep ii];
            end
        end
        path_folders = path_folders(idx_to_keep);
        p = strjoin(path_folders, ':');
        setenv('PATH', p);
        
        if noEnvsDeact
            disp('No envs were deactivated');
        end
        
        setenv('PATH', p);
    end


end



end % end classdef