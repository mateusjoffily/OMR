function A = omr_matrix(P2)

% Last modified 16-11-2010 Mateus Joffily

% Copyright (C) 2002, 2007, 2010 Mateus Joffily, mateusjoffily@gmail.com.

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%%

% Define affine transformation matrix: A
%   P(1)  - x translation
%   P(2)  - y translation
%   P(3)  - z translation
P(1:3) = [P2(1) P2(2) 0];
%   P(4)  - x rotation about - {pitch} (radians)
%   P(5)  - y rotation about - {roll}  (radians)
%   P(6)  - z rotation about - {yaw}   (radians)
 P(4:6) = [0 0 P2(3)];
%   P(7)  - x scaling
%   P(8)  - y scaling
%   P(9)  - z scaling
P(7:9) = [P2(4) P2(5) 1];
%   P(10) - x affine
%   P(11) - y affine
%   P(12) - z affine
% P(10:12) = [P2(6) 0 0];
P(10:12) = [0 0 0];
A = spm_matrix(P);        % 3D transformation matrix
A = A([1 2 4],[1 2 4]);   % reduce transformation matrix to 2D

function [A] = spm_matrix(P, order)
% returns an affine transformation matrix
% FORMAT [A] = spm_matrix(P, order)
% P(1)  - x translation
% P(2)  - y translation
% P(3)  - z translation
% P(4)  - x rotation about - {pitch} (radians)
% P(5)  - y rotation about - {roll}  (radians)
% P(6)  - z rotation about - {yaw}   (radians)
% P(7)  - x scaling
% P(8)  - y scaling
% P(9)  - z scaling
% P(10) - x affine
% P(11) - y affine
% P(12) - z affine
%
% order (optional) application order of transformations.
%
% A     - affine transformation matrix
%___________________________________________________________________________
%
% spm_matrix returns a matrix defining an orthogonal linear (translation,
% rotation, scaling or affine) transformation given a vector of
% parameters (P).  By default, the transformations are applied in the
% following order (i.e., the opposite to which they are specified):
%
% 1) shear
% 2) scale (zoom)
% 3) rotation - yaw, roll & pitch
% 4) translation
%
% This order can be changed by calling spm_matrix with a string as a
% second argument. This string may contain any valid MATLAB expression
% that returns a 4x4 matrix after evaluation. The special characters 'S',
% 'Z', 'R', 'T' can be used to reference the transformations 1)-4)
% above. The default order is 'T*R*Z*S', as described above.
%
% SPM uses a PRE-multiplication format i.e. Y = A*X where X and Y are 4 x n
% matrices of n coordinates.
%
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_matrix.m 1149 2008-02-14 14:29:04Z volkmar $


% pad P with 'null' parameters
%---------------------------------------------------------------------------
q  = [0 0 0 0 0 0 1 1 1 0 0 0];
P  = [P q((length(P) + 1):12)];

% default multiplication order if not specified
%---------------------------------------------------------------------------
if nargin < 2
    order = 'T*R*Z*S';
end;

T  =   [1   0   0   P(1);
        0   1   0   P(2);
        0   0   1   P(3);
        0   0   0   1];

R1  =  [1    0      0          0;
        0    cos(P(4))  sin(P(4))  0;
        0   -sin(P(4))  cos(P(4))  0;
        0    0      0          1];

R2  =  [cos(P(5))  0    sin(P(5))  0;
        0          1    0      0;
       -sin(P(5))  0    cos(P(5))  0;
        0          0    0          1];

R3  =  [cos(P(6))   sin(P(6))   0  0;
       -sin(P(6))   cos(P(6))   0  0;
        0           0           1  0;
        0           0       0  1];

R   = R1*R2*R3;

Z   =  [P(7)    0       0       0;
        0       P(8)    0       0;
        0       0       P(9)    0;
        0       0       0       1];

S   =  [1       P(10)   P(11)   0;
        0       1   P(12)   0;
        0       0       1   0;
        0       0       0       1];

A = eval(sprintf('%s;', order));
if ~isnumeric(A) || ndims(A) ~= 2 || any(size(A) ~= 4)
    error('Order expression ''%s'' did not return a valid 4x4 matrix.', ...
          order);
end;
