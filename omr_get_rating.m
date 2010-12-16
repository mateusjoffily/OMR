function rating = omr_get_rating(data, labels)

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

% Find blobs related to scale
[idx order] = ismember(data.labels, labels);

% Get blobs values
blobs_values = data.values( idx );
blobs_values = blobs_values(order(order>0));

% Select blob with value higher than 1.5x minimum
value = find( blobs_values > 1.5 * min(blobs_values) );

if isempty(value)
    % If scale is blank, set NaN 
    value = NaN;
    status = 'blank';

elseif numel(value) > 1
    % If scale was rated in more than one option, set NaN 
    value = NaN;
    status = 'ambiguous';

else    
    status = 'ok';
    
end

% Return rating
rating.value  = value;
rating.status = status;
