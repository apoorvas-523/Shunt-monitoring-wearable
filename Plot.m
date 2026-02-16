clear; clc; close all;

%% -------------------- LOAD DATA --------------------
FLOW = readmatrix('FLOWColdpack.xlsx');
NOFLOW = readmatrix('NoFlowSecond (Retry).xlsx');

t_flow = FLOW(:,1);
T_flow = FLOW(:,2);

t_noflow = NOFLOW(:,1);
T_noflow = NOFLOW(:,2);

%% -------------------- OUTLIER FILTER (>35°C) --------------------
valid_flow = T_flow <= 35;
t_flow = t_flow(valid_flow);
T_flow = T_flow(valid_flow);

valid_noflow = T_noflow <= 35;
t_noflow = t_noflow(valid_noflow);
T_noflow = T_noflow(valid_noflow);

%% -------------------- SMOOTHING --------------------
window = 15;   % adjust if needed

T_flow_s = movmean(T_flow, window);
T_noflow_s = movmean(T_noflow, window);

%% -------------------- TEMPERATURE DROP --------------------
drop_flow = T_flow_s(1) - min(T_flow_s);
drop_noflow = T_noflow_s(1) - min(T_noflow_s);

%% -------------------- MAX COOLING SLOPE --------------------
dTdt_flow = gradient(T_flow_s) ./ gradient(t_flow);
dTdt_noflow = gradient(T_noflow_s) ./ gradient(t_noflow);

max_cool_flow = min(dTdt_flow);
max_cool_noflow = min(dTdt_noflow);

%% -------------------- PRINT RESULTS --------------------
fprintf('\n----- RESULTS -----\n');
fprintf('FLOW Temp Drop: %.3f °C\n', drop_flow);
fprintf('NO FLOW Temp Drop: %.3f °C\n', drop_noflow);
fprintf('FLOW Max Cooling Slope: %.4f °C/s\n', max_cool_flow);
fprintf('NO FLOW Max Cooling Slope: %.4f °C/s\n', max_cool_noflow);

%% -------------------- FIGURE --------------------
delta_flow = T_flow_s - T_flow_s(1);
delta_noflow = T_noflow_s - T_noflow_s(1);

figure;
plot(t_flow, delta_flow, 'LineWidth', 2)
hold on
plot(t_noflow, delta_noflow, 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Temperature Change (°C)')
title('Cooling Period: FLOW vs NO FLOW')
legend('FLOW','NO FLOW','Location','best')
grid on

max_heat_flow = max(dTdt_flow);
max_heat_noflow = max(dTdt_noflow);