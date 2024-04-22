function [Q,Q_std] = func_IME(column, omega_a, wind_speed,unenhanced_std,mask)
%反算排放,将Q与emission_per_hour 对比
% column = column(101:500,:);

pixel_resolution = 30;
M_CH4 = 16;
M_dry = 28.9647;

if nargin < 5 || isempty(mask)
%     %% mask制作 Varon
%     data = double(column > unenhanced_std * 2);
%     % 假设你的二维矩阵叫做 data
%     % 定义中值滤波和高斯滤波的参数
%     median_filter_size = 3;
%     gaussian_filter_size = 3;
%     gaussian_sigma = 2;
%     
%     % 对矩阵进行中值滤波
%     data_median = medfilt2(data, [median_filter_size, median_filter_size]);
%     
%     % 对矩阵进行高斯滤波
%     gaussian_filter = fspecial('gaussian', [gaussian_filter_size, gaussian_filter_size], gaussian_sigma);
%     data_gaussian = imfilter(data_median, gaussian_filter);
%     mask = (data_gaussian > 0.1);
mask = column > 2 * unenhanced_std;
end

L = sqrt( sum(sum(mask)) ) * pixel_resolution;
% omega_a = 1.0374e4;
masked_column = column .* mask;
delta_omega = M_CH4 ./ M_dry .* omega_a  .* (masked_column ./ 1e9);
IME = sum(sum(delta_omega .* (pixel_resolution * pixel_resolution)));
% u10 = 3; 
% v10 = 0; 
% wind_speed = sqrt(u10^2 + v10^2);% 风速
Ueff = 0.34 * wind_speed + 0.44;
Q = Ueff .* IME ./ L;  % in kg/s     %自己设置的一个系数。如果用真实的数据，这个需要删掉
Q = Q * 60 * 60; % in kg/h

%% 计算不确定度-蒙特卡洛模拟
% masked_column = reshape(masked_column,size(masked_column,1) * size(masked_column,2),1);
% for i = 1:length(masked_column)
%     multi_masked_column(i,:) = normrnd(masked_column(i),unenhanced_std,1,10000);
% end
% multi_delta_omega = M_CH4 ./ M_dry .* omega_a  .* (multi_masked_column ./ 1e9);
% multi_IME = sum(multi_delta_omega .* (pixel_resolution * pixel_resolution),1); %按列求和
% multi_wind_speed = normrnd(wind_speed,wind_speed * 0.5,1,10000); % 这里的0.5表示 风速具有50%的误差
% multi_Ueff = 0.34 .* multi_wind_speed + 0.44;
% 
% multi_Q = multi_Ueff .* multi_IME ./ L;  % in kg/s    
% multi_Q = multi_Q * 60 * 60; % in kg/h
% Q_std = std(multi_Q);
%% 计算不确定度-误差传递
Ueff_std = 0.34 * wind_speed * 0.4; % 风速误差按40%
delta_omega_std = M_CH4 ./ M_dry .* omega_a ./ 1e9 .* unenhanced_std;
IME_std = pixel_resolution * pixel_resolution * sqrt( sum(sum(delta_omega_std.^2)));
Q_std = sqrt(( Ueff * IME_std).^2 + (IME * Ueff_std).^2 ) ./ L;
Q_std = Q_std * 60 * 60;

% wind_speed_std = wind_speed * 0.4;
% Ueff_std = 0.34 * wind_speed_std;
% omega_a_std = 0; % 干空气柱质量按 0% 
% delta_omega_std = M_CH4 ./ M_dry ./ 1e9 .* sqrt( ( omega_a_std .* masked_column).^2 + ( omega_a .* unenhanced_std).^2);
% IME_std = pixel_resolution * pixel_resolution * sqrt( sum(sum(delta_omega_std.^2)));
% Q_std = sqrt( (Ueff * IME_std).^2 + (Ueff_std * IME).^2 ) ./ L ; % in kg/s
% Q_std = Q_std * 60 * 60
end
