
function [pnoise_smooth,freq_spur,power_spur] = pn_separation(freq,pnoise_ssb)

despur=2;
Factor_smooth=0.08;
smooth_method='rlowess';
pnoise_smooth=smooth(pnoise_ssb,Factor_smooth,smooth_method);

pnoise_delta=pnoise_ssb-pnoise_smooth;
pnoise_delta(pnoise_delta<despur)=-inf;
pnoise_delta_diff=diff(pnoise_delta);

ind=zeros(length(pnoise_delta_diff)-1,1);
for i=1:length(pnoise_delta_diff)-1
    if(pnoise_delta_diff(i)>0 && pnoise_delta_diff(i+1)<0)
        if i==1
            ind(i)=1;
        else
            [~,ind_temp]=max(pnoise_ssb(i-1:i+1));
            ind(i)=i+ind_temp-2;
        end
    end
end   

ind=ind(ind>0);
freq_spur=freq(ind);
pnoise_spur=pnoise_ssb(ind);
A=[freq_spur,pnoise_spur];
B=sortrows(A,1);
freq_spur=B(:,1);
pnoise_spur=B(:,2);
power_spur=pn2power(freq_spur,pnoise_spur);


