function [x, iter] = boxcqp(G, d, xl, xu)
%
% Description: 
%   Solves the convex quadratic minimization problem
%
%           min 1/2 x' G x + x' d
%           s.t.  xl <= x <= xu
%
% Input: 
%   G : (nxn) Hessian matrix (positive definite)
%   d : (nx1) linear term
%   xl: (nx1) lower bound
%   xu: (nx1) upper bound
%
% Output:
%   x   :  (nx1) Solution
%   iter:   Number of iterations
%
    n = length(d);
    i = 1:n;
    %
    % Inititalize iteration counter
    iter = 1;
    %
    % Calculate initial point (Newton point)
    l(i) = 0;
    m(i) = 0;
    l= l';
    m = m';
    x = -G \ d;
    %
    % Check for feasibility of the Newton point
    if ( isfeas(x, xu, xl)==0)
       %disp('Newton point solution: ')
       %disp(x);
       return;
    end 
    %
    % Loop until convergence to KKT point
    while 1>0,
        %    
        % 1. Step: Define L, U, S sets 
        Lset = find((x<xl | (x==xl & l>=0))>0);
        Uset = find((x>xu | (x==xu & m>=0))>0);
        Sset = find(((x>xl & x<xu)|(x==xl & l<0)|(x==xu & m<0) )>0);

        %
        % 2. Step: Projections
        x(Lset) = xl(Lset);
        m(Lset) = 0;

        x(Uset) = xu(Uset);
        l(Uset) = 0;

        m(Sset) = 0;
        l(Sset) = 0;

        %
        % 3. Step: Form reduced Ax = b!!!
        if (~isempty(Sset))
            b(Sset) = 0;
            b = b';
            if (~isempty(Lset))
               b(Sset) = b(Sset) - G(Sset,Lset)*xl(Lset);
            end
            if (~isempty(Uset))
               b(Sset) = b(Sset) - G(Sset,Uset)*xu(Uset);
            end

            b(Sset) = b(Sset) - d(Sset);

            A = G(Sset, Sset);
        %
        % 3.1 Calculate x in S 
            x(Sset) = A\b(Sset);
            clear('A', 'b');

        end
        %
        % 3.2 Calculate lamda in L 
        if (~isempty(Lset))
           l(Lset) = G(Lset, i) * x(i) + d(Lset) ;
        end
        %
        % 3.2 Calculate mu in U 
        if (~isempty(Uset))
           m(Uset) = -G(Uset, i) * x(i) - d(Uset);
        end

        % 4. Step: Check if KKT conditions are satisfied
        iter = iter + 1;
        f = quadratic(G, d, proj(x, xu, xl));
        %fprintf(1, 'Iter: %i, F = %f \n', iter, f);
        if (isempty(Sset) | (x(Sset)>xl(Sset) & x(Sset)<xu(Sset)))
            if  ((~isempty(Uset) & m(Uset)>=0 | isempty(Uset))) 
                if ((~isempty(Lset) & l(Lset)>=0 | isempty(Lset)))  
                        %disp('Point reached: ')
                       return;
                end
            end
        end
        %
        % Extra check: Do not iterate more than 20 times
        %              the problem dimension
        if iter > n*20 
            return;
        end
    end
end

%
% Check if x is feasible (i.e  inside the box defined by xl, xu)
function res = isfeas(x, xu, xl)
    n = length(x);
    for i=1:n
        if (x(i)>xu(i) | x(i)<xl(i))
            res = 1;
                return;
        end            
    end 
    res = 0;
end

%
% Projects x on the box defined by xl, xu
function y = proj(x, xu, xl)
    n = length(x);
    y = x;
    for i=1:n
       if (x(i)>=xu(i))
          y(i) = xu(i);
       elseif (x(i)<=xl(i))    
          y(i) = xl(i);    
       end            
    end
end

function f = quadratic(B, d, x)
    f = 1/2 * (x' * B * x) + x'* d;
end