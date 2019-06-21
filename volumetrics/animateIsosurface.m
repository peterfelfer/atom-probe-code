function mov = animateIsosurface(conc,gv,cmin,cmax,nFrames,fileName)
%creates an animation of the evolution of an isovalue from cmin to cmax in
%N steps

%creates turntable animation of the current figure and returns movie
%variable. deg is the step in degrees

mainFig = gcf;

%histFig = figure;
%hist(conc(:),100);

if ~exist('fileName','var')
    [file path] = uigetfile('*.avi','export movie');
    fileName = [path file];
end

set(mainFig,'Color','w');
%set(histFig,'Color','w');

%axis vis3d

t = text(10,10,10,'conc');

c = linspace(cmin,cmax,nFrames);

for f = 1:nFrames
    fv = isosurface(gv{2}, gv{1}, gv{3}, conc,c(f));
    p = patch(fv,'FaceColor',[.5 .5 .5]); axis equal; rotate3d on;
    set(t,'String',num2str(c(f)));
    frame = getframe(gcf);
    mov(f) = frame;
    %camorbit(deg,0);
    
    delete(p);
end

myVideo = VideoWriter(fileName);

myVideo.FrameRate = 30;  % Default 30
myVideo.Quality = 50;    % Default 75

open(myVideo);
writeVideo(myVideo, mov);
close(myVideo);
