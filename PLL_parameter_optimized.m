 % Type II 4rd-order PLL parameters optimized 
 
 %% parameters define
 fmin = 10; 
 fmax = 10e9; 
 Ndec = 10;  % freq. points for decible 
 Ntot = ceil(log10(fmax/fmin)*Ndec);  % total freq. points
 in = 0:1:Ntot-1; % indes for freq. array
 f = 10.^(log10(fmin)+in./Ndec);  % freq. points Hz
 s = 1j * 2*pi .* f;              % complex freq. point
 parameters = zeros([],8);        % results matrix
 param = zeros([],8);             % a part of parameters
 iter = 1;
 
 Icp = 20e-6;
 Kvco = 500e6;
 Ndiv = 45;
 
 R1 = 10e3:5e3:20e3;
 C1 = 60e-12:5e-12:90e-12;
 C2 = 2e-12:0.5e-12:4e-12;
 R3 = 3e3:0.5e3:10e3;
 C3 = 1e-12:1e-12:4e-12;
 
 %% iteration 
 for nC1 = 1:1:length(C1)
     for nR1 = 1:1:length(R1)
         for nC2 = 1:1:length(C2)
             for nC3 = 1:1:length(C3)
                 for nR3 = 1:1:length(R3)
                     c1 = C1(nC1); r1 = R1(nR1); c2 = C2(nC2); c3 = C3(nC3); r3 = R3(nR3);
                     t1 = r1*c1; t3 = r3*c3; 
                     Z = tf([t1 1],[c2*t1*t3 c1*t3+c3*t1+c2*(t1+t3) c1+c2+c3 0]);  % 3rd-order loop filter
                     Hol = 1/Ndiv * Icp * Kvco*tf(1,[1 0]) * Z;
                     Hcl = feedback(Hol*Ndiv,1/Ndiv);
                     fcl3dB = bandwidth(Hcl)/2/pi;
                     [Gm,Pm,Wg,Wp] = margin(Hol);
                     gpeak = getPeakGain(Hcl,0.001);
                     Peak = 20*log10(gpeak) - 20*log10(Ndiv);
 %%%%%%%%%%%%%%%%%%%%%%%% judge and record parameters %%%%%%%%%%%%%%%%%%%%%                    
                     if Pm>=60 && Pm<=70
                         if fcl3dB>=500e3 && fcl3dB<=1.5e6
                             if Peak <=1.5
                                 parameters(iter,1) = r1;
                                 parameters(iter,2) = c1;
                                 parameters(iter,3) = c2;
                                 parameters(iter,4) = r3;
                                 parameters(iter,5) = c3;
                                 parameters(iter,6) = Pm;
                                 parameters(iter,7) = fcl3dB;
                                 parameters(iter,8) = Peak;
                                 iter = iter + 1;
                             end
                         end
                     end
                 end
             end
         end
     end
 end
 
 %% parameters post-process 
 numparam = size(parameters);
 for npara=1:1:numparam(1)
     if  parameters(npara,2) == 60e-12
         if  parameters(npara,1) == 20e3
             param(npara,:) = parameters(npara,:);
         end
     end
 end
                                 
 
 
 
 
