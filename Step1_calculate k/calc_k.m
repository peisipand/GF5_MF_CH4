function [k] = calc_k(cw,fwhm,sn)
% 参数说明
% cw: center wavelength 中心波长 in nm
% fwhm: full width at half maxima 半宽 in nm
% sn: satellite name 卫星名字

load('radiance_in_wv_total')
load('wavenumber')
radiance_toa_column1 = radiance_in_wv_total(:,1);
radiance_toa_column2 = radiance_in_wv_total(:,2);
radiance_toa_column3 = radiance_in_wv_total(:,3);
radiance_toa_column4 = radiance_in_wv_total(:,4);

% 卷积
conv_radiance1 = convolv(wavenumber,radiance_toa_column1,cw,fwhm);
conv_radiance2 = convolv(wavenumber,radiance_toa_column2,cw,fwhm);
conv_radiance3 = convolv(wavenumber,radiance_toa_column3,cw,fwhm);
conv_radiance4 = convolv(wavenumber,radiance_toa_column4,cw,fwhm);
% cw_fwhm = [cw fwhm];
% cw_fwhm_wn(:,1) = 1e7 ./ cw_fwhm(:,1); %wavelength to wavenumber
% cw_fwhm_wn(:,2) = 1e7 ./ (cw_fwhm(:,1)-cw_fwhm(:,2)/2) - 1e7 ./ (cw_fwhm(:,1)+cw_fwhm(:,2)/2);
% %开始卷积 k = l*cross_section
% step = wavenumber(2,1) - wavenumber(1,1); %需要与hitran的间隔保持一致!!!   step must be less than resolution
% % resolution 是 半宽的 两倍
% AF_Wing = 100;
% x = -AF_Wing:step:AF_Wing;
% for i = 1:length(cw_fwhm_wn)
%     wavenumber_temp = cw_fwhm_wn(i,1);
%     [~,index] = min(abs(wavenumber - wavenumber_temp));
%     radiance1(i,:) = radiance_toa_column1(round(index-AF_Wing/step):round(index+AF_Wing/step),1);
%     radiance2(i,:) = radiance_toa_column2(round(index-AF_Wing/step):round(index+AF_Wing/step),1);
%     radiance3(i,:) = radiance_toa_column3(round(index-AF_Wing/step):round(index+AF_Wing/step),1);
%     radiance4(i,:) = radiance_toa_column4(round(index-AF_Wing/step):round(index+AF_Wing/step),1);
% end
% 
% 
% %公式参考HAPI.py
% for i = 1:length(cw_fwhm_wn)
%     g = cw_fwhm_wn(i,2); % g为半宽 或者叫resolution
% %     slit(i,:) = 2 / g * sqrt(log(2) / pi) * exp(-log(2)*(2*x/g).^2);  %该处做了改动
%     g = g / 2;
%     slit(i,:) = sqrt(log(2)) / (sqrt(pi) * g) * exp(-log(2)*(x/g).^2);  %该处做了改动
%     slit(i,:) = slit(i,:) / (sum(slit(i,:))*step);
% end
% conv_radiance1 = sum(radiance1 .* slit,2) * step;
% conv_radiance2 = sum(radiance2 .* slit,2) * step;
% conv_radiance3 = sum(radiance3 .* slit,2) * step;
% conv_radiance4 = sum(radiance4 .* slit,2) * step;

% plot(cw,[conv_radiance1 conv_radiance2 conv_radiance3 conv_radiance4])

for i = 1:length(conv_radiance1)
    A = [1.9 2.9 3.9 4.9;-1 -1 -1 -1]';
    L = -[log(conv_radiance1(i)) log(conv_radiance2(i)) log(conv_radiance3(i)) log(conv_radiance4(i))]';
    X = inv(A'*A)*A'*L;
    k(i,1) = X(1);
end

% plot(cw,k)

k = k ./ 1e3 ; % 单位每ppb
% plot(FWHM(:,1),k)
save(['k_',sn],'k')
end




