function varargout = IsosurfGUI(varargin)
% ISOSURFGUI M-file for IsosurfGUI.fig
%      ISOSURFGUI, by itself, creates a new ISOSURFGUI or raises the existing
%      singleton*.
%
%      H = ISOSURFGUI returns the handle to a new ISOSURFGUI or the handle to
%      the existing singleton*.
%
%      ISOSURFGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISOSURFGUI.M with the given input arguments.
%
%      ISOSURFGUI('Property','Value',...) creates a new ISOSURFGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IsosurfGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IsosurfGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IsosurfGUI

% Last Modified by GUIDE v2.5 30-Dec-2011 18:56:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IsosurfGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @IsosurfGUI_OutputFcn, ...
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


% --- Executes just before IsosurfGUI is made visible.
function IsosurfGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IsosurfGUI (see VARARGIN)

CField = varargin{1};





%% adds background image
% This creates the 'background' axes
ha = axes('units','pixels', ...
'position',[10 10  639/2 236/2]);

% Move the background axes to the bottom
uistack(ha,'bottom');

% Load in a background image and display it using the correct colors
% The image used below, is in the Image Processing Toolbox. If you do not have %access to this toolbox, you can use another image file instead.
I=imread('USYD.jpg');
hi = imagesc(I);

% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(ha,'handlevisibility','off', ...
'visible','off')













%% does useful stuff

% check which elements are present
k=1;
for i=1:100
    present = ~~sum(nonzeros(CField.concentration{i}));
    
    k = k+present;
    
    if present
        elements(k)=i;
        
    end
    
    
end

elements = nonzeros(elements);
k=length(elements);

handles.isosurfout = [];
handles.isocapsout = [];


handles.elements = elements;

set(handles.listbox1,'String',handles.elements,'Value',k)

set(handles.listbox1,'Max',k);

handles.isocaps = 0;

handles.minverts = 0;


handles.selectedelement = elements(end);





fv = isosurface(CField.x,CField.y,CField.z,CField.concentration{handles.selectedelement},0);

set(handles.IsoSurfAxes,'UserData', CField);

patch(fv, 'FaceColor',[0 0 1], 'EdgeColor', [0 1 0]);

lighting phong;

camlight(-80,-10);

view(3);

rotate3d;

set(handles.IsoElementText,'String',sym4number(handles.selectedelement));



axis equal;




% Choose default command line output for IsosurfGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IsosurfGUI wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IsosurfGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

%varargout{1} = handles.output;

%varargout{2} = handles.isosurfout;

%varargout{3} = handles.isocapsout;







% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


redisplay(handles);



set(handles.isoValue,'String',num2str(get(handles.slider1,'Value')));


guidata(hObject,handles);




% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

selectedelement = handles.elements(get(hObject,'Value'));



handles.selectedelement = selectedelement;



%set the name string
elstr = [];
for i=1:length(selectedelement)
    elstr = [elstr ' + ' sym4number(selectedelement(i))];
end
elstr(1:2) = [];
set(handles.IsoElementText,'String',elstr);







redisplay(handles);

guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function isoValue_Callback(hObject, eventdata, handles)
% hObject    handle to isoValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of isoValue as text
%        str2double(get(hObject,'String')) returns contents of isoValue as a double

isoval = str2double(get(hObject,'String'));

set(handles.slider1,'Value',isoval);

redisplay(handles);

guidata(hObject,handles);


% --- Executes on button press in IsoCapsCheck.
function IsoCapsCheck_Callback(hObject, eventdata, handles)
% hObject    handle to IsoCapsCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IsoCapsCheck
handles.isocaps = get(hObject,'Value');

redisplay(handles);

guidata(hObject,handles);






% function that updates the figure with new isovalue

function redisplay(handles)

isoval = get(handles.slider1,'Value');

CField = get(handles.IsoSurfAxes,'UserData');

concentration = zeros(size(CField.concentration{1}));

for i=1:length(handles.selectedelement)
    concentration = concentration + CField.concentration{handles.selectedelement(i)};    
end


cla; % clears axis

fv = isosurface(CField.x,CField.y,CField.z,concentration,isoval);

normalslength = str2double(get(handles.normalsSize,'String'));

invertnormals = 1;

if get(handles.useInvertNormals,'Value')
    invertnormals = -1;
end


