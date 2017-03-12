function P = rmpaths(varargin)
% RMPATHS Remove directory from search path recursively
%
%   RMPATHS(DIR1, DIR2, ...) recursively removes the directories DIR1, DIR2 from
%   the search path. Recursively means, if there is a 'finish.m' script or
%   function in the directory, it will be called.
%
%   P = RMPATHS(...) returns the path prior to removing the specified paths.
%
%   Outputs:
%
%   P                   The path prior to removing the specified paths.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2017-03-12
% Changelog:
%   2017-03-12
%       * Initial release



%% Do your code magic here
% Return old paths?
if nargout > 0
    P = path;
end

% Get the paths to be removed
cePaths = varargin;
% Get list of all paths registered
cePathList = regexp(path, pathsep, 'Split');

% Get the current debug stack so we don't recursively call startup of the same
% file
stStack = dbstack('-completenames');
% Get all the filenames from the current stack so that access later on is easier
ceFileStack = {stStack.file};

% Loop over every path-to-be-removed
for iPath = numel(cePaths):-1:1
    % Extract current path form list of paths (faster because we'll be needing
    % it a few more times)
    chPath = cePaths{iPath};
    
    % If the path given is a string generated by genpath, then we will need to
    % split that by ';'
    if strfind(chPath, pathsep)
        % Split this path into each of its subpaths
        cePathPathList = regexp(chPath, pathsep, 'Split');
        
        % Try removing each of the paths inside this path list separately
        try
            rmpaths(cePathPathList{:});
        catch ME
            warning(ME.message);
        end
    % Just a single path given
    else
        % Get path's canonical name i.e., turn any relative path into an absolute
        % path
        % @see http://stackoverflow.com/questions/18395892/how-to-resolve-a-relative-directory-path-to-canonical-path-in-matlab-octave
        jFile = java.io.File(chPath);
        chPath = char(jFile.getCanonicalPath);

        % Only remove the path if it is on the path
        if any(ismember(chPath, cePathList)) && 7 == exist(chPath, 'dir')
            % Try removing the folder from the path. If things fail here, we'll
            % be save because we're just TRYing to remove the folder so a
            % failure won't break the whole script
            try
                % Remove the path
                rmpath(chPath);
                % Startup file path
                chFinishFile = fullfile(chPath, 'finish.m');
                % Finish file exists and we're not calling the same finish file
                % that we are currently being called from?
                if 0 ~= exist(chFinishFile, 'file') && ~ismember(chFinishFile, ceFileStack)
                    % Execute it
                    run(chFinishFile);
                end
            catch ME
                warning(ME.message);
            end
        end
    end
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
