function BLOBS = omr_mask_labels(MSK, dispOK)

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

% If MSK is a string, load image
if ischar(MSK)
    [MSK map] = imread(MSK);            % mask image
    MSK = omr_adjust_image(MSK, map);   % convert to intensity image and scale
end

if nargin < 2
    % Display BLOBS and their labels
    dispOK = false;
end

max_blobs_row = 100;    % maximum number of blobs per row in the image

% Locate blobs in mask and label them
[L, N] = bwlabel(~MSK);   % N = number of blobs found

% Calculate blob's diameter and center of gravity
siz = zeros(1,N);
cog = zeros(2,N);
for k = 1:N
    [i j] = find(L == k);
    cog(:,k) = mean([i j])';
    siz(k) = ceil( 2 * sqrt( numel(i)/pi ) );
end

% Re-label blobs in a meaningful way
labels = zeros(1,N);
[x ix] = sort(cog(1,:));  % sort CoG along columns
line_breaks = [0 find(diff([x Inf]) > mean(siz))];
for i = 1:numel(line_breaks)-1  % loop over rows
    % index of blobs in the same row
    idx = ix(line_breaks(i)+1:line_breaks(i+1));
    % sort in row blobs along columns
    [y iy] = sort(cog(2, idx));
    % create labels: row * max_blobs_row + column
    labels(idx(iy)) = i * max_blobs_row + (1:numel(y));
end

% Create blobs labelled matrix (same size as MSK)
BLOBS = zeros(size(L));
for i = 1:N
    BLOBS(L==i) = labels(i);
end

if dispOK
    imshow(BLOBS);
    for i = 1:N
        t = text(cog(2,i), cog(1,i), num2str(labels(i)));
        set(t, 'Color', 'r', 'FontWeight', 'bold');
    end
end

