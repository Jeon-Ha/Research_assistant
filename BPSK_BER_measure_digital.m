message=randi([0,1],1,1000000);
count=0;
simbol=message;               %심볼화
for i = 1:1:length(message)
    if(message(1,i)==0)
        simbol(1,i)=-1;
    end
end

for x_dB= 0:1:10
    epoch=0;
    error=0;
    while error==200
        S=sum(simbol.^2)/length(simbol);
        N=S*10^(-0.1*x_dB);
        noise =sqrt(N/2)*randn(1,length(simbol));      % 잡음 생성
        simbol_noise=simbol+noise;
        simbol_demo = simbol_noise;
        for j=1:1:length(message)
            if(simbol_noise(1,j)>=0)
                simbol_demo = 