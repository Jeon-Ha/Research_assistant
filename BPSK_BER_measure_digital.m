clc;
clear all;
close all;


message = randi([0,1],1,100000);  %�����ϴ� �޽���
for i = 1:1:length(message)
    if message[i] == 1
        bit = 1;
    else
        bit = 0;
        
    end  
end
epoch = 0; % trial Ƚ��
error = 0;

for x = 0:1:10
   while(error == 200)
      noise_xdB = sqrt(N/2)*randn(1,n);           % white_gaussian_noise(mean = 0, var = N_0dB)
      receive = symbol + noise_xdB; %���� �ɹ� 
        if(receive > 0)
            receive_bit = 1;
        else 
            receive_bit = 0;
        end
   end
   BER = error/(epoch*length(message));  %BER = �������
end

