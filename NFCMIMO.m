tx = 4;
rx = 4;
symbols = 1000;
fc = 2.4e9;
c = 3e8;
mod = 4;
lambda = c/fc;
d_tx = lambda/2;
d_rx = lambda/2;
d = 0.5;
SNR = 0:5:30;
BER = zeros(1,length(SNR));
for idx=1:length(SNR)
    SNR_idx = SNR(idx);
    modata = randi([0 mod-1],tx,symbols);
    txsymbol = qammod(modata,mod);
    H = zeroes(tx,rx);
    for i=1:length(rx)
        for j=1:length(tx)
            d_ij = sqrt((i*d_rx)^2+(j*d_tx)^2+d^2);
            H(i,j) = exp(-1i*2*pi*d_ij/lambda)/d_ij;
        end
    end
    txsignal = H*symbols;
    noise = sqrt(0.5)*randn(size(txsignal))+1i*randn(size(txsignal));
    rxsignal = awgn(txsignal,SNR_idx,'measured');
    H_inv = pinv(H);
    rxsymbol = H_inv*rxsignal;
    rxdata = qamdemod(rxsymbol,mod);
    [numErrors,BER(idx)] = biterr(rxdata,modata);
end
figure;
semilogy(SNR,BER,'-o');
grid on;
xlabel('SNR in dB')
ylabel('BER')
title('NFC using MIMO')
legend('NFC 4X4 MIMO')

