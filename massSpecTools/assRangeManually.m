function rng = assRangeManually(rng,rangeName,mcbegin,mcend,vol,atoms,color)

rng(end+1).rangeName = rangeName;
rng(end).mcbegin = mcbegin;
rng(end).mcend = mcend;
rng(end).vol = vol;
rng(end).atoms = atoms;


if ~exist('color','var')
    colorDefined = false;
    for r = 1:length(handles.rng)
        if strcmp(handles.rng(r).rangeName,rangeName)
            color = handles.rng(r).color;
            colorDefined = true;
        end
    end
end

rng(end).color = color;