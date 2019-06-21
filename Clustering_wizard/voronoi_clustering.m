% data structures:
% handles.
% pos
% xrng
% path  last used file path





function varargout = voronoi_clustering(varargin)
% VORONOI_CLUSTERING MATLAB code for voronoi_clustering.fig
%      VORONOI_CLUSTERING, by itself, creates a new VORONOI_CLUSTERING or raises the existing
%      singleton*.
%
%      H = VORONOI_CLUSTERING returns the handle to a new VORONOI_CLUSTERING or the handle to
%      the existing singleton*.
%
%      VORONOI_CLUSTERING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VORONOI_CLUSTERING.M with the given input arguments.
%
%      VORONOI_CLUSTERING('Property','Value',...) creates a new VORONOI_CLUSTERING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voronoi_clustering_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voronoi_clustering_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voronoi_clustering

% Last Modified by GUIDE v2.5 04-Jun-2013 11:54:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @voronoi_clustering_OpeningFcn, ...
    'gui_OutputFcn',  @voronoi_clustering_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before voronoi_clustering is made visible.
function voronoi_clustering_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voronoi_clustering (see VARARGIN)


addpath('resources')
addpath('pos_tools')
addpath('xml_tools')



% Choose default command line output for voronoi_clustering
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voronoi_clustering wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = voronoi_clustering_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadData_button.
function loadData_button_Callback(hObject, eventdata, handles)
% hObject    handle to loadData_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[posfile path] = uigetfile('*.pos','select pos file');

handles.posFileName = posfile;
handles.posFilePath = path;

handles.pos = readpos([path posfile]);

[xrngfile path] = uigetfile('*.xrng','select xrng file', path);

handles.xrngFileName = xrngfile;
handles.xrngFilePath = path;

handles.xrng = xml_read([path xrngfile]);









%% update the elements listbox
handles.usedElements = [];

numrng = length(handles.xrng.ranges);
k = 1;

for rng=1:numrng
    
    numions = length(handles.xrng.ranges(rng).ions);
    
    for ion = 1:numions
        
        numatoms = length(handles.xrng.ranges(rng).ions(ion).atoms);
        
        for atom = 1:numatoms
            
            handles.usedElements(k) = handles.xrng.ranges(rng).ions(ion).atoms(atom).atomicnumber; %str2num(handles.xrng.ranges(rng).ions(ion).atoms(atom).atomicnumber);
            k=k+1;
        end
        
        
    end
    
    
    
end


handles.usedElements = sort(unique(handles.usedElements));


for i=1:length(handles.usedElements)
    elementsStr{i} = sym4number(handles.usedElements(i));
end


set(handles.species_listbox,'String',elementsStr);
set(handles.species_listbox,'Max',k);


handles.decomposedPos = decomposePos(handles.pos,handles.xrng,'atomic');




constr = ['pos file: ' posfile ' and xrng file: ' xrngfile ' loaded.'];

set(handles.console_string,'String',constr);

guidata(hObject,handles);



% --- Executes on selection change in species_listbox.
function species_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to species_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns species_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from species_listbox


% --- Executes during object creation, after setting all properties.
function species_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to species_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in analysis_button.
function analysis_button_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBINS = 100;


%clusterSizes = handles.clusterSizes;
% atomic positions of atoms for cluster query

indexSelected = get(handles.species_listbox,'Value');
elementList = get(handles.species_listbox,'String');
elementList = elementList(indexSelected);


handles.clusterPos = [];
figName = [];

for el = 1:length(elementList)
    
    tmpPos = retrievePos(handles.decomposedPos,elementList{el});
    handles.clusterPos = [handles.clusterPos; tmpPos];
    figName = [figName ' ' elementList{el}];
end


%% actual Voronoi cluster analysis

figName = ['Voronoi volume analysis of ' figName];
handles.voronoiFigureHandle = figure('Name',figName);


[handles.numClustered handles.clusterCutoff handles.experimental handles.random handles.experimentalVolumes handles.randomVolumes randPos] = ...
    voronoiVolumeAnalysis(handles.clusterPos, handles.pos,true);






