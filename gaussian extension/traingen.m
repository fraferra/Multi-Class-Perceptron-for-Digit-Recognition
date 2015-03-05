function [mistakes,a]= traingen( trainSet, a, nDigits, c )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

mistakes=0;
for i=1:length(trainSet)
    realY=trainSet(i,1);
    x=trainSet(i,2:257);
    y=-1;
    maxi=0;
    preds = zeros(nDigits,1);
    updateKernel=gaussianKernel(x,trainSet(:,2:end),c);
    for j=1:nDigits
        preds(j)= classpredk(updateKernel,a(j,:));
    end


    maxc=-10^15;
    for j=0:nDigits-1
        if realY==j
            y=1;
        else
            y=-1;
        end
        
        if y*preds(j+1)<=0 %error event - K is postive and y is negative
            a(j+1,i)=a(j+1,i)-mysign(preds(j+1));
        end
        %get maximum weight and index for that weight
        if preds(j+1)>maxc
            maxc=preds(j+1);
            maxi=j;
        end
        
    end
    %check if a mistake was made
    if maxi~=realY
        mistakes=mistakes+1;
    end
end

end

