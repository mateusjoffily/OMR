function [SRC_aligned P fval] = omr_realign(SRC, REF, XY)    
% Image registration after spatial transformation 
%  Use MATLAB's basic optimization routine, 'fminsearch' to find
%     the transformation that restores the original image shape.
%--------------------------------------------------------------------------
% adapted from Semmelow (2004) "Biosignal and Biomedical Image Processing"

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

% Estimate a good starting point to image translation
%----------------------------------------------------
[M N] = size(REF);
[x0 y0] = find(REF<=0);
[x1 y1] = find(SRC<=0);

dx = mean( [(min(x1) - min(x0)) (max(x1) - max(x0))] );
dy = mean( [(min(y1) - min(y0)) (max(y1) - max(y0))] );

px = -dx * diff(XY(1,:))/M;
py = -dy * diff(XY(2,:))/N;

% Set initial values for transformation
%----------------------------------------------------
P0 = [py px 0 1 1];  

% Find transformation to align image
%----------------------------------------------------
options = optimset('Display','iter', 'TolFun', 10^-3, 'TolX', 10^-3);
[P, fval, e] = fminsearch('omr_transform', P0, options, REF, SRC, XY);

% Realign image using optimized parameters
%----------------------------------------------------
A = omr_matrix(P);
Tform = maketform('affine', A');
SRC_aligned = omr_imtransform(SRC, Tform, XY);