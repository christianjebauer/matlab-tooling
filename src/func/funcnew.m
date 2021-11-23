function funcnew(Name, varargin)
%% FUNCNEW creates a new function file based on a template
%
% FUNCNEW(NAME) creates function NAME into a new file at the specified target.
% It will not have any input or return arguments pre-defined.
%
% FUNCNEW(NAME, ARGIN) also adds the list of input arguments defined in ARGIN to
% the function declaration.
%
% FUNCNEW(NAME, ARGIN, ARGOUT) creates function NAME into a new file at the
% specified target. The cell array ARGIN and ARGOUT define the argument input
% and argument output names.
%
% Inputs:
%
%   NAME                Name of the function. Can also be a fully qualified file
%                       name from which the function name will then be
%                       extracted.
%
%   ARGIN               Cell array of input variable names. If empty, function
%                       will not take any arguments. Placeholder `varargin` can
%                       be used by liking. Note that, any variable name occuring
%                       after `varargin` will be striped.
%
%   ARGOUT              Cell array of output variable names. If empty i.e., {},
%                       function will not return any arguments. Placeholder
%                       `varargout` may be used by requirement. Note that, any
%                       variable name occuring after `varargout` will be
%                       striped.
%
% Optional Inputs -- specified as parameter value pairs
%
%   Author              Author string to be set. Most preferable you will  use
%                       something like
%                       'Firstname Lastname <author-email@example.com>'
%   
%   Description         Description of function which is usually the first line
%                       after the function declaration and contains the function
%                       name in all caps.
%
%   NArgIn              Number of input arguments to use in `narginchk`.
%                       Default: [] i.e., all arguments required.
%
%   NArgOut             Number of output arguments to use in `nargoutchk`.
%                       Default: [] i.e., all arguments required.
%
%   Template            Path to a template file that should be used instead of
%                       the default found in this function's directory.
%                       Default: 'functiontemplate.mtpl'



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-11-23
% Changelog:
%   2021-11-23
%       * Fix H1 Documentation
%       * Add Name/Value options `NArgin` and `NArgout`
%       * Add section "Parse arguments" in generated file
%   2020-11-12
%       * Fix indentation of 'Inputs:' and 'Outputs:' in generated code
%   2020-11-02
%       * Change domain name in default value for `Author` to `ls2n.fr`
%   2018-11-18
%       * Fix typo in help lines
%   2018-05-14
%       * A custom defined template file path can be given now, too
%       * Additionally, if no custom template file path was givent, a file
%       template matching the target function name will be searched and used if
%       found. For example, if a function called `myfun` was to be created, we
%       look for a file called `myfun.mtpl` somewhere on the MATLAB path and load
%       this instead of `functiontemplate.mtpl`
%   2017-03-05
%       * Really fix incorrcet determination of the next major column depending
%       on the length of the input arguments and dividable by 4
%   2016-12-03
%       * Fix incorrect determination of the next major column depending on the
%       length of the input arguments and dividable by 4
%   2016-11-17
%       * Add validation of input and output argument formats such that these
%       will be valid MATLAB identifiers (make use of matlab.lang.makeValidName)
%       * Remove inline function in_charToValidArgument and replace with
%       parseswitcharg
%   2016-11-13
%       * Minor tweaking of determination of column to start argument
%       description in. Now is at least at column 21 if no longer argument names
%       are found
%   2016-11-11
%       * Update handling of no return arguments causing an empty equal sign to
%       appear and break code highlighting
%       * Fix message identifiers used in MException
%   2016-11-06
%       * Fix that square brackets were placed around a single output argument
%       where it actually is not needed
%   2016-09-02
%       * Fix bug in description parsing when only {'varargin'} or {'varargout'}
%       was given for 'ArgIn' or 'ArgOut', respectively
%       * Tweak checking for file existance and overwrite flag
%   2016-09-01
%       * Prevent function from overwriting already existing functions unless
%       overwriting is explicitely enforced
%       * Fix bug in determination of longest ON or OUT argument name causing a
%       warning to be emitted by MATLAB
%   2016-08-25
%       * Add support for input and output arguments appearing in the help part
%       of the script
%       * Change option 'Open' to 'Silent' to have argument make more sense (A
%       toggle should always be FALSE by default and only TRUE by request.
%       Previously, that was not the case)
%    2016-08-04
%       * Change default value of option 'Open' to 'on'
%   2016-08-02
%       * Initial release



