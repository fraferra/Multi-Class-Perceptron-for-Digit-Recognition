% Research Method / CW5 - F. Ferrari and B. Daullxhiu


function res = gaussianKernel(p, q, c)
    % Gaussian kernel
    k = zeros(length(q),1);
    for i=1:length(q)
        k(i) = norm(p-q(i,:));
    end
    res = exp(-c*k.^2);
   
end

