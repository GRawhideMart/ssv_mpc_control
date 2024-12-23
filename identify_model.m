% Initialize variables for storing results
s_L_range = 0:0.01:0.5;
s_R_range = 0:0.01:0.5;
num_points = length(s_L_range) * length(s_R_range);
results = zeros(num_points, 10); % 2 slip values + 7 coefficients

% Create a waitbar for progress tracking
h = waitbar(0, 'Processing slip values...');
counter = 1;

% Open file for writing
fileID = fopen('system_identification_results.csv', 'w');
% Write header
fprintf(fileID, 's_L,s_R,b2,b1,b0,a3,a2,a1,a0\n');

% Nested loops for all combinations of s_L and s_R
for s_L = s_L_range
    for s_R = s_R_range
        % Run simulation
        out = sim('system_identification_ssv.slx');
        
        % Get simulation data
        v_xP = out.get('v_xP').data;
        x_P = out.get('x_P').data;
        tout = out.get('tout');
        Ts = tout(2) - tout(1);
        data_11 = iddata(x_P, v_xP, Ts);
        
        % System identification
        init_sys = idtf([1 1 1], [1 1 1 0]);
        init_sys.Structure.Denominator.Free(end) = false;
        opts = tfestOptions('InitializeMethod', 'all');
        G11 = tfest(data_11, init_sys, opts);
        
        % Extract coefficients
        [num, den] = tfdata(G11, 'v');
        
        % Store results
        results(counter, :) = [s_L, s_R, num, den];
        
        % Write to CSV
        fprintf(fileID, '%.4f,%.4f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n', ...
            s_L, s_R, num(1), num(2), num(3), den(1), den(2), den(3), den(4));
        
        % Update progress bar
        waitbar(counter/num_points, h);
        counter = counter + 1;
    end
end

% Close file and clean up
fclose(fileID);
close(h);

% Display completion message
fprintf('System identification completed. Results saved to system_identification_results.csv\n');