%% Define the input parser
ip = inputParser;

% Require: Filename
valFcn_Name = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Name');
addRequired(ip, 'Name', valFcn_Name);

% Allow custom input argument list
valFcn_ArgIn = @(x) validateattributes(x, {'cell'}, {}, mfilename(), 'ArgIn');
addOptional(ip, 'ArgIn', {}, valFcn_ArgIn);

% Allow custom return argument list
valFcn_ArgOut = @(x) validateattributes(x, {'cell'}, {}, mfilename(), 'ArgOut');
addOptional(ip, 'ArgOut', {}, valFcn_ArgOut);

% Author: Char. Non-empty
valFcn_Author = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Author');
addParameter(ip, 'Author', 'Philipp Tempel <philipp.tempel@ls2n.fr>', valFcn_Author);

% Description: Char. Non-empty
valFcn_Description = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Description');
addParameter(ip, 'Description', '', valFcn_Description);

% Number of input/output arguments
valFcn_NArgIn  = @(x) validateattributes(x, {'double'}, {'vector', 'numel', 2, 'nonnegative', 'nondecreasing', 'nonnan'}, mfilename(), 'NArgIn');
valFcn_NArgOut = @(x) validateattributes(x, {'double'}, {'vector', 'numel', 2, 'nonnegative', 'nondecreasing', 'nonnan'}, mfilename(), 'NArgOut');
addParameter(ip, 'NArgIn', [], valFcn_NArgIn);
addParameter(ip, 'NArgOut', [], valFcn_NArgOut);

% Overwrite: Char. Matches {'on', 'off', 'yes', 'no'}. Defaults 'no';
valFcn_Overwrite = @(x) any(validatestring(x, {'on', 'off', 'yes', 'no'}, mfilename(), 'Overwrite'));
addParameter(ip, 'Overwrite', 'off', valFcn_Overwrite);

% A package name may also be provided
valFcn_Package = @(x) validateattributes(x, {'char'}, {}, mfilename(), 'Package');
addParameter(ip, 'Package', '', valFcn_Package);

% Silent: Char. Matches {'on', 'off', 'yes', 'no'}. Defaults 'off'
valFcn_Silent = @(x) any(validatestring(x, {'on', 'off', 'yes', 'no'}, mfilename(), 'Silent'));
addParameter(ip, 'Silent', 'off', valFcn_Silent);

% Template: Char; non-empty
valFcn_Template = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Template');
addParameter(ip, 'Template', '', valFcn_Template);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    % FUNCNEW(NAME)
    % FUNCNEW(NAME, IN)
    % FUNCNEW(NAME, IN, OUT)
    % FUNCNEW(NAME, IN, OUT, 'Name', 'Value', ...)
    narginchk(1, Inf);
    
    % FUNCNEW(...)
    nargoutchk(0, 0);
    
    args = [{Name}, varargin];
    
    parse(ip, args{:});
catch me
    throwAsCaller(MException(me.identifier, me.message));
end



%% Parse results
% Function name/path
chName = ip.Results.Name;
% Get function path, file name, and extension
[chFunction_Path, chFunction_Name, chFunction_Ext] = fileparts(chName);
% Empty filepath?
if isempty(chFunction_Path)
    % Save in the current working directory
    chFunction_Path = pwd;
end
% Empty file extension?
if isempty(chFunction_Ext)
    % Ensure we'll save as '.m' file
    chFunction_Ext = '.m';
end
% List of input arguments
[ceArgIn, fVarArgIn] = parse_vararg('in', ip.Results.ArgIn);
% List of output arguments
[ceArgOut, fVarArgOut] = parse_vararg('out', ip.Results.ArgOut);
% Description text
chDescription = ip.Results.Description;
% Author name
chAuthor = ip.Results.Author;
% Silent creation?
chSilent = parseswitcharg(ip.Results.Silent);
% Overwrite existing?
chOverwrite = parseswitcharg(ip.Results.Overwrite);
% Path to template file
chTemplate = ip.Results.Template;
% Package name
chPackage = ip.Results.Package;
% Number of input/output arguments
nArgI = ip.Results.NArgIn;
nArgO = ip.Results.NArgOut;

