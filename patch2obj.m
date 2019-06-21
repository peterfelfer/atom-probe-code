function patch2obj(patch,objName,fileName)
% exports obj file into Wavefront obj. If a list (vector) of patches is
% parsed it will be saved in one obj file. Object names can be parsed in
% 'objNames'



if ~exist('patch','var')
    object = gco;
    patch.vertices = get(object,'vertices');
    patch.faces = get(object,'faces');
end
numPatch = length(patch);

if ~exist('fileName','var')
    [file path] = uiputfile('*.obj','Save *.obj file to');
    
    fileName = [path file];
end

if ~exist('objName','var')
    for p = 1:numPatch
        objName{p} = ['mesh' num2str(p)];
    end
elseif numPatch == 1
    objName{1} = objName;
    
end





fid = fopen(fileName,'wt');

if( fid == -1 )
    error('Cant open file.');
    return;
end

fprintf(fid, '# openVA obj exporter, (c) Peter Felfer, The University of Sydney 2012 \n');


%% writing each patch
offset = 0;

for p = 1:numPatch
    fprintf(fid, 'v %f %f %f\n', patch(p).vertices');
    patch(p).faces =  patch(p).faces + offset;
    offset = offset + length(patch(p).vertices(:,1));
    
end

%% writing faces for individual objects
for p = 1:numPatch
    oName = ['o ' objName{p} '\n'];
    fprintf(fid, oName);
    fprintf(fid, 'f %u %u %u\n', patch(p).faces');
end


fclose(fid);
clear fid;
end