function c = color(varargin)
%% COLOR Create a color RGB triplet from a human readable name
%
% C = COLOR(NAME)
%
% C = COLOR(NAME_1, NAME_2, ...)
%
% Inputs:
%
%   NAME                Name of the color to convert into RGB. Possible values
%                       are
%                         * black
%                         * blue
%                         * cyan
%                         * darkgray
%                         * darkgrey
%                         * fuelyellow
%                         * gray
%                         * grey
%                         * green
%                         * lochmara
%                         * lightgray
%                         * lightgrey
%                         * magenta
%                         * orange
%                         * pictonblue
%                         * red
%                         * sushi
%                         * tamarillo
%                         * violet
%                         * white
%                         * yellow
%
% Outputs:
%
%   C                   Nx3 array of RGB triplets.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-03-29
% Changelog:
%   2021-03-29
%       * Add darker and lighter gray colors
%       * Add alias `grey` for `gray`
%       * Add support for actions such as `add`ing or `remove`ing a color or
%       `list`ing all colors
%   2021-02-26
%       * Initial release



%% Parse arguments

% COLOR(NAME)
% COLOR(NAME, ...)
narginchk(1, Inf);
% COLOR(___)
% C = COLOR(___)
nargoutchk(0, 1);



%% Do your code magic here

persistent colors

if isempty(colors)
  % Registered default color names
  colors = [ ...
    {'Black'},        {[0.000, 0.000, 0.000]} ; ...
    {'Blue'},         {[0.000, 0.000, 1.000]} ; ...
    {'Cyan'},         {[0.000, 1.000, 1.000]} ; ...
    {'DarkGray'},     {[0.333, 0.333, 0.333]} ; ...
    {'DarkGrey'},     {[0.333, 0.333, 0.333]} ; ...
    {'FuelYellow'},   {[0.929, 0.694, 0.125]} ; ...
    {'Gray'},         {[0.500, 0.500, 0.500]} ; ...
    {'Grey'},         {[0.500, 0.500, 0.500]} ; ...
    {'Green'},        {[0.000, 1.000, 0.000]} ; ...
    {'LightGray'},    {[0.666, 0.666, 0.666]} ; ...
    {'LightGrey'},    {[0.666, 0.666, 0.666]} ; ...
    {'Lochmara'},     {[0.000, 0.447, 0.741]} ; ...
    {'Magenta'},      {[1.000, 0.000, 1.000]} ; ...
    {'Orange'},       {[0.850, 0.325, 0.098]} ; ...
    {'PictonBlue'},   {[0.301, 0.745, 0.933]} ; ...
    {'Red'},          {[1.000, 0.000, 0.000]} ; ...
    {'Sushi'},        {[0.456, 0.674, 0.188]} ; ...
    {'Tamarillo'},    {[0.635, 0.078, 0.184]} ; ...
    {'Violet'},       {[0.494, 0.184, 0.556]} ; ...
    {'White'},        {[1.000, 1.000, 1.000]} ; ...
    {'Yellow'},       {[1.000, 1.000, 0.000]} ; ...
  ];

end


% Decide what to do
switch lower(varargin{1})
  case 'add'
    narginchk(3, 3);
    cname = varargin{2};
    crgb = varargin{3};
    try
      newcs = vertcat(colors, {lower(cname), crgb});
      [~, idx] = sort(lower(newcs(:,1)));
      colors = newcs(idx,:);
    catch me
      warning(me.identifier, '%s', me.message);
    end
    
    
  case 'remove'
    narginchk(2, 2);
    cname = varargin{2};
    
    % Remove matching color(s)
    try
      colors(strcmpi(colors(:,1), cname),:) = [];
    catch me
      warning(me.identifier, '%s', me.message);
    end
    
  case 'list'
    spacer = 2 + max(cell2mat(cellfun(@numel, colors(:,1), 'UniformOutput', false)));
    fmt = ['  %-', num2str(spacer) , 's %4d %4d %4d\n'];
    for iname = 1:size(colors, 1)
      cRGB = round(255 * colors{iname,2});
      fprintf(fmt, colors{iname,1}, cRGB(1), cRGB(2), cRGB(3));
    end
    
  otherwise
    % Extract RGB triplet for each color name match in `varargin`
    try
      matches = cellfun(@(m) colors(m,2), cellfun(@(n) strcmpi(n, colors(:,1)), varargin, 'UniformOutput', false), 'UniformOutput', false);

    catch me
      throwAsCaller(me);

    end

    % Some colors were not found?
    if any(cellfun(@isempty, matches))
      error('invalid color name `%s`', varargin{find(cellfun(@isempty, matches), 1)});

    end

    % Turn into an Nx3 array
    matches = cellfun(@cell2mat, matches, 'UniformOutput', false);
    c = vertcat(matches{:});
    
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header