%% analysis of cluster sizes
% experimental
[handles.clusterIdx handles.numClusters] = identifyClusters(handles.clusterPos,handles.clusterCutoff,handles.experimentalVolumes);

% random
[handles.randomClusterIdx handles.randomNumClusters] = identifyClusters(randPos,handles.clusterCutoff,handles.randomVolumes);



handles.clusterSizes = hist(handles.clusterIdx, handles.numClusters);
handles.randomClusterSizes = hist(handles.randomClusterIdx, handles.randomNumClusters);



handles.clusterSizeFigureHandle = figure('Name',['size distribution of ' figName ' clusters']);
Nmin = analyzeClusterSizes(handles.clusterSizes, handles.randomClusterSizes);
handles.Nmin = num2str(Nmin);



%% Kolmogorov - Smirnov test:
significanceLimit = 1.92 / sqrt(length(handles.clusterPos(:,1)));

pass = (handles.numClustered/length(handles.clusterPos(:,1))) > significanceLimit;



%% creation of analysis report text file

%set(handles.console_string,'String',constr);


%set cluster definition values in dialog box

set(handles.Vthresh_string,'String',num2str(handles.clusterCutoff));
set(handles.Nmin_string,'String',handles.Nmin);


%% construct string with analysis results
results = ['openVA Voronoi clustering results /n '];
results = [results '(c) 2013 Peter Felfer, The University of Sydney \n '];

results = [results 'posfile name:      ' handles.posFileName ' \n '];
results = [results 'posfile path:      ' handles.posFilePath ' \n\n '];
results = [results 'xrngfile name:     ' handles.xrngFileName ' \n '];
results = [results 'xrngfile path:     ' handles.xrngFilePath ' \n\n '];

results = [results 'tested elements:   ' figName ' \n '];
results = [results 'cluster cutoff:    ' num2str(handles.clusterCutoff) ' nm3 \n '];
results = [results '                   ' num2str(1/handles.clusterCutoff) ' atoms/nm3 \n '];
results = [results 'cluster percentage:' num2str(handles.numClustered/length(handles.clusterPos(:,1)) * 100) '% \n '];
results = [results 'significance limit:' num2str(significanceLimit*100,3) '% \n'];
results = [results 'clustered atoms:   ' num2str(handles.numClustered) ' of ' num2str(length(handles.clusterPos)) '\n '];
results = [results 'max random cluster:' handles.Nmin ' \n '];

handles.analysisResultsString = results;

time = clock;
time = [num2str(time(4)) ':' num2str(time(5)) ':' num2str(time(6),2)];
constr = [time ': analysis finished, cluster percentage = ' num2str(handles.numClustered/length(handles.clusterPos(:,1)) * 100)];

if pass
    txt = 'detected';
else
    txt = 'statistically insignificant';
end

msgbox(['cluster percentage: ' num2str(handles.numClustered/length(handles.clusterPos(:,1)) * 100,3) '%, significance limit: ' num2str(significanceLimit *100,3) '%, non-randomness is ' txt], 'clustering significance','help');

set(handles.console_string,'String',constr);
guidata(hObject,handles);


% --- Executes on button press in exportPos_button.
function exportPos_button_Callback(hObject, eventdata, handles)
% hObject    handle to exportPos_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%exports filtered data (clustersize > nmin) and convex hulls for N > 3)
%user is prompted to choose if the convex hull is included (as obj)
%and if all atoms inside the convex hull or only the cluster atoms are
%exported.

%% creating the file of cluster atoms to be exported
Nmin = handles.Nmin;
% create the posfile for export
%keywords: max N1 (only export largest clusters) N1 - N2 (range) - N2 (up to N2)

% cluster sizes:
clusterSizes = handles.clusterSizes;
clusterIdx = handles.clusterIdx;

str = strread(Nmin,'%s');


if length(str) == 1
    
    if strcmp(str{1},'max')
        % only use largest cluster
        significantClusterIdx = find(clusterSizes == max(clusterSizes));
        
    else
        % only use Nmin
        Nmin = str2num(Nmin);
        
        significantClusterIdx = find(clusterSizes >= Nmin);
    end
    
