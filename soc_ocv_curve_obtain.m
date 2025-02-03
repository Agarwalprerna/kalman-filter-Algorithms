clear all;
clc;
load ICD118650_2ah_25CS2.mat

Q_nominal = 2;
I = ICD1186502ah25CS2.CurrentA;
V = ICD1186502ah25CS2.VoltageV;
time = ICD1186502ah25CS2.Test_Times;
soc = zeros(length(I) ,1);
OCV = []; % Initialize OCV array
soc_smp = []; % Initialize SOC sample array
Ts =1/3600;
eta = 1;
soc(1) = 0.25
 % SOC calculation and rest period detection
for i = 2:length(V)
    % if I(i)>0 
    %     eta = 0.99;
    % elseif I(i) <0 
    %         eta = 1;
    % end
    soc(i) = soc(i-1) + (Ts * eta * I(i) / Q_nominal); % SOC calculation using Coulomb counting
    if I(i) == 0 && I(i-1) ~= 0 % Detect rest periods
        OCV = [OCV, V(i)]; % Capture OCV value
        soc_smp = [soc_smp, soc(i)]; % Capture corresponding SOC value
    end
end

% Extract and fit data
ocv_data = OCV; % OCV data
soc_data = soc_smp; % SOC data
p = polyfit(soc_data, ocv_data, 7) % Fit polynomial to SOC-OCV data
q = polyfit(ocv_data, soc_data, 7) % Fit polynomial to OCV-SOC data (reverse)

% Plotting

% SOC vs OCV
ylabalepos = [-0.06, 0.5, 0]; % Y-label position adjustment
figure(1)
plot(soc_smp, OCV, 'r', 'linewidth', 1.2)
title('SoC VS OCV');
xlabel({'\it SoC'});
ylabel({'\it Open Circuit Voltage (V)'}, 'Units', 'Normalized', 'Position', ylabalepos, 'Rotation', 90)
xlim([0 1])


% Assume soc_data and ocv_data are your SOC-OCV data points

% degrees = 1:7; % Degrees to test
% errors = zeros(length(degrees), 1); % Initialize error array
% 
% for d = degrees
%     % Fit polynomial of degree d
%     p = polyfit(soc_data, ocv_data, d);
% 
%     % Evaluate the polynomial at data points
%     ocv_fit = polyval(p, soc_data);
% 
%     % Compute RMSE
%     errors(d) = sqrt(mean((ocv_data - ocv_fit).^2));
% end
% 
% % Find the degree with the minimum RMSE
% [~, best_degree] = min(errors);
% 
% % Display the best degree
% disp(['Best polynomial degree: ', num2str(best_degree)]);
% 
% % Fit and plot the best polynomial
% p_best = polyfit(soc_data, ocv_data, best_degree);
% ocv_fit_best = polyval(p_best, soc_data);
% 
% figure;
% plot(soc_data, ocv_data, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Data');
% hold on;
% plot(soc_data, ocv_fit_best, 'b-', 'DisplayName', ['Fit (degree = ', num2str(best_degree), ')']);
% xlabel('State of Charge (SOC) [%]');
% ylabel('Open Circuit Voltage (OCV) [V]');
% title('SOC-OCV Curve with Best Polynomial Fit');
% legend;
% grid on;
