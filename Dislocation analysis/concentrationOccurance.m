function distance = concentrationOccurance(coord,values,conc,dist)

%coord is the coordinate vector of the vertex for this element
%values are the corresponding concentration values
%conc is the average concentration of the bin
%dist is the pseudo-1D coordinate of the bin we are looking at


smaller = values < conc;

%% first we need search for all intervals where the concentration profile
%% is intersecting

crossing = smaller(1:end-1)~=smaller(2:end)

crossing = find(crossing)

distance = zeros(length(crossing),1);

for i=1:length(crossing)
    distance(i) = interp1q([values(crossing(i)); values(crossing(i)+1)], [coord(crossing(i)); coord(crossing(i)+1)], conc);
end


[~,distance] = dsearchn(distance,dist);
distance = distance(1);


end