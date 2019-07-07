function varargout = periodicTableSelect(varargin)
% Periodic Table of Elements
%
% Syntax
%
%   elements = periodic_table()
%   elements = periodic_table('Name',Value',...)
%
% Description
%
%   elements = periodic_table() creates a figure with a periodic table and
%   returns a cell array with the elements the user has selected.
%
%   elements = periodic_table('Name',Value',...) allows some user editing 
%   to the periodic table.
%   Optional Arguments:
%           'DisplayElements':      Highlight certain elements in green.
%           'DisableElements':      Highlight certain elements in red. User
%                                   selection is disabled.
%   Both optional arguments take a cell array with symbols of elements
%
% Example
%
%   elements = periodic_table('DisplayElements',{'Na','Ca'})
%       creates a periodic table with Na and Ca highlighted in green.
%
%
%   periodic_table('DisplayElements',{'Na','Ca'},'DisableElements',{'Ar'})
%       creates a periodic table with Na and Ca highlighted in green and Ar
%       disabled.
%
% Note:
%   If elements.m and elements.txt from Gerhard Nieuwenhuiys's Mole Package
%   (http://www.mathworks.com/matlabcentral/fileexchange/10873-mole-package)
%   are present in the current directory, additional info is displayed.
%
% function created by Kevin Hellemans
%% Create Figure
    pt = figure('Name','Periodic Table','NumberTitle','off',...
        'position',[300,300,700,400],'Color',[0.95 0.95 0.95]);
% Disable Menus
    set(pt,'MenuBar','none');
% Create handle structure
    pt_handles = guihandles(pt);
    
% Create Table    
    CreateTable(pt);
    arrayfun(@CreateElement, get(pt,'Children'));
    
% Textbox
    pt_handles.txtbox = uicontrol('Style','text','Units','normalized',...
        'Position',[0.2 0.7 0.4 0.25],'Visible','off','FontUnits',...
        'normalized','HorizontalAlignment','left');
   
% OK Button
   uicontrol('Units','normalized','Position',[0.1 0.1 0.1 0.1],'Callback',...
       'uiresume(gcbf)','String','OK')
   
%% Argument Check
   narginchk(0,5);
   p = inputParser;
   addOptional(p,'DisplayElements',{})
   addOptional(p,'DisableElements',{})
   parse(p,varargin{:});
   %disp(p.Results)
   if iscell(p.Results.DisplayElements)
        arrayfun(@(x) HighlightElement(x,p.Results.DisplayElements),...
            get(pt,'Children'));
        pt_handles.user_input = p.Results.DisplayElements;
   else
       pt_handles.user_input = {};
   end
   if iscell(p.Results.DisableElements)
        arrayfun(@(x) DisableElement(x,p.Results.DisableElements),...
            get(pt,'Children'));
   end
   
 %% Update handle structure   
   pt_handles.SelectedElements = {};
   guidata(pt,pt_handles);
   
 %% Output       
   uiwait(pt)
   try
        pt_handles = guidata(pt); % Update handles
        varargout{1} = pt_handles.SelectedElements;
        close(pt)
   catch % Close Figure by X
       varargout{1} = [];
   end
%% Local Functions   
function Select_Callback (pt,~,~)
% Load handle structure
    pt_handles = guidata(pt);
    if ismember(1,strcmp(get(gcbo,'Tag'),pt_handles.user_input))
         el_color = [0 0.9 0];
    else
        el_color = [0.8 0.9 0.9];
    end
% Change selection
    if ~isequal(get(gcbo,'Color'), [1 1 0])
        set(gcbo,'Color', [1 1 0])
        pt_handles.SelectedElements = [pt_handles.SelectedElements,...
            {get(gcbo,'Tag')}];
        % Display elemental info
        if ~isempty(dir('elements.m'))
            line1 = ['Name: ',elements('Symbol',get(gcbo,'Tag'),'Name'),...
                ' (',get(gcbo,'Tag'),')'];
            line2 = ['Atomic Number: ',num2str(elements('Symbol',...
                get(gcbo,'Tag'),'atomicnumber'))];
            line3 = ['Atomic Mass: ',num2str(elements('Symbol',...
                get(gcbo,'Tag'),'atomicmass'))];
            txt = sprintf('%s\n%s\n%s',line1,line2,line3);
            set(pt_handles.txtbox,'String',txt)
            set(pt_handles.txtbox,'Visible','on')
        end
    else
        set(gcbo,'Color', el_color)
        idx = strcmp(get(gcbo,'Tag'),pt_handles.SelectedElements);
        pt_handles.SelectedElements(idx) = [];
        set(pt_handles.txtbox,'Visible','off')
    end
 % Update handle structure
    guidata(pt,pt_handles);
    
function CreateElement(input_handle)
string = get(input_handle,'Tag');
set(input_handle,'XTick',[],'YTick',[],'ButtonDownFcn',@Select_Callback,'XLim',...
       [0 1],'YLim',[0 1],'Box','on','Color',[0.8 0.9 0.9]);
text(0.5,0.5,string,'Parent',input_handle,'FontSize',12,'FontUnits','normalized',...
       'Units','normalized','HorizontalAlignment','center',...
       'VerticalAlignment','middle','HitTest','off')
   
function HighlightElement(input_handle, user_input)
string = get(input_handle,'Tag');
if ismember(1,strcmp(string,user_input))
    set(input_handle,'Color', [0 0.9 0])
end
function DisableElement(input_handle, user_input)
string = get(input_handle,'Tag');
if ismember(1,strcmp(string,user_input))
    set(input_handle,'Color', [1 0 0])
    set(input_handle,'ButtonDownFcn',[])
end
function CreateTable(pt)
   axes('Parent',pt,'Position', [0.05 0.85 0.04 0.09],'Tag','H');
   axes('Parent',pt,'Position', [0.05 0.75 0.04 0.09],'Tag','Li');
   axes('Parent',pt,'Position', [0.05 0.65 0.04 0.09],'Tag','Na');
   axes('Parent',pt,'Position', [0.05 0.55 0.04 0.09],'Tag','K');
   axes('Parent',pt,'Position', [0.05 0.45 0.04 0.09],'Tag','Rb');
   axes('Parent',pt,'Position', [0.05 0.35 0.04 0.09],'Tag','Cs');
   axes('Parent',pt,'Position', [0.05 0.25 0.04 0.09],'Tag','Fr');
   axes('Parent',pt,'Position', [0.1 0.75 0.04 0.09],'Tag','Be');
   axes('Parent',pt,'Position', [0.1 0.65 0.04 0.09],'Tag','Mg');
   axes('Parent',pt,'Position', [0.1 0.55 0.04 0.09],'Tag','Ca');
   axes('Parent',pt,'Position', [0.1 0.45 0.04 0.09],'Tag','Sr');
   axes('Parent',pt,'Position', [0.1 0.35 0.04 0.09],'Tag','Ba');
   axes('Parent',pt,'Position', [0.1 0.25 0.04 0.09],'Tag','Ra');   
   axes('Parent',pt,'Position', [0.15 0.55 0.04 0.09],'Tag','Sc');
   axes('Parent',pt,'Position', [0.2 0.55 0.04 0.09],'Tag','Ti');
   axes('Parent',pt,'Position', [0.25 0.55 0.04 0.09],'Tag','V');
   axes('Parent',pt,'Position', [0.3 0.55 0.04 0.09],'Tag','Cr');
   axes('Parent',pt,'Position', [0.35 0.55 0.04 0.09],'Tag','Mn');
   axes('Parent',pt,'Position', [0.4 0.55 0.04 0.09],'Tag','Fe');   
   axes('Parent',pt,'Position', [0.45 0.55 0.04 0.09],'Tag','Co');
   axes('Parent',pt,'Position', [0.5 0.55 0.04 0.09],'Tag','Ni');
   axes('Parent',pt,'Position', [0.55 0.55 0.04 0.09],'Tag','Cu');
   axes('Parent',pt,'Position', [0.6 0.55 0.04 0.09],'Tag','Zn');
   axes('Parent',pt,'Position', [0.65 0.55 0.04 0.09],'Tag','Ga');
   axes('Parent',pt,'Position', [0.7 0.55 0.04 0.09],'Tag','Ge');
   axes('Parent',pt,'Position', [0.75 0.55 0.04 0.09],'Tag','As');
   axes('Parent',pt,'Position', [0.8 0.55 0.04 0.09],'Tag','Se');
   axes('Parent',pt,'Position', [0.85 0.55 0.04 0.09],'Tag','Br');
   axes('Parent',pt,'Position', [0.9 0.55 0.04 0.09],'Tag','Kr');   
   axes('Parent',pt,'Position', [0.15 0.45 0.04 0.09],'Tag','Y');
   axes('Parent',pt,'Position', [0.2 0.45 0.04 0.09],'Tag','Zr');
   axes('Parent',pt,'Position', [0.25 0.45 0.04 0.09],'Tag','Nb');
   axes('Parent',pt,'Position', [0.3 0.45 0.04 0.09],'Tag','Mo');
   axes('Parent',pt,'Position', [0.35 0.45 0.04 0.09],'Tag','Tc');
   axes('Parent',pt,'Position', [0.4 0.45 0.04 0.09],'Tag','Ru');   
   axes('Parent',pt,'Position', [0.45 0.45 0.04 0.09],'Tag','Rh');
   axes('Parent',pt,'Position', [0.5 0.45 0.04 0.09],'Tag','Pd');
   axes('Parent',pt,'Position', [0.55 0.45 0.04 0.09],'Tag','Ag');
   axes('Parent',pt,'Position', [0.6 0.45 0.04 0.09],'Tag','Cd');
   axes('Parent',pt,'Position', [0.65 0.45 0.04 0.09],'Tag','In');
   axes('Parent',pt,'Position', [0.7 0.45 0.04 0.09],'Tag','Sn');
   axes('Parent',pt,'Position', [0.75 0.45 0.04 0.09],'Tag','Sb');
   axes('Parent',pt,'Position', [0.8 0.45 0.04 0.09],'Tag','Te');
   axes('Parent',pt,'Position', [0.85 0.45 0.04 0.09],'Tag','I');
   axes('Parent',pt,'Position', [0.9 0.45 0.04 0.09],'Tag','Xe');
   axes('Parent',pt,'Position', [0.15 0.35 0.04 0.09],'Tag','La');
   axes('Parent',pt,'Position', [0.2 0.35 0.04 0.09],'Tag','Hf');
   axes('Parent',pt,'Position', [0.25 0.35 0.04 0.09],'Tag','Ta');
   axes('Parent',pt,'Position', [0.3 0.35 0.04 0.09],'Tag','W');
   axes('Parent',pt,'Position', [0.35 0.35 0.04 0.09],'Tag','Re');
   axes('Parent',pt,'Position', [0.4 0.35 0.04 0.09],'Tag','Os');   
   axes('Parent',pt,'Position', [0.45 0.35 0.04 0.09],'Tag','Ir');
   axes('Parent',pt,'Position', [0.5 0.35 0.04 0.09],'Tag','Pt');
   axes('Parent',pt,'Position', [0.55 0.35 0.04 0.09],'Tag','Au');
   axes('Parent',pt,'Position', [0.6 0.35 0.04 0.09],'Tag','Hg');
   axes('Parent',pt,'Position', [0.65 0.35 0.04 0.09],'Tag','Tl');
   axes('Parent',pt,'Position', [0.7 0.35 0.04 0.09],'Tag','Pb');
   axes('Parent',pt,'Position', [0.75 0.35 0.04 0.09],'Tag','Bi');
   axes('Parent',pt,'Position', [0.8 0.35 0.04 0.09],'Tag','Po');
   axes('Parent',pt,'Position', [0.85 0.35 0.04 0.09],'Tag','At');
   axes('Parent',pt,'Position', [0.9 0.35 0.04 0.09],'Tag','Rn');
   axes('Parent',pt,'Position', [0.15 0.25 0.04 0.09],'Tag','Ac');
   axes('Parent',pt,'Position', [0.65 0.75 0.04 0.09],'Tag','B');
   axes('Parent',pt,'Position', [0.7 0.75 0.04 0.09],'Tag','C');
   axes('Parent',pt,'Position', [0.75 0.75 0.04 0.09],'Tag','N');
   axes('Parent',pt,'Position', [0.8 0.75 0.04 0.09],'Tag','O');
   axes('Parent',pt,'Position', [0.85 0.75 0.04 0.09],'Tag','F');
   axes('Parent',pt,'Position', [0.9 0.75 0.04 0.09],'Tag','Ne');
   axes('Parent',pt,'Position', [0.65 0.65 0.04 0.09],'Tag','Al');
   axes('Parent',pt,'Position', [0.7 0.65 0.04 0.09],'Tag','Si');
   axes('Parent',pt,'Position', [0.75 0.65 0.04 0.09],'Tag','P');
   axes('Parent',pt,'Position', [0.8 0.65 0.04 0.09],'Tag','S');
   axes('Parent',pt,'Position', [0.85 0.65 0.04 0.09],'Tag','Cl');
   axes('Parent',pt,'Position', [0.9 0.65 0.04 0.09],'Tag','Ar');
   axes('Parent',pt,'Position', [0.9 0.85 0.04 0.09],'Tag','He');
   axes('Parent',pt,'Position', [0.25 0.2 0.04 0.09],'Tag','Ce');
   axes('Parent',pt,'Position', [0.3 0.2 0.04 0.09],'Tag','Pr');
   axes('Parent',pt,'Position', [0.35 0.2 0.04 0.09],'Tag','Nd');
   axes('Parent',pt,'Position', [0.4 0.2 0.04 0.09],'Tag','Pm');
   axes('Parent',pt,'Position', [0.45 0.2 0.04 0.09],'Tag','Sm');
   axes('Parent',pt,'Position', [0.5 0.2 0.04 0.09],'Tag','Eu');
   axes('Parent',pt,'Position', [0.55 0.2 0.04 0.09],'Tag','Gd');
   axes('Parent',pt,'Position', [0.6 0.2 0.04 0.09],'Tag','Tb');
   axes('Parent',pt,'Position', [0.65 0.2 0.04 0.09],'Tag','Dy');
   axes('Parent',pt,'Position', [0.7 0.2 0.04 0.09],'Tag','Ho');
   axes('Parent',pt,'Position', [0.75 0.2 0.04 0.09],'Tag','Er');
   axes('Parent',pt,'Position', [0.8 0.2 0.04 0.09],'Tag','Tm');
   axes('Parent',pt,'Position', [0.85 0.2 0.04 0.09],'Tag','Yb');
   axes('Parent',pt,'Position', [0.9 0.2 0.04 0.09],'Tag','Lu');  
   axes('Parent',pt,'Position', [0.25 0.1 0.04 0.09],'Tag','Th');
   axes('Parent',pt,'Position', [0.3 0.1 0.04 0.09],'Tag','Pa');
   axes('Parent',pt,'Position', [0.35 0.1 0.04 0.09],'Tag','U');
   axes('Parent',pt,'Position', [0.4 0.1 0.04 0.09],'Tag','Np');
   axes('Parent',pt,'Position', [0.45 0.1 0.04 0.09],'Tag','Pu');
   axes('Parent',pt,'Position', [0.5 0.1 0.04 0.09],'Tag','Am');
   axes('Parent',pt,'Position', [0.55 0.1 0.04 0.09],'Tag','Cm');
   axes('Parent',pt,'Position', [0.6 0.1 0.04 0.09],'Tag','Bk');
   axes('Parent',pt,'Position', [0.65 0.1 0.04 0.09],'Tag','Cf');
   axes('Parent',pt,'Position', [0.7 0.1 0.04 0.09],'Tag','Es');
   axes('Parent',pt,'Position', [0.75 0.1 0.04 0.09],'Tag','Fm');
   axes('Parent',pt,'Position', [0.8 0.1 0.04 0.09],'Tag','Md');
   axes('Parent',pt,'Position', [0.85 0.1 0.04 0.09],'Tag','No');
   axes('Parent',pt,'Position', [0.9 0.1 0.04 0.09],'Tag','Lr');