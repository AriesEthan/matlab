function [rj,power] = rj_calc(fcarrier,freq,pnoise_ssb,integ_start,integ_stop)

ind=find(freq>=integ_start);
ind_integ_start=ind(1);
ind=find(freq<=integ_stop);
if ind(end)+1>length(freq)
    ind_integ_stop=length(freq);
else
    ind_integ_stop=ind(end)+1;
end
pnoise_integ=pnoise_ssb(ind_integ_start:ind_integ_stop);
freq_integ  =freq(ind_integ_start:ind_integ_stop);
%semilogx(freq_integ,pnoise_integ);
pn_rad2=10.^(pnoise_integ/10);
power=trapz(freq_integ,pn_rad2);
rj=sqrt(2*power)/(2*pi*fcarrier);