%%% Local variables
% No templtae file given?
if isempty(chTemplate)
    % Check if a template for this function name exists
    if 2 == exist(sprintf('%s.mtpl', chFunction_Name), 'file')
        % Get the fully qualified file path to the function template name
        chTemplateFilepath = which(sprintf('%s.mtpl', chFunction_Name));
    else
        % Then use the default function template
        chTemplateFilepath = fullfile(fileparts(mfilename('fullpath')), 'functiontemplate.mtpl');
    end
end
% Date of creation of the file
chDate = datestr(now, 'yyyy-mm-dd');
if ~isempty(chPackage)
    % Split package name as string into package parts
    cePackage = strsplit(chPackage, '.');
    % Merge package name components back into a string with '/+' as separator
    chPackage = strjoin(cePackage, '/+');
    % Prepend a last missing package indicator in front of the first package name
    chPackage = ['+' , chPackage];
    % Append to file path
    chFunction_Path = fullfile(chFunction_Path, chPackage);
end
% Lastly, add file name to file path
chFunction_FullFile = fullfile(chFunction_Path, sprintf('%s%s', chFunction_Name , chFunction_Ext));



%% Assert variables
% Assert we have a valid function template filepath
assert(2 == exist(chTemplateFilepath, 'file'), 'PHILIPPTEMPEL:MATLAB_TOOLING:FUNCNEW:functionTemplateNotFound', 'Function template cannot be found at %s.', chTemplateFilepath);
% Assert the target file does not exist yet
assert(2 == exist(chFunction_FullFile, 'file') && strcmp(chOverwrite, 'on') || 0 == exist(chFunction_FullFile, 'file'), 'PHILIPPTEMPEL:FUNCNEW:functionExists', 'Function already exists. Will not overwrite unless forced to do so.');



%% Create the file contents
% Read the file template
try
    fidSource = fopen(chTemplateFilepath);
    ceFunction_Contents = textscan(fidSource, '%s', 'Delimiter', '\n', 'Whitespace', ''); ceFunction_Contents = ceFunction_Contents{1};
    fclose(fidSource);
catch me
    if strcmp(me.identifier, 'MATLAB:FileIO:InvalidFid')
        throwAsCaller(MException('PHILIPPTEMPEL:MATLAB_TOOLING:FUNCNEW:invalidTemplateFid', 'Could not open source file for reading.'));
    end
    
    throwAsCaller(MException(me.identifier, me.message));
end

% Join the input arguments
chArgsIn = strjoin(cellfun(@(chArg) matlab.lang.makeValidName(chArg), ceArgIn, 'UniformOutput', false), ', ');
% Join the output arguments
chArgsOut = strjoin(cellfun(@(chArg) matlab.lang.makeValidName(chArg), ceArgOut, 'UniformOutput', false), ', ');
% Wrap output argumets in square brackets if there are more than one
if numel(ceArgOut) > 0
    if numel(ceArgOut) > 1
        chArgsOut = sprintf('[%s]', chArgsOut);
    end
    
    chArgsOut = sprintf('%s = ', chArgsOut);
end

% Input/output argument checking
arginchk = build_argchk('in', nArgI);
argoutchk = build_argchk('out', nArgO);

% Description string
chDescription = in_createDescription(chDescription, ceArgIn, ceArgOut);

% Define the set of placeholders to replace here
ceReplacers = {...
    'FUNCTION', chFunction_Name; ...
    'FUNCTION_UPPER', upper(chFunction_Name); ...
    'ARGIN', chArgsIn; ...
    'ARGOUT', chArgsOut; ...
    'DESCRIPTION', chDescription; ...
    'AUTHOR', chAuthor; ...
    'DATE', chDate;
    'ARGINCHK', arginchk ; ...
    'ARGOUTCHK', argoutchk ; ...
};
% Replace all placeholders with their respective content
for iReplace = 1:size(ceReplacers, 1)
    ceFunction_Contents = cellfun(@(str) strrep(str, sprintf('{{%s}}', ceReplacers{iReplace,1}), ceReplacers{iReplace,2}), ceFunction_Contents, 'Uniform', false);
end


