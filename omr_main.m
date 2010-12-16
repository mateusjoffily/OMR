function [data fsrc] = omr_main(fref, fmsk, dsrc, Ipages)

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

% Select TIFF files in 'dsrc' directory
fsrc = dir(fullfile(dsrc, '*.tif'));

% Number of Reference images 
Nref = numel(fref);

% Preallocate memory for cell arrays
REF = cell(1,Nref);     % Reference images
MSK = cell(1,Nref);     % Mask images
BLOBS = cell(1,Nref);   % Mask images blobs
XY = cell(1,Nref);      % World coordinates of REF images

% Pages to be processed in TIFF files
IpagesALL.num = [];
IpagesALL.idx = [];

% Load Reference and Mask images
for i = 1:numel(fref)   % loop over reference images
    
    % Create single variable to hold pages information
    IpagesALL.num = [IpagesALL.num Ipages{i}];
    IpagesALL.idx = [IpagesALL.idx repmat(i,1,numel(Ipages{i}))];
    
    % Read images
    [REF{i} map] = imread(fref{i});           % reference image
    REF{i} = omr_adjust_image(REF{i}, map);   % convert to intensity image and scale
    [MSK{i} map] = imread(fmsk{i});           % mask image
    MSK{i} = omr_adjust_image(MSK{i}, map);   % convert to intensity image and scale

    % Resize images, if they are too large
    if numel(REF{i}) > 1024*800
        gain = 600/size(REF{i},1);
        REF{i} = imresize(REF{i}, gain);
    end
    MSK{i} = imresize(MSK{i}, size(REF{i}));

    % Set spatial location of the REF image in the world: 
    %  - center at (0,0)
    %  - scale to -1:1
    [M N] = size(REF{i});
    XY{i}(1,:) = [0 M] - M/2;
    XY{i}(2,:) = [0 N] - N/2;
    XY{i} = XY{i} / max(XY{i}(:,2));

    % Make binary mask
    MSK{i}(MSK{i}<0.5)  = 0;
    MSK{i}(MSK{i}>=0.5) = 1;

    % Locate blobs in mask and label them in a meaningful way
    BLOBS{i} = omr_mask_labels(MSK{i});
end

% Sort pages
[IpagesALL.num iy] = sort(IpagesALL.num);
IpagesALL.idx = IpagesALL.idx(iy);

Nscr = numel(fsrc);             % Total number of Multi-image TIFF files 
Npages = numel(IpagesALL.num);  % Total number of pages in TIFF files

% Initialize output data structure
data = struct('values', {}, 'labels', {}, 'fval', {});

for n = 1:Nscr    % Loop over Multi-image TIFF files    
    % Display some feedback information to the user
    disp(['reading file: ' fsrc(n).name ' (' num2str(Npages) ' pages)']);
    
    for p = 1:Npages    % Loop over pages
        tic

        % Read single image from Multi-image TIFF file
        [SRC map] = imread(fullfile(dsrc, fsrc(n).name), IpagesALL.num(p));
        
        % Convert image to intensity
        SRC = omr_adjust_image(SRC, map);
        
        % Resize source image to the same size of reference image
        SRC = imresize(SRC, size(REF{IpagesALL.idx(p)}));
        
        % Realign source to reference image
        [aSRC P fval] = omr_realign(SRC, REF{IpagesALL.idx(p)}, XY{IpagesALL.idx(p)});
        
        % mask source image
        mSRC = ~MSK{IpagesALL.idx(p)} .* 1-Scale(aSRC);
        
        % get source image intensity at mask locations
        [values labels] = omr_values(mSRC, BLOBS{IpagesALL.idx(p)});
        
        % Record output data
        data(n,p).values = values;
        data(n,p).labels = labels;
        data(n,p).fval = fval;
        
        % Display some feedback information to the user
        disp([fsrc(n).name ': concluded page ' num2str(p) '/' num2str(Npages) ', fval = ' num2str(fval)]);
        
        toc
    end
    
end


% % Display final images
% figure
% subplot(1,3,1), imshow(REF{1}), axis image
% subplot(1,3,2), imshow(SRC), axis image
% subplot(1,3,3), imshow(aSRC), axis image
% figure
% subplot(1,2,1), imshow(MSK .* REF), axis image
% subplot(1,2,2), imshow(MSK .* aSRC), axis image
% figure
% subplot(1,2,1), imshow(MSK .* SRC), axis image
% subplot(1,2,2), imshow(MSK .* aSRC), axis image
% figure
% subplot(1,2,1), imshow(~MSK .* 1-Scale(SRC)), axis image
% subplot(1,2,2), imshow(~MSK .* 1-Scale(aSRC)), axis image