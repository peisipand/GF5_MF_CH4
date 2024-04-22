function [Q,Q_std,mask] = func_IME(column, omega_a, wind_speed,unenhanced_std,mask)
%反算排放,将Q与emission_per_hour 对比
% column = column(101:500,:);

pixel_resolution = 30;
M_CH4 = 16;
M_dry = 28.9647;

if nargin < 5 || isempty(mask)
    %% mask制作
    data = double(column > unenhanced_std * 2);
    % 假设你的二维矩阵叫做 data
    % 定义中值滤波和高斯滤波的参数
    median_filter_size = 3;
    gaussian_filter_size = 3;
    gaussian_sigma = 2;
    
    % 对矩阵进行中值滤波
    data_median = medfilt2(data, [median_filter_size, median_filter_size]);
    
    % 对矩阵进行高斯滤波
    gaussian_filter = fspecial('gaussian', [gaussian_filter_size, gaussian_filter_size], gaussian_sigma);
    data_gaussian = imfilter(data_median, gaussian_filter);
    mask = (data_gaussian > 0.5);
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

%% 不确定性估计
wind_speed_std = wind_speed * 0.4; % 风速误差按40%
Ueff_std = 0.34 * wind_speed_std;
omega_a_std = 0; % 干空气柱质量按 0% 
delta_omega_std = M_CH4 ./ M_dry ./ 1e9 .* sqrt( ( omega_a_std .* masked_column).^2 + ( omega_a .* unenhanced_std).^2);
IME_std = pixel_resolution * pixel_resolution * sqrt( sum(sum(delta_omega_std.^2)));
Q_std = sqrt( (Ueff * IME_std).^2 + (Ueff_std * IME).^2 ) ./ L * 60 * 60;

end
