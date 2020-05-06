function [epos,pulse]=readEPOS(fileName)
% function [pos]=readpos(fileName)
% Reads data from a .pos file (4 floats-big endian)
% and extract 1 matrix with x,y,z and m (Nx4)

% the filename is optional. a dialog box will pop up if no file name is
% given

if ~exist('fileName','var')
    [file path] = uigetfile('*.EPOS','Select an epos file');
    fileName = [path file];
    
end




%% opens the file
fid = fopen(fileName, 'r');
disp('epos file is being read...');



%% Reads through the file made of 9 floats, with 8 byte stride (the two
%% integers at the end)
lflo=fread(fid, inf, '9*float32', 8 ,'ieee-be');


%% reads the pulse info from epos
fseek(fid,36,'bof');

pul = fread(fid, inf, '2*uint32', 36 ,'ieee-be');




%% Makes an array with the list of floats
nb=length(lflo)/9;


epos=reshape(lflo, [9 nb]);
epos = single(epos);
epos=epos';


pulse = reshape(pul, [2,nb]);
pulse = pulse';


clear lflo




%% Closes the file
fclose(fid);
disp('OK, file read, variables created.');

end

