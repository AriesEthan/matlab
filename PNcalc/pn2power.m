function power_spur=pn2power(freq_spur,pnoise_spur)
% freq_spur: spur freq
% pnoise_spur: spur SSB pnoise
% power_spur: spur SSB pnoise convert to power by RBW array(fsea30)
span = 2*freq_spur;
RBW=zeros(length(span),1);
for i=1:length(span)    
	if span(i)<=20
	    RBW(i)=2;
    elseif span(i)>20 && span(i)<=40
	    RBW(i)=5;
    elseif span(i)>40 && span(i)<=100
	    RBW(i)=10;
    elseif span(i)>100 && span(i)<=200
        RBW(i)=20;
    elseif span(i)>200 && span(i)<=400
	    RBW(i)=50;
	elseif span(i)>400 && span(i)<=1e3
	    RBW(i)=100;
	elseif span(i)>1e3 && span(i)<=10e3
	    RBW(i) = 200;
	elseif span(i)>10e3 && span(i)<=100e3
	    RBW(i) = 500;            
	elseif span(i)>100e3 && span(i)<=1e6
	    RBW(i) = 3e3;     
	elseif span(i)>1e6 && span(i)<=10e6
	    RBW(i) = 30e3;
	elseif span(i)>10e6 && span(i)<=100e6
	    RBW(i) = 300e3;
    else
	    RBW(i) =3e6;
end
end
power_spur=pnoise_spur+10*log10(RBW);