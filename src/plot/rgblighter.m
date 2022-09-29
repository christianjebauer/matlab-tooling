function lighter = rgblighter(rgb, factor, varargin)
% RGBLIGHTER 
%
%   RGBLIGHTER(RGB, FACTOR) turns the RGB-triplet RGB darker by factor FACTOR.
%
%   RGBLIGHTER(RGB, FACTOR, 'Name', 'Value', ...) allows setting optional
%   inputs using name/value pairs.
%
%   Inputs:
%
%   RGB                 1x3 triplet of RGB values in the range of 0..1.
%
%   FACTOR              Factor to lighten the RGB triplet to. Must be between
%                       0 and 1. With 1, the triplet will not be lightened, with
%                       0 it will be set to zero
%
%   Outputs:
%
%   LIGHTER             1x3 array of lightened RGB values in the range of 0..1



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-29
% Changelog:
%   2022-09-29
%       * Fix deprecated call to `PARSESWITCHARG` with `ONOFFSTATE`
%   2021-12-13
%       * Update to new signature of `PARSESWITCHARG`
%   2020-11-16
%       * Copy from my old MATLAB package
%       * Change email domain to `ls2n.fr`
%       * Rename to `rgbdarker`
%   2018-05-14
%       * Remove `fix` to keep original precision
%   2017-08-01
%       * Add option 'AsInteger' to allow returning the lighter RGB as integer
%       values
%       * Add help block text
%   2017-02-24
%       * Initial release



%% Define the input parser
ip = inputParser;

% Required: RGB; numeric; 2d, ncols 3, non-empty, non-sparse, non-negative, <=
% 1,
valFcn_Rgb = @(x) validateattributes(x, {'numeric'}, {'2d', 'nonempty', 'ncols', 3, 'nonsparse', 'nonnegative', '<=', 1}, mfilename, 'rgb');
addRequired(ip, 'rgb', valFcn_Rgb);

% Required: factor; numeric; scalar, non-empty, non-sparse, non-negative, <= 1,
valFcn_Factor = @(x) validateattributes(x, {'numeric'}, {'scalar', 'nonempty', 'scalar', 'nonsparse', 'nonnegative', '<=', 1}, mfilename, 'factor');
addRequired(ip, 'factor', valFcn_Factor);

% Optional: AsInteger; 
valFcn_AsInteger = @(x) any(validatestring(lower(x), {'on', 'yes', 'off', 'no'}, mfilename, 'AsInteger'));
addOptional(ip, 'AsInteger', 'off', valFcn_AsInteger);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    args = [{rgb}, {factor}, varargin];
    
    parse(ip, args{:});
catch me
    throwAsCaller(me);
end



%% Parse IP results
% Values to transform
aRgb = ip.Results.rgb;
% Factor to scale each color
dFactor = ip.Results.factor;
% Return result as integer not float?
chAsInteger = onoffstate(ip.Results.AsInteger);



%% Do your code magic here

% Calculate the lighter RGB values
lighter = (aRgb + (1 - aRgb)*dFactor);

% Turn floats into integers as requested by the user
if chAsInteger == matlab.lang.OnOffSwitchState.on
    lighter = round(lighter.*255);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