if ~get(handles.useMinVerts,'Value')
    
    patch(fv, 'FaceColor',[0 0 1], 'EdgeColor', [0 1 0]);
    
    if get(handles.useVertexNormals,'Value')
        normals = patchnormals(fv);
        
        normals = normals * invertnormals *normalslength;
    
        [no.faces,no.vertices,~]=quiver3Dpatch(fv.vertices(:,1), fv.vertices(:,2), fv.vertices(:,3),normals(:,1),normals(:,2),normals(:,3),[],[normalslength normalslength]);
    
        patch(no);
    end
    
else
    
    patches = splitFV(fv);
    
    for i=1:length(patches)
        if size(patches(i).vertices,1) > handles.minverts
            patch(patches(i), 'FaceColor',[0 0 1], 'EdgeColor', [0 1 0]);
            
            
                if get(handles.useVertexNormals,'Value')
                    normals = patchnormals(patches(i));
        
                    normals = normals * invertnormals * normalslength;
    
                    [no.faces,no.vertices,~]=quiver3Dpatch(patches(i).vertices(:,1), patches(i).vertices(:,2), patches(i).vertices(:,3),normals(:,1),normals(:,2),normals(:,3),[],[0 1]);
    
                    patch(no);
                end
            
            
            
        end
        
    end
    
    
    
end




handles.output = isoval;




if handles.isocaps
    ic = isocaps(CField.x,CField.y,CField.z,concentration,isoval);
    patch(ic);
    handles.output = ic;
    handles.isocapsout = ic;
end

handles.isosurfout = fv;



lighting phong;

camlight('headlight');


function sym = sym4number(Z)



switch Z
    case 1 
        sym = 'H';
        
    case 2 
        sym = 'He';
        
    case 3
        sym = 'Li';

    case 4
        sym = 'Be';
        
    case 5 
        sym = 'B';
        
    case 6 
        sym = 'C';
        
    case 7 
        sym = 'N';
        
    case 8 
        sym = 'O';
        
    case 9 
        sym = 'F';
        
    case 10 
        sym = 'Ne';
        
    case 11 
        sym = 'Na';
        
    case 12 
        sym = 'Mg';
        
    case 13 
        sym = 'Al';
        
    case 14 
        sym = 'Si';
        
    case 15 
        sym = 'P';
        
    case 16 
        sym = 'S';
        
    case 17 
        sym = 'Cl';
        
    case 18 
        sym = 'Ar';
        
    case 19 
        sym = 'K';
        
    case 20 
        sym = 'Ca';
        
    case 21 
        sym = 'Sc';
        
    case 22 
        sym = 'Ti';
        
    case 23 
        sym = 'V';
        
    case 24 
        sym = 'Cr';
        
    case 25 
        sym = 'Mn';
        
    case 26 
        sym = 'Fe';
        
    case 27 
        sym = 'Co';
        
    case 28 
        sym = 'Ni';
        
    case 29 
        sym = 'Cu';
        
    case 30 
        sym = 'Zn';
        
    case 31 
        sym = 'Ga';
        
    case 32 
        sym = 'Ge';
        
    case 33 
        sym = 'As';
        
    case 34 
        sym = 'Se';
        
    case 35 
        sym = 'Br';
        
    case 36 
        sym = 'Kr';
        
    case 37 
        sym = 'Rb';
        
    case 38 
        sym = 'Sr';
        
    case 39 
        sym = 'Y';
        
    case 40 
        sym = 'Zr';
        
    case 41 
        sym = 'Nb';
        
    case 42 
        sym = 'Mo';
        
    case 44 
        sym = 'Ru';
        
    case 45 
        sym = 'Rh';
        
    case 46 
        sym = 'Pd';
        
    case 47 
        sym = 'Ag';
        
    case 48 
        sym = 'Cd';
        
    case 49 
        sym = 'In';
        
    case 50 
        sym = 'Sn';
        
    case 51 
        sym = 'Sb';
        
    case 52 
        sym = 'Te';
        
    case 53 
        sym = 'I';
        
    case 54 
        sym = 'Xe';
        
    case 55 
        sym = 'Cs';
        
    case 56 
        sym = 'Ba';
        
    case 58 
        sym = 'Ce';
        
    case 59 
        sym = 'Pr';
        
    case 60 
        sym = 'Nd';
        
    case 72 
        sym = 'Hf';
        
    case 73 
        sym = 'Ta';
        
    case 74 
        sym = 'W';
        
    case 75 
        sym = 'Re';
        
    case 76 
        sym = 'Os';
        
    case 77 
        sym = 'Ir';
        
    case 78 
        sym = 'Pt';
        
    case 79 
        sym = 'Au';
        
    case 80 
        sym = 'Hg';
        
    case 82 
        sym = 'Pb';
        
    case 83 
        sym = 'Bi';
        
    case 90 
        sym = 'Th';
        
    case 92 
        sym = 'U';
        
    otherwise
        disp(' symbol undefined!');
