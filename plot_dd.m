%==========================================================================
%   Create Delaunay diagram and plotting
%==========================================================================
%  Example
%
%  [T]=plot_dd(x)   % x: N x dim
%
%==========================================================================
% January 13, 2009
% Implemented by Daewon Lee
% WWW: http://sites.google.com/site/daewonlee/
%==========================================================================

function [T]=plot_dd(x)

T=delaunayn(x);
[num dummy]=size(T);

if size(x,2)==2
    figure;
    hold on
    for i=1:num
        temp=[x(T(i,1),:);x(T(i,2),:);x(T(i,3),:);x(T(i,1),:)];
        plot(temp(:,1),temp(:,2));
    end
    title('Proximity graph by Delaunay diagram (DD)');
    hold off
end