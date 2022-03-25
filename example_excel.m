function data_excel(fmat, fxls)

if nargin < 1
    % input MATLAB file
    [file, path] = uigetfile('*.mat');
    fmat = fullfile(path, file);
end

if nargin < 2
    % output MS Excel file
    [path, file] = fileparts(fmat);
    fxls = fullfile(path, [file '.xlsx']);
end

% Load results
res  = load(fmat, 'fsrc', 'ratings');

varNames = {'date', 'file', ...
            'Q1.1.value', 'Q1.1.status', 'Q1.2.value', 'Q1.2.status', ...
            'Q1.3.value', 'Q1.3.status', 'Q1.4.value', 'Q1.4.status', ...
            'Q1.5.value', 'Q1.5.status', 'Q2.1.value', 'Q2.1.status', ...
            'Q2.2.value', 'Q2.2.status', 'Q2.3.value', 'Q2.3.status', ...
            'Q2.4.value', 'Q2.4.status', 'Q2.5.value', 'Q2.5.status', ...
            'Q2.6.value', 'Q2.6.status', 'Q2.7.value', 'Q2.7.status', ...
            'Q2.8.value', 'Q2.8.status', 'Q2.9.value', 'Q2.9.status', ...
            'Q2.10.value','Q2.10.status','Q2.11.value','Q2.11.status', ...
            'Q2.12.value','Q2.12.status','Q2.13.value','Q2.13.status'};

varTypes = {'string', 'string',...
            'cell','string','cell','string','cell','string', ...
            'cell','string','cell','string','cell','string', ...
            'cell','string','cell','string','cell','string', ...
            'cell','string','cell','string','cell','string', ...
            'cell','string','cell','string','cell','string', ...
            'cell','string','cell','string','cell','string'};

Nsrc = length(res.fsrc);
Nvar = length(varNames);

T = table('Size',[Nsrc Nvar],'VariableTypes',varTypes, ...
    'VariableNames',varNames);

for n = 1:Nsrc                        % loop over files/subjects 
    x    = cell(1,Nvar);
    x{1} = datestr(now);
    x{2} = res.fsrc(n).name(1:end-4);

    Nscale = length(res.ratings);     % number of scales/questions
    j = 2;                            % previous excel variable index
    for i = 1:Nscale                  % loop over scales/questions
        status = {res.ratings{i}.status};
        value  = {res.ratings{i}.value};
        if strcmp(status{n}, 'blank') || strcmp(status{n}, 'multiple')
            x{j+1} = '';
            x{j+2} = 'false';         % bad recognition
        else
            x{j+1} = value(n);
            x{j+2} = 'true';          % good recognition
        end
        j = j + 2;                    % increment excel variable index
    end

    T(n,:) = x;
end

writetable(T, fxls, 'Sheet', 1, 'WriteMode', 'Append')


