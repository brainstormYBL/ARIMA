%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Description %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author  : Baolin Yin
% Data    : 11,25, 2022
% Email   : 932261247@qq.com
% Version : V1.0
% Function: Calculate the best MGUs circule related to distrabution of MGUs and area of overlap.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Description %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data      : The data.
% time_step : The time step that is predicted. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% forcast : The predicted result.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [forcast] = mgus_trajectory_prediction(data, time_step)
    True = 1;
    data_te = data;
    parameter_i = 0;
    % Making the data stable by solving the difference.
    while True
        y_h_adf = adftest(data_te);
        y_h_kpss = kpsstest(data_te);
        if y_h_adf == 1 && y_h_kpss == 0
            break;
        end
        data_te = diff(data_te);
        parameter_i = parameter_i + 1;
    end
%     figure(1);
%     subplot(411);
%     plot(data);
%     
%     subplot(412);
%     plot(data_te);
%     
%     subplot(413);
%     autocorr(data_te);
%     
%     subplot(414);
%     parcorr(data_te);
    pmax = 4;
    qmax = 4;
    % Find the best p and q.
    [p, q] = findPQ(data, pmax, qmax, parameter_i);
    % Bulding the predicted model.
    model = arima(p, parameter_i, q); 
    EstMdl = estimate(model,data);
    % Predicting
    [forData] = forecast(EstMdl,time_step,'Y0',data); 
    forcast = forData;
end