% Save the file
try
  % Make target directory
    if 7 ~= exist(chFunction_Path, 'dir')
        mkdir(chFunction_Path);
    end
    fidTarget = fopen(chFunction_FullFile, 'w+');
    for row = 1:numel(ceFunction_Contents)
        fprintf(fidTarget, '%s\r\n', ceFunction_Contents{row,:});
    end
    fcStatus = fclose(fidTarget);
    assert(fcStatus == 0);
catch me
    if strcmp(me.identifier, 'MATLAB:FileIO:InvalidFid')
        throwAsCaller(MException('PHILIPPTEMPEL:MATLAB_TOOLING:FUNCNEW:invalidTargetFid', 'Could not open target file for writing.'));
    end
    
    throwAsCaller(MException(me.identifier, me.message));
end



%% Assign output quantities
% Open file afterwards?
if strcmp(chSilent, 'off')
    open(chFunction_FullFile);
end


end


function chDesc = in_createDescription(chDescription, ceArgIn, ceArgOut)
%% IN_CREATEDESCRIPTION



% Holds the formatted list entries of inargs and outargs
ceArgIn_List = cell(numel(ceArgIn), min(numel(ceArgIn), 1));
ceArgOut_List = cell(numel(ceArgOut), min(numel(ceArgOut), 1));

% Determine longest argument name for input
nCharsLongestArg_In = max(cellfun(@(x) length(x), ceArgIn));
if isempty(nCharsLongestArg_In)
    nCharsLongestArg_In = 0;
end
% and output
nCharsLongestArg_Out = max(cellfun(@(x) length(x), ceArgOut));
if isempty(nCharsLongestArg_Out)
    nCharsLongestArg_Out = 0;
end

% Determine the longer argument names: input or output?
nCharsLongestArg = max([nCharsLongestArg_In, nCharsLongestArg_Out]);
% Get the index of the next column (dividable by 4) but be at least at
% column 21
nNextColumn = max([21, 4*ceil((nCharsLongestArg + 1)/4) + 1]);

% First, create a lits of in arguments
if ~isempty(ceArgIn)
    % Prepend comment char and whitespace before uppercased argument
    % name, append whitespace up to filling column and a placeholder at
    % the end
    ceArgIn_List = cellfun(@(x) sprintf('%%   %s%s%s %s', upper(x), repmat(' ', 1, nNextColumn - length(x) - 1), 'Description of argument', upper(x)), ceArgIn, 'Uniform', false);
end

% Second, create a lits of out arguments
if ~isempty(ceArgOut)
    % Prepend comment char and whitespace before uppercased argument
    % name, append whitespace up to filling column and a placeholder at
    % the end
    ceArgOut_List = cellfun(@(x) sprintf('%%   %s%s%s %s', upper(x), repmat(' ', 1, nNextColumn - length(x) - 1), 'Description of argument', upper(x)), ceArgOut, 'Uniform', false);
end

% Create the description first from the text given by the user
chDesc = sprintf('%s', chDescription);

% Append list of input arguments?
if ~isempty(ceArgIn_List)
    chDesc = sprintf('%s\n%%\n%% Inputs:\n%%\n%s', chDesc, strjoin(ceArgIn_List, '\n%\n'));
end

% Append list of output arguments?
if ~isempty(ceArgOut_List)
    chDesc = sprintf('%s\n%%\n%% Outputs:\n%%\n%s', chDesc, strjoin(ceArgOut_List, '\n%\n'));
end


end


function [args, f] = parse_vararg(t, args)
%% PARSE_VARARG
%
% [ARGS, F] = PARSE_VARARG(T, ARGS)



% Find the index of 'varargin' in the input argument names
idxS = find(strcmpi(args, sprintf('vararg%s', t)));
f = ~isempty(idxS) && numel(args) >= idxS;
% Reject everything after 'varargin'
if f
  args((idxS + 1):end) = [];
end


end


function a = build_argchk(t, n)
%% BUILD_ARGCHK
%
% A = BUILD_ARGCHK(T, N)



if ~isempty(n)
  a = sprintf('narg%schk(%d, %d);', t, n(1), n(2));
  if strcmpi(t, 'in')
    a = sprintf('\n%s\n', a);
  elseif strcmpi(t, 'out')
    a = sprintf('%s\n\n', a);
  end
else
  a = '';
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
