function raw = oxcartRawDataImport(fileName)

if not(exist('fileName','var'))
    [file path] = uigetfile('*.dat');
    fileName = [path file];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["detx", "dety", "tsumx", "tsumy"];
opts.VariableTypes = ["double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% Import the data
raw = readtable(fileName, opts);


%% Clear temporary variables
clear opts