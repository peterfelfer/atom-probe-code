function varargout = selectIonGUI(varargin)
% SELECTIONGUI MATLAB code for selectIonGUI.fig
%      SELECTIONGUI, by itself, creates a new SELECTIONGUI or raises the existing
%      singleton*.
%
%      H = SELECTIONGUI returns the handle to a new SELECTIONGUI or the handle to
%      the existing singleton*.
%
%      SELECTIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTIONGUI.M with the given input arguments.
%
%      SELECTIONGUI('Property','Value',...) creates a new SELECTIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectIonGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectIonGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectIonGUI

% Last Modified by GUIDE v2.5 30-Jun-2019 15:13:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectIonGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @selectIonGUI_OutputFcn, ...
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


% --- Executes just before selectIonGUI is made visible.
function selectIonGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectIonGUI (see VARARGIN)

% Choose default command line output for selectIonGUI
%handles.output = hObject;

%% contants
handles.PADDING = 1; %padding on the plot in Da beyond ions/selections



%% reading inputs
% order of input: rng,mcPlot, baseElements, complexFormers, chargeStates,
% maxComplex, thresh, colorScheme
handles.rng = evalin('base',varargin{1});
handles.varName = varargin{1};
handles.mcPlot = varargin{2};
handles.baseElements = varargin{3};
handles.complexFormers = varargin{4};
handles.chargeStates = varargin{5};
handles.maxComplex = varargin{6};
handles.thresh = varargin{7};
handles.colorScheme = varargin{8};

handles.bins = handles.mcPlot.XData;
handles.histogram = handles.mcPlot.YData;
handles.binSize = handles.bins(2)-handles.bins(1);


%% get range and plot it
axes(get(handles.mcPlot,'Parent'));
[x, ~] = ginput(2);
x = sort(x);
handles.mcBegin = x(1);
handles.mcEnd = x(2);

% find highest peak within that range
interval = handles.bins>=handles.mcBegin & handles.bins<=handles.mcEnd;
tempHist = handles.histogram .* interval;
maxIdx = median(find(tempHist == max(tempHist)));
handles.mcMax = handles.bins(maxIdx);

inRng = (handles.bins>=handles.mcBegin) & (handles.bins<handles.mcEnd);


%check overlap and crop if needed
for r = 1:length(handles.rng)
    overlap(r) = (handles.mcBegin < handles.rng(r).mcend) & (handles.mcEnd > handles.rng(r).mcbegin); 
end
numOverlaps = sum(overlap);
mcEndMax = 0;
mcBeginMin = 1E6;
overlap = find(overlap);
if overlap
    for o = 1:numOverlaps
        mcEndMax = max([handles.rng(overlap(o)).mcend mcEndMax]);
        mcBeginMin = min([handles.rng(overlap(o)).mcbegin mcBeginMin]);
    end
    
    if handles.mcBegin < mcEndMax
        handles.mcBegin = mcEndMax + handles.binSize;
    end
    if handles.mcEnd > mcBeginMin
        handles.mcEnd = mcBeginMin - handles.binSize;
    end
    
end



%% getting hostogram data from original plot and populate plot
handles.mcPlotHandle = plot(handles.mcPlot.XData,handles.mcPlot.YData,'Parent',handles.histogramAxis);
hold(handles.histogramAxis,'on')
handles.histogramAxis.YScale = 'log';
handles.histogramAxis.XLim = [handles.mcMax-handles.PADDING handles.mcMax+handles.PADDING];

%% populate listbox with possible ions
handles.ionList = createIonList(handles.baseElements,handles.chargeStates,handles.maxComplex,handles.complexFormers,handles.thresh);
%create ions name list and distances to selected peak
for ion = 1 : length(handles.ionList.massToCharge)
    currName = ionName(handles.ionList.ionSpecies{ion});
    for cs = 1:handles.ionList.chargeState(ion)
        currName = [currName '+'];
    end  
    ionNames{ion} = currName;
    ionNamesDist{ion} = [currName '  ' num2str(handles.ionList.massToCharge(ion)-handles.mcMax,2) '  ' num2str(handles.ionList.relativeAbundance(ion),3)];
    dist(ion) = handles.ionList.massToCharge(ion)-handles.mcMax;
