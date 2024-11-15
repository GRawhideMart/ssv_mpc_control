clear all;
close all;
clc;

assignin('base', 's_R', 0.2);
assignin('base', 's_L', 0.2);

simOut = sim('system_identification.slx'); 
        
% Extract data from simulation outputs
v_xP = simOut.get('v_xP').data;
v_yP = simOut.get('v_yP').data;
x_P = simOut.get('x_P').data;
y_P = simOut.get('y_P').data;
tout = simOut.get('tout');
Ts = tout(2) - tout(1);
clear tout;
clear simOut;

data = iddata(y_P, v_xP, Ts);

% Define the maximum number of poles and zeros
max_poles = 3;
max_zeros = 2; % The number of zeros must be less than the number of poles

% Initialize a data structure to store the metrics
metrics = struct();

% Loop over all possible models
for i = 1:max_poles
    for j = 1:min(i-1, max_zeros)  % Ensure the number of zeros is less than the number of poles
        
        % Create the model with tfest (replace with your code)
        model = tfest(data, i, j); 
        
        % Calculate the desired metrics (replace with your metrics)
        [y,fit,x0] = compare(model, data);
        fit_percentage = fit;
        fpe_value = fpe(model);
        aic_value = aic(model);
        
        % Store the metrics in the data structure
        metrics.(sprintf('model_p%d_z%d', i, j)).poles = i;
        metrics.(sprintf('model_p%d_z%d', i, j)).zeros = j;
        metrics.(sprintf('model_p%d_z%d', i, j)).fit = fit_percentage;
        metrics.(sprintf('model_p%d_z%d', i, j)).fpe = fpe_value;
        metrics.(sprintf('model_p%d_z%d', i, j)).aic = aic_value;
    end
end

% Find the best model based on a chosen metric (e.g., AIC)
best_aic = Inf;
best_model_name = '';
model_names = fieldnames(metrics);
for i = 1:numel(model_names)
    model_name = model_names{i};
    model_aic = metrics.(model_name).aic;
    if model_aic < best_aic
        best_aic = model_aic;
        best_model_name = model_name;
    end
end

% Display the best model
fprintf('The best model is: %s\n', best_model_name);
fprintf('AIC: %f\n', best_aic);

% Access the best model's metrics
best_model_metrics = metrics.(best_model_name);

% Save the data structure to a .mat file
save('model_metrics.mat', 'metrics');