function startup()
% STARTUP starts this project



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2020-06-11
% Changelog:
%   2020-06-11
%       * Make standalone tooling project and ensure that it can be used as
%       start directory of MATLAB
%   2018-05-16
%       * Move the installation of the plot styles to a separate file
%   2018-05-14
%       * Add installation of plot styles to MATLAB's `prefdir()/ExportSetup`
%       directory
%   2018-04-29
%       * Move all path definitions to `pathdef.m`
%   2017-03-12
%       * Initial release



%% Do your code magic here

% Get path's to add to MATLAB's search path
p = mlt_projpath();
% and add the paths
addpath(p{:});

% Set random number generator to a set or pre-defined options
setrng()

% Copy all plotstyles if they need to be copied
copy_plotstyles();


end

function paths()
end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
