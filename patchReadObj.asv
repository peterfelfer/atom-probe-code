function obj = patchReadObj(fullfilename)
% obj = patchReadObj(fullfilename) opens a wavefront .obj file and 
% converts it into a structure with vertices and objects.
%
% obj = patchReadObj(fullfilename)
%
% obj = patchReadObj()
% A selection window pops up and an .obj file must be selected.
%
% INPUT:
%   fullfilename: full name of the .obj file as a string ('example.obj').
%   The file must be located in the Current Folder.
%
% OUTPUT:
%   obj: structure with vertices and objects fields; obj.objects itself is
%   a structure consisting of field of type and field of vertices
%
% hints: the 'vertices' of the sub-structure obj.objects are the numbers of the vertices,
% which generate the triangulated faces (fv.faces = obj.objects{1}.vertices). 
% The 'vertices' of the OUTPUT are the vertices of the patch.


if ~exist('fullfilename','var')
    [file path] = uigetfile('*.obj','select .obj file');
    fullfilename = [path file];
end

% Read the DI3D OBJ textfile to a cell array
file_words = file2cellarray( fullfilename);
% Remove empty cells, merge lines split by "\" and convert strings with values to double
[ftype fdata]= fixlines(file_words);



% Vertex data
vertices=[]; nv=0;
vertices_texture=[]; nvt=0;
vertices_point=[]; nvp=0;
vertices_normal=[]; nvn=0;
material=[];

% Surface data
no=0;


fileCells = file2cellarray( fullfilename);

objects = 0;
vertices = 0;



obj.vertices = [];


for c = 1:size(fileCells,2)
    
    try
        type = fileCells{1,c}{1,1};
    catch
        type = 'not recognized';
    end
    

        switch type


            case 'v'

                vertices = vertices +1;

                obj.vertices(vertices,:) = [str2double(fileCells{1, c}{1,2}) str2double(fileCells{1, c}{1,3}) str2double(fileCells{1, c}{1,4})];



            case 'o'

                objects = objects +1;

                obj.objects{objects}.type = fileCells{1, c+1}{1,1};
                
                obj.objects{objects}.vertices = [];



            case 'p'

                point = str2num(fileCells{1,c}{1,2});

                obj.objects{objects}.vertices = [obj.objects{objects}.vertices; point];


            case 'l'

                line = [str2num(fileCells{1,c}{1,2}) str2num(fileCells{1,c}{1,3})];

                obj.objects{objects}.vertices = [obj.objects{objects}.vertices; line];



            case 'f'

                face = [str2num(fileCells{1,c}{1,2}) str2num(fileCells{1,c}{1,3}) str2num(fileCells{1,c}{1,4})];

                obj.objects{objects}.vertices = [obj.objects{objects}.vertices; face];

        end
        

    
    
    
end



















function twords=stringsplit(tline,tchar)
% Get start and end position of all "words" separated by a char
i=find(tline(2:end-1)==tchar)+1; i_start=[1 i+1]; i_end=[i-1 length(tline)];
% Create a cell array of the words
twords=cell(1,length(i_start)); for j=1:length(i_start), twords{j}=tline(i_start(j):i_end(j)); end

function file_words=file2cellarray(filename)
% Open a DI3D OBJ textfile
fid=fopen(filename,'r');
file_text=fread(fid, inf, 'uint8=>char')';
fclose(fid);
file_lines = regexp(file_text, '\n+', 'split');
file_words = regexp(file_lines, '\s+', 'split');

function [ftype fdata]=fixlines(file_words)
ftype=cell(size(file_words));
fdata=cell(size(file_words));

iline=0; jline=0;
while(iline<length(file_words))
    iline=iline+1;
    twords=removeemptycells(file_words{iline});
    if(~isempty(twords))
        % Add next line to current line when line end with '\'
        while(strcmp(twords{end},'\')&&iline<length(file_words))
            iline=iline+1;
            twords(end)=[];
            twords=[twords removeemptycells(file_words{iline})];
        end
        % Values to double
        
        type=twords{1};
        stringdold=true;
        j=0;
        switch(type)
            case{'#','$'}
                for i=2:length(twords)
                    j=j+1; twords{j}=twords{i};                    
                end    
            otherwise    
                for i=2:length(twords)
                    str=twords{i};
                    val=str2double(str);
                    stringd=~isfinite(val);
                    if(stringd)
                        j=j+1; twords{j}=str;
                    else
                        if(stringdold)
                            j=j+1; twords{j}=val;
                        else
                            twords{j}=[twords{j} val];    
                        end
                    end
                    stringdold=stringd;
                end
        end
        twords(j+1:end)=[];
        jline=jline+1;
        ftype{jline}=type;
        if(length(twords)==1), twords=twords{1}; end
        fdata{jline}=twords;
    end
end
ftype(jline+1:end)=[];
fdata(jline+1:end)=[];

function b=removeemptycells(a)
j=0; b={};
for i=1:length(a);
    if(~isempty(a{i})),j=j+1; b{j}=a{i}; end;
end

function  objects=readmtl(filename_mtl,verbose)
if(verbose),disp(['Reading Material file : ' filename_mtl]); end
file_words=file2cellarray(filename_mtl);
% Remove empty cells, merge lines split by "\" and convert strings with values to double
[ftype fdata]= fixlines(file_words);

% Surface data
objects.type(length(ftype))=0; 
objects.data(length(ftype))=0; 
no=0;
% Loop through the Wavefront object file
for iline=1:length(ftype)
  type=ftype{iline}; data=fdata{iline};
    
    % Switch on data type line
    switch(type)
        case{'#','$'}
            % Comment
            tline='  %'; 
            if(iscell(data))
                for i=1:length(data), tline=[tline ' ' data{i}]; end
            else
                tline=[tline data];
            end
            if(verbose), disp(tline); end
        case{''}
        otherwise
            no=no+1;
            if(mod(no,10000)==1), objects(no+10001).data=0; end
            objects(no).type=type;
            objects(no).data=data;
    end
end
objects=objects(1:no);
if(verbose),disp('Finished Reading Material file'); end

