%% Вычислитель синдрома ошибок
clc; clear; close all;
m = 10; 
n = 128; % длина кодового слова
N = 2^10;
t=6; % макс число исправляемых ошибок в коде
pp = primpoly(10);
% v1 = randi([0 1], 1,128);
% v2 = gf(v1,m,pp);
v1 = zeros(1,128);
v1(5)=1;
v1(50)=1;
v1(51)=1;
v1(102)=1;
v1(124)=1;
v1(126)=1;

syndrome = gf(zeros(1, 2*t), m, pp);
v_gf = gf(fliplr(v1), m, pp);
alpha = gf(2, m, pp); % примитивный элемент поля

for j = 1:2*t
    for i = 0:n-1
        syndrome(j) = syndrome(j) + v_gf(i+1) * (alpha^j)^(n-1-i);
    end
end

rec = find(v1 > 0) - 1;
fprintf('Принятый многочлен: x^%u+x^%u+x^%u+x^%u+x^%u+x^%u\n', rec);
fprintf('Синдром = [%s]\n',num2str(syndrome.x));
%% RiBM

gamma = gf(1,m,pp);
k = 0;

delta = gf(zeros(1, 3*t+2), m, pp);         
delta(3*t+1) = gf(1,m,pp);
delta(1:(2*t)) = syndrome;
theta = delta(1:3*t+1);   
delta_next = delta;

for r=1:2*t+1         
    delta = delta_next;    
    delta_next(1:3*t+1) = (gamma.*delta(2:3*t+2))-(delta(1).*theta(1:3*t+1));
    if((delta(1) ~= gf(0,m,pp)) && (k>=0))
        theta = delta(2:3*t+2);
        gamma = delta(1);
        k = -k-1;
    else
        theta = theta;
        gamma = gamma;
        k = k+1;
    end          
end

lambda = delta(t+1:2*t+1); % Полином локатора ошибок
%% Процедура Ченя 
roots = [];

for i = 0:N-2
    alpha = gf(2, m, pp)^i;
    rule = gf(0, m, pp);
    for j = 1:length(lambda)
        rule = rule + lambda(j)*alpha^(j-1);
    end
    if rule == gf(0,m,pp)
        roots = [roots i];
    end
end

fprintf('Локаторы ошибок: %u, %u, %u, %u, %u, %u\n', roots);
roots_pos = N-1-roots(:);
fprintf('Позиции ошибок: %u, %u, %u, %u, %u, %u\n', roots_pos);

root_new = zeros(1,n);
root_new(roots_pos+1) = 1;
e = v_gf + gf(fliplr(root_new),m,pp);
correct = find(fliplr(e.x) > 0)-1;
fprintf('Исправленный многочлен: x^%u+x^%u+x^%u+x^%u+x^%u+x^%u+x^%u+x^%u+x^%u+x^%u\n', correct);