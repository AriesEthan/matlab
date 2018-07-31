function A=jt_mask_edp_hbr(freq_ext)
% A(:,1)=JT_SJ
% A(:,2)=JT_total
% A(:,3)=freq
% sel='int', freq from function, otherwise freq from freq_ext

% clearvars; clc; close all; 
fstart=1e6;
fstop=3e9;
NumPerDec=10;
freq_int=LogDistrib(fstart,fstop,NumPerDec);
if(isempty(freq_ext))
    freq=freq_int;
else
    freq=freq_ext;
end

syms s tz tp2 G_HBR;
%s=2*pi*f*1j; tz=1.656e-7; tp2=6.596e-10; G_HBR=3.421e14; G_RBR=1.673e14;
G0_HBR=G_HBR./s.^2.*(s*tz+1)./(s*tp2+1); 
%G0_RBR=G_RBR./s.^2.*(s*tz+1)./(s*tp2+1);
Hs_HBR=G0_HBR./(1+G0_HBR);
%Hs_RBR=G0_RBR./(1+G0_RBR);
ISI_HBR=0.161; non_ISI_HBR=0.33;
%ISI_RBR=0.57;  non_ISI_RBR=0.18;
JTHBR_SJ=abs(0.2./(1-Hs_HBR));
JTHBR=JTHBR_SJ-0.2 +ISI_HBR+non_ISI_HBR; 
JTHBR_SJ=subs(JTHBR_SJ,[tz tp2 G_HBR],[1.656e-7 6.596e-10 3.421e14]);
JTHBR=subs(JTHBR,[tz tp2 G_HBR],[1.656e-7 6.596e-10 3.421e14]);
JTHBR_SJout=zeros(length(freq),1);
JTHBR_Jtotout=JTHBR_SJout;
for i=1:length(freq)
    JTHBR_SJout(i,1)=subs(JTHBR_SJ, s, 1j*2*pi*freq(i,1));
    JTHBR_Jtotout(i,1)=subs(JTHBR, s, 1j*2*pi*freq(i,1));
end
% semilogx(freq,[JTHBR_SJout,JTHBR_Jtotout],'o-'); grid on;
% legend('JT\_SJ','JT\_total');
A(:,1)=JTHBR_SJout;
A(:,2)=JTHBR_Jtotout;
if(isempty(freq_ext))
    A(:,3)=freq;
end
end