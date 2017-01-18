clear all

% OMR example: job launcher
%--------------------------------------------------------------------------
fref{1}     = fullfile('.','example','reference.tif');
fmsk{1}     = fullfile('.','example','mask.tif');
dsrc        = fullfile('.','example','subjects','*.tif');

% Multi-image TIFF files: index of images in SRC files
Ipages{1}   = 1:5;

% User supplied function to analyze forms
OMR_RATINGS = @example_ratings;

% Output file name: save 'data' and 'ratings' variables
fout        = fullfile('.','example','results');

% analyze forms without pre-processing images ('data' must already exist in fout)
analyzeONLY = false;

% Launch OMR job
tic
omr_job(fref, fmsk, dsrc, Ipages, fout, OMR_RATINGS,analyzeONLY);
toc
