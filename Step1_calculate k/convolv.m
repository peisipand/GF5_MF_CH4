function [convolved_result] = convolv(wavenumber,high_resolution,cw,fwhm)
% 卷积
cw_fwhm = [cw fwhm];
cw_fwhm_wn(:,1) = 1e7 ./ cw_fwhm(:,1); %wavelength to wavenumber
cw_fwhm_wn(:,2) = 1e7 ./ (cw_fwhm(:,1)-cw_fwhm(:,2)/2) - 1e7 ./ (cw_fwhm(:,1)+cw_fwhm(:,2)/2);
%开始卷积 k = l*cross_section
step = wavenumber(2,1) - wavenumber(1,1); %需要与hitran的间隔保持一致!!!   step must be less than resolution
% resolution 是 半宽的 两倍
AF_Wing = 100;
x = -AF_Wing:step:AF_Wing;
high_resolution_in_Wing = zeros(length(cw_fwhm_wn),length(x));
for i = 1:length(cw_fwhm_wn)
    wavenumber_temp = cw_fwhm_wn(i,1);
    [~,index] = min(abs(wavenumber - wavenumber_temp));
    high_resolution_in_Wing(i,:) = high_resolution(round(index-AF_Wing/step):round(index+AF_Wing/step),1);
end


%公式参考HAPI.py
for i = 1:length(cw_fwhm_wn)
    g = cw_fwhm_wn(i,2); % g为半宽 或者叫resolution
%     slit(i,:) = 2 / g * sqrt(log(2) / pi) * exp(-log(2)*(2*x/g).^2);  %该处做了改动
    g = g / 2;
    slit(i,:) = sqrt(log(2)) / (sqrt(pi) * g) * exp(-log(2)*(x/g).^2);  %该处做了改动
    slit(i,:) = slit(i,:) / (sum(slit(i,:))*step);
end
convolved_result = sum(high_resolution_in_Wing .* slit,2) * step;
end

