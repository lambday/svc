function [ts]=Find_TSs(locals,model)
%==========================================================================
% Find transition points and label the SEPs
% 1. Find transition points
% 2. Determine the optimal cutting level for making K clusters
% 3. Construct an adjacent matrix
%
% ts.x [N x dim] transition points
% ts.f [N x 1] squared radius on the TS points
% ts.neighbor [N x 2] index of neighbor SEPs
% ts.purturb  [N x 2*dim] purturbed points from the TS
%
%==========================================================================
% January 13, 2009
% Implemented by Daewon Lee
% WWW: http://sites.google.com/site/daewonlee/
%==========================================================================

epsilon=model.options.epsilon;
R=model.r+10^(-7);

options = optimset('LargeScale','on','Display','off','GradObj','on','Hessian','on');
options2 = optimset('Jacobian','on','LargeScale','on','Display','off');

% ts matrix
ts.x=[];    % transition states
ts.f=[];    % f value in x
ts.neighbor=[];    % index of two neighbor local mins;
ts.purturb=[];

[N,attr]=size(locals);
tmp_x=[];

% Find all corresponding equilibrium points for points sampled from 
% lines between pairs of SEPs.
for i=1:N
    for j=i:N
        for k=1:10
            x0=locals(i,:)+0.1*k*(locals(j,:)-locals(i,:));
            [sep]= fsolve(@fsolve_R,x0,options2,model);
            tmp_x=[tmp_x;sep];
        end
    end
end
[dummy,I,J]=unique(round(tmp_x*10),'rows');
tmp_x=tmp_x(I,:);

for i=1:size(tmp_x,1)
    sep=tmp_x(i,:);
    [f,g,H]=my_R(sep,model);
    [V,D]=eig(H);
    if sum(diag(D)<0)==1    % find index-1 transition states
        sep1=sep+epsilon*V(:,find(diag(D)<0))';
        sep2=sep-epsilon*V(:,find(diag(D)<0))';
        if attr==2
            [temp1, val]=fminsearch(@my_R,sep1,[],model);
            [temp2, val]=fminsearch(@my_R,sep2,[],model);
        else
            [temp1, val]=fminunc(@my_R,sep1,options,model);    
            [temp2, val]=fminunc(@my_R,sep2,options,model);
        end
        [dummy,ind1]=min(dist2(temp1,locals));
        [dummy,ind2]=min(dist2(temp2,locals));
        if ind1~=ind2
            % find transition states and ther neighbor local mins
            ts.x=[ts.x;sep];
            ts.f=[ts.f;f];
            ts.neighbor=[ts.neighbor;ind1 ind2];
            ts.purturb=[ts.purturb;sep1 sep2];
        end
    end
end