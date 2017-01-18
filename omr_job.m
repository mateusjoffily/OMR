function omr_job(fref, fmsk, dsrc, Ipages, fout, OMR_RATINGS, analyzeONLY)
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

if exist('OCTAVE_VERSION', 'builtin') ~= 0
    try 
        pkg load image
    catch
        error('image toolbox needs to be installed.');
    end
end

if nargin < 7
    analyzeONLY = false;
end

if analyzeONLY
    % Use pre-processed data
    load([fout '.mat'], 'data', 'fsrc');
else
    % Process images
    [data,fsrc] = omr_main(fref, fmsk, dsrc, Ipages);

    % Save results to matlab file
    save([fout '.mat'], 'data', 'fsrc');
end

% Get scales ratings
ratings = OMR_RATINGS(data);

% Save results to matlab file
save([fout '.mat'], 'ratings', '-APPEND');

% Save results to text file
fid = fopen([fout '.txt'], 'w');
for i = 1:size(ratings{1},1)
    fprintf(fid, '%s\t', fsrc(i).name);
    for j = 1:size(ratings{1},1)
        fprintf(fid, '%d\t', [ratings{j}(i,:).value]');
    end
    fprintf(fid, '\n');
end
fclose(fid);

end
