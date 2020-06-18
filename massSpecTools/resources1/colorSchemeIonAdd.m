function colorScheme = colorSchemeIonAdd(colorScheme, newIon, selection)
% colorSchemeIonAdd adds new ions to the colorScheme table and adds a new
% color which was not used before.
% 
% colorScheme = colorSchemeIonAdd(colorScheme, newIon, select)
% colorScheme = colorSchemeIonAdd(colorScheme, newIon)
%
% INPUT
% colorScheme = The existing colorScheme
% newIon = Name of the newIon
% selection = 'select' if you want to choose the color
%               if nothing is parsed, the color is randomly generated
% OUTPUT
% colorScheme = the new colorScheme with the new ion added at the end of
%               the table

%% Check for ion name
ionTable = ionConvertName(newIon); % Convert the name in the table format
ionName = ionConvertName(ionTable); % make the correct name

length = size(colorScheme.ion);
ionAlreadyExist = false;
%% Check if ion already exist in colorScheme

for j = 1:length(1,1)
        if colorScheme.ion(j,1) == ionName(1,:)
            disp ('ion already exist in colorScheme')
            match = false; % don't start the color searching loop  
            ionAlreadyExist = true;
        else 
            match = true; 
        end
end
        


%% check if color already exist for another ion, if the color already exist,
%   you need to choose a new color 
n = false;
while match == true
    % add a color to the new ion
    if exist('selection', 'var') & ionAlreadyExist == false; ;
        if n == false
            color = uisetcolor();
            n = true;
        else 
            title = 'color already exists';
            color = uisetcolor(title);
        end
    else
        color = rand(1,3); 
    end
    
    % check if color already exist and change the match variable 
    for i = 1:length(1,1)
            if colorScheme.color(i,1) == color(1,1) && colorScheme.color(i,2) == color(1,2) && colorScheme.color(i,3) == color(1,3);
                match = true; % color already exist in colorScheme
                n = 1; %countnumber for the second 
                i = length(1,1);
            else
                match = false; % color does not exist in colorScheme
            end


    end
end



%% write ionName and color in the color Scheme
if ionAlreadyExist == false
    newIonRow = {ionName, color};
    colorScheme(end+1,:) = newIonRow;
end

end