function writerrng(rng,fileName)
%wries a rng variable to a CAMECA *.rrng range file
%IMPORTANT: since this format is able to reflect isotopes and chargestates,
%this exporter only works with rng variables without special range
%designations!

if ~exist('fileName','var')
    [file path] = uiputfile('*.rng','export rrng file','rng');
end

txt = [];
%% ion definition section
ionCount = ;




%% range definition section
