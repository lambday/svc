%==========================================================================
%   Create KNN plotting
%==========================================================================
%  Example
%
%  [result]=knn_svc(k,Samples)   % Samples: dim x N
%
%==========================================================================
% January 13, 2009
% Implemented by Daewon Lee
% WWW: http://sites.google.com/site/daewonlee/
%==========================================================================

function [result]=knn_svc(k,Samples)

N=size(Samples,2);
result=zeros(N,k);
for i=1:N
    temp=dist2(Samples(:,i)',Samples');
    [dummy ind]=sort(temp);
    result(i,:)=ind(1,2:k+1);
end

if size(Samples,1)==2
    figure;
    hold on
    for i=1:N
        for j=1:k
            temp=[Samples(:,i)';Samples(:,result(i,j))'];
            plot(temp(:,1),temp(:,2));    
        end
    end
    title('Proximity graph by K-Nearest neighborhood (KNN)');
    hold off
end
