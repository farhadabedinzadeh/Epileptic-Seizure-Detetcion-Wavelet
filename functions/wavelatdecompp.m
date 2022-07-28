function [D1,D2,D3,D4,D5,D6,D7,D8,A8] = wavelatdecompp(signal,level,wavename)

[C,L]=wavedec(signal,level,wavename);                       
[THR,SORH,KeepApp]=ddencmp('den','wv',signal); 
Input_test= wdencmp('gbl',C,L,wavename,4,THR,SORH,KeepApp); 
    
    
    WaveletFunction='db8'; %OR 'sym8' Symlet8
    [C,L]=wavedec(signal,8,WaveletFunction);
    %% Calculate The Coefficient Vector
    
    %%%CoefficientDtail=DetailCoefficient(C,L,level);
    
    cD1=detcoef(C,L,1);  %Noisy
    cD2=detcoef(C,L,2);  %Noisy
    cD3=detcoef(C,L,3);  %Noisy
    cD4=detcoef(C,L,4);  %Noisy
    cD5=detcoef(C,L,5);  %Gama
    cD6=detcoef(C,L,6);  %Beta
    cD7=detcoef(C,L,7);  %Alpha
    cD8=detcoef(C,L,8);  %Teta
    cA8=appcoef(C,L,WaveletFunction,8);  %Delta   %CoefficientApproximation=ApproximationCoefficient(C,L,level)
    
    
    %%%%Calculate The Details Vector
        
    D1=wrcoef('d',C,L,WaveletFunction,1);    %Noisy
    D2=wrcoef('d',C,L,WaveletFunction,2);    %Noisy
    D3=wrcoef('d',C,L,WaveletFunction,3);    %Noisy
    D4=wrcoef('d',C,L,WaveletFunction,4);    %Noisy
    D5=wrcoef('d',C,L,WaveletFunction,5);    %Gama
    D6=wrcoef('d',C,L,WaveletFunction,6);    %Beta
    D7=wrcoef('d',C,L,WaveletFunction,7);    %Alpha
    D8=wrcoef('d',C,L,WaveletFunction,8);    %Teta
    A8=wrcoef('d',C,L,WaveletFunction,8);    %Delta

end