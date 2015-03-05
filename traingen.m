% Research Method / CW5 - F. Ferrari and B. Daullxhiu


function [mistakes,a]= traingen( trainSet, a, nDigits, kernelMatrixTrain )
%traingen - method that calculates number of mistakes and return updated
%coefficient matrix
%INPUT
%trainSet - training set including y and x
%a - coefficient matrix
%nDigits - number of digits that we are trying to classify
%kernelMatrixTrain - Gram Matrix for the train set. we pass this to lower
%considerably the computational time
%OUTPUT
%mistakes - total number of mistakes made
%a - coefficient matrix

mistakes=0;
for i=1:length(trainSet)
    realY=trainSet(i,1);
    x=trainSet(i,2:257);
    y=-1;
    maxi=0;
    preds = zeros(nDigits,1);
    tmpKernel=kernelMatrixTrain(i,:);
    for j=1:nDigits
        preds(j)= classpredk(tmpKernel,a(j,:));
    end

    maxc=-10^15;
    %for j=0:nDigits-1
    for j=0:nDigits-1
        if realY==j
            y=1;
        else
            y=-1;
        end
        
        if y*preds(j+1)<=0 %error event - K is postive and y is negative
            a(j+1,i)=a(j+1,i)-mysign(preds(j+1));
        end
        if preds(j+1)>maxc
            maxc=preds(j+1);
            maxi=j;
        end
        
    end
    if maxi~=realY
        mistakes=mistakes+1;
    end
end

end