elseif length(str) == 2
    
    if strcmp(str{1},'max')
        % use N largest clusters
        N = str2num(str{2});
        
        [sorted, idx] = sort(clusterSizes);
        significantClusterIdx = idx(1:N);
        
    else
        % use Nmax
        handles.Nmax = str2num(str{2});
        Nmax = handles.Nmax;
        
        significantClusterIdx = find(clusterSizes <= Nmax);
        
    end
    
    
elseif length(str) == 3
    
    Nmin = str2num(str{1});
    Nmax = str2num(str{3});
    
    significantClusterIdx = find((clusterSizes >= Nmin) && (clusterSizes <= Nmax));
    
    
    
end



% actually creating the atomic positions
isClustered = ismember(clusterIdx,significantClusterIdx);

identifiedClusterPos = handles.clusterPos(isClustered,:);

handles.significantClusterIdx = significantClusterIdx;





%% plotting the voronoi histograms after classification
%plotVoronoiHistograms(handles.experimentalVolumes,handles.randomVolumes,isClustered);





%% exporting only cluster atoms, convex hulls or all contained atoms
% user prompt

str = {'cluster test report','clusters: test atoms','convex hulls','clusters: all atoms','cluster locations'};
[s,v] = listdlg('PromptString','Export:',...
    'SelectionMode','multiple',...
    'ListString',str);

if ~v
    return
end

if s == 1
    % export the cluster test report
    [file path] = uiputfile({'*.txt'},'Exporting cluster report',handles.posFilePath);
    fid = fopen([path file],'w');
    if fid
        fwrite(fid,handles.analysisResultsString);
        fclose(fid);
    else
        disp('could not create file');
    end
    
end

if s == 2
    % export cluster test atoms
    handles.clusterPosFileName = savepos(identifiedClusterPos);
    
end


if s == 3
    % export convex hulls
    hullPatch = clusterHulls(handles.clusterPos, clusterIdx, significantClusterIdx);
    patch2obj(hullPatch);
end


if s == 4
    % carry out containment test and export all atoms inside the convex
    % hulls
    posOut = atomsInClusterHulls(handles.pos, handles.clusterPos, clusterIdx, significantClusterIdx);
    savepos(posOut);
    
end

    


if s == 5
    % export cluster locations to pos file (4th column is cluster size)
    
    
    
    
    
    %% calculation of cluster centers
    clusterLocation = [];
    
    for clust = 1:length(significantClusterIdx);
        
        
        tmpPos = handles.clusterPos(handles.clusterIdx == significantClusterIdx(clust),1:3);
        clusterLocation(clust,:) = [mean(tmpPos,1) length(tmpPos(:,1))];
        
    end
    
    handles.clusterLocations = clusterLocation;
    posOut = handles.clusterLocations(handles.clusterLocations(:,4)>= Nmin,:);
    
    [file path idx] = uiputfile({'*.pos';'*.obj'},'Exporting cluster locations',handles.posFilePath);
    switch idx
        case 1
            savepos(posOut,[path file]);
            
        case 2
            posVar2obj(posOut, [path file]);
    end
    
    
end


%disp('exporting')
time = clock;
time = [num2str(time(4)) ':' num2str(time(5)) ':' num2str(time(6),2)];
constr = [time ': exporting finished'];

set(handles.console_string,'String',constr);
guidata(hObject,handles);






function Vthresh_string_Callback(hObject, eventdata, handles)
% hObject    handle to Vthresh_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Vthresh_string as text
%        str2double(get(hObject,'String')) returns contents of Vthresh_string as a double


% --- Executes during object creation, after setting all properties.
function Vthresh_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vthresh_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nmin_string_Callback(hObject, eventdata, handles)
% hObject    handle to Nmin_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nmin_string as text
%        str2double(get(hObject,'String')) returns contents of Nmin_string as a double


%keywords: max (only export larget cluster) N1 - N2 (range) - N2 (up to N2)
handles.Nmin = get(hObject,'String');

