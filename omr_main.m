function [data,fsrc] = omr_main(fref, fmsk, ftgt, dsrc, Ipages)
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

% List of selected images in 'dsrc' directory
fimg  = dir(dsrc);
if isempty(fimg)
    disp('TIFF images not found in SRC folder.');
    return
end

imfmt = imformats;
imext = strcat('.',[imfmt.ext]);
Nimg  = length(fimg);
imgOK = false(1,Nimg);
for n = 1:Nimg
    [fpath,fname,fext] = fileparts(fimg(n).name);
    if ismember(fext,imext)
        imgOK(n) = true;
    end
end
fsrc = fimg(imgOK);             % images filename
if isdir(dsrc)
    psrc = dsrc;                % images path
else
    psrc = fileparts(dsrc);     
end

% Number of Reference images 
Nref  = numel(fref);

% Preallocate memory for cell arrays
REF   = cell(1,Nref);     % Reference images
MSK   = cell(1,Nref);     % Mask images
TGT   = cell(1,Nref);     % Target images
BLOBS = cell(1,Nref);     % Mask images blobs
XY    = cell(1,Nref);     % World coordinates of REF images

% Pages to be processed in TIFF files
IpagesALL.num = [];
IpagesALL.idx = [];

% Load Reference and Mask images
for i = 1:numel(fref)   % loop over reference images
    
    % Create single variable to hold pages information
    IpagesALL.num = [IpagesALL.num Ipages{i}];
    IpagesALL.idx = [IpagesALL.idx repmat(i,1,numel(Ipages{i}))];
    
    % Read images
    [REF{i},map]  = imread(fref{i});                 % reference image
    REF{i}        = omr_adjust_image(REF{i}, map);   % convert to intensity image and scale
    [MSK{i},map]  = imread(fmsk{i});                 % mask image
    MSK{i}        = omr_adjust_image(MSK{i}, map);   % convert to intensity image and scale
    [TGT{i},map]  = imread(ftgt{i});                 % realigment image
    TGT{i}        = omr_adjust_image(TGT{i}, map);   % convert to intensity image and scale

    % Resize images, if they are too large
    if numel(REF{i}) > 1024*800
        gain   = 600/size(REF{i},1);
        REF{i} = imresize(REF{i}, gain);
    end
    MSK{i} = imresize(MSK{i}, size(REF{i}));
    TGT{i} = imresize(TGT{i}, size(REF{i}));

    % Set spatial location of the REF image in the world: 
    %  - center at (0,0)
    %  - scale to -1:1
    [M,N]      = size(REF{i});
    XY{i}(1,:) = [0 M] - M/2;
    XY{i}(2,:) = [0 N] - N/2;
    XY{i}      = XY{i} / max(XY{i}(:,2));

    % Make binary mask
    MSK{i}(MSK{i}<0.5)  = 0;
    MSK{i}(MSK{i}>=0.5) = 1;

    % Make binary realigment image
    TGT{i}(TGT{i}<0.5)  = 0;
    TGT{i}(TGT{i}>=0.5) = 1;

    % Locate blobs in mask and label them in a meaningful way
    BLOBS{i} = omr_mask_labels(MSK{i});
end

% Sort pages
[IpagesALL.num,iy] = sort(IpagesALL.num);
IpagesALL.idx      = IpagesALL.idx(iy);

Nscr   = numel(fsrc);           % Total number of Multi-image TIFF files 
Npages = numel(IpagesALL.num);  % Total number of pages in TIFF files

% Initialize output data structure
data = struct('values', {}, 'labels', {}, 'fval', {});

for n = 1:Nscr    % Loop over Multi-image TIFF files    
    % Display some feedback information to the user
    disp(['reading file: ' fsrc(n).name ' (' num2str(n) '/' num2str(Nscr) ', ' num2str(Npages) ' pages)']);
    
    for p = 1:Npages    % Loop over pages
        % Read single image from Multi-image TIFF file
        [SRC,map]       = imread(fullfile(psrc, fsrc(n).name), IpagesALL.num(p));

        % Convert image to intensity
        SRC = omr_adjust_image(SRC, map);
        
        % Resize SRC to the size of REF
        SRC = imresize(SRC, size(REF{IpagesALL.idx(p)}));
        
        % Realign SRC to REF image
        [aSRC,P,fval]   = omr_realign(SRC, REF{IpagesALL.idx(p)}, TGT{IpagesALL.idx(p)}, XY{IpagesALL.idx(p)}, p);
        
        % mask source image
        mSRC            = ~MSK{IpagesALL.idx(p)} .* 1-Scale(aSRC);
        
        % get source image intensity at mask locations
        [values,labels] = omr_values(mSRC, BLOBS{IpagesALL.idx(p)});
        
        % Record output data
        data(n,p).values = values;
        data(n,p).labels = labels;
        data(n,p).fval   = fval;
        
        % Display some feedback information
        disp([fsrc(n).name ': concluded page ' num2str(p) '/' num2str(Npages) ', fval = ' num2str(fval)]);
    end
    
end

% Display final images
i = IpagesALL.idx(p);

figure
ax = subplot(1,3,1); imagesc(REF{i}), axis image
title('Reference');
ax(2) = subplot(1,3,2); imagesc(SRC), axis image
title('Source Native');
ax(3) = subplot(1,3,3); imagesc(aSRC), axis image
title('Source Realigned');
linkaxes(ax);

figure
ax = subplot(1,3,1), imagesc(MSK{i} .* REF{i}); axis image
title('Reference Masked');
ax(2) = subplot(1,3,2); imagesc(MSK{i} .* SRC); axis image
title('Source Masked');
ax(3) = subplot(1,3,3); imagesc(MSK{i} .* aSRC); axis image
title('Source Realigned Masked');
linkaxes(ax);

figure
ax = subplot(1,2,1); imagesc(REF{i}); axis image
title('Reference');
ax(2) = subplot(1,2,2); imagesc(MSK{i}); axis image
title('Mask');
linkaxes(ax);

figure
ax = subplot(1,2,1); imagesc(~MSK{i} .* 1-Scale(SRC)); axis image
title('Negative Source Masked');
ax(2) = subplot(1,2,2); imagesc(~MSK{i} .* 1-Scale(aSRC)); axis image
title('Negative Source Realigned Masked');
linkaxes(ax);

end

function output = Scale(input)
% output = Scale(input)
% Perform an affine scaling to put data in range [0-1].
%
% Adapted from Psychtoolbox-3 (http://psychtoolbox.org/)

minval = min(input(:));
maxval = max(input(:));
output = (input - minval) ./ (maxval-minval);

end