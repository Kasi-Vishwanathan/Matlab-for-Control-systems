% Parameters
numTransmitAntennas = 2;
numReceiveAntennas = 2;
numSymbols = 1000; % Number of symbols to transmit
SNR_dB = 0:5:30; % Array of SNR values in dB

% Preallocate BER array
BER = zeros(length(SNR_dB), 1);

for snrIndex = 1:length(SNR_dB)
    % Generate random data symbols
    data = randi([0 1], numSymbols, numTransmitAntennas); %Generating input data
    modData = 2*data-1; % BPSK modulation

    % Channel matrix 
    H = (randn(numReceiveAntennas, numTransmitAntennas) + 1j*randn(numReceiveAntennas, numTransmitAntennas)) / sqrt(2);

    % Transmitting through MIMO
    txSignal = modData * H;

    % Add noise
    noise = (randn(numSymbols, numReceiveAntennas) + 1j*randn(numSymbols, numReceiveAntennas)) / sqrt(2);
    noisePower = 10^(-SNR_dB(snrIndex)/10);
    rxSignal = txSignal + sqrt(noisePower) * noise;

    % MIMO Detection using Zero Forcing Equalization
    H_pseudoInv = pinv(H); % Pseudo-inverse
    detectedData = rxSignal * H_pseudoInv;

    % Real data
    detectedDataBinary = real(detectedData) > 0;

    % Calculation of BER
    bitErrors = sum(detectedDataBinary ~= data);
    BER(snrIndex) = bitErrors / (numSymbols * numTransmitAntennas);
end

% Plot 
figure;
semilogy(SNR_dB, BER, '-o');
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs. SNR for MIMO Multiplexing');
grid on;
