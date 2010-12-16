clear all

% OMR example: job launcher
%--------------------------------------------------------------------------
fref{1} = '.\example\reference.tif';
fmsk{1} = '.\example\mask.tif';
dsrc = '.\example\subjects';

% Multi-image TIFF files: index of images in SRC files
Ipages{1} = 1:5;

% User supplied function to read ratings
OMR_RATINGS = @example_ratings;

% Output file name
fout = '.\example\results';

% Launch OMR job
tic
omr_job(fref, fmsk, dsrc, Ipages, fout, OMR_RATINGS);
toc
