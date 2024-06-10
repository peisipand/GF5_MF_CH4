function [result,likehold] = MF(swir,k)

[a,b,c_] = size(swir);
result = zeros(a,b);
for i_column = 1:b 
    temp = swir(:,i_column,:);
    temp = permute(temp,[1 3 2]);
    % 真实的数据中，可能会出现 某个波段所有像素 全是0 的情况
    index_all_zero = find(all(temp==0,1));% 看看第几个波段 全是0
    k_temp = k;
    k_temp(index_all_zero,:) = [];
    temp(:,index_all_zero) = [];
    % 真实的数据中，可能会出现 个别像素个别波段 是0 的情况，求对数后影响求逆
    index_zero = find(any(temp==0,2));% 看看第几个像素 含0
    temp(index_zero,:) = nan;
    if sum(all(isnan(temp))) == 0 %如果temp全为空，就不计算
        %25:38 2230-2330nm      改为  8:55 2110-2448nm
        junzhi = nanmean(temp)';
        albedo_factor = (temp * junzhi) ./ (junzhi' * junzhi);
        mu = nanmean(temp)';
        Cb = nancov(temp)';
        Cb_inv = pinv(Cb);
        fenzi = (mu - temp')' * Cb_inv * (mu .* k_temp);
        fenmu = albedo_factor .* (mu .* k_temp)' * Cb_inv * (mu .* k_temp);
        alpha = fenzi ./ fenmu;
        % alpha(alpha < 0 ) = 0; %这里如果负值赋予0的话，会影响unhancement_std的计算
        %迭代 正则化
        %             epsilon = 10^(-9);
        %             for k_index = 1:20
        %                 w = 1 ./ (alpha + epsilon);
        %                 mu = nanmean(temp + albedo_factor .* alpha * (mu .* k)')';
        %                 covariance = nancov(temp + albedo_factor .* alpha * (mu .* k)')';
        %                 inv_cov = pinv(covariance);
        %                 fenzi = (mu - temp')' * inv_cov * (mu .* k) - w;
        %                 fenmu = albedo_factor .* (mu .* k)' * inv_cov * (mu .* k);
        %                 alpha = fenzi ./ fenmu;
        %                 alpha(alpha < 0 ) = 0;
        %             end
        %14个波段中有零的全给剔除掉
        %             [row_,col_]=find(temp == 0);
        %             alpha(row_,1) = 0;
        %14个波段必须全部小于μ 条件过于苛刻
        %             index = all(temp-mu' <= 0,2);%后面的2代表 检测每一列,index中1代表符合条件
        %             index = ~index;
        %             alpha(1,index) = nan;
        %画图备用
        % hhh = alpha >400;
        % plot(List_Cw_Swir,re_swir(hhh,:)')
        
        mut = mu .* exp(-k_temp * alpha'); % mu - k_temp * alpha';
%         mut = nanmean(temp .* exp(-k_temp * alpha')')'; 
        Ct = nancov(temp .* exp(-k_temp * alpha')' );
        Ct_inv = pinv(Ct);
        
        Pt = exp(-1/2 .* ( (mut - temp')' * Ct_inv * (mut - temp')) ) ./ (  sqrt(det(Ct)));
        Pb = exp(-1/2 .* ( (mu - temp')' * Cb_inv * (mu - temp')) ) ./ (  sqrt(det(Cb)));
        likehold(:,i_column) = diag(Pt ./ Pb); % 越大越好
        result(:,i_column) = alpha;
    end
end
result = reshape(result,a,b);
end