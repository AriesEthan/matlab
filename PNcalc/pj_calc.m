function pj = pj_calc(fcarrier,freq_spur,power_spur,integ_start,integ_stop)

ind=find(freq_spur>=integ_start);
ind_integ_start=ind(1);
ind=find(freq_spur<=integ_stop);
ind_integ_stop=ind(end);
pnoise_spur_integ=power_spur(ind_integ_start:ind_integ_stop);
power_spur_rad2=10.^(pnoise_spur_integ/10);
pj=sqrt(2*sum(power_spur_rad2))/(2*pi*fcarrier);
% semilogx(freq_spur,power_spur,'-');
% scatter(freq_spur,power_spur);

