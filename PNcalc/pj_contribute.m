function pj_contribute(fcarrier,freq_spur,power_spur,topN)
% freq_spur: spur freq
% power_spur: spur power(dBc)
% topN: display the first N largest contributors

power_spur_rad2=10.^(power_spur/10);
pj_single_tone=sqrt(2*power_spur_rad2)/(2*pi*fcarrier);
power_contribute=power_spur_rad2./sum(power_spur_rad2);

A1=[freq_spur,power_spur,pj_single_tone,power_contribute];
B1=sortrows(A1,4);
B1_ud=flipud(B1);
fprintf('\n               Spur Power Contributor Table\n');
fprintf('\nSpur Freq.(Hz) Spur Power(dBc)   Pj(sec)    Power Contribute\n');
fprintf('  %0.2e         %0.2g\t        %0.2e\t %.2g\n', (B1_ud(1:topN,:,:,:))');