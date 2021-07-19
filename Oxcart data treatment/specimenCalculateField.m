% simulating field distribution of APT tip

rect_domain = [3,4,1.75e-4,1.75e-4,-1.75e-4,-1.75e-4,-1.7e-5,1.3e-5,1.3e-5,-1.7e-5]';
rect_movable = [3,4,7.5e-5,7.5e-5,-7.5e-5,-7.5e-5,2.0e-6,4.0e-6,4.0e-6,2.0e-6]';
rect_fixed = [3,4,7.5e-5,7.5e-5,2.5e-5,2.5e-5,-2.0e-6,0,0,-2.0e-6]';
gd = [rect_domain,rect_movable,rect_fixed];


ns = char('rect_domain','rect_movable','rect_fixed');
ns = ns';

sf = 'rect_domain-(rect_movable+rect_fixed)';

dl = decsg(gd,sf,ns);

model = createpde;
geometryFromEdges(model,dl);


pdegplot(model,'EdgeLabels','on','FaceLabels','on')
xlabel('x-coordinate, meters')
ylabel('y-coordinate, meters')
axis([-2e-4, 2e-4,-4e-5, 4e-5])
axis square

V0 = 0;
V1 = 20;
applyBoundaryCondition(model,'dirichlet','Edge',[4,8,9,10],'u',V0);
applyBoundaryCondition(model,'dirichlet','Edge',[1,2,5,6],'u',V0);
applyBoundaryCondition(model,'dirichlet','Edge',[3,7,11,12],'u',V1);


specifyCoefficients(model,'m',0,'d',0,'c',1,'a',0,'f',0);


hmax = 5e-6;
generateMesh(model,'Hmax',hmax);
pdeplot(model)
xlabel('x-coordinate, meters')
ylabel('y-coordinate, meters')
axis([-2e-4, 2e-4,-4e-5, 4e-5])
axis square


results = solvepde(model);


u = results.NodalSolution;
figure
pdeplot(model,'XYData',results.NodalSolution,...
              'ColorMap','jet');

title('Electric Potential');
xlabel('x-coordinate, meters')
ylabel('y-coordinate, meters')
axis([-2e-4, 2e-4,-4e-5, 4e-5])
axis square