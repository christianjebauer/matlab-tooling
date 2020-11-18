function p = mlt_projpath()
% MLT_PROJPATH returns the path definiton for this project
%
%   Outputs:
%
%   P                   Cell array of paths to automatically load



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2020-10-30
% Changelog:
%   2020-10-30
%       * Fix path to `matlab2tikz` source directory
%   2020-06-11
%       * Add directory` video` to cell of paths
%       * Move into `private` directory so it is only accesible from functions
%       within this directory
%       * Rename to `mlt_projpath`
%   2019-02-28
%       * Remove directory 'dae' which is not yet to be available
%   2018-04-29
%       * Initial release



%% Do your code magic here

chPath = fullfile(fileparts(mfilename('fullpath')), '..');

p = { ...
    fullfile(chPath) ...
    fullfile(chPath, 'data') ...
    fullfile(chPath, 'experiments') ...
    fullfile(chPath, 'exportfig') ...
    fullfile(chPath, 'file') ...
    fullfile(chPath, 'func') ...
    fullfile(chPath, 'jsonlab') ...
    fullfile(chPath, 'mat') ...
    fullfile(chPath, 'math') ...
    fullfile(chPath, 'matlab2tikz', 'src') ...
    fullfile(chPath, 'ode') ...
    fullfile(chPath, 'optim') ...
    genpath(fullfile(chPath, 'plot')) ...
    fullfile(chPath, 'signal') ...
    fullfile(chPath, 'solarized-matlab') ...
    fullfile(chPath, 'str') ...
    fullfile(chPath, 'symbolic') ...
    fullfile(chPath, 'sys') ...
    fullfile(chPath, 'twincat') ...
    fullfile(chPath, 'video') ...
};


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header