%disp(handles.Nmin)
if isfield(handles,'clusterPosFileName')
    
    % overwrite the current file with new Nmin
    %disp('exporting');
    %% creating the file of cluster atoms to be exported
    Nmin = handles.Nmin;
    % create the posfile for export
    %keywords: max N1 (only export largest clusters) N1 - N2 (range) - N2 (up to N2)
    
    % cluster sizes:
    clusterSizes = handles.clusterSizes;
    clusterIdx = handles.clusterIdx;
    
    str = strread(Nmin,'%s');
    
    
    if length(str) == 1
        
        if strcmp(str{1},'max')
            % only use largest cluster
            significantClusterIdx = find(clusterSizes == max(clusterSizes));
            
        else
            % only use Nmin
            Nmin = str2num(Nmin);
            
            significantClusterIdx = find(clusterSizes >= Nmin);
        end
        
    elseif length(str) == 2
        
        if str{1} == 'max'
            % use N largest clusters
            N = str2num(str{2});
            
            [sorted, idx] = sort(clusterSizes);
            significantClusterIdx = idx(1:N);
            
        else
            % use Nmax
            handles.Nmax = str2num(str{2});
            Nmax = handles.Nmax;
            
            significantClusterIdx = find(clusterSizes <= Nmax);
            
        end
        
        
    elseif length(str) == 3
        
        Nmin = str2num(str{1});
        Nmax = str2num(str{3});
        
        significantClusterIdx = find((clusterSizes >= Nmin) && (clusterSizes <= Nmax));
        
        
        
    end
    
    % actually creating the atomic positions
    identifiedClusterPos = handles.clusterPos(ismember(clusterIdx,significantClusterIdx),:);
    
    
    savepos(identifiedClusterPos,handles.clusterPosFileName);
    
    
    
    %% calculation of cluster centers
    clusterLocation = [];
    
    for clust = 1:length(significantClusterIdx);
        
        
        tmpPos = handles.clusterPos(handles.clusterIdx == significantClusterIdx(clust),1:3);
        clusterLocation(clust,:) = [mean(tmpPos,1) length(tmpPos(:,1))];
        
    end
    
    handles.clusterLocations = clusterLocation;
    
end





time = clock;
time = [num2str(time(4)) ':' num2str(time(5)) ':' num2str(time(6),2)];
constr = [time ': Nmin updated'];

set(handles.console_string,'String',constr);
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Nmin_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nmin_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compositionAnalysis_button.
function compositionAnalysis_button_Callback(hObject, eventdata, handles)
% hObject    handle to compositionAnalysis_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


usedElements = handles.usedElements;
numElements = length(usedElements);



str = {'feature excess','contained atoms'};
[s,v] = listdlg('PromptString','Export:',...
    'SelectionMode','multiple',...
    'ListString',str);

if ~v
    return
end






if s == 1
    % calculate the feature excess for each cluster, exporing to .csv
    clusterLocations = handles.clusterLocations;
    
end


if s == 2
    % calculate the atomic concentrations for each cluster (using the
    % convex hulls of the clusters, exporing to .csv
    significantClusterIdx = handles.significantClusterIdx;
    [posOut posOutCells] = atomsInClusterHulls(handles.pos, handles.clusterPos, handles.clusterIdx, handles.significantClusterIdx);
    
    posMC = cell(size(posOutCells));
    for idx = 1:length(posOutCells)
        posMC{idx} = posOutCells{idx}(:,4);
    end
    
    [conc variance] = atomicConcentration(posMC, handles.xrng);
    
    % exported properties: atomic concentrations, number of atoms
    
    numClusters = length(posOutCells);
    concOut = cell(numClusters,numElements+1);
    
    for el = 1:numElements
        for clust = 1:numClusters
            
            concOut{clust,el} = conc{clust}(usedElements(el));
            
        end
    end
    
    for clust = 1:numClusters
        concOut{clust,end} = length(posOutCells{clust}(:,1));
    end
    
    header = cell(1,length(concOut(1,:)));
    for el = 1:numElements
        header{1,el} = sym4number(usedElements(el));
    end
    header{1,end} = 'num atoms';
    
            
    concOut = [header; concOut];
    
    
    [file path] = uiputfile('*.csv','Exporting cluster concentrations');
    
    dlmcell([path file],concOut,' ');
    
end

time = clock;
time = [num2str(time(4)) ':' num2str(time(5)) ':' num2str(time(6),2)];
constr = [time ': chemical analysis exported'];

set(handles.console_string,'String',constr);
guidata(hObject,handles);
























