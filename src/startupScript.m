%% add to search path
[path,~,~] = fileparts(mfilename('fullpath'));
cutIdx = strfind(path, '\');
workspacePath = path(1:cutIdx(end));
addpath(workspacePath);
addpath(strcat(workspacePath,'src\'));

ftPath = strcat(workspacePath,'src\fieldtrip');
addpath(ftPath);
ft_defaults;