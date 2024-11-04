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

function visualize_bode_plots()
    % Create the main figure
    fig = figure('Position', [100 100 1200 1000], 'Name', 'Interactive Bode Plots');
    
    % Create sliders for s_L and s_R
    s_L_slider = uicontrol('Style', 'slider', ...
        'Position', [50 20 300 20], ...
        'Min', 0, 'Max', 0.4, ...
        'Value', 0, ...
        'SliderStep', [0.05/0.4 0.05/0.4]);
    s_R_slider = uicontrol('Style', 'slider', ...
        'Position', [400 20 300 20], ...
        'Min', 0, 'Max', 0.4, ...
        'Value', 0, ...
        'SliderStep', [0.05/0.4 0.05/0.4]);
    
    % Add labels for sliders
    uicontrol('Style', 'text', ...
        'Position', [50 45 300 20], ...
        'String', 'Left Slip (s_L)');
    uicontrol('Style', 'text', ...
        'Position', [400 45 300 20], ...
        'String', 'Right Slip (s_R)');
    
    % Create value displays
    s_L_text = uicontrol('Style', 'text', ...
        'Position', [50 0 300 20]);
    s_R_text = uicontrol('Style', 'text', ...
        'Position', [400 0 300 20]);
    
    % Create subplots for Bode plots (2 rows for each transfer function)
    for i = 1:4
        subplot(4,2,(i-1)*2+1); grid on; % Magnitude plot
        subplot(4,2,i*2); grid on;       % Phase plot
    end
    
    % Update function for sliders
    function update_plots(~,~)
        s_L_val = get(s_L_slider, 'Value');
        s_R_val = get(s_R_slider, 'Value');
        
        % Find nearest indices in slipRange
        slipRange = 0:0.05:0.4;
        [~, i_R] = min(abs(slipRange - s_R_val));
        [~, i_L] = min(abs(slipRange - s_L_val));
        
        % Update text displays
        set(s_L_text, 'String', sprintf('s_L = %.2f', s_L_val));
        set(s_R_text, 'String', sprintf('s_R = %.2f', s_R_val));
        
        % Get transfer functions for current slip values
        G11 = results{i_R,i_L}.G11;
        G12 = results{i_R,i_L}.G12;
        G21 = results{i_R,i_L}.G21;
        G22 = results{i_R,i_L}.G22;
        
        % Define frequency vector for bode plots
        w = logspace(-2, 2, 1000);
        
        % Plot G11
        [mag11,phase11,w11] = bode(G11,w);
        subplot(4,2,1);
        semilogx(w11(:),20*log10(squeeze(mag11))); grid on;
        title(sprintf('G11 Magnitude (s_L=%.2f, s_R=%.2f)', s_L_val, s_R_val));
        ylabel('Magnitude (dB)');
        
        subplot(4,2,2);
        semilogx(w11(:),squeeze(phase11)); grid on;
        title('G11 Phase');
        ylabel('Phase (deg)');
        
        % Plot G12
        [mag12,phase12,w12] = bode(G12,w);
        subplot(4,2,3);
        semilogx(w12(:),20*log10(squeeze(mag12))); grid on;
        title(sprintf('G12 Magnitude (s_L=%.2f, s_R=%.2f)', s_L_val, s_R_val));
        ylabel('Magnitude (dB)');
        
        subplot(4,2,4);
        semilogx(w12(:),squeeze(phase12)); grid on;
        title('G12 Phase');
        ylabel('Phase (deg)');
        
        % Plot G21
        [mag21,phase21,w21] = bode(G21,w);
        subplot(4,2,5);
        semilogx(w21(:),20*log10(squeeze(mag21))); grid on;
        title(sprintf('G21 Magnitude (s_L=%.2f, s_R=%.2f)', s_L_val, s_R_val));
        ylabel('Magnitude (dB)');
        
        subplot(4,2,6);
        semilogx(w21(:),squeeze(phase21)); grid on;
        title('G21 Phase');
        ylabel('Phase (deg)');
        
        % Plot G22
        [mag22,phase22,w22] = bode(G22,w);
        subplot(4,2,7);
        semilogx(w22(:),20*log10(squeeze(mag22))); grid on;
        title(sprintf('G22 Magnitude (s_L=%.2f, s_R=%.2f)', s_L_val, s_R_val));
        ylabel('Magnitude (dB)');
        xlabel('Frequency (rad/s)');
        
        subplot(4,2,8);
        semilogx(w22(:),squeeze(phase22)); grid on;
        title('G22 Phase');
        ylabel('Phase (deg)');
        xlabel('Frequency (rad/s)');
    end

    % Set callback functions for sliders
    set(s_L_slider, 'Callback', @update_plots);
    set(s_R_slider, 'Callback', @update_plots);
    
    % Initial plot
    update_plots([], []);
end