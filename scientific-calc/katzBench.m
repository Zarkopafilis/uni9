% load email first
tolerance = 1e-7;
maxreps = 50;

I = eye(size(email));
e = ones(size(email, 1), 1);

% find min and max a that makes sense
% fprintf("Finding which a result to invertible matrix\n");
% 
valid_a = [];

tic
for a = 0.01:0.01:1
    if det(I - a * email') ~= 0
        if all((I - a * email') * e > 0)
            valid_a = [valid_a a];
        end
    end
end
toc


max_a = max(valid_a);
min_a = min(valid_a);

fprintf("max(a) = %f \nmin(a) = %f\n", max_a, min_a);

a = [min_a max_a];

fprintf("\n\n DIRECT ")
method = "direct";
params = {};
X = multiKatz(email, a, method, params);
fprintf("explicit (mina) \n");
show_top5(X(1, :));
fprintf("explicit (maxa) \n");
show_top5(X(end, :));

fprintf("\n\n PCG ")

method = "pcg";
params = {tolerance, maxreps};
X = multiKatz(email, a, method, params);
fprintf("pcg no prec (mina) \n");
show_top5(X(1, :));
fprintf("pcg no prec (maxa) \n");
show_top5(X(end, :));

fprintf("\n\n PCG ICHOL ")

method = "pcg";
params = {tolerance, maxreps, "ichol"};
X = multiKatz(email, a, method, params);
fprintf("pcg ichol prec (mina) \n");
show_top5(X(1, :));
fprintf("pcg ichol prec (maxa) \n");
show_top5(X(end, :));

function [] = show_top5(x)
    m = maxk(x, 5);
    top5 = find(x >= m(end));
    top5 = sort(top5, 'descend');
    fprintf("%d,", top5);
    fprintf("\n");
end
