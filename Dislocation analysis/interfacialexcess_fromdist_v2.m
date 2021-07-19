function [excess] = interfacialexcess_fromdist_v2(vap,xrng,dim,thresh,plotelements)
%implement: XRNG SUPPORT, OUTPUT AS VECTOR



if ~exist('plotelements','var')
    plotelements = 101;
end

%calculates the interfacial excess for a vap file for species within the
%ranges specified in the two-colum vector rng

%% used fixed variables not passed on

%span for moving average used in curve smoothing
span = round(length(vap)/10);

%fraction of maximum of derivative used as threshold for the
%interpolation of linear fits before and after boundary
%thresh = 0.2;

% #elements truncated from derivative curve to avoid edge effects
trunc = round(span/3);


%% sort the vap file
%dimensionality translates into the distance metric used. 0D means we use
%the distance to the vertex (6th value in the vap file), 1D means we use
%the distance to the vertex normal (8th vap value), 2D means we use
%distance along the vertex normal (7th value).

switch dim
    case 0
        dim = 6;
    case 1
        dim = 8;
    case 2
        dim = 7;
    otherwise
        disp('Please choose a valid dimensionality!');
end


vap(:,dim) = abs(vap(:,dim));

vap = sortrows(vap,dim);
    
numatoms = length(vap);


%% next we'll find out which chemical elements are actually used


numrng = length(xrng.ranges);

elements = zeros(numrng,100);

for i=1:numrng
    numrngatoms = length(xrng.ranges{i}.ions{1}.atoms);
    for k=1:numrngatoms
        elements(i,k) = uint8(str2double(xrng.ranges{i}.ions{1}.atoms{k}.atomicnumber));
    end    
    
end

elements = sort(unique(nonzeros(elements)));

numelements = length(elements);


%% this means we need a matrix of 'numatoms' * 'elements' to hold the
%% occurances

for i=1:numrng
    ranges(i,1) = str2double(xrng.ranges{i}.masstochargebegin);
    ranges(i,2) = str2double(xrng.ranges{i}.masstochargeend);
    
end

% holds all the occurance of the elements
elementcount = zeros(numatoms,numelements);

for i=1:numrng
    
    
    inrange = (vap(:,4)>=ranges(i,1))&(vap(:,4)<=ranges(i,2));
   
    
    numrngatoms = length(xrng.ranges{i}.ions{1}.atoms);
    for k=1:numrngatoms
        currentelement = uint8(str2double(xrng.ranges{i}.ions{1}.atoms{k}.atomicnumber));

        elementcount(:,elements==currentelement) = elementcount(:,elements==currentelement) + inrange;
        
        
    end 

end

%OK, WE HAVE THE EXCESS FOR THIS VERTEX AND EVERY ELEMENT!
excess = zeros(100,1); %again, only up to Fermium! Just dont atom probe anything containing Mendelevium, ok :-)



% now, the cumulative sums
elementcount = cumsum(elementcount,1);

for i=1:numelements 
    
    %% calculation of the derivative curve and thresholds for linear fits
    smoothcumulative = smooth(elementcount(:,i),span);
    derivative = diff(smoothcumulative);

    
    
    %set the first and last few elements 0

    derivative(1:trunc)=0;
    len=length(derivative);
    derivative((len-trunc):len)=0;

    
    %find limit of interpolation 
    maxvalue = max(derivative);
    maxindex = 1;
    thresh=maxvalue*thresh;
    upperlimit = maxindex+1;



    if maxvalue>0
        while derivative(upperlimit)>thresh
            upperlimit=upperlimit+1; 
        end

    end
    
    
    if upperlimit>len/2
        upperlimit = len/2
    end
    
    

    % maxindex and upperlimit are now defined


    
    
    %% linear interpolation and calculation of interfacial excess

    x = 1:numatoms;
    x = x';


    interpolationbefore = 0;
    interpolationafter = polyfit(x(upperlimit:end),elementcount(upperlimit:end,i),1);



    %%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    excess(elements(i)) = polyval(interpolationafter,maxindex);
    %%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% plotting of the curves if the element is selected for plotting




    if sum(plotelements==elements(i))
    
         % plots the cumulative curve
    
        figure(1); subplot(2,1,1);
        plot(x,elementcount(:,i),'linewidth',2) % plots cumulative number of selected atoms VS cumulative number of all atoms
        xlabel('\bf \Sigma of all atoms','fontsize',14);ylabel(['\bf \Sigma of ' sym4number(elements(i)) ' atoms'],'fontsize',14); % add a legend
        title('\bf Cumulative diagram ','fontsize',16);
        set(gca, 'FontSize', 20);
        maxcum=max(elementcount(:,i));
        if maxcum==0
            maxcum=1;
        end
    
        axis([0 max(x) 0 maxcum]);
    
    
        % plots the derivative curve
    
        figure(1); subplot(2,1,2);
        plot(derivative,'linewidth',2) 
        xlabel('\bf \Sigma of all atoms','fontsize',14);ylabel('\bf derivative','fontsize',14); % add a legend
        title('\bf Derivative curve of the cumulative diagram','fontsize',16)
        set(gca, 'FontSize', 20);
        maxder=max(derivative);
        if maxder==0
            maxder=1;
        end
        axis([0 max(x) 0 maxder]);
    
        %plots the linear regressions
    
        %before
        regressionbefore = polyval(interpolationbefore,x);
        figure(1); subplot(2,1,1);
        hold on; plot(x,regressionbefore,'k--','linewidth',1)
    
        %after
        regressionafter = polyval(interpolationafter,x);
        figure(1); subplot(2,1,1);
        hold on; plot(x,regressionafter,'k--','linewidth',1)
    
        % delineate excess
        figure(1); subplot(2,1,1);hold on;
        plot([maxindex maxindex],[regressionbefore(maxindex) regressionafter(maxindex)],'k--')
    
        %value of interfacial excess
        text(numatoms/2, 0, ['    \bfexcess = ' num2str(excess(elements(i)))],'fontsize',16);
    
    end
    
    
