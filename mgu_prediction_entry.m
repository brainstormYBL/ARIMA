%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Description %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author  : Baolin Yin
% Data    : 11,25, 2022
% Email   : 932261247@qq.com
% Version : V1.0
% Function: Achieving the prediction of the MGUs' position.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Description %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% velocity_his : The historical velocity of MGUs. Shape:(N, 2) Unit:m^2/s
% pos_now      : The current position of MGUs. Shape:(N,2) Unit:m
% delta        : The time interval. Unit:s
% num_step     : The time step that is predicted. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% velocity_pre_x    : The predicted velocity at direction x. Shape: (N, 1) Unit:m^2/s
% velocity_pre_y    : The predicted velocity at direction y. Shape: (N, 1) Unit:m^2/s
% position_pre      : The predicted position of MGUs. Shape: (N, 2) Unit:m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [velocity_pre, position_pre] = mgu_prediction_entry(velocity_his,pos_now, delta, num_step)
% Getting the velocity at direction x of all the MGUs.
velocity_x = velocity_his(:, 1);
% Getting the velocity at direction y of all the MGUs.
velocity_y = velocity_his(:, 2);
% Predicting the velocity at direction x of all the MGUs.
[velocity_pre_x] = mgus_trajectory_prediction(velocity_x, num_step);
% Predicting the velocity at direction y of all the MGUs.
[velocity_pre_y] = mgus_trajectory_prediction(velocity_y, num_step);
velocity_pre = [velocity_pre_x, velocity_pre_y];
% Calculating the velocity at direction y of all the MGUs based predicted velocity.
position_pre = pos_now + velocity_pre * delta;
end

