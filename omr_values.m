function [values labels] = omr_values(mSRC, BLOBS)

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

% Calculate mean intensity within each blob
%----------------------------------------------------
labels = unique(BLOBS)';
labels(labels == 0) = [];  % exclude background
values = zeros(1, numel(labels));

for i = 1:numel(labels)
    values(i) = mean(mSRC(BLOBS==labels(i)));
end