end


end





function sym = sym4number(Z)



switch Z
    case 1 
        sym = 'H';
        
    case 2 
        sym = 'He';
        
    case 3
        sym = 'Li';

    case 4
        sym = 'Be';
        
    case 5 
        sym = 'B';
        
    case 6 
        sym = 'C';
        
    case 7 
        sym = 'N';
        
    case 8 
        sym = 'O';
        
    case 9 
        sym = 'F';
        
    case 10 
        sym = 'Ne';
        
    case 11 
        sym = 'Na';
        
    case 12 
        sym = 'Mg';
        
    case 13 
        sym = 'Al';
        
    case 14 
        sym = 'Si';
        
    case 15 
        sym = 'P';
        
    case 16 
        sym = 'S';
        
    case 17 
        sym = 'Cl';
        
    case 18 
        sym = 'Ar';
        
    case 19 
        sym = 'K';
        
    case 20 
        sym = 'Ca';
        
    case 21 
        sym = 'Sc';
        
    case 22 
        sym = 'Ti';
        
    case 23 
        sym = 'V';
        
    case 24 
        sym = 'Cr';
        
    case 25 
        sym = 'Mn';
        
    case 26 
        sym = 'Fe';
        
    case 27 
        sym = 'Co';
        
    case 28 
        sym = 'Ni';
        
    case 29 
        sym = 'Cu';
        
    case 30 
        sym = 'Zn';
        
    case 31 
        sym = 'Ga';
        
    case 32 
        sym = 'Ge';
        
    case 33 
        sym = 'As';
        
    case 34 
        sym = 'Se';
        
    case 35 
        sym = 'Br';
        
    case 36 
        sym = 'Kr';
        
    case 37 
        sym = 'Rb';
        
    case 38 
        sym = 'Sr';
        
    case 39 
        sym = 'Y';
        
    case 40 
        sym = 'Zr';
        
    case 41 
        sym = 'Nb';
        
    case 42 
        sym = 'Mo';
        
    case 44 
        sym = 'Ru';
        
    case 45 
        sym = 'Rh';
        
    case 46 
        sym = 'Pd';
        
    case 47 
        sym = 'Ag';
        
    case 48 
        sym = 'Cd';
        
    case 49 
        sym = 'In';
        
    case 50 
        sym = 'Sn';
        
    case 51 
        sym = 'Sb';
        
    case 52 
        sym = 'Te';
        
    case 53 
        sym = 'I';
        
    case 54 
        sym = 'Xe';
        
    case 55 
        sym = 'Cs';
        
    case 56 
        sym = 'Ba';
        
    case 58 
        sym = 'Ce';
        
    case 59 
        sym = 'Pr';
        
    case 60 
        sym = 'Nd';
        
    case 72 
        sym = 'Hf';
        
    case 73 
        sym = 'Ta';
        
    case 74 
        sym = 'W';
        
    case 75 
        sym = 'Re';
        
    case 76 
        sym = 'Os';
        
    case 77 
        sym = 'Ir';
        
    case 78 
        sym = 'Pt';
        
    case 79 
        sym = 'Au';
        
    case 80 
        sym = 'Hg';
        
    case 82 
        sym = 'Pb';
        
    case 83 
        sym = 'Bi';
        
    case 90 
        sym = 'Th';
        
    case 92 
        sym = 'U';
        
    otherwise
        disp(' symbol undefined!');
        
end
    


end




