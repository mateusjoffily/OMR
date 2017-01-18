function BLOBS = omr_mask_labels(MSK, dispOK)
%%
% Copyright Universita di Trento, Italy, and Centre National de la 
% Recherche Scientifique, France : Mateus Joffily, 2007 and 2017.
%
% mateusjoffily@gmail.com

% This software is a computer program whose purpose is to perform optical 
% mark recognition (OMR).

% This software is governed by the CeCILL  license under French law and
% abiding by the rules of distribution of free software.  You can  use, 
% modify and/ or redistribute the software under the terms of the CeCILL
% license as circulated by CEA, CNRS and INRIA at the following URL
% "http://www.cecill.info". 
%
% As a counterpart to the access to the source code and  rights to copy,
% modify and redistribute granted by the license, users are provided only
% with a limited warranty  and the software's author,  the holder of the
% economic rights,  and the successive licensors  have only  limited
% liability. 
%
% In this respect, the user's attention is drawn to the risks associated
% with loading,  using,  modifying and/or developing or reproducing the
% software by the user in light of its specific status of free software,
% that may mean  that it is complicated to manipulate,  and  that  also
% therefore means  that it is reserved for developers  and  experienced
% professionals having in-depth computer knowledge. Users are therefore
% encouraged to load and test the software's suitability as regards their
% requirements in conditions enabling the security of their systems and/or 
% data to be ensured and,  more generally, to use and operate it in the 
% same conditions as regards security.
%
% The fact that you are presently reading this means that you have had
% knowledge of the CeCILL license and that you accept its terms.%%
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

end