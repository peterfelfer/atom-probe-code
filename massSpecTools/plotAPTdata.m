function p = plotAPTdata(pos,rngTable,species,sample,size,plotAxis)
%plots APT data in the usual style. Sample allows the specificaiton of a
%subset to plot. If sample <1, it is a fraction of the overall number of
%atoms, if >1, it is a fixed number. 'color' is provided as RGB vector
%'crop' crops data before plotting rather than just setting axes limits.
%Makes for more responsive plots and smaller fiels when saving a figure. If
%an axis is parsed, it will be plotted in that axis.


%sample needs to be scalar or vector with same length as species

if exist('plotAxis','var')
    ax = plotAxis;
    hold on 
else
    f = figure('Name',varName);
    ax = axes();
end

% default size is 36
if ~exist('size','var')
    size = 36;
end

% loop through species and plot each one
for sp = 1:length(species)
    
    if 