end

idxIn = (handles.ionList.massToCharge>=(handles.mcMax-handles.PADDING)) & (handles.ionList.massToCharge<=(handles.mcMax+handles.PADDING));
ionNamesIn = ionNames(idxIn);
ionNamesDistIn = ionNamesDist(idxIn);

if isempty(ionNamesDistIn)
    disp('no matching ions found in vicinity of peak');
    return
    
end

handles.ionSelectionListbox.String = ionNamesDist;
handles.ionSelectionListbox.Value = floor(median(find(abs(dist) == min(abs(dist)))));

%% plot all ranges on top of histogram
%new range
handles.rangePlot = area(handles.bins(inRng),handles.histogram(inRng),'Parent',handles.histogramAxis);
handles.rangePlot.FaceColor = [.9 .9 .9];
%existing ranges
for r=1:length(handles.rng)
    inRng = (handles.bins>=handles.rng(r).mcbegin) & (handles.bins<handles.rng(r).mcend);
    handles.rngPlotHandles(r) = area(handles.bins(inRng),handles.histogram(inRng),'Parent',handles.histogramAxis);
    handles.rngPlotHandles(r).FaceColor = handles.rng(r).color;
end



%% initial STEM plot of ion abundances
handles.peakHeight = handles.histogram(maxIdx);
% find all ions and abundances of same kind
currentID = handles.ionList.ionID(handles.ionSelectionListbox.Value);
sameID = (handles.ionList.ionID == currentID) & (handles.ionList.chargeState == handles.ionList.chargeState(handles.ionSelectionListbox.Value));
mcs = handles.ionList.massToCharge(sameID);

relativeAbundance = handles.ionList.relativeAbundance(sameID) / 100;
peakHeight = handles.peakHeight * relativeAbundance / handles.ionList.relativeAbundance(handles.ionSelectionListbox.Value)* 100;

% plot all isotopic combinations
handles.abundancePlot = stem(mcs,peakHeight,'Parent',handles.histogramAxis);
handles.abundancePlot.Marker = 'o';
handles.abundancePlot.Color = [.8 0 0];
handles.abundancePlot.LineWidth = 1;

%plot the selected ion in thicker line
handles.currentIonPlot = stem(handles.ionList.massToCharge(handles.ionSelectionListbox.Value), handles.peakHeight,'Parent',handles.histogramAxis);
handles.currentIonPlot.Marker = 'o';
handles.currentIonPlot.Color = [1 0 0];
handles.currentIonPlot.LineWidth = 3;

% change axis limit while keeping peak centered
LLim = min([min(mcs)-handles.PADDING handles.mcMax-handles.PADDING]);
ULim = max([max(mcs)+handles.PADDING handles.mcMax+handles.PADDING]);
span = max([handles.mcMax - LLim ULim - handles.mcMax]);
LLim = handles.mcMax - span;
ULim = handles.mcMax + span;
handles.histogramAxis.XLim = [LLim ULim];
handles.histogramAxis.YLim = [handles.histogramAxis.YLim(1) handles.peakHeight  *1.25];

%% populate edit string
currentSelection = handles.ionSelectionListbox.Value;
atoms = handles.ionList.ionSpecies{currentSelection}(:,1);
atomTypes = unique(atoms);
numAtom = length(atomTypes);
nameStr = [];
for a = 1:numAtom
    multi = sum(atoms == atomTypes(a));
    if multi > 1
        nameStr = [nameStr sym4number(atomTypes(a)) num2str(multi) ' '];
    else
        nameStr = [nameStr sym4number(atomTypes(a)) ' '];
    end
end

handles.manualIonNameStringInput.String = nameStr(1:end-1);

uicontrol(handles.ionSelectionListbox);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes selectIonGUI wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = selectIonGUI_OutputFcn(hObject, eventdata, handles, output) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp('output fcn'); % for debugging purposes
% Get default command line output from handles structure

%uiresume(handles.rangingGUI);


% --- Executes on selection change in ionSelectionListbox.
function ionSelectionListbox_Callback(hObject, eventdata, handles)
% hObject    handle to ionSelectionListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% get selection and abundances
currentSelection = handles.ionSelectionListbox.Value;
currentID = handles.ionList.ionID(currentSelection);
sameID = (handles.ionList.ionID == currentID) & (handles.ionList.chargeState == handles.ionList.chargeState(currentSelection));


