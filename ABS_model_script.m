%% Anti-Lock Braking System Project
% Arjun Rajan
% Matlab script for Anti-Lock Braking System Project
clear
clc
close all

% Define constants
g = 9.8;                % Acceleration due to gravity (meters/s^2)
R = 0.203;              % Wheel Radius (meters)
Kf = 1;                 % Brake Friction Constant
m = 22;                 % Mass of Wheel (kg)
PBmax = 5515805;        % Brake Pressure (pascals)
TB = 0.01;              % tf constant
I = 0.5*m*(R^2);        % Moment of Inertia (kg*meters^2)
     
% Initial Condition
v0 = 25;              % Initial vehicle velocity (meters/s)   

% MU-slip curve data points
slip = (0:.05:1.0); 
mu = [0 .4 .8 .97 1.0 .98 .96 .94 .92 .9 .88 .855 .83 .81 .79 .77 .75 .73 .72 .71 .7];

% Open simulink ABS model
open('ABS_simulink_model.slx') % Open ABS simulink model

%% Running the simulation with ABS
ctrl = 1;             

% Run simulink model with ABS
sim('ABS_simulink_model.slx')  

% Stopping distance with ABS
Stopping_Dist = getElement(logsout, 'Sd');
outputValsSd = Stopping_Dist.Values;
outputTimesSd = outputValsSd.Time;
outputDataSd = outputValsSd.Data;

% Vehicle Speed with ABS
Vehicle_Speed = getElement(logsout, 'Vs');
outputValsVs = Vehicle_Speed.Values;
outputTimesVs = outputValsVs.Time;
outputDataVs = outputValsVs.Data;

% Wheel speed with ABS
Wheel_Speed = getElement(logsout, 'Ww');
outputValsWw = Wheel_Speed.Values;
outputTimesWw = outputValsWw.Time;
outputDataWw = outputValsWw.Data;

%% Running the simulation without ABS
ctrl = 0;

% Run simulink model without ABS
sim('ABS_simulink_model.slx') 

% Stopping distance without ABS
NoABS_Stopping_Dist = getElement(logsout, 'Sd');
outputValsSd_N = NoABS_Stopping_Dist.Values;
outputTimesSd_N = outputValsSd_N.Time;
outputDataSd_N = outputValsSd_N.Data;

% Vehicle Speed without ABS
NoABS_Vehicle_Speed = getElement(logsout, 'Vs');
outputValsVs_N = NoABS_Vehicle_Speed.Values;
outputTimesVs_N = outputValsVs_N.Time;
outputDataVs_N = outputValsVs_N.Data;

% Wheel speed without ABS
NoABS_Wheel_Speed = getElement(logsout, 'Ww');
outputValsWw_N = NoABS_Wheel_Speed.Values;
outputTimesWw_N = outputValsWw_N.Time;
outputDataWw_N = outputValsWw_N.Data;

%% Compartive Analaysis of vehicle under hard braking conditions

% plot vehicle speed and wheel speed with ABS on and off
figure
subplot(2,1,1);
plot(outputTimesVs, outputDataVs)
hold on 
plot(outputTimesWw, outputDataWw)
legend('Vehicle Speed \omega_v','Wheel Speed \omega_w','Location','best'); 
title('Vehicle speed and wheel speed with ABS');
xlabel('Time(sec)');
ylabel('Speed(rad/sec)');
subplot(2,1,2);
plot(outputTimesVs_N, outputDataVs_N)
hold on 
plot(outputTimesWw_N, outputDataWw_N)
legend('Vehicle Speed \omega_v','Wheel Speed \omega_w','Location','best'); 
title('Vehicle speed and wheel speed without ABS');
xlabel('Time(sec)');
ylabel('Speed(rad/sec)');

% plot stopping distance ABS on and off
figure
plot(outputTimesSd, outputDataSd, outputTimesSd_N, outputDataSd_N); 
xlabel('Slip Time (sec)'); 
ylabel('Stopping Distance (m)');
legend('With ABS','Without ABS','Location','SouthEast');
title('Stopping distance for hard braking with and without ABS');




















