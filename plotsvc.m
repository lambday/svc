function varargout=plotsvc(data,model)


[Ax,Ay] = meshgrid(linspace(-5,5,100),linspace(-5,5,100));
dist = kdist2([Ax(:)';Ay(:)'],model);

if isequal(model.options.method,'SEP-CG') | isequal(model.options.method,'E-SVC') 
    figure; hold on; 
    test.X=data.X;
    test.y=model.cluster_labels; 
    ppatterns2(data.X(:,model.sv_ind),'ro',10);   % SV
    plot(model.local(1,:),model.local(2,:),'rs','MarkerSize',10); % SEP    
    if isfield(model,{'ts'})
        plot(model.ts.x(:,1),model.ts.x(:,2),'r+','MarkerSize',10);
        legend('SVs','SEPs','TSs','Location','SouthEast');
    else
        legend('SVs','SEPs','Location','SouthEast');
    end
    ppatterns2(test); 
    contour( Ax, Ay, reshape(dist,100,100),[model.r model.r],'k');    
    title(strcat(['Labelling method: ', model.options.method]));
    hold off
else
    figure; hold on; 
    test.X=data.X(:,model.inside_ind);
    test.y=model.cluster_labels(model.inside_ind); 
    ppatterns2(data.X(:,model.sv_ind),'ro',10);   % SV
    ppatterns2(data.X(:,model.bsv_ind),'k.',5);  % BSV   
    ppatterns2(test); 
    contour( Ax, Ay, reshape(dist,100,100),[model.r model.r],'k');
    legend('SVs','BSV (outliers)','Location','SouthEast');
    title(strcat(['Labelling method: ', model.options.method]));
    hold off
end

