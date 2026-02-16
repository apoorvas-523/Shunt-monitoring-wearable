% Clear workspace
clear; 
clc;

% File name
filename = 'NoFlowThird.txt';   

fid = fopen(filename, 'r');
time = [];
temperature = [];

while ~feof(fid)
    
    line1 = fgetl(fid);
    line2 = fgetl(fid);
    
    if ischar(line1) && ischar(line2)
        
        t = sscanf(line1, 'Time (s): %f');
        temp = sscanf(line2, '%f degrees C');
        
        if ~isempty(t) && ~isempty(temp)
            time(end+1,1) = t;
            temperature(end+1,1) = temp;
        end
    end
end

fclose(fid);

% Create table (cleaner for Excel)
T = table(time, temperature);

% Save as Excel file
writetable(T, 'NoFlowThird.xlsx');

disp('Excel file NoFlowThird.xlsx created successfully.');