mcs = handles.ionList.massToCharge(sameID);
relativeAbundance = handles.ionList.relativeAbundance(sameID) / 100;
peakHeight = handles.peakHeight * relativeAbundance / handles.ionList.relativeAbundance(currentSelection) *100;

%% update plot
handles.abundancePlot.XData = mcs;
handles.abundancePlot.YData = peakHeight;
handles.currentIonPlot.XData = handles.ionList.massToCharge(currentSelection);
handles.currentIonPlot.YData = handles.peakHeight;


% change axis limit while keeping peak centered
LLim = min([min(mcs)-handles.PADDING handles.mcMax-handles.PADDING]);
ULim = max([max(mcs)+handles.PADDING handles.mcMax+handles.PADDING]);
span = max([handles.mcMax - LLim ULim - handles.mcMax]);
LLim = handles.mcMax - span;
ULim = handles.mcMax + span;
handles.histogramAxis.XLim = [LLim ULim];
handles.histogramAxis.YLim = [handles.histogramAxis.YLim(1) max(peakHeight)  *1.25];

%% update name string into edit box
currentSelection = handles.ionSelectionListbox.Value;
atoms = handles.ionList.ionSpecies{currentSelection}(:,1);
atomTypes = unique(atoms);
numAtom = length(atomTypes);
nameStr = [];
for a = 1:numAtom
    multi = sum(atoms == atomTypes(a));
    if multi > 1
        nameStr = [nameStr sym4number(atomTypes(a)) num2str(multi) ' '];
    else
        nameStr = [nameStr sym4number(atomTypes(a)) ' '];
    end
end

handles.manualIonNameStringInput.String = nameStr(1:end-1);

%% change color on main area plot
% coloring
% check if ion is already in use
rangeName = handles.manualIonNameStringInput.String;
colorDefined = false;
for r = 1:length(handles.rng)
    if strcmp(handles.rng(r).rangeName,rangeName)
        color = handles.rng(r).color;
        colorDefined = true;
    end
end

%if not, try color scheme
if ~colorDefined
    for cs = 1:length(handles.colorScheme)
        if strcmp(handles.colorScheme{cs,1},rangeName)
            color = handles.colorScheme{cs,2};
            colorDefined = true;
        end
    end
end

%if colorscheme not available, use color picker
if ~colorDefined
    color = [.9 .9 .9];
end
handles.rangePlot.FaceColor = color;
% Hints: contents = cellstr(get(hObject,'String')) returns ionSelectionListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ionSelectionListbox

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ionSelectionListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ionSelectionListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OKButton.
function OKButton_Callback(hObject, eventdata, handles)
% hObject    handle to OKButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% add range to rng variable

%create range name

%use automated naming CURRENTLY WITHOUT ISOTOPES
currentSelection = handles.ionSelectionListbox.Value;
atoms = handles.ionList.ionSpecies{currentSelection}(:,1);
atomTypes = unique(atoms);
numAtom = length(atomTypes);
for a = 1:numAtom
    atomsOut(a).atom = sym4number(atomTypes(a));
    atomsOut(a).atomicNumber = atomTypes(a);
    atomsOut(a).count = sum(atoms == atomTypes(a));
end

rangeName = handles.manualIonNameStringInput.String;




% coloring
% check if ion is already in use
colorDefined = false;
for r = 1:length(handles.rng)
    if strcmp(handles.rng(r).rangeName,rangeName)
        color = handles.rng(r).color;
        colorDefined = true;
    end
end

%if not, try color scheme
if ~colorDefined
    for cs = 1:length(handles.colorScheme)
        if strcmp(handles.colorScheme{cs,1},rangeName)
            color = handles.colorScheme{cs,2};
            colorDefined = true;
        end
    end
end

%if colorscheme not available, use color picker
if ~colorDefined
    color = uisetcolor();
end

% add range to output variable
handles.rng(end+1).rangeName = rangeName;
handles.rng(end).mcbegin = handles.mcBegin;
handles.rng(end).mcend = handles.mcEnd;
handles.rng(end).vol = 0;
handles.rng(end).color = color;
handles.rng(end).atoms = atomsOut;
handles.rng = nestedSortStruct(handles.rng,{'mcbegin'});

