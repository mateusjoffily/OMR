function ratings = example_ratings(data)

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

Nsub = size(data, 1);   % Total number of subjects (TIFF images)
Npages = size(data, 2); % Total number of pages

Nratings_per_page = 4;  % Total number of ratings in a same scale per page 

% Initalize scales
ple = struct('value', {}, 'status', {});
unp = struct('value', {}, 'status', {});
sen = struct('value', {}, 'status', {});
int = struct('value', {}, 'status', {});
sle = struct('value', {}, 'status', {});

for n = 1:Nsub    % Loop over subjects        
    for p = 1:Npages    % Loop over pages

        idx = Nratings_per_page * (p-1);
        
        % Pleasant
        ple(n, idx+1) = omr_get_rating(data(n,p), 101:105);
        ple(n, idx+2) = omr_get_rating(data(n,p), 406:410);
        ple(n, idx+3) = omr_get_rating(data(n,p), 1001:1005);
        ple(n, idx+4) = omr_get_rating(data(n,p), 706:710);

        % Unplesant
        unp(n, idx+1) = omr_get_rating(data(n,p), 301:305);
        unp(n, idx+2) = omr_get_rating(data(n,p), 106:110);
        unp(n, idx+3) = omr_get_rating(data(n,p), 901:905);
        unp(n, idx+4) = omr_get_rating(data(n,p), 1006:1010);

        % Sensorial
        sen(n, idx+1) = omr_get_rating(data(n,p), 201:205);
        sen(n, idx+2) = omr_get_rating(data(n,p), 506:510);
        sen(n, idx+3) = omr_get_rating(data(n,p), 601:605);
        sen(n, idx+4) = omr_get_rating(data(n,p), 806:810);

        % Intellectual
        int(n, idx+1) = omr_get_rating(data(n,p), 401:405);
        int(n, idx+2) = omr_get_rating(data(n,p), 206:210);
        int(n, idx+3) = omr_get_rating(data(n,p), 801:805);
        int(n, idx+4) = omr_get_rating(data(n,p), 606:610);

        % Sleep
        sle(n, idx+1) = omr_get_rating(data(n,p), 501:505);
        sle(n, idx+2) = omr_get_rating(data(n,p), 306:310);
        sle(n, idx+3) = omr_get_rating(data(n,p), 701:705);
        sle(n, idx+4) = omr_get_rating(data(n,p), 906:910);
    end
end

% Remove ratings box 40
ple(:,40) = [];
unp(:,40) = [];
sen(:,40) = [];
int(:,40) = [];
sle(:,40) = [];

% Save results in ratings structure array
ratings = {ple unp sen int sle}; 