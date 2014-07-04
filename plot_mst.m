%==========================================================================
%   Create Minimum Spanning Tree (MST) and plotting
%==========================================================================
%  Example
%
%  [T]=plot_mst(x)   % x: N x dim
%
%==========================================================================
% January 13, 2009
% Implemented by Daewon Lee
% WWW: http://sites.google.com/site/daewonlee/
%==========================================================================
function [T]=plot_mst(x)

edge=[]; cost=[];
for i=1:size(x,1)
    for j=1:size(x,1)
        if i<j
            edge=[edge; i j];
            cost=[cost; dist2(x(i,:),x(j,:))];
        end
    end
end

T=mst(edge,cost);

[num dummy]=size(T);

if size(x,2)==2
    figure;
    hold on
    for i=1:num
        temp=[x(T(i,1),:);x(T(i,2),:)];
        plot(temp(:,1),temp(:,2));
    end
    title('Proximity graph by Minimum Spanning Tree (MST)');
    hold off
end
