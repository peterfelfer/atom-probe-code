function saxeyPlot(mc,multi)
%creates a correlative ion plot aka Saxey plot for data with the
%mass-to-charge values mc and the hit multiplicity multi. For a 2D
%diagram, only multiplicities of 2 are considered.


% automatically converts hit multiplicites if 0s are present.
if ~ isempty(multi == 0)
    multi = convertMultiplicity(multi);
    disp('zeros were removed from hit multiplicity');
end

% automatically takes the 4th colum if a pos file or epos file is parsed
if length(mc(1,:)) > 1
    mc = mc(:,4);
end


idx = multi == 2;

mcselect = mc(idx);
everySecond = logical(repmat([1; 0], length(mcselect)/2, 1));

mc1(:,1) = mcselect(everySecond);
mc1(:,2) = mcselect(~everySecond);

mc1 = sort(mc1,2);
mc1 = fliplr(mc1);

%query settings for plot
prompt = {'maximum m/c','bin width'};
dlg_title = 'bin width';
def = {'200','0.2'};

maxMC = inputdlg(prompt,dlg_title,1,def);

if isempty(maxMC)
    return;
end


binWidth = str2num(maxMC{2});
maxMC = str2num(maxMC{1});
numBins = round(maxMC/binWidth);

isIn = ~((mc1(:,1)>maxMC) | (mc1(:,2)>maxMC));

mc1 = mc1(isIn,:);



figure;
scatter(mc1(:,1),mc1(:,2),'.k');

%[his, centers] = hist3([mc1(:,1) mc1(:,2)],[numBins numBins]);
%surf(centers{1},centers{2},his);
%shading interp;


%set(gca,'ZScale','Log');
end

