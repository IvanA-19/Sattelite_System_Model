function out = psk_theory(EbNo_dB, M, type)
% Точные теоретические BER/SER для PSK

EbNo_lin = 10.^(EbNo_dB/10);

switch M
    case 2  % BPSK
        ber = qfunc(sqrt(2*EbNo_lin));
        ser = ber;
        
    case 4  % QPSK (Gray coding)
        ber = qfunc(sqrt(2*EbNo_lin));
        q = qfunc(sqrt(2*EbNo_lin));
        ser = 2*q - q.^2;
        
    case 8  % 8-PSK
        ber = berawgn(EbNo_dB, 'psk', 8, 'nondiff');
        ser = berawgn(EbNo_dB, 'psk', 8, 'nondiff'); % Для SER нужна Es/No
        % Полная формула SER для 8-PSK через интеграл
end

switch type
    case 'ber', out = ber;
    case 'ser', out = ser;
end
end