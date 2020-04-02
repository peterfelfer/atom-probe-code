function p = plotAPTdata(pos,species,sample,colorScheme,size,plotAxis)
%plots APT data in the usual style. Sample allows the specificaiton of a
%subset to plot. If sample <1, it is a fraction of the overall number of
%atoms, if >1, it is a fixed number. 'color' is provided as RGB vector
%'crop' crops data before plotting rather than just setting axes limits.
%Makes for more responsive plots and smaller fiels when saving a figure. If
%an axis is parsed, it will be plotted in that axis.


%sample needs to be scalar or vector with same length as species

%if multiple species are given, array of axes is plotted with synced axis
%movement


if exist('plotAxis','var')
    ax = plotAxis;
    hold on 
else
    f = figure('Name',species);
    ax = axes();
end

% default size is 36
if ~exist('size','var')
    size = 36;
end

% loop through species and plot each one
color = colorScheme.color(colorScheme.ion == species,:);


% calculating sample indices
if sample>numAtoms
    error('number of sampled atoms greater than length of the dataset');
elseif sample<1
    sample = round(numAtoms * sample);
    sample = randsample(numAtoms,sample);
else
    sample = 1:numAtoms;
end

