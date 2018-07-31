clearvars; clc; clf;
fmin=10e3;
fmax=742.5e6;
N_perdec=5;
N=N_perdec*log10(fmax/fmin);
f=[10.^(log10(fmin)+(0:1:N)'/N_perdec);fmax];
%f=[1:0.5:10]'*1e6;
s=2*pi*f*1j; tz=1.656e-7; tp2=6.596e-10; G_HBR=3.421e14; G_RBR=1.673e14;
G0_HBR=G_HBR./s.^2.*(s*tz+1)./(s*tp2+1); 
G0_RBR=G_RBR./s.^2.*(s*tz+1)./(s*tp2+1);
Hs_HBR=G0_HBR./(1+G0_HBR);
Hs_RBR=G0_RBR./(1+G0_RBR);

ISI_HBR=0.161; non_ISI_HBR=0.33;
ISI_RBR=0.57;  non_ISI_RBR=0.18;

JTHBR_SJ=abs(0.2./(1-Hs_HBR));
JTHBR=JTHBR_SJ-0.2 +ISI_HBR+non_ISI_HBR; 
JTRBR=abs((ISI_RBR+non_ISI_RBR)./(1-Hs_RBR));
JTRBR_SJ=JTRBR-(ISI_RBR+non_ISI_RBR);
fid=figure(1); 
subplot(2,2,1),semilogx(f,abs(Hs_HBR)); grid on; title('Hs\_HBR');
subplot(2,2,3),semilogx(f,JTHBR); grid on; hold on;
semilogx(f,JTHBR_SJ); title('JTMASK\_HBR');
legend('JT\_HBR','JT\_HBR\_SJ');
subplot(2,2,2),semilogx(f,abs(Hs_RBR)); grid on; title('Hs\_RBR');
subplot(2,2,4),semilogx(f,JTRBR); grid on; hold on;
semilogx(f,JTRBR_SJ); title('JTMASK\_RBR');
legend('JT\_RBR','JT\_RBR\_SJ');

title('JTMASK\_RBR');
%loglog(f,JTFAUXfc); 

JT_MASK_HBR=[f,JTHBR,JTHBR_SJ,JTHBR-JTHBR_SJ];
JT_MASK_RBR=[f,JTRBR,JTRBR_SJ];