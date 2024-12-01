clear all;
close all;
clc;

% Initialize variables for storing results
s_L_range = 0:0.01:0.5;
s_R_range = 0:0.01:0.5;
num_points = length(s_L_range) * length(s_R_range);
results = zeros(num_points, 3); % 2 slip values + coefficient K

% Create a waitbar for progress tracking
h = waitbar(0, 'Processing slip values...');
counter = 1;

% Open file for writing
fileID = fopen('error_identification_results.csv', 'w');
% Write header
fprintf(fileID, 's_L,s_R,K\n');

% Nested loops for all combinations of s_L and s_R
for s_L = s_L_range
    for s_R = s_R_range
        % Run simulation
        out = sim('system_identification.slx');
        
        % Get simulation data
        v_xP = out.get('v_xP').data;
        e = out.get('e').data;
        tout = out.get('tout');
        Ts = tout(2) - tout(1);
        data_error = iddata(e, v_xP, Ts);
        
        % System identification
        % Structure: K/(s(s+a)) = K/[s^2 + as]
        init_sys = idtf([1], [1 0 0]);
        init_sys.Structure.Denominator.Free(end-1:end) = false;
        opts = tfestOptions('InitializeMethod', 'all');
        G_error = tfest(data_error, init_sys, opts);
        
        % Extract coefficients
        [num, den] = tfdata(G_error, 'v');
        K = num(1);
        %a = den(2);
        
        % Store results
        results(counter, :) = [s_L, s_R, K];
        
        % Write to CSV
        fprintf(fileID, '%.4f,%.4f,%.6f\n', s_L, s_R, K);
        
        % Update progress bar
        waitbar(counter/num_points, h);
        counter = counter + 1;
    end
end

% Close file and clean up
fclose(fileID);
close(h);

% Display completion message
fprintf('Error identification completed. Results saved to error_identification_results.csv\n');
