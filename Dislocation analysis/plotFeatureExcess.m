function plotFeatureExcess(verts,excess,elements,dim,triangulation,factors)

EPSILON = 0.0001;
plots = length(elements);



if exist('factors','var')
    
    for i=1:plots
        excess(elements(i),:)=excess(elements(i),:)*factors(i);
    end
    
end


belowzero = excess<0;

absexcess = abs(excess);


positiveexcess = absexcess.*~belowzero;
positiveexcess(positiveexcess==0) = EPSILON;
negativeexcess = absexcess.*belowzero;
negativeexcess(negativeexcess==0) = EPSILON;


for i=1:plots
    

    h(i) = subplot(1,plots,i);
    
    hold(h(i));
    
    title([ sym4number(elements(i)) ' excess']);
    
    
    if dim==1
        plot3(verts(:,1),verts(:,2),verts(:,3),'k--');
    
    
        scatter3(verts(:,1),verts(:,2),verts(:,3),positiveexcess(elements(i),:)','MarkerFaceColor','g','MarkerEdgeColor','k');
        scatter3(verts(:,1),verts(:,2),verts(:,3),negativeexcess(elements(i),:)','MarkerFaceColor','b','MarkerEdgeColor','k');
    
    end
    
    
    
    if dim==2
        trisurf(triangulation,verts(:,1),verts(:,2),verts(:,3),excess(elements(i),:));
        shading interp;
    end
    
    
    
    
    
    
    
    
    
    
    axis equal;
     
     
     
end

hlink = linkprop(h,{'CameraPosition','CameraUpVector'});
key = 'graphics_linkprop';
% Store link object on first subplot axes
setappdata(h(1),key,hlink); 

rotate3d on


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