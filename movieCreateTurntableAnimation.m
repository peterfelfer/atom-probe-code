function mov = movieCreateTurntableAnimation(deg,fileName)
% creates turntable animation of the current figure and returns movie
% variable.
%
% 
%
% INPUTS
% deg:      step sice in degree in which the animation rotates. determines
%           the length and speed of the film.
% fileName: name under which the film is saved.
%
% OUTPUT
%           movie of the turning atom probe tip.


if ~exist('fileName','var')
    [file path] = uigetfile('*.avi','export movie');
    fileName = [path file];
end

set(gcf,'Color','w');
axis vis3d

nFrames = 360/deg;

for f = 1:nFrames
    frame = getframe(gcf);
    mov(f) = frame;
    camorbit(deg,0);
end

myVideo = VideoWriter(fileName);

myVideo.FrameRate = 30;  % Default 30
myVideo.Quality = 50;    % Default 75

open(myVideo);
writeVideo(myVideo, mov);
close(myVideo);
