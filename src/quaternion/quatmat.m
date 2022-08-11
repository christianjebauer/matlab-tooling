function [Q, Qc] = quatmat(q)%#codegen
%% QUATMAT Calculate quaternion matrix and conjugate quaternion matrix
%
% Inputs:
%
%   Q                   4xN quaternion(s) with scalar element in first row.
%
% Outputs:
%
%   Q                   4x4xN quaternion matrix 
%
%   QC                  4x4xN conjugate quaternion matrix



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-08-11
% Changelog:
%   2022-08-11
%     * Fix calculation of eye matrix of quaternion scalars
%     * Update function to be fully codegen compatible
%   2022-02-08
%     * Use new syntax of `quatvalid` also returning number of quaternions N
%   2021-11-12
%     * Correct signs in quaternion matrix and conjugate quaternion matrix
%   2021-10-21
%     * Revert previous "fix"
%   2021-10-07
%     * Fix sign of skew-symmetric part in quaternion matrix and its conjugate
%     quaternion matrix counterpart
%   2020-11-24
%     * Updates to support code generation
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-10
%     * Initial release



%% Parse arguments

% QUATMAT(Q);
narginchk(1, 1);

% QUATMAT(Q)
% QM = QUATMAT(Q);
% [QM, QCM] = QUATMAT(Q);
nargoutchk(0, 2);

% Parse quaternions
[qv, ~] = quatvalid(q, 'quatmat');



%% Algorithm

% Skew symmetric matrices of quaternion vector part
qskm = vec2skew(qv([2,3,4],:));

% Shift number of quaternions into third dimensions
qv = permute(qv, [1, 3, 2]);

% Split scalar and vector part from quaternions
qsca = qv(1,:,:);
qvec = qv([2,3,4],:,:);

% Matrix of scalar quaternion entries on main diagonal
qscaeye = bsxfun(@mtimes, eye(3, 3), qsca);

% Quaternion matrix
Q = cat( ...
    1 ...
  , cat( ...
      2 ...
    , qsca ...
    , permute(-qvec, [2, 1, 3]) ...
  ) ...
  , cat( ...
      2 ...
    , qvec ...
    , qscaeye + qskm ...
  ) ...
);

% Conjugate quaternion matrix, conditionally
if nargout > 1
  Qc = cat( ...
      1 ...
    , cat( ...
        2 ...
      , qsca ...
      , permute(-qvec, [2, 1, 3]) ...
    ) ...
    , cat( ...
        2 ...
      , qvec ...
      , qscaeye - qskm ...
    ) ...
  );
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
