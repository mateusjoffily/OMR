function ratings = example_ratings(data)
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

Nsub   = size(data, 1);   % Total number of subjects (TIFF images)
Npages = size(data, 2);   % Total number of pages

Nratings_per_page = 4;  % Total number of ratings in the same scale per page 

% Initalize scales
face1 = struct('value', {}, 'status', {});
face2 = struct('value', {}, 'status', {});
face3 = struct('value', {}, 'status', {});
face4 = struct('value', {}, 'status', {});
face5 = struct('value', {}, 'status', {});

for n = 1:Nsub    % Loop over subjects        
    for p = 1:Npages    % Loop over pages

        idx = Nratings_per_page * (p-1);
        
        % Smile
        face1(n, idx+1) = omr_get_rating(data(n,p), [ 6 16 28 40 48]);
        face1(n, idx+2) = omr_get_rating(data(n,p), [52 67 74 89 95]);
        face1(n, idx+3) = omr_get_rating(data(n,p), [ 1 15 24 35 43]);
        face1(n, idx+4) = omr_get_rating(data(n,p), [55 70 77 82 98]);

        % Frown
        face2(n, idx+1) = omr_get_rating(data(n,p), [ 8 18 30 37 50]);
        face2(n, idx+2) = omr_get_rating(data(n,p), [58 64 79 86 92]);
        face2(n, idx+3) = omr_get_rating(data(n,p), [ 5 14 23 34 42]);
        face2(n, idx+4) = omr_get_rating(data(n,p), [51 63 72 85 91]);

        % Listen
        face3(n, idx+1) = omr_get_rating(data(n,p), [ 7 17 29 36 49]);
        face3(n, idx+2) = omr_get_rating(data(n,p), [53 68 75 90 96]);
        face3(n, idx+3) = omr_get_rating(data(n,p), [ 2 11 27 31 46]);
        face3(n, idx+4) = omr_get_rating(data(n,p), [56 61 78 83 99]);

        % Thought
        face4(n, idx+1) = omr_get_rating(data(n,p), [ 9 19 25 38 44]);
        face4(n, idx+2) = omr_get_rating(data(n,p), [59 65 80 87 93]);
        face4(n, idx+3) = omr_get_rating(data(n,p), [ 4 13 22 33 41]);
        face4(n, idx+4) = omr_get_rating(data(n,p), [54 69 76 81 97]);

        % Sleep
        face5(n, idx+1) = omr_get_rating(data(n,p), [10 20 26 39 45]);
        face5(n, idx+2) = omr_get_rating(data(n,p), [60 66 73 88 94]);
        face5(n, idx+3) = omr_get_rating(data(n,p), [ 3 12 21 32 47]);
        face5(n, idx+4) = omr_get_rating(data(n,p), [57 62 71 84 100]);
    end
end

% Save results in ratings structure array
ratings = {face1 face2 face3 face4 face5}; 

end