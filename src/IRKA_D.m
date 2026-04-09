function [Ar, Br, Cr, Er, converged] = IRKA_D(A, E, B, C, r,Lfull, conv_tol, maxiter)
% IRKA_D performs H2-based model reduction for descriptor (DAE) systems.
%   E * dx/dt = A * x + B * u,   y = C * x
% Inputs:
%   A, E, B, C : system matrices
%   r          : reduced order
%   conv_tol   : convergence tolerance
%   maxiter    : maximum IRKA iterations
% Outputs:
%   Ar, Br, Cr, Er : reduced model
%   converged      : true if converged

n = size(A, 1);

%% Initial interpolation data using r smallest eigenvalues of lambda*E -A
L = Lfull((abs(Lfull)<1e15));
L = sort(L);
s = -L(1:r);

%% Random generated interpolation points (assume real(lambda)<0, (lmada E - A)) 
% realParts = abs(randn(r,1));      
% imagParts = randn(r,1); 
% s= realParts + 1i * imagParts;

iter = 0;
conv_crit = Inf;
rhs_b = B;
rhs_c = C';

%% IRKA loop
while conv_crit > conv_tol && iter < maxiter
    iter = iter + 1;
    V_new = [];
    W_new = [];

    j = 1;
    while j <= r
        Mb = s(j) * E - A;
        Mc = s(j) * E' - A';

        x = Mb \ rhs_b;
        y = Mc \ rhs_c;

        % Check for NaN/Inf
        if any(isnan(x)) || any(isnan(y))
            warning('NaN in interpolated vectors at iter %d', iter);
            x(:) = 0; y(:) = 0;
        end

        % Handle complex shift
        if abs(imag(s(j)))./abs(s(j)) > 1e-6 && j <= r
            V_new(:, j)   = real(x);
            V_new(:, j+1) = imag(x);
            W_new(:, j)   = real(y);
            W_new(:, j+1) = imag(y);
            j = j + 2;
        else
            V_new(:, j) = real(x);
            W_new(:, j) = real(y);
            j = j + 1;
        end
    end

    % Orthonormalize
    [V, ~] = qr(V_new, 0);
    [W, ~] = qr(W_new, 0);

    
    Er = W' * E * V;
    Ar = W' * A * V;

   
    if any(~isfinite(Ar(:))) || any(~isfinite(Er(:))) ...
        error('Reduced matrices contain NaN or Inf at iter %d.', iter);
    end
    
    if rank(Er) < r
        warning('Projection Er is rank deficient at iter %d', iter);
    end

    % Update interpolation data
    s_old = s;
    [T, S] = eig(Ar,Er); 
    s = -diag(S);
    size(s);

    % Convergence criterion
    conv_crit = norm(sort(s) - sort(s_old)) / norm(s_old);
end
Br = W' * B;
Cr = C * V;
converged = conv_crit < conv_tol;

end