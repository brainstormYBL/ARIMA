clc;
clear;
close all;
% The parameters.
RADIUS_INIT_MGU = 400; % The init radius of MGUs area.
RADIUS_INIT_UAV = max(RADIUS_INIT_MGU / 2, 200);
CENTER_INIT = [0, 0];
NUM_MGU = 100; % The number of MGUs.
OBSERVE_TIME = 400; % The observe tims.
TIME_INTERVAL = 0.5;
NUM_SLOT = ceil(OBSERVE_TIME ./ TIME_INTERVAL);
VELOCITY_UAV = 20;
TIME_GET = ceil(OBSERVE_TIME / TIME_INTERVAL);
NUM_SLOT_FORCAST = 200;


% Generate the MGUs.
pos_now_mgu = zeros(NUM_SLOT, NUM_MGU, 2);
velocity_mgus = zeros(NUM_SLOT, NUM_MGU, 2);
theta = deg2rad(rand(NUM_MGU, 1) * 360);
pos_now_mgu(1, :, :) = CENTER_INIT + [(rand(NUM_MGU, 1) .* RADIUS_INIT_MGU) .* cos(theta), (rand(NUM_MGU, 1) .* RADIUS_INIT_MGU) .* sin(theta)];
velocity_mgus(1,:,:) = normrnd(3, 3, [1, NUM_MGU, 2]);
% figure(1);
% scatter(pos_now_mgu(1, :, 1), pos_now_mgu(1, :, 2));
% title("The distribution of MGUs at time slot 1");
% xlabel('X (m)');
% ylabel('Y (m)');
% hold on;
% scatter(CENTER_INIT(1), CENTER_INIT(2));
% plot(RADIUS_INIT_MGU .* cos(deg2rad(linspace(0, 360, 100))), RADIUS_INIT_MGU .* sin(deg2rad(linspace(0, 360, 100))));
% legend('The position of MGUs', 'Center of MGUs', ' Distributed range of MGUs');


% The velocity of the NGUs
% figure(2);
% scatter(pos_now_mgu(1,:, 1), pos_now_mgu(1,:, 2));
% hold on;

num_train= 50;
num_test = 200;
for index_slot = 2:TIME_GET
%     scatter(pos_now_mgu(index_slot,:, 1), pos_now_mgu(index_slot,:, 2));
    velocity_mgus(index_slot,:,:) = normrnd(1, 1, [1, NUM_MGU, 2]);
    pos_now_mgu(index_slot,:,:) = pos_now_mgu(index_slot - 1,:,:) + velocity_mgus(index_slot - 1,:,:);
end
ve_x_train = reshape(velocity_mgus(1:num_train, 1, 1), [num_train, 1]);
ve_y_train = reshape(velocity_mgus(1:num_train, 1, 2), [num_train, 1]);
ve_x_test = reshape(velocity_mgus(num_train+1:num_train+num_test, 1, 1), [num_test, 1]);
ve_y_test = reshape(velocity_mgus(num_train+1:num_train+num_test, 1, 2), [num_test, 1]);
po_now = reshape(pos_now_mgu(num_train, 1, :), [1, 2]);
po_test = reshape(pos_now_mgu(num_train+1:num_train+num_test, 1, :), [num_test, 2]);

velocity_his = [ve_x_train, ve_y_train];
velocity_test = [ve_x_test, ve_y_test];
[velocity_pre, position_pre] = mgu_prediction(velocity_his,po_now,TIME_INTERVAL,num_test);
err_v = velocity_test - velocity_pre;
err_p = po_test - position_pre;
err_dis = sqrt(sum(err_p .^ 2, 2));
figure(1);
slot = 1:1:num_test;
plot(slot,err_dis,'-ro','MarkerIndices',1:4:length(slot(:)),LineWidth=1.5);
xlabel("预测未来的时隙数");
ylabel("距离误差(m)");
