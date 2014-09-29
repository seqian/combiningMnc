% Defaults
addpath(genpath('/opt/matlab7.5/toolbox/fmristat')); addpath(genpath('/opt/matlab12b/toolbox/emma'),'-end');

% Options
fwhm_varatio = 1;

%% Figure out columns in Excel
[~,~,xls] = xlsread('/home/wang/Documents/bin2/20140422_Database.xlsx');
for i = 1:size(xls,2)
    if strcmpi(xls{1,i},'diag2'); diagColumn = i;
    elseif strcmpi(xls{1,i},'ef_2'); efColumn = i;
    elseif strcmpi(xls{1,i},'sd_2'); sdColumn = i;
    elseif strcmpi(xls{1,i},'dataset'); datasetColumn = i;
    elseif strcmpi(xls{1,i},'qc'); qcColumn = i;
    end
end

%% Generate a dictionary of subjects with paths
input_ef = {}; input_sd = {};
for i = 2:size(xls,1)
    diag = xls{i,diagColumn}; % Double
    ef = xls{i,efColumn}; % String
    sd = xls{i,sdColumn}; % String
    
    % Conditions
    if diag ~= desiredDiag; continue; end
    if ~isnan(xls{i,qcColumn}); continue; end
    if ~strcmpi(xls{i,datasetColumn},desiredDataset); continue; end
    
    input_ef = [input_ef [inputFolder '/' ef]];
    input_sd = [input_sd [inputFolder '/' sd]];
end
    
input_ef = input_ef(:); % To make it work
input_sd = input_sd(:); % To make it work
contrast = 1;
which_stats='_t _ef _sd';
display(output_file_base{1});
X = ones(length(input_ef),1);

%% Getting the local computer's name
[gb_psom_tmp_var,gb_psom_localhost] = system('uname -n');
gb_psom_localhost = deblank(gb_psom_localhost);
display(gb_psom_localhost);

my_multistat(input_ef,input_sd,[],[],X,contrast,output_file_base,which_stats,fwhm_varatio);
