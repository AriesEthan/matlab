clc;
clearvars;
fn=input('Nyquist Freq(default:2461.27e6 Hz):');
if(isempty(fn))
    fn=2461.27e6;  %Nyquist freq.
end
fn_attenu=input('Nyquist Attenuation(default: -7dB):');
if(isempty(fn_attenu))
    fn_attenu=-7;  %attenuation @ fn
end
TdPerMeter=input('Delay(default:4.7 ns/m):');
if(isempty(TdPerMeter))
    TdPerMeter=4.7e-9; %ns/meter
end
LineLength=input('Line Length(default:1.5M):');
if(isempty(LineLength))
    LineLength=1.5;  %meter
end

Td_total=LineLength*TdPerMeter;
fin1=(0:1e6:fn)';
fin2=(fn:2e6:50e9)';
fin=[fin1;fin2];
a=fn_attenu/fn;
attenu_dB=a.*fin;
attenu_mag=10.^(attenu_dB/20);
td_deg=-1.*((Td_total.*fin*360));

Sparam_S11=zeros(length(attenu_mag),2);
Sparam_S21=[attenu_mag,td_deg];
Sparam=[fin/1e9,Sparam_S11,Sparam_S21,Sparam_S21,Sparam_S11];

fid=fopen('./Sparam.s2p','wt');
fprintf(fid,'# GHz S MA R 50\n');
fprintf(fid,'! 2-port S-parameter file\n');
fprintf(fid,'! freq S11mag S11ang S21mag S21ang S12mag S12ang S22mag S22ang\n');
fprintf(fid,'%e\t %f\t%f\t %f\t%f\t %f\t%f\t %f\t%f\t \n',Sparam');
fclose(fid);


