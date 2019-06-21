function varargout = rangingGUI(varargin)
% RANGINGGUI MATLAB code for rangingGUI.fig
%      RANGINGGUI, by itself, creates a new RANGINGGUI or raises the existing
%      singleton*.
%
%      H = RANGINGGUI returns the handle to a new RANGINGGUI or the handle to
%      the existing singleton*.
%
%      RANGINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RANGINGGUI.M with the given input arguments.
%
%      RANGINGGUI('Property','Value',...) creates a new RANGINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rangingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rangingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rangingGUI

% Last Modified by GUIDE v2.5 20-Jun-2019 11:15:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rangingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @rangingGUI_OutputFcn, ...
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


% --- Executes just before rangingGUI is made visible.
function rangingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rangingGUI (see VARARGIN)

% Choose default command line output for rangingGUI
handles.output = hObject;

if nargin == 1
    initialisationType = 'mc';
else
    initialisationType = 'mcrng';
end

%variable setup
handles.posData = varargin{1};

if length(handles.posData(1,:)) > 1
    handles.posData = handles.posData(:,4);
end

mcmax = max(handles.posData);
binSize = 0.1; %default bin size for initialisation

handles.bins = linspace(0,mcmax,round(mcmax/binSize));
handles.mcMainHistogramData = hist(handles.posData,handles.bins);
handles.mcMainPlot = area(handles.bins,handles.mcMainHistogramData,'FaceColor',[.9 .9 .9]); %creates area plot



%setting display properties
handles.rangingGUIhandle.Name = 'Mass spectrum';
handles.rangingGUIhandle.Color = [1 1 1];

handles.massSpecAxis.YScale = 'Log';
handles.massSpecAxis.XLabel.String = 'mass-to-chargestate [Da]';
handles.massSpecAxis.YLabel.String = 'frequency [cts/Da/cts]';
handles.massSpecAxis.XLim = [0 mcmax];

%setting defaults
handles.binSizeString.String = num2str(binSize);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rangingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rangingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in rangesListbox.
function rangesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to rangesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rangesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rangesListbox


% --- Executes during object creation, after setting all properties.
function rangesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ionTypeString_Callback(hObject, eventdata, handles)
% hObject    handle to ionTypeString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ionTypeString as text
%        str2double(get(hObject,'String')) returns contents of ionTypeString as a double


% --- Executes during object creation, after setting all properties.
function ionTypeString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ionTypeString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function chargeStateString_Callback(hObject, eventdata, handles)
% hObject    handle to chargeStateString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chargeStateString as text
%        str2double(get(hObject,'String')) returns contents of chargeStateString as a double


% --- Executes during object creation, after setting all properties.
function chargeStateString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chargeStateString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mcBeginString_Callback(hObject, eventdata, handles)
% hObject    handle to mcBeginString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mcBeginString as text
%        str2double(get(hObject,'String')) returns contents of mcBeginString as a double


% --- Executes during object creation, after setting all properties.
function mcBeginString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mcBeginString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mcEndString_Callback(hObject, eventdata, handles)
% hObject    handle to mcEndString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mcEndString as text
%        str2double(get(hObject,'String')) returns contents of mcEndString as a double


% --- Executes during object creation, after setting all properties.
function mcEndString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mcEndString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushToWSButton.
function pushToWSButton_Callback(hObject, eventdata, handles)
% hObject    handle to pushToWSButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function rngListContextMenu_Callback(hObject, eventdata, handles)
% hObject    handle to rngListContextMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function binSizeString_Callback(hObject, eventdata, handles)
% hObject    handle to binSizeString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binSizeString as text
%        str2double(get(hObject,'String')) returns contents of binSizeString as a double


% --- Executes during object creation, after setting all properties.
function binSizeString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binSizeString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
