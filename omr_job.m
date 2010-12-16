function omr_job(fref, fmsk, dsrc, Ipages, fout, OMR_RATINGS, rerate)

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

if nargin < 7
    rerate = false;
end

if ~rerate
    % Process images
    [data fsrc] = omr_main(fref, fmsk, dsrc, Ipages);

    % Save results to matlab file
    save([fout '.mat'], 'data', 'fsrc');
else
    load([fout '.mat'], 'data', 'fsrc');
end

% Get scales ratings
ratings = OMR_RATINGS(data, Ipages);

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
