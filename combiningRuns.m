[~,~,xls] = xlsread('/home/wang/Documents/bin2/20140422_Database.xlsx');

% Defaults
addpath(genpath('/opt/matlab7.5/toolbox/fmristat')); addpath(genpath('/opt/matlab12b/toolbox/emma'),'-end');
if exist([inputFolder '/data2']); rmdir([inputFolder '/data2']); end
mkdir(inputFolder,'data2');

for i = 1:size(xls,2)
	switch lower(xls{1,i})
		case 'diag2'; diagColumn = i;
		case 'ef'; efColumn = i;
		case 'rid'; ridColumn = i;
		case 'session'; sessionColumn = i;
		case 'dataset'; datasetColumn = i;
		case 'qc'; qcColumn = i;
	end
end

subjectsList = containers.Map('KeyType','double','ValueType','any');
for i = 2:size(xls,1)
    rid = xls{i,ridColumn};
    % Conditions
    if ~strcmpi(xls{i,datasetColumn},desiredDataset); continue; end
    if ~isnan(xls{i,qcColumn}); continue; end % If QC Problem
    %if ~exist([inputFolder '/data/' xls{i,efColumn}],'file'); continue; end % Ignore if file doesn't exist
    if ~isKey(subjectsList, rid) % If new subject, reset cell for values
    	values = {};
    	previousDiag = xls{i,diagColumn};
    end
    if xls{i,diagColumn} ~= previousDiag; continue; end % If Diagnosis not the same as previous

    values{end+1} = xls{i,efColumn};
    subjectsList(rid) = values;
end

for i = keys(subjectsList)
    %if i{1} ~= 15; continue; end % For quality purposes check
    firstPath = subjectsList(i{1}); firstPath = firstPath{1};
    runIndex = strfind(firstPath,'run'); % Combine all runs per session per subject
    subjectIndex = strfind(firstPath,'subject');
    sessionIndex = strfind(firstPath,'_session1');
    if strcmpi(desiredDataset,'adni')
        pathsList = subjectsList(i{1}); % Cell with paths
        input_ef = pathsList; input_sd = pathsList; % If want to combine all sessions for a given subject
        % input_ef = pathsList(1); input_sd = pathsList(1); % If only want to take first relevant session for a given subject
        for j = 1:length(input_ef); input_ef{j} = [inputFolder '/data/' input_ef{j}(subjectIndex:runIndex+3) '_mag_ef.mnc']; end
        for j = 1:length(input_sd); input_sd{j} = [inputFolder '/data/' input_sd{j}(subjectIndex:runIndex+3) '_mag_sd.mnc']; end
        output_file_base{1} = [inputFolder '/data2/' firstPath(subjectIndex:sessionIndex-2) firstPath(sessionIndex(end):runIndex-1) 'multi'];
    elseif strcmpi(desiredDataset,'mcsa')
        pathsList = fMRIListDir([inputFolder '/data/' firstPath]);
        input_ef = pathsList;
        output_file_base{1} = [inputFolder '/data2/' firstPath(subjectIndex:sessionIndex-1) firstPath(sessionIndex(end):runIndex-1) 'multi'];
        for j = 1:length(input_ef); input_sd{j} = regexprep(input_ef{j},'_ef','_sd'); end
    end
    
    input_ef = input_ef(:); % To make it work
	input_sd = input_sd(:); % To make it work
    contrast = 1;
    which_stats='_t _ef _sd';
	X = ones(length(input_ef),1);
	my_multistat(input_ef,input_sd,1,[],X,contrast,output_file_base,which_stats,[]);
	c = 0;
	clear output_file_base input_ef input_sd;
end
