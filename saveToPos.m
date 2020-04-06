function varargout = saveToPos(pos,fileName)
% saveToPos creates a numatoms*4 matrix out of the pos variable and saves
% it as a binary file made of 4 float with big endian called fileName.pos
%
% saveToPos(pos,'fileName.pos')
% saveToPos(pos)
%
% INPUT
% pos: is a table that contains all the data that will be saved as a binary file
% fileName: is the Name of the file that will be created and will store the data 


%% 
if ~exist('fileName','var')
    [file path ~] = uiputfile('*.pos','Save pos file');
    fileName = [path file];
    
    varargout{1} = fileName;
    
end

%% opens the file
fid = fopen(fileName,'W','b');

disp('File opened...');

%% Convert pos file to Class single
pos = [pos.x pos.y pos.z pos.mc];

%% Get the file length
numatoms=length(pos(:,1));

pos = pos';

%% reshape the matrix to get one row for posfile
mat=reshape(pos,numatoms*4,1);


%% write the matrix as floats
fwrite(fid,mat,'float32');
fclose(fid);
disp('posfile saved');

end