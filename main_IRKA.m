clc;
clear;
format short
load Bode_500_10_1e8_1e-8

[E, A, B, C, Pr, Pl] = rcl_ind2(500,10,1e-8,1e-8);

%whos('-file', 'Bode_500_10_1e8_1e-8.mat')
D = 0;
n = size(E, 1);
r = 20;                 
conv_tol = 1e-6;
maxiter = 60;


% Call IRKA for DAE systems 
%[Ar, Br, Cr, Er, converged] = IRKA_D(A, E, B, C, r, Lfull, conv_tol, maxiter); % standard IRKA für DAE
[Ar, Br, Cr, Er, converged] = IRKA_WCF(A, E, B, C, Pr, Pl, Lfull, r, conv_tol, maxiter);  % IKRA using weierstraß canonical form


% Evaluate full and reduced transfer functions
omega = logspace(6, 16, 200);
s = 1i * omega;

G = zeros(size(omega));
Gr = zeros(size(omega));

for k = 1:length(omega)
    Sk = s(k);
    G(k) = C * ((Sk * E - A) \ B) + D;
    Gr(k) = Cr * ((Sk * Er - Ar) \ Br) + D;
end


%% Plot result
figure;

% Magnitude plot with log-scale y-axis
subplot(2,1,1);
semilogx(omega, abs(G), 'b', omega, abs(Gr), 'r--', 'LineWidth', 1.5);
legend('|G(i\omega)|', '|G̃(i\omega)|', 'Location','northwest');
title('Magnitude of Transfer Functions and Absolute Error over Frequency', 'r=20');
ylabel('G(i\omega)|, |G̃(i\omega)|');
set(gca, 'YScale', 'log');  % Logarithmic y-axis
grid on;

% Error plot with log-scale y-axis
subplot(2,1,2);
semilogx(omega, abs(G - Gr), 'k', 'LineWidth', 1.5);
title('Absolute Error |G(i\omega) - G̃(i\omega)|');
xlabel('Frequency (rad/s)');
ylabel('|G(i\omega) - G̃(i\omega)|');
set(gca, 'YScale', 'log');  % Logarithmic y-axis
grid on;








