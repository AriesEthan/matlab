%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TF of 2nd-Type 3rd-Order ChargePump PLL                          %
% 2nd-Order Integrator-Lead filter                                 %
%    CP-------------VCO           ---Icp/2pi--F(s)--Kv--           %
%        |      |                  |                   |           %
%        R1     |                  |--------1/N--------|           %
%        |      |                                                  %
%        C1     C2                                                 %
%        |      |                                                  %
%       GND    GND                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clearvars;
fstart=10e3; fstop=1e9; NumPerDec=11;
freq=LogDistrib(fstart,fstop,NumPerDec);

syms Icp R1 C1 C2 Kv N s
Z1=R1+1/(s*C1); Z2=1/(s*C2);
Fs=Z1*Z2/(Z1+Z2);
Kd=Icp/(2*pi);
Gs=Kd*Fs*(Kv*2*pi/s)*1/N*2*pi;  % loop TF, last 2pi for rad/s -> 1/s=Hz
Hs=N*Gs/(1+Gs);                 % closed loop TF
K=Kd*Kv*2*pi*R1*C1/(C1+C2)*1/N; % loop gain

fprintf('2nd Order Filter TF:\n');
pretty(simplifyFraction(Fs)); fprintf('\n');
fprintf('Loop TF G(s):\n');
pretty(simplifyFraction(Gs)); fprintf('\n');
fprintf('open loop gain:\n');
pretty(simplifyFraction(K));  fprintf('\n');
fprintf('Closed loop TF H(s):\n');
pretty(simplifyFraction(Hs));
%fprintf('\n');
%pretty(simplifyFraction(diff(Hs,s)));

Icp_num=500e-6;        % A
R1_num=1000;           % ohm
C1_num=400e-12;        % F
C2_num=16e-12;         % F
f0=800e6;              % VCO free running freq.Hz
fref=24e6;             % reference clock, Hz
Kv_num=100e6;          % VCO gain£¬Hz/V
N_num=56;           

tz1=C1_num*R1_num;
tp1=C1_num*C2_num/(C1_num+C2_num)*R1_num;
Afilter=1/(C1_num+C2_num);

Gs=subs(Gs, [Icp, R1, C1, C2, Kv, N], [Icp_num, R1_num, C1_num, C2_num, Kv_num, N_num]);
Hs=subs(Hs, [Icp, R1, C1, C2, Kv, N], [Icp_num, R1_num, C1_num, C2_num, Kv_num, N_num]);
K=subs(K,[Icp, R1, C1, C2, Kv, N], [Icp_num, R1_num, C1_num, C2_num, Kv_num, N_num]);

for i=1:length(freq)
    Gs_jw(i,1)=subs(Gs, s, 1j*2*pi*freq(i,1));
    Gs_mag_dB(i,1)=20*log10(abs(Gs_jw(i,1)));
    Gs_ang_deg(i,1)=angle(Gs_jw(i,1))/pi*180;
    
    Hs_jw(i,1)=subs(Hs, s, 1j*2*pi*freq(i,1));
    Hs_mag_dB(i,1)=20*log10(abs(Hs_jw(i,1)));
    Hs_ang_deg(i,1)=angle(Hs_jw(i,1))/pi*180;
end
Gs_mag_dB=double(Gs_mag_dB);
Gs_ang_deg=double(Gs_ang_deg);
fprintf('Loop Gain K=%1.2g Hz\n',double(K));
fprintf('Unity Gain Freq.: %1.2g Hz\n', freq(find(Gs_mag_dB>=0, 1, 'last' )));
fprintf('Zero freq.Z=%1.2g Hz\n',1/tz1/(2*pi));
fprintf('Pole freq.P=%1.2g Hz\n',1/tp1/(2*pi));
PM=Gs_ang_deg(find(Gs_mag_dB>=0, 1, 'last' ))-(-180);
fprintf('Phase Margin(deg): %1.1f\n C',PM);
figure(1);
subplot(2,1,1),semilogx(freq,Gs_mag_dB); grid on; title('Frequency Response of Magnitude G(s)');
subplot(2,1,2),semilogx(freq,Gs_ang_deg); grid on; title('Frequency Response of Phase G(s)');

figure(2);
subplot(2,1,1),semilogx(freq,Hs_mag_dB-20*log10(N_num)); grid on; title('normalized |H(s)|');
subplot(2,1,2),semilogx(freq,Hs_ang_deg); grid on; title('Phase Response of H(s)');
