function num = elementAtomicNumber(element)
% elementAtomicNumber produces the atomic number Z of the input element
%
% INPUT: element: string of the element symbol, e.g., ('H')
%
% OUTPUT: num: atomic number of the input element 
%
% notice: element symbols with corresponding atomic number Z of 1 to 118 
%         are stored in the function

switch element
    case 'H'
        num = 1;
        
    case 'He'
        num = 2;
        
    case 'Li'
        num = 3;

    case 'Be'
        num = 4;
        
    case 'B'
        num = 5;
        
    case 'C' 
        num = 6;
        
    case 'N' 
        num = 7;
        
    case 'O'
        num = 8;
        
    case 'F'
        num = 9;
        
    case 'Ne'
        num = 10;
        
    case 'Na' 
        num = 11;
        
    case 'Mg'
        num = 12;
        
    case 'Al'
        num = 13;
        
    case 'Si' 
        num = 14;
        
    case 'P' 
        num = 15;
        
    case 'S'
        num = 16;
        
    case 'Cl'
        num = 17;
        
    case 'Ar'
        num = 18;
        
    case 'K' 
        num = 19;
        
    case 'Ca'
        num = 20;
        
    case 'Sc' 
        num = 21;
        
    case 'Ti' 
        num = 22;
        
    case 'V' 
        num = 23;
        
    case 'Cr' 
        num = 24;
        
    case 'Mn' 
        num = 25;
        
    case 'Fe' 
        num = 26;
        
    case 'Co' 
        num = 27;
        
    case 'Ni' 
        num = 28;
        
    case 'Cu' 
        num = 29;
        
    case 'Zn' 
        num = 30;
        
    case 'Ga' 
        num = 31;
        
    case 'Ge' 
        num = 32;
        
    case 'As' 
        num = 33;
        
    case 'Se'
        num = 34;
        
    case 'Br' 
        num = 35;
        
    case 'Kr' 
        num = 36;
        
    case 'Rb' 
        num = 37;
        
    case 'Sr' 
        num = 38;
        
    case 'Y' 
        num = 39;
        
    case 'Zr' 
        num = 40;
        
    case 'Nb' 
        num = 41;
        
    case 'Mo' 
        num = 42;
        
    case 'Ru'
        num = 44;
        
    case 'Rh' 
        num = 45;
        
    case 'Pd'
        num = 46;
        
    case 'Ag' 
        num = 47;
        
    case 'Cd'
        num = 48;
        
    case 'In'
        num = 49;
        
    case 'Sn'
        num = 50;
        
    case 'Sb' 
        num = 51;
        
    case 'Te'
        num = 52;
        
    case 'I'
        num = 53;
        
    case 'Xe'
        num = 54;
        
    case 'Cs'
        num = 55;
        
    case 'Ba'
        num = 56;
        
    case 'La'
        num = 57;
        
    case 'Ce'
        num = 58;
        
    case 'Pr'
        num = 59;
        
    case 'Nd'
        num = 60;
        
    case 'Pm'
        num = 61;
        
    case 'Sm'
        num = 62;
        
    case 'Eu'
        num = 63;
        
    case 'Gd'
        num = 64;
        
    case 'Tb'
        num = 65;
        
    case 'Dy'
        num = 66;
        
    case 'Ho'
        num = 67;
        
    case 'Er'
        num = 68;
        
    case 'Tm'
        num = 69;
        
    case 'Yb'
        num = 70;
        
    case 'Lu'
        num = 71;
        
    case 'Hf'
        num = 72;
        
    case 'Ta'
        num = 73;
        
    case 'W'
        num = 74;
        
    case 'Re'
        num = 75;
        
    case 'Os'
        num = 76;
        
    case 'Ir'
        num = 77;
        
    case 'Pt'
        num = 78;
        
    case 'Au'
        num = 79;
        
    case 'Hg'
        num = 80;
        
    case 'Tl'
        num = 81;
        
    case 'Pb'
        num = 82;
        
    case 'Bi'
        num = 83;
        
    case 'Po'
        num = 84;
        
    case 'At'
        num = 85;
        
    case 'Rn'
        num = 86;
        
    case 'Fr'
        num = 87;
        
    case 'Ra'
        num = 88;
        
    case 'Ac'
        num = 89;
        
    case 'Th'
        num = 90;
        
    case 'Pa'
        num = 91;
        
    case 'U'
        num = 92;
        
    case 'Np'
        num = 93;
        
    case 'Pu'
        num = 94;
        
    case 'Am'
        num = 95;
        
    case 'Cm'
        num = 96;
        
    case 'Bk'
        num = 97;
        
    case 'Cf'
        num = 98;
        
    case 'Es'
        num = 99;
        
    case 'Fm'
        num = 100;
        
    case 'Md'
        num = 101;
        
    case 'No'
        num = 102;
        
    case 'Lr'
        num = 103;
        
    case 'Rf'
        num = 104;
        
    case 'Db'
        num = 105;
        
    case 'Sg'
        num = 106;
        
    case 'Bh'
        num = 107;
        
    case 'Hs'
        num = 108;
        
    case 'Mt'
        num = 109;
        
    case 'Ds'
        num = 110;
        
    case 'Rg'
        num = 111;
        
    case 'Uub'
        num = 112;
        
    case 'Uzt'
        num = 113;
        
    case 'Uuq'
        num = 114;
        
    case 'Uup'
        num = 115;
        
    case 'Uuh'
        num = 116;
        
    case 'Uus'
        num = 117;
        
    case 'Uuo'
        num = 118;
        
    otherwise
        num = 0;
        disp([' element undefined!' Z]);
end