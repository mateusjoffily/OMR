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
        face1(n, idx+1) = omr_get_rating(data(n,p), 101:105);
        face1(n, idx+2) = omr_get_rating(data(n,p), 406:410);
        face1(n, idx+3) = omr_get_rating(data(n,p), 1001:1005);
        face1(n, idx+4) = omr_get_rating(data(n,p), 706:710);

        % Frown
        face2(n, idx+1) = omr_get_rating(data(n,p), 301:305);
        face2(n, idx+2) = omr_get_rating(data(n,p), 106:110);
        face2(n, idx+3) = omr_get_rating(data(n,p), 901:905);
        face2(n, idx+4) = omr_get_rating(data(n,p), 1006:1010);

        % Listen
        face3(n, idx+1) = omr_get_rating(data(n,p), 201:205);
        face3(n, idx+2) = omr_get_rating(data(n,p), 506:510);
        face3(n, idx+3) = omr_get_rating(data(n,p), 601:605);
        face3(n, idx+4) = omr_get_rating(data(n,p), 806:810);

        % Thought
        face4(n, idx+1) = omr_get_rating(data(n,p), 401:405);
        face4(n, idx+2) = omr_get_rating(data(n,p), 206:210);
        face4(n, idx+3) = omr_get_rating(data(n,p), 801:805);
        face4(n, idx+4) = omr_get_rating(data(n,p), 606:610);

        % Sleep
        face5(n, idx+1) = omr_get_rating(data(n,p), 501:505);
        face5(n, idx+2) = omr_get_rating(data(n,p), 306:310);
        face5(n, idx+3) = omr_get_rating(data(n,p), 701:705);
        face5(n, idx+4) = omr_get_rating(data(n,p), 906:910);
    end
end

% Save results in ratings structure array
ratings = {face1 face2 face3 face4 face5}; 

end