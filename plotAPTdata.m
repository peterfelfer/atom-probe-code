function plotAPTdata(pos,sample,color,size)
%plots APT data in the usual style. Sample allows the specificaiton of a
%subset to plot. If sample <1, it is a fraction of the overall number of
%atoms, if >1, it is a fixed number. 'color' is provided as RGB vector
%'crop' crops data before plotting rather than just setting axes limits.
%Makes for more responsive plots and smaller fiels when saving a figure

varName = inputname(1);
f = figure('Name',varName);



if ~exist('size','var')
    size = 36;
end


if iscell(color)
    color = pickFromColorscheme(color);
end
if isstruct(color) %rng struct can be parsed for coloring
    %search if variable name exists in rng struct 
    varName = varName(1:end-4);
    rng = color;
    numRng = length(rng);
    for r = 1:numRng
        if strcmp(varName,rng(r).rangeName(~isspace(rng(r).rangeName)))
            color = rng(r).color;
        end
    end
    if isstruct(color)
        warning('no corresponding plot color found in range variable. defaulting to grey');
        color = [.5 .5 .5];
    end
    
end
if ~exist('color','var')
    color = [.5 .5 .5];
end


if size > 35
    edgeColor = [0 0 0];
    fillColor = color;
    markerStyle = 'o';
else
    edgeColor = color;
    fillColor = color;
    markerStyle = '.';
end


numAtoms = length(pos(:,1));

% calculating sample indices
if sample>numAtoms
    error('number of sampled atoms greater than length of the dataset');
end
if sample<=1
    sample = round(numAtoms * sample);
end
sample = randsample(numAtoms,sample);


scatter3(pos(sample,1),pos(sample,2),pos(sample,3),markerStyle,'MarkerEdgeColor',edgeColor,...
        'MarkerFaceColor',fillColor,'SizeData',size); 
axis equal; 
rotate3d on;

set(gca,'Box','On');
set(gca,'BoxStyle','full');
set(gca,'XColor',[1 0 0]);
set(gca,'YColor',[0 1 0]);
set(gca,'ZColor',[0 0 1]);

set(gca,'ZDir','reverse');

set(gcf,'Color',[1 1 1]);