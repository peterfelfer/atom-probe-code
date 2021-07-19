function [conc, variance] = atomicConcentration(mc,xrng)


%% mc must be a cell array!!!!! in return we can use parfor!
numvols = length(mc);


% conc will be a cell array of same length.
conc = cell(numvols,1);
variance = conc;



numrng = length(xrng.ranges);

ranges = zeros(numrng,2); %contains all ranging windows

for i=1:numrng
    ranges(i,1) = str2double(xrng.ranges(i).masstochargebegin);
    ranges(i,2) = str2double(xrng.ranges(i).masstochargeend);
    
end
    

% checks for overlapping ranges
checkranges = sortrows(ranges,1);

if sum(~(checkranges(1:end-1,2)<=checkranges(2:end,1)))
    disp('one or more ranges overlap');
end



parfor_progress(numvols);

for i=1:numvols
    [conc{i},variance{i}] = concentrationsFromElementCount(elementCount(assignToRange(mc{i},ranges),xrng));
    parfor_progress;
end


parfor_progress(0);


end






%% subfunction that takes a mc vector and counts the atoms that are in the
%% range for each range
function inrange = assignToRange(mc,ranges)

numrng = size(ranges,1);
inrange = zeros(numrng,1);

for i=1:numrng
    
    inrange(i) = sum((mc>=ranges(i,1))&(mc<=ranges(i,2)));   
end


end




%% subfunction that takes an a vector with the amount of counts per ranges
%% with the corresponding xrng struct and returns a vector with the counts
%% per chemical element
function elements = elementCount(inrange,xrng)

%only elements up to Fermium are considered! Just dont atom probe anything containing Mendelevium, ok :-)
elements = zeros(100,1);

numrng = length(xrng.ranges);

for i=1:numrng
    numatoms = length(xrng.ranges(i).ions(1).atoms);
    for k=1:numatoms
        atoms(k) = uint8(str2double(xrng.ranges(i).ions(1).atoms(k).atomicnumber));
    end
    elements(atoms) = elements(atoms) + inrange(i);
    
    
end

end






%% subfunction that turns the element count into actual concentrations
%% (fractions, not percent!
function [conc,variance] = concentrationsFromElementCount(elementcount)

% again, dont probe anything heavier than Fermium
conc = zeros(100,1);
variance = conc;


%to avoid NANs, doesnt change actual concentrations
atomcount = sum(elementcount);
if atomcount == 0
    atomcount = 1;
end

for i=1:100
    conc(i) = elementcount(i)/atomcount;
    
    [~,V] = binostat(elementcount(i),conc(i));
    
    variance(i) = V/elementcount(i);
    
    
end





end




%Copyright (c) 2011, Jeremy Scheff
%All rights reserved.

%Redistribution and use in source and binary forms, with or without 
%modification, are permitted provided that the following conditions are 
%met:
%
%    * Redistributions of source code must retain the above copyright 
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in 
%      the documentation and/or other materials provided with the distribution
%      
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%POSSIBILITY OF SUCH DAMAGE.






function percent = parfor_progress(N)
%PARFOR_PROGRESS Progress monitor (progress bar) that works with parfor.
%   PARFOR_PROGRESS works by creating a file called parfor_progress.txt in
%   your working directory, and then keeping track of the parfor loop's
%   progress within that file. This workaround is necessary because parfor
%   workers cannot communicate with one another so there is no simple way
%   to know which iterations have finished and which haven't.
%
%   PARFOR_PROGRESS(N) initializes the progress monitor for a set of N
%   upcoming calculations.
%
%   PARFOR_PROGRESS updates the progress inside your parfor loop and
%   displays an updated progress bar.
%
%   PARFOR_PROGRESS(0) deletes parfor_progress.txt and finalizes progress
%   bar.
%
%   To suppress output from any of these functions, just ask for a return
%   variable from the function calls, like PERCENT = PARFOR_PROGRESS which
%   returns the percentage of completion.
%
%   Example:
%
%      N = 100;
%      parfor_progress(N);
%      parfor i=1:N
%         pause(rand); % Replace with real code
%         parfor_progress;
%      end
%      parfor_progress(0);
%
%   See also PARFOR.

% By Jeremy Scheff - jdscheff@gmail.com - http://www.jeremyscheff.com/

error(nargchk(0, 1, nargin, 'struct'));

if nargin < 1
    N = -1;
end

percent = 0;
w = 50; % Width of progress bar

if N > 0
    f = fopen('parfor_progress.txt', 'w');
    if f<0
        error('Do you have write permissions for %s?', pwd);
    end
    fprintf(f, '%d\n', N); % Save N at the top of progress.txt
    fclose(f);
    
    if nargout == 0
        disp(['  0%[>', repmat(' ', 1, w), ']']);
    end
elseif N == 0
    delete('parfor_progress.txt');
    percent = 100;
    
    if nargout == 0
        disp([repmat(char(8), 1, (w+9)), char(10), '100%[', repmat('=', 1, w+1), ']']);
    end
else
    if ~exist('parfor_progress.txt', 'file')
        error('parfor_progress.txt not found. Run PARFOR_PROGRESS(N) before PARFOR_PROGRESS to initialize parfor_progress.txt.');
    end
    
    f = fopen('parfor_progress.txt', 'a');
    fprintf(f, '1\n');
    fclose(f);
    
    f = fopen('parfor_progress.txt', 'r');
    progress = fscanf(f, '%d');
    fclose(f);
    percent = (length(progress)-1)/progress(1)*100;
    
    if nargout == 0
        perc = sprintf('%3.0f%%', percent); % 4 characters wide, percentage
        disp([repmat(char(8), 1, (w+9)), char(10), perc, '[', repmat('=', 1, round(percent*w/100)), '>', repmat(' ', 1, w - round(percent*w/100)), ']']);
    end
end

end



















