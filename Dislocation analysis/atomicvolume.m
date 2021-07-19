function vol = atomicvolume(Z)

% density in at/nm^3
% atomic volume in nm^3



switch Z
    case 1 %H
        density = 52.7;
        
    case 2 %He
        density = 28.7;
        
    case 3 %Li
        density = 46.3;

    case 4 %Be
        density = 124.4;      
        
    case 5 %B
        density = 137.2;        
        
    case 6 %C
        density = 113.9;        
        
    case 7 %N
        density = 44.5;        
        
    case 8 %O
        density = 34.7;        
        
    case 9 %F
        density = 53.8;        
        
    case 10 %Ne
        density = 45.5;        
        
    case 11 %Na
        density = 25.3;       
        
    case 12 %Mg
        density = 43;         
        
    case 13 %Al
        density = 60.2;        
        
    case 14 %Si
        density = 49.9;        
        
    case 15 %P
        density = 35.4;        
        
    case 16 %S
        density = 38.8;        
        
    case 17 %Cl
        density = 34.6;        
        
    case 18 %Ar
        density = 26.7;        
        
    case 19 %K
        density = 13.1;        
        
    case 20 %Ca
        density = 23;       
        
    case 21 %Sc
        density = 40.2;     
        
    case 22 %Ti
        density = 56.6;       
        
    case 23 %V
        density = 72.4;
        
    case 24 %Cr
        density = 83.3;       
        
    case 25 %Mn
        density = 81.9;       
        
    case 26 %Fe
        density = 85;       
        
    case 27 %Co
        density = 90.3;       
        
    case 28 %Ni
        density = 91.4;       
        
    case 29 %Cu
        density = 84.7;       
        
    case 30 %Zn
        density = 65.8;       
        
    case 31 %Ga
        density = 51;       
        
    case 32 %Ge
        density = 44.2;
        
    case 33 %As
        density = 46.5;
        
    case 34 %Se
        density = 36.7;
        
    case 35 %Br
        density = 30.4;
        
    case 36 %Kr
        density = 21.5;        
        
    case 37 %Rb
        density = 10.8;
        
    case 38 %Sr
        density = 17.7;
        
    case 39 %Y
        density = 30.3;
        
    case 40 %Zr
        density = 43;
        
    case 41 %Nb
        density = 55.6;
        
    case 42 %Mo
        density = 64.2;
        
    case 44 %Ru
        density = 73.7;
        
    case 45 %Rh
        density = 72.7;        
        
    case 46 %Pd
        density = 70.4;
        
    case 47 %Ag
        density = 58.6;
        
    case 48 %Cd
        density = 46.3;
        
    case 49 %In
        density = 38.2; 
        
    case 50 %Sn
        density = 37;
        
    case 51 %Sb
        density = 33.1;
        
    case 52 %Te
        density = 29.4;
        
    case 53 %I
        density = 23.4;        
        
    case 54 %Xe
        density = 16.8;
        
    case 55 %Cs
        density = 8.5;
        
    case 56 %Ba
        density = 15.8;
        
    case 58 %Ce
        density = 29.1;
        
    case 59 %Pr
        density = 29;
        
    case 60 %Nd
        density = 29.3;
        
    case 72 %Hf
        density = 44.8;
        
    case 73 %Ta
        density = 55.5;        
        
    case 74 %W
        density = 63.6;
        
    case 75 %Re
        density = 68;
        
    case 76 %Os
        density = 71.5;
        
    case 77 %Ir
        density = 70.7;
        
    case 78 %Pt
        density = 66.3;
        
    case 79 %Au
        density = 59;
        
    case 80 %Hg
        density = 42.7;
        
    case 82 %Pb
        density = 32.9;        
        
    case 83 %Bi
        density = 28.3;
        
    case 90 %Th
        density = 30.4;
        
    case 92 %U
        density = 48.2;
        
    otherwise
        vol = 0;
        return 
        
end


vol = 1/density;


end