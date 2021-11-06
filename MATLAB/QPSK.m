function [ tt, Signal ] = QPSK( N ) %NΪ��Ԫ��

Ts=1;           %��Ԫ����
N_sample=128;   %������Ԫ��������      
alpha=0.5;        %����ϵ��    %��Ԫ��
dt=Ts/N_sample; %ʱ��ֱ���
t=-3*Ts:dt:3*Ts;

% t1=0:dt:(N/2*N_sample-1)*dt;%���д���ʱ��

%1 �����ҹ����˲����ĳ弤��Ӧh(t)����

ht=sinc(t/Ts).*(cos(alpha*pi*t/Ts))./(1-4*alpha^2*t.^2/Ts^2+eps);


% figure(1)
% plot(t,ht,'LineWidth',1.5);
% grid on;
% axis([-3 3 -0.2 1.2]);
% xlabel('ʱ��(s)');ylabel('��ѹֵ(V)'); 
% title('�������˲����ĳ弤��Ӧh(t)');

%2 ���������ź�
gt_original = [1 zeros(1, N_sample/2-1)];
gt_IQ = [1 zeros(1, N_sample-1)];
RAN = round(rand(1, N)); % ���0 1����
seq_original=[];
seq_I = [];
seq_Q = [];
for i = 1 : N % ��������
   if RAN(i)==1
       seq_original = [seq_original gt_original];
   else
       seq_original = [seq_original -1*gt_original];
   end
end
for i = 1 : N/2 % ��������
   if RAN(2*i)==1
       seq_I = [seq_I gt_IQ];
   else
       seq_I = [seq_I -1*gt_IQ];
   end
      if RAN(2*i-1)==1
       seq_Q = [seq_Q gt_IQ];
   else
       seq_Q = [seq_Q -1*gt_IQ];
   end
end
% figure(2)
% subplot(311)
% plot(t1,seq_original,'LineWidth',1.5);
% axis([0 20 -1.2 1.2]);
% grid on;
% xlabel('ʱ��(s)');ylabel('��ѹֵ(V)'); 
% title('���������ź�ʱ����ͼ');
% subplot(312)
% plot(t1,seq_I,'LineWidth',1.5);
% axis([0 20 -1.2 1.2]);
% grid on;
% xlabel('ʱ��(s)');ylabel('��ѹֵ(V)'); 
% title('I·ʱ����ͼ');
% subplot(313)
% plot(t1,seq_Q,'LineWidth',1.5);
% axis([0 20 -1.2 1.2]);
% grid on;
% xlabel('ʱ��(s)');ylabel('��ѹֵ(V)'); 
% title('Q·ʱ����ͼ');


%3 �����������
% figure(3);

st_I=conv(seq_I,ht);
tt=-3*Ts:dt:(N/2+3)*N_sample*dt-dt;
% subplot(211)
% plot(tt,st_I,'LineWidth',1.5);
% grid on
% axis([0 20 -2 2]);  
% xlabel('ʱ��(s)');title('I·�źų����ź�ʱ����ͼ');

st_Q=conv(seq_Q,ht);
tt=-3*Ts:dt:(N/2+3)*N_sample*dt-dt;
% subplot(212)
% plot(tt,st_Q,'LineWidth',1.5);
% grid on
% axis([0 20 -2 2]);  
% xlabel('ʱ��(s)');title('Q·�źų����ź�ʱ����ͼ');

fc=10000;
I = 2 / sqrt(2) * cos(2*pi*fc*tt);
Q = -2 / sqrt(2) * sin(2*pi*fc*tt);
%Signal = st_I.*I + st_Q.*Q;
signal_complex = (st_I + 1j.*st_Q).*exp(1j*2*pi*fc*tt);

Fs=2000;            %����Ƶ��
Ts=1/Fs;            %�������
Fd=50;             %DopplerƵƫ��Hz
tau=[0,0.001];       %�ྶ��ʱ������s
pdb=[0,0];          %�ྶ�ŵ�����������dB
chan = rayleighchan(Ts, Fd, tau, pdb);

y = filter(chan,signal_complex);

Signal = real(y);
% figure(4)
% plot(tt, Signal);grid on;axis([0 10 -2 2]);title('QPSK');











