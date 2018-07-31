%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TF of MDLL                                                       %
%                                                                  %
%    CP-----------VCDL           |---------Href(s)-------------|   %
%        |                     --|--Icp--F(s)--Kvcdl---Hrl(s)--|-- %
%        |                       |-------------1/N-------------|   %
%        |                                                         %
%        C1                                                        %
%        |                                                         %
%       GND                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clearvars;
fstart=1e3; fstop=100e6; NumPerDec=11;
freq=LogDistrib(fstart,fstop,NumPerDec);

syms Icp C1 Kv N Tref s
t=s*Tref/2;
Hrefs=N*exp(-1*t)*(sin(abs(t))/abs(t));
Hrls=1-exp(-1*t)*(sin(abs(t))/abs(t));
Kvcdl=-1*Tref^2/N*Kv; 
Fs=1/(s*C1);
Kd=Icp/(2*pi);
Gs=Kd*Fs*(Kv/s*2*pi)*Hrls*1/N*2*pi;      % loop TF
Hs=N*Gs/(1+Gs)+Hrefs;                    % closed loop TF
Hs_vco=Hrls/(1+Gs);
K=Kd*Kv*2*pi*1/C1*1/N;                   % loop gain
pn_vco=270.8*freq.^(-0.09076)-187.5-10;     % vco phase noise dBc/Hz

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

Icp_num=100e-6;        % A
C1_num=600e-12;        % F
f0=500e6;              % VCO free running freq.Hz
fref=200e6;             % reference clock, Hz
Tref_num=1/fref;
Kv_num=420e6;          % VCO gain£¬Hz/V
N_num=16;           

Gs=subs(Gs, [Icp, C1, Kv, N, Tref], [Icp_num, C1_num, Kv_num, N_num, Tref_num]);
Hs=subs(Hs, [Icp, C1, Kv, N, Tref], [Icp_num, C1_num, Kv_num, N_num, Tref_num]);

K =subs(K,  [Icp, C1, Kv, N, Tref], [Icp_num, C1_num, Kv_num, N_num, Tref_num]);

Hs_vco=subs(Hs_vco, [Icp, C1, Kv, N, Tref], [Icp_num, C1_num, Kv_num, N_num, Tref_num]);
Hrefs=subs(Hrefs, [Icp, C1, Kv, N, Tref], [Icp_num, C1_num, Kv_num, N_num, Tref_num]);

for i=1:length(freq)
    Gs_jw(i,1)=subs(Gs, s, 1j*2*pi*freq(i,1));
    Gs_mag_dB(i,1)=20*log10(abs(Gs_jw(i,1)));
    Gs_ang_deg(i,1)=angle(Gs_jw(i,1))/pi*180;
    
    Hs_jw(i,1)=subs(Hs, s, 1j*2*pi*freq(i,1));
    Hs_mag_dB(i,1)=20*log10(abs(Hs_jw(i,1)));
    Hs_ang_deg(i,1)=angle(Hs_jw(i,1))/pi*180;
    
    Hs_vco_jw(i,1)=subs(Hs_vco, s, 1j*2*pi*freq(i,1));
    Hs_vco_mag_dB(i,1)=20*log10(abs(Hs_vco_jw(i,1)));
    
    Hrefs_jw(i,1)=subs(Hrefs, s, 1j*2*pi*freq(i,1));
    Hrefs_mag_dB(i,1)=20*log10(abs(Hrefs_jw(i,1)));
    
    
end
Gs_mag_dB=double(Gs_mag_dB);
Gs_ang_deg=double(Gs_ang_deg);
fprintf('Loop Gain K=%1.2g Hz\n',double(K));
fprintf('Unity Gain Freq.: %1.2g Hz\n', freq(find(Gs_mag_dB>=0, 1, 'last' )));
figure(1);
subplot(2,1,1),semilogx(freq,Gs_mag_dB); grid on; title('Frequency Response of Magnitude G(s)');
subplot(2,1,2),semilogx(freq,Gs_ang_deg); grid on; title('Frequency Response of Phase G(s)');

figure(2);
subplot(2,1,1),semilogx(freq,Hs_mag_dB); grid on; title('|H(s)|');
subplot(2,1,2),semilogx(freq,Hs_ang_deg); grid on; title('Phase Response of H(s)');

figure(3);
semilogx(freq,Hs_vco_mag_dB); grid on; title('|H\_vco(s)|');
figure(4);
semilogx(freq,Hs_vco_mag_dB+pn_vco); grid on; title('PN output from VCO');

figure(5);
semilogx(freq,Hrefs_mag_dB); grid on; title('Hrefs');