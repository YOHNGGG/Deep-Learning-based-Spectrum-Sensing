function [ tt, Signal ] = eightPSK( N )
% Generate received 8PSK modulated analog signal

Ts=1;          
N_sample=126;  
alpha=0.5;       
dt=Ts/N_sample; 
t=-3*Ts:dt:3*Ts;

ht=sinc(t/Ts).*(cos(alpha*pi*t/Ts))./(1-4*alpha^2*t.^2/Ts^2+eps);

gt_original = [1 zeros(1, floor(N_sample/3)-1)];
gt_IQ = [1 zeros(1, N_sample-1)];
RAN = round(rand(1, N));
seq_original=[];
seq_1 = [];
seq_2 = [];
seq_3 = [];
for i = 1 : N 
   if RAN(i)==1
       seq_original = [seq_original gt_original];
   else
       seq_original = [seq_original -1*gt_original];
   end
end
for i = 1 : floor(N/3) 
   if RAN(2*i)==1
       seq_1 = [seq_1 1];
   else
       seq_1 = [seq_1 0];
   end
   if RAN(2*i-1)==1
       seq_2 = [seq_2 1];
   else
       seq_2 = [seq_2 0];
   end
   if RAN(3*i-2)==1
       seq_3 = [seq_3 1];
   else
       seq_3 = [seq_3 0];
   end
end

seq_I = [];
seq_Q = [];
gt_1 = [0.924 zeros(1, N_sample-1)];
gt_2 = [-0.924 zeros(1, N_sample-1)];
gt_3 = [0.383 zeros(1, N_sample-1)];
gt_4 = [-0.383 zeros(1, N_sample-1)];
for i = 1 : floor(N/3)
    if isequal([seq_1(i),seq_2(i),seq_3(i)],[0,0,0])
        seq_I = [seq_I gt_1];
        seq_Q = [seq_Q gt_3];
    end
    if isequal([seq_1(i),seq_2(i),seq_3(i)],[0,0,1])
        seq_I = [seq_I gt_3];
        seq_Q = [seq_Q gt_1];
    end
    if isequal([seq_1(i),seq_2(i),seq_3(i)],[0,1,1])
        seq_I = [seq_I gt_4];
        seq_Q = [seq_Q gt_1];
    end
    if isequal([seq_1(i),seq_2(i),seq_3(i)],[0,1,0])
        seq_I = [seq_I gt_2];
        seq_Q = [seq_Q gt_3];
    end
    if isequal([seq_1(i),seq_2(i),seq_3(i)],[1,1,0])
        seq_I = [seq_I gt_2];
        seq_Q = [seq_Q gt_4];
    end
    if isequal([seq_1(i),seq_2(i),seq_3(i)],[1,1,1])
        seq_I = [seq_I gt_4];
        seq_Q = [seq_Q gt_2];
    end
    if isequal([seq_1(i),seq_2(i),seq_3(i)],[1,0,1])
        seq_I = [seq_I gt_3];
        seq_Q = [seq_Q gt_2];
    end
    if isequal([seq_1(i),seq_2(i),seq_3(i)],[1,0,0])
        seq_I = [seq_I gt_1];
        seq_Q = [seq_Q gt_4];
    end
end

st_I=conv(seq_I,ht);
tt=-3*Ts:dt:(floor(N/3)+3)*N_sample*dt-dt;

st_Q=conv(seq_Q,ht);
tt=-3*Ts:dt:(floor(N/3)+3)*N_sample*dt-dt;

fc=10000;
I = 2 / sqrt(2) * cos(2*pi*fc*tt);
Q = -2 / sqrt(2) * sin(2*pi*fc*tt);
%Signal = st_I.*I + st_Q.*Q;
signal_complex = (st_I + 1j.*st_Q).*exp(1j*2*pi*fc*tt);

Fs=2000;       
Ts=1/Fs;          
Fd=50;            
tau=[0,0.001];      
pdb=[0,0];         
chan = rayleighchan(Ts, Fd, tau, pdb);

y = filter(chan,signal_complex);

Signal = real(y);