handles.output = handles.rng;

assignin('base',handles.varName, handles.rng);

rangingGUI_CloseRequestFcn(handles.rangingGUI, eventdata, handles)
%rangingGUI_CloseRequestFcn(handles.rangingGUI, eventdata, handles)


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rangingGUI_CloseRequestFcn(handles.rangingGUI, eventdata, handles)


% --- Executes on button press in keepIsotopesCheckbox.
function keepIsotopesCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to keepIsotopesCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of keepIsotopesCheckbox



function manualIonNameStringInput_Callback(hObject, eventdata, handles)
% hObject    handle to manualIonNameStringInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manualIonNameStringInput as text
%        str2double(get(hObject,'String')) returns contents of manualIonNameStringInput as a double


% --- Executes during object creation, after setting all properties.
function manualIonNameStringInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manualIonNameStringInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close rangingGUI.
function rangingGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to rangingGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in rangeSameButton.
function rangeSameButton_Callback(hObject, eventdata, handles)
% hObject    handle to rangeSameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% gives the ability to range all ions of the same type & chargestate
% it goes through all ions apart from the one you have already ranged.
% The histogram is zoomed to +/- 2 Da from the peak
SPAN = 1;%Da
disp('range same');
currentSelection = handles.ionSelectionListbox.Value;
currentID = handles.ionList.ionID(currentSelection);
sameID = (handles.ionList.ionID == currentID) & (handles.ionList.chargeState == handles.ionList.chargeState(currentSelection));
currentSelectionLogical = false(length(sameID),1);
currentSelectionLogical(currentSelection) = true;
otherIons = find(sameID & ~currentSelectionLogical);
numIons = length(otherIons);

%use automated naming CURRENTLY WITHOUT ISOTOPES
currentSelection = handles.ionSelectionListbox.Value;
atoms = handles.ionList.ionSpecies{currentSelection}(:,1);
atomTypes = unique(atoms);
numAtom = length(atomTypes);
for a = 1:numAtom
    atomsOut(a).atom = sym4number(atomTypes(a));
    atomsOut(a).atomicNumber = atomTypes(a);
    atomsOut(a).count = sum(atoms == atomTypes(a));
end

rangeName = handles.manualIonNameStringInput.String;

% coloring
% check if ion is already in use
colorDefined = false;
for r = 1:length(handles.rng)
    if strcmp(handles.rng(r).rangeName,rangeName)
        color = handles.rng(r).color;
        colorDefined = true;
    end
end

%if not, try color scheme
if ~colorDefined
    for cs = 1:length(handles.colorScheme)
        if strcmp(handles.colorScheme{cs,1},rangeName)
            color = handles.colorScheme{cs,2};
            colorDefined = true;
        end
    end
end

%if colorscheme not available, use color picker
if ~colorDefined
    color = uisetcolor();
end

% add original range to output variable
handles.rng(end+1).rangeName = rangeName;
handles.rng(end).mcbegin = handles.mcBegin;
handles.rng(end).mcend = handles.mcEnd;
handles.rng(end).vol = 0;
handles.rng(end).color = color;
handles.rng(end).atoms = atomsOut;

axes(handles.histogramAxis); % set focus
for i = 1:numIons
    mc = handles.ionList.massToCharge(otherIons(i));
    % set zoom
    handles.histogramAxis.XLim = [mc-SPAN mc+SPAN];
    
    % get range limits
    [x, y] = ginput(2);
    x = sort(x);
    
    if length(x) == 2
        % add range to output variable
        handles.rng(end+1).rangeName = rangeName;
        handles.rng(end).mcbegin = x(1);
        handles.rng(end).mcend = x(2);
        handles.rng(end).vol = 0;
        handles.rng(end).color = color;
        handles.rng(end).atoms = atomsOut;
        
    end
    
    
    
end


handles.rng = nestedSortStruct(handles.rng,{'mcbegin'});

handles.output = handles.rng;


assignin('base',handles.varName, handles.rng);

rangingGUI_CloseRequestFcn(handles.rangingGUI, eventdata, handles)

