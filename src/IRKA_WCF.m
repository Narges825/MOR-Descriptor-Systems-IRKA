function [Ar, Br, Cr, Er, converged] = IRKA_WCF(A, E, B, C, Pr, Pl, Lfull, r, conv_tol, maxiter)
n = size(A, 1);
m = size(B, 2);
p = size(C, 1);


%% Initial interpolation data 
L = Lfull((abs(Lfull)<1e15));
L = sort(L);
s = -L(1:r);

% IRKA iterations
iter = 0;
conv_crit = inf;
rhs_b = Pl * B;
rhs_c = Pr' * C';
while conv_crit > conv_tol && iter < maxiter
    iter = iter + 1;
    j = 1;
    while j <= r

        x = (s(j) * E - A) \ rhs_b;
        y = (s(j) * E' - A') \ rhs_c;

        if any(isnan(x)) || any(isnan(y))
            warning('NaN in interpolated vectors at iter %d', iter);
            x(:) = 0; y(:) = 0;
        end

        if abs(imag(s(j)))./abs(s(j)) > 1e-6 && j < r 
            Vf(:, j)   = real(x);
            Vf(:, j+1) = imag(x);
            Wf(:, j)   = real(y);
            Wf(:, j+1) = imag(y);
            j = j + 2;
        else
            Vf(:, j) = real(x);
            Wf(:, j) = real(y);
            j = j + 1;
        end
    end

    [Vf, ~] = qr(Vf, 0);
    [Wf, ~] = qr(Wf, 0);

    
    if rank(full(Wf' * E * Vf)) < r
        warning('Projection Er is rank deficient at iter %d', iter);
    end
    
    
    E_sp = Wf' * E * Vf;
    A_sp = Wf' * A * Vf;


    %% Get reduced poles 
    [Zr, Lam, Wr] = eig(full(A_sp), full(E_sp)); % Right eigenvectors Zr, left Wr
    s_old = s;
    s = -diag(Lam);
  
    
    conv_crit = max(abs((sort(s) - sort(s_old)))) / max(abs(s_old));
    
end

converged = (conv_crit < conv_tol);
fprintf('IRKA finished in %d iterations. Converged: %d\n', iter, converged);
I = speye(n);
Vinf = orth(full(I - Pr)); 
Winf = orth(full(I - Pl'));
V = [Vf,Vinf]; W=[Wf,Winf];
Er = W'*E*V; 

Ar=W'*A*V;
Br=W'*B;
Cr = C*V;
end

