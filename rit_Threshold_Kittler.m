function Topt = rit_Threshold_Kittler(obr)
% Looking for optimal threshold based on Kittler thresholding

obr = double(obr);

% obr=obr*1/max(max(obr));
% obr(obr<0.5*mean(mean(obr))) = mean(mean(obr));
% obr = 1 - obr;
h = imhist(obr);

p = h/sum(h);
p(1) = 0;

for i = 1:length(p)
    P = sum(p(1:i));
    mf = sum([1:i].*p(1:i)');
    sigma_f = sqrt(sum((([1:i]-mf).^2) .*p(1:i)'));
%     sf = std(p(1:i));
    mb = sum([i+1:length(p)].*p(i+1:end)');
    sigma_b = sqrt(sum(([i+1:length(p)]-mf).^2 .* p(i+1:end)'));
%     sb = std(p(i+1:end));
%     T(i) = P * log(sf) + (1-P) * log(sb) - P*log(P) - (1-P)* log(1-P);
    T(i) = P * log(sigma_f) + (1-P) * log(sigma_b) - P*log(P) - (1-P)* log(1-P);
end

Topt = (find(T == min(T(T>-inf))))/256
Topt=Topt(end);


