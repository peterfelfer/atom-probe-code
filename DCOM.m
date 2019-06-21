function fv = DCOM(fv,pos,rad,lim)
%performs DCOM relaxation until the DCOM energy is converged to lim times
%the initial DCOM energy if lin < 1, if lim > 1, it performs lim number of steps. rad is the influence radius, pos are the
%reference points.



[fv, energy(1)] = DCOMstep(fv,pos,rad);

i = 1;

if lim <1
    while energy(i) > energy(1) * lim;
        i = i + 1;
        [fv, energy(i)] = DCOMstep(fv,pos,rad);
        disp(['DCOM energy: ' num2str(energy(i))]);
    end
end

if lim > 1
    for i = 1:lim
        [fv, energy(i)] = DCOMstep(fv,pos,rad);
        disp(['DCOM energy: ' num2str(energy(i))]);
    end
end

disp(['DCOM steps: ' num2str(i)]);

if false
    figure('Name','DCOM convergence');
    plot(energy,'-g');
end