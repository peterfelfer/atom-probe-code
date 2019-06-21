function posVar2obj(pos,fileName)

if ~exist('fileName','var')
    [file path] = uiputfile('*.obj','writing obj files');
    fileName = [path file(1:end-4)];
end



fid = fopen([fileName '.obj'],'wt');

if( fid == -1 )
    error('Cant open file.');
    return;
end


fprintf(fid, '# openVA pos to obj exporter, (c) Peter Felfer, The University of Sydney 2012 \n');
fprintf(fid, 'v %f %f %f\n',pos(:,1:3)');
fclose(fid);
clear fid;


end
