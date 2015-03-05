function soln = classpredk(xt, cl)
    % calculate predictor
    sum=0;
    for i=1:length(cl)
        sum=sum+cl(i)*xt(i);
    end
    soln=sum;
end