end
        
function fvOut = splitFV( f, v )
%SPLITFV Splits faces and vertices into connected pieces
%   FVOUT = SPLITFV(F,V) separates disconnected pieces inside a patch defined by faces (F) and
%   vertices (V). FVOUT is a structure array with fields "faces" and "vertices". Each element of
%   this array indicates a separately connected patch.
%
%   FVOUT = SPLITFV(FV) takes in FV as a structure with fields "faces" and "vertices"
%
%   For example:
%     fullpatch.vertices = [2 4; 2 8; 8 4; 8 0; 0 4; 2 6; 2 2; 4 2; 4 0; 5 2; 5 0];
%     fullpatch.faces = [1 2 3; 1 3 4; 5 6 1; 7 8 9; 11 10 4];
%     figure, subplot(2,1,1), patch(fullpatch,'facecolor','r'), title('Unsplit mesh');
%     splitpatch = splitFV(fullpatch);
%     colours = lines(length(splitpatch));
%     subplot(2,1,2), hold on, title('Split mesh');
%     for i=1:length(splitpatch)
%         patch(splitpatch(i),'facecolor',colours(i,:));
%     end
%
%   Note: faces and vertices should be defined such that faces sharing a coincident vertex reference
%   the same vertex number, rather than having a separate vertice defined for each face (yet at the
%   same vertex location). In other words, running the following command: size(unique(v,'rows') ==
%   size(v) should return TRUE. An explicit test for this has not been included in this function so
%   as to allow for the deliberate splitting of a mesh at a given location by simply duplicating
%   those vertices.
%
%   See also PATCH

%   Copyright Sven Holcombe
%   $Date: 2010/05/19 $

%% Extract f and v
if nargin==1 && isstruct(f) && all(isfield(f,{'faces','vertices'}))
    v = f.vertices;
    f = f.faces;
elseif nargin==2
    % f and v are already defined
else
    error('splitFV:badArgs','splitFV takes a faces/vertices structure, or these fields passed individually')
end

%% Organise faces into connected fSets that share nodes
fSets = zeros(size(f,1),1,'uint32');
currentSet = 0;

while any(fSets==0)
    currentSet = currentSet + 1;
    %fprintf('Connecting set #%d vertices...',currentSet);
    nextAvailFace = find(fSets==0,1,'first');
    openVertices = f(nextAvailFace,:);
    while ~isempty(openVertices)
        availFaceInds = find(fSets==0);
        [availFaceSub, xyzSub] = find(ismember(f(availFaceInds,:), openVertices));
        fSets(availFaceInds(availFaceSub)) = currentSet;
        openVertices = f(availFaceInds(availFaceSub),xyzSub);
    end
    %fprintf(' done! Set #%d has %d faces.\n',currentSet,nnz(fSets==currentSet));
end
numSets = currentSet;

%% Create separate faces/vertices structures for each fSet
fvOut = repmat(struct('faces',[],'vertices',[]),numSets,1);

for currentSet = 1:numSets
    setF = f(fSets==currentSet,:);
    [unqVertIds, ~, newVertIndices] = unique(setF);
    fvOut(currentSet).faces = reshape(newVertIndices,size(setF));
    fvOut(currentSet).vertices = v(unqVertIds,:);
end



function minVerts_Callback(hObject, eventdata, handles)
% hObject    handle to minVerts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minVerts as text
%        str2double(get(hObject,'String')) returns contents of minVerts as a double

handles.minverts = str2double(get(hObject,'String'));


redisplay(handles);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function minVerts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minVerts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in useMinVerts.
function useMinVerts_Callback(hObject, eventdata, handles)
% hObject    handle to useMinVerts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useMinVerts
guidata(hObject,handles);
redisplay(handles);


% --- Executes on button press in exportObjButton.
function exportObjButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportObjButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


isoval = get(handles.slider1,'Value');


CField = get(handles.IsoSurfAxes,'UserData');

concentration = zeros(size(CField.concentration{1}));

for i=1:length(handles.selectedelement)
    concentration = concentration + CField.concentration{handles.selectedelement(i)};    
end




fv = isosurface(CField.x,CField.y,CField.z,concentration,isoval);



obj.vertices = [];

if ~get(handles.useMinVerts,'Value')
    
    obj.vertices = fv.vertices;
    obj.objects(1).type = 'f';
    obj.objects(1).data.vertices = fv.faces;
    
else
    
    patches = splitFV(fv);
    
    k=1;
    accumverts = 0;
    
    for i=1:length(patches)
        if size(patches(i).vertices,1) > handles.minverts
            
            obj.vertices = [obj.vertices; patches(i).vertices];
            
            
            
            
            obj.objects(k).type = 'f'
            
            patches(i).faces = patches(i).faces + accumverts
            
            obj.objects(k).data.vertices = patches(i).faces;
            accumverts = accumverts + size(patches(i).vertices,1)
            k=k+1;
            
        end
        
    end
    
    
    
end


[file path] = uiputfile('*.obj','save as Wavefront .obj');


write_wobj(obj, [path file]);







function write_wobj(OBJ,fullfilename)
% Write objects to a Wavefront OBJ file
%
%
% Function is written by D.Kroon University of Twente (June 2010)

if(exist('fullfilename','var')==0)
    [filename, filefolder] = uiputfile('*.obj', 'Write obj-file');
    fullfilename = [filefolder filename];
end
[filefolder,filename] = fileparts( fullfilename);

comments=cell(1,4);
comments{1}=' Produced by Matlab Write Wobj exporter ';
comments{2}='';

fid = fopen(fullfilename,'w');
write_comment(fid,comments);

if(isfield(OBJ,'material')&&~isempty(OBJ.material))
    filename_mtl=fullfile(filefolder,[filename '.mtl']);
    fprintf(fid,'mtllib %s\n',filename_mtl);
    write_MTL_file(filename_mtl,OBJ.material)
    
end

if(isfield(OBJ,'vertices')&&~isempty(OBJ.vertices))
    write_vertices(fid,OBJ.vertices,'v');
end

if(isfield(OBJ,'vertices_point')&&~isempty(OBJ.vertices_point))
    write_vertices(fid,OBJ.vertices_point,'vp');
end

if(isfield(OBJ,'vertices_normal')&&~isempty(OBJ.vertices_normal))
    write_vertices(fid,OBJ.vertices_normal,'vn');
end

if(isfield(OBJ,'vertices_texture')&&~isempty(OBJ.vertices_texture))
    write_vertices(fid,OBJ.vertices_texture,'vt');
end

for i=1:length(OBJ.objects)
    type=OBJ.objects(i).type
    data=OBJ.objects(i).data
    
    verts = OBJ.objects(i).data.vertices;
    
    fprintf(fid,['o ' num2str(i) '\n']);
    
    
    switch(type)
        case 'usemtl'
            fprintf(fid,'usemtl %s\n',data);
        case 'f'
            
            
            
            
            check1=(isfield(OBJ,'vertices_texture')&&~isempty(OBJ.vertices_texture));
            check2=(isfield(OBJ,'vertices_normal')&&~isempty(OBJ.vertices_normal));
            if(check1&&check2)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d/%d/%d',data.vertices(j,1),data.texture(j,1),data.normal(j,1));
                    fprintf(fid,' %d/%d/%d', data.vertices(j,2),data.texture(j,2),data.normal(j,2));
                    fprintf(fid,' %d/%d/%d\n', data.vertices(j,3),data.texture(j,3),data.normal(j,3));
                end
            elseif(check1)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d/%d',data.vertices(j,1),data.texture(j,1));
                    fprintf(fid,' %d/%d', data.vertices(j,2),data.texture(j,2));
                    fprintf(fid,' %d/%d\n', data.vertices(j,3),data.texture(j,3));
                end
            elseif(check2)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d//%d',data.vertices(j,1),data.normal(j,1));
                    fprintf(fid,' %d//%d', data.vertices(j,2),data.normal(j,2));
                    fprintf(fid,' %d//%d\n', data.vertices(j,3),data.normal(j,3));
                end
            else
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d %d %d\n',data.vertices(j,1),data.vertices(j,2),data.vertices(j,3));
                end
            end
        otherwise
            fprintf(fid,'%s ',type);
            if(iscell(data))
                for j=1:length(data)
                    if(ischar(data{j}))
                        fprintf(fid,'%s ',data{j});
                    else
                        fprintf(fid,'%0.5g ',data{j});
                    end
                end 
            elseif(ischar(data))
                 fprintf(fid,'%s ',data);
            else
                for j=1:length(data)
                    fprintf(fid,'%0.5g ',data(j));
                end      
            end
            fprintf(fid,'\n');
    end
end
fclose(fid);

function write_MTL_file(filename,material)
fid = fopen(filename,'w');
comments=cell(1,2);
comments{1}=' Produced by Matlab Write Wobj exporter ';
comments{2}='';
write_comment(fid,comments);

for i=1:length(material)
    type=material(i).type;
    data=material(i).data;
    
    
    
    switch(type)
        case('newmtl')
            fprintf(fid,'%s ',type);
            fprintf(fid,'%s\n',data);
        case{'Ka','Kd','Ks'}
            fprintf(fid,'%s ',type);
            fprintf(fid,'%5.5f %5.5f %5.5f\n',data);
        case('illum')
            fprintf(fid,'%s ',type);
            fprintf(fid,'%d\n',data);
        case {'Ns','Tr','d'}
            fprintf(fid,'%s ',type);
            fprintf(fid,'%5.5f\n',data);
        otherwise
            fprintf(fid,'%s ',type);
            if(iscell(data))
                for j=1:length(data)
                    if(ischar(data{j}))
                        fprintf(fid,'%s ',data{j});
                    else
                        fprintf(fid,'%0.5g ',data{j});
                    end
                end 
            elseif(ischar(data))
                fprintf(fid,'%s ',data);
            else
                for j=1:length(data)
                    fprintf(fid,'%0.5g ',data(j));
                end      
            end
            fprintf(fid,'\n');
    end
end

comments=cell(1,2);
comments{1}='';
comments{2}=' EOF';
write_comment(fid,comments);
fclose(fid);

function write_comment(fid,comments)
for i=1:length(comments), fprintf(fid,'# %s\n',comments{i}); end






function write_vertices(fid,V,type)



switch size(V,2)
    case 1
        for i=1:size(V,1)
            fprintf(fid,'%s %5.5f\n', type, V(i,1));
        end
    case 2
        for i=1:size(V,1)
            fprintf(fid,'%s %5.5f %5.5f\n', type, V(i,1), V(i,2));
        end
    case 3
        for i=1:size(V,1)
            fprintf(fid,'%s %5.5f %5.5f %5.5f\n', type, V(i,1), V(i,2), V(i,3));
        end
    otherwise
end
switch(type)
    case 'v'
        fprintf(fid,'# %d vertices \n', size(V,1));
    case 'vt'
        fprintf(fid,'# %d texture verticies \n', size(V,1));
    case 'vn'
        fprintf(fid,'# %d normals \n', size(V,1));
    otherwise
        fprintf(fid,'# %d\n', size(V,1));
        
end



function [F,V,C]=quiver3Dpatch(x,y,z,ux,uy,uz,c,a)

% function [F,V,C]=quiver3Dpatch(x,y,z,ux,uy,uz,a)
% ------------------------------------------------------------------------
%
% This function allows plotting of colored 3D arrows by generating patch
% data (faces F, vertices V and color data C). The patch data which
% allows plotting of 3D quiver arrows with specified (e.g. colormap driven)
% color. To save memory n arrows are created using only n*6 faces and n*7
% vertices. The vector "a" defines arrow length scaling where a(1) is the
% smallest arrow length and a(2) the largest. Use the PATCH command to plot
% the arrows:  
%
% [F,V,C]=quiver3Dpatch(x,y,z,ux,uy,uz,a)
% patch('Faces',F,'Vertices',V,'CData',C,'FaceColor','flat'); 
%
% Below is a detailed example illustrating color specifications for
% (combined) patch data. 
%
%%% EXAMPLE
% %% Plotting colormap driven arrows combined with RGB driven iso-surface
% a=[0.5 1]; %Arrow length scaling
% L=G>0.8; %Logic indices for arrows
% c=[]; %Default length dependant color will be used
% [F,V,C]=quiver3Dpatch(X(L),Y(L),Z(L),u(L),v(L),w(L),c,a);
% 
% Ci1n=(c_iso1.*ones(numel(Ci1),3))-min(M(:)); Ci1n=Ci1n./max(M(:)-min(M(:)));%Custom isosurface color
% Ci2n=(c_iso2.*ones(numel(Ci2),3))-min(M(:)); Ci2n=Ci2n./max(M(:)-min(M(:)));%Custom isosurface color
% 
% fig=figure; clf(fig); colordef (fig,'black'); set(fig,'Color','k');
% set(fig,'units','normalized','outerposition',[0 0 1 1]); hold on; 
% xlabel('X','FontSize',20);ylabel('Y','FontSize',20);zlabel('Z','FontSize',20);
% title('Colormap driven arrows, RGB isosurfaces','FontSize',15);
% patch('Faces',F,'Vertices',V,'EdgeColor','none', 'CData',C,'FaceColor','flat','FaceAlpha',1); colormap jet; colorbar; caxis([min(C(:)) max(C(:))]);
% patch('Faces',Fi1,'Vertices',Vi1,'FaceColor','flat','FaceVertexCData',Ci1n,'EdgeColor','none','FaceAlpha',0.75); hold on;
% patch('Faces',Fi2,'Vertices',Vi2,'FaceColor','flat','FaceVertexCData',Ci2n,'EdgeColor','none','FaceAlpha',0.75); hold on;
% view(3); grid on; axis vis3d; set(gca,'FontSize',20);
% 
% %% Plotting RGB driven arrows combined with colormap driven iso-surface
% a=[0.5 1]; %Arrow length scaling
% L=G>0.8; %Logic indices for arrows
% %Length dependent custom RGB (here grayscale) color specification
% c=1-(G(L)./max(G(L)))*ones(1,3);
% [F,V,C]=quiver3Dpatch(X(L),Y(L),Z(L),u(L),v(L),w(L),c,a);
% 
% fig=figure; clf(fig); colordef (fig,'white'); set(fig,'Color','w');
% set(fig,'units','normalized','outerposition',[0 0 1 1]); hold on; 
% xlabel('X','FontSize',20);ylabel('Y','FontSize',20);zlabel('Z','FontSize',20);
% title('RGB arrows, colormap driven iso-surfaces','FontSize',15);
% patch('Faces',Fi1,'Vertices',Vi1,'FaceColor','flat','CData',Ci1,'EdgeColor','none','FaceAlpha',0.4); hold on;
% patch('Faces',Fi2,'Vertices',Vi2,'FaceColor','flat','CData',Ci2,'EdgeColor','none','FaceAlpha',0.4); hold on;
% colormap jet; colorbar; caxis([c_iso1 c_iso2]);
% patch('Faces',F,'Vertices',V,'EdgeColor','none', 'FaceVertexCData',C,'FaceColor','flat','FaceAlpha',0.8);
% view(3); grid on; axis vis3d; set(gca,'FontSize',20);
%
%
% Kevin Mattheus Moerman
% kevinmoerman@hotmail.com
% 12/04/2011
%------------------------------------------------------------------------

%% 
%Coordinates
x=x(:); y=y(:); z=z(:);
ux=ux(:); uy=uy(:); uz=uz(:);

%Spherical coordinates
[THETA_vec,PHI_vec,R_vec] = cart2sph(ux,uy,uz);
  
%% Setting arrow size properties

%Arrow length
if  min(R_vec(:))==max(R_vec(:)) %If all radii are equal, or if just 1 vector is used
    arrow_length=a(2)*ones(size(R_vec)); %All arrow lengths become a(2)
else
    %Scale arrow lengths between a(1) and a(2)
    arrow_length=R_vec-min(R_vec(:));
    arrow_length=a(1)+((arrow_length./max(arrow_length(:))).*(a(2)-a(1)));
end

%Other arrow dimensions as functions of arrow length and phi (golden ratio)
phi=(1+sqrt(5))/2;
head_size=arrow_length./(phi);
head_width=head_size./(2.*phi);
stick_width=head_width./(2.*phi);
h=sin((2/3).*pi).*stick_width;
ha=sin((2/3).*pi).*head_width;

%% Creating arrow triangle vertices coordinates

X_tri=[zeros(size(x))  zeros(size(x)) zeros(size(x))...
    head_size.*ones(size(x)) head_size.*ones(size(x)) head_size.*ones(size(x))...
    arrow_length];
Y_tri=[-(0.5.*stick_width).*ones(size(x)) (0.5.*stick_width).*ones(size(x))  zeros(size(x))...
    -(0.5.*head_width).*ones(size(x))  (0.5.*head_width).*ones(size(x))  zeros(size(x))...
    zeros(size(x))];
Z_tri=[-(0.5.*stick_width.*tan(pi/6)).*ones(size(x))...
    -(0.5.*stick_width.*tan(pi/6)).*ones(size(x))...
    (h-(0.5.*stick_width.*tan(pi/6))).*ones(size(x))...
    -(0.5.*head_width.*tan(pi/6)).*ones(size(x))...
    -(0.5.*head_width.*tan(pi/6)).*ones(size(x))...
    (ha-(0.5.*head_width.*tan(pi/6))).*ones(size(x))...
    zeros(size(x))];

% Rotating vertices
[THETA_ar,PHI_ar,R_vec_ar] = cart2sph(X_tri,zeros(size(Y_tri)),Z_tri);
PHI_ar=PHI_ar+PHI_vec*ones(1,size(THETA_ar,2));
[X_arg,Y_arg,Z_arg] = sph2cart(THETA_ar,PHI_ar,R_vec_ar);
Y_arg=Y_arg+Y_tri;
[THETA_ar,PHI_ar,R_vec_ar] = cart2sph(X_arg,Y_arg,Z_arg);
THETA_ar=THETA_ar+THETA_vec*ones(1,size(THETA_ar,2));
[X_arg,Y_arg,Z_arg] = sph2cart(THETA_ar,PHI_ar,R_vec_ar);

X_arg=X_arg+x*ones(1,size(THETA_ar,2)); X_arg=X_arg';
Y_arg=Y_arg+y*ones(1,size(THETA_ar,2)); Y_arg=Y_arg';
Z_arg=Z_arg+z*ones(1,size(THETA_ar,2)); Z_arg=Z_arg';

V=[X_arg(:) Y_arg(:) Z_arg(:)];

%% Creating faces matrix

%Standard vertex order for 6 face arrow style
F_order=[1 2 7; 2 3 7; 3 1 7; 4 5 7; 5 6 7; 6 4 7;];
no_nodes=size(X_tri,2);
b=(no_nodes.*((1:1:numel(x))'-1))*ones(1,3);

%Loops size(F_order,1) times
F=zeros(numel(x)*size(F_order,1),3); %Allocating faces matrix
for f=1:1:size(F_order,1)
    Fi=ones(size(x))*F_order(f,:)+b;
    F(1+(f-1)*numel(x):f*numel(x),:)=Fi;
end

%     %Alternative without for loop, not faster for some tested problems
%     F_order=(ones(numel(x),1)*[1 2 7 2 3 7 3 1 7 4 5 7 5 6 7 6 4 7])';
%     F_order1=ones(numel(x),1)*(1:6);
%     F_order2=ones(numel(x),1)*[2 3 1 5 6 4];
%     F_order=[F_order1(:) F_order2(:)];
%     F_order(:,3)=7;
%     b=repmat(((no_nodes.*(0:1:numel(x)-1)')*ones(1,3)),[6,1]);
%     F=F_order+b;

%% Color specification

if isempty(c); %If empty specify vector magnitudes as color
    C=repmat(R_vec,[size(F_order,1),1]);
else %If user specified color replicate to match # of added faces for arrow
    C=repmat(c,[size(F_order,1),1]);
end    






function N=patchnormals(FV)
% This function PATCHNORMALS calculates the normals of a triangulated
% mesh. PATCHNORMALS calls the patchnormal_double.c mex function which 
% first calculates the normals of all faces, and after that calculates 
% the vertice normals from the face normals weighted by the angles 
% of the faces.
%
% N=patchnormals(FV);
%
% Inputs,
%   FV : A struct containing FV.faces with a facelist Nx3 and FV.vertices
%        with a Nx3 vertices list. Such a structure is created by Matlab
%        Patch function
% Outputs,
%   N : A Mx3 list with the normals of all vertices
%
% Example,
%   % Compile the c-coded function
%   mex patchnormals_double.c -v
%
%   % Load a triangulated mesh of a sphere
%   load sphere; 
%
%   % Calculate the normals
%   N=patchnormals(FV);
%
%   % Show the normals
%   figure, patch(FV,'FaceColor',[1 0 0]); axis square; hold on;
%   for i=1:size(N,1);
%       p1=FV.vertices(i,:); p2=FV.vertices(i,:)+10*N(i,:);       
%       plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'g-');
%   end       
%
% Function is written by D.Kroon University of Twente (June 2009)


sizev=size(FV.vertices);
% Check size of vertice array
if((sizev(2)~=3)||(length(sizev)~=2))
    error('patchnormals:inputs','The vertice list is not a m x 3 array')
end

sizef=size(FV.faces);
% Check size of vertice array
if((sizef(2)~=3)||(length(sizef)~=2))
    error('patchnormals:inputs','The vertice list is not a m x 3 array')
end

% Check if vertice indices exist
if(max(FV.faces(:))>size(FV.vertices,1))
    error('patchnormals:inputs','The face list contains an undefined vertex index')
end

% Check if vertice indices exist
if(min(FV.faces(:))<1)
    error('patchnormals:inputs','The face list contains an vertex index smaller then 1')
end

[Nx,Ny,Nz]=patchnormals_double(double(FV.faces(:,1)),double(FV.faces(:,2)),double(FV.faces(:,3)),double(FV.vertices(:,1)),double(FV.vertices(:,2)),double(FV.vertices(:,3)));

N=zeros(length(Nx),3);
N(:,1)=Nx;
N(:,2)=Ny;
N(:,3)=Nz;

function [Nx,Ny,Nz]=patchnormals_double(Fa,Fb,Fc,Vx,Vy,Vz)
%
%  [Nx,Ny,Nz]=patchnormals_double(Fa,Fb,Fc,Vx,Vy,Vz)
%

FV.vertices=zeros(length(Vx),3);
FV.vertices(:,1)=Vx;
FV.vertices(:,2)=Vy;
FV.vertices(:,3)=Vz;

% Get all edge vectors
e1=FV.vertices(Fa,:)-FV.vertices(Fb,:);
e2=FV.vertices(Fb,:)-FV.vertices(Fc,:);
e3=FV.vertices(Fc,:)-FV.vertices(Fa,:);

% Normalize edge vectors
e1_norm=e1./repmat(sqrt(e1(:,1).^2+e1(:,2).^2+e1(:,3).^2),1,3); 
e2_norm=e2./repmat(sqrt(e2(:,1).^2+e2(:,2).^2+e2(:,3).^2),1,3); 
e3_norm=e3./repmat(sqrt(e3(:,1).^2+e3(:,2).^2+e3(:,3).^2),1,3);

% Calculate Angle of face seen from vertices
Angle =  [acos(dot(e1_norm',-e3_norm'));acos(dot(e2_norm',-e1_norm'));acos(dot(e3_norm',-e2_norm'))]';

% Calculate normal of face
 Normal=cross(e1,e3);

% Calculate Vertice Normals 
VerticeNormals=zeros([size(FV.vertices,1) 3]);
for i=1:size(Fa,1),
    VerticeNormals(Fa(i),:)=VerticeNormals(Fa(i),:)+Normal(i,:)*Angle(i,1);
    VerticeNormals(Fb(i),:)=VerticeNormals(Fb(i),:)+Normal(i,:)*Angle(i,2);
    VerticeNormals(Fc(i),:)=VerticeNormals(Fc(i),:)+Normal(i,:)*Angle(i,3);
end

V_norm=sqrt(VerticeNormals(:,1).^2+VerticeNormals(:,2).^2+VerticeNormals(:,3).^2)+eps;
VerticeNormals=VerticeNormals./repmat(V_norm,1,3);
Nx=VerticeNormals(:,1);
Ny=VerticeNormals(:,2);
Nz=VerticeNormals(:,3);


% --- Executes on button press in useVertexNormals.
function useVertexNormals_Callback(hObject, eventdata, handles)
% hObject    handle to useVertexNormals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useVertexNormals
guidata(hObject,handles);

redisplay(handles);





% --- Executes on button press in useInvertNormals.
function useInvertNormals_Callback(hObject, eventdata, handles)
% hObject    handle to useInvertNormals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useInvertNormals
guidata(hObject,handles);

redisplay(handles);


function normalsSize_Callback(hObject, eventdata, handles)
% hObject    handle to normalsSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of normalsSize as text
%        str2double(get(hObject,'String')) returns contents of normalsSize as a double
guidata(hObject,handles);

redisplay(handles);


% --- Executes during object creation, after setting all properties.
function normalsSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalsSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

% Hint: delete(hObject) closes the figure
delete(hObject);
