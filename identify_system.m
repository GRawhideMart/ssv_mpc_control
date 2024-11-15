clear all; 
close all;
clc;

% Define ranges for slip values
slipRange = 0:0.05:0.4; % Range from 0 to 0.4

% Preallocate an array to store the results (optional)
results = cell(length(slipRange), length(slipRange));

% Loop over all combinations of slip values
for i = 1:length(slipRange)
    s_R = slipRange(i);
    for j = 1:length(slipRange)
        s_L = slipRange(j);

        % Set the slip values in the base workspace
        assignin('base', 's_R', s_R);
        assignin('base', 's_L', s_L);

        % Set the slip values in the Simulink model

        
        % Run the simulation
        simOut = sim('system_identification.slx'); 
        
        % Extract data from simulation outputs
        v_xP = simOut.get('v_xP').data;
        v_yP = simOut.get('v_yP').data;
        x_P = simOut.get('x_P').data;
        y_P = simOut.get('y_P').data;
        tout = simOut.get('tout');
        Ts = tout(2) - tout(1);
        clear tout; % For memory saving
        clear simOut; % For memory saving
        
        % Create iddata object
        data = iddata([x_P, y_P], [v_xP, v_yP], Ts);
        
        % Store iddata in a cell for future study
        results{i,j}.s_R = s_R;
        results{i,j}.s_L = s_L;
        results{i,j}.data = data;
        results{i,j}.sys = tfest(data, 2);
        results{i,j}.G11 = results{i,j}.sys(1,1);
        results{i,j}.G12 = results{i,j}.sys(1,2);
        results{i,j}.G21 = results{i,j}.sys(2,1);
        results{i,j}.G22 = results{i,j}.sys(2,2);
    end
end