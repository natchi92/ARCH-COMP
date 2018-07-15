if dim > 3
    disp('Plotting the grid is only possible for systems up to 3 dimensions.');
    return
elseif dim == 3
    X_data = (X*[ones(1,16);zeros(2,16);0.5*[-1,1,1,-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1];zeros(2,16)])';
    Y_data = (X*[zeros(1,16);ones(1,16);zeros(2,16);0.5*[-1,-1,-1,-1,1,1,-1,1,1,-1,1,1,-1,1,1,-1];zeros(1,16)])';
    Z_data = (X*[zeros(2,16);ones(1,16);zeros(2,16);0.5*[-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,1,1]])';
    C_data = ones(size(X_data));
    figure;
    p=patch(X_data,Y_data,Z_data,C_data,'FaceColor','none');
    axis equal tight
elseif dim == 2
    X_data = (X*[ones(1,dim*2);zeros(1,dim*2);0.5*[-1,1,1,-1];zeros(1,dim*2)])';
    Y_data = (X*[zeros(1,dim*2);ones(1,dim*2);zeros(1,dim*2);0.5*[-1,-1,1,1]])';
    C_data = ones(4,size(X,1));
    figure;
    p=patch(X_data,Y_data,C_data,'FaceColor','w');
    %axis equal tight
elseif dim == 1
    X=sortrows(X,1);
    X_data = [X*[1 -0.5]',X*[1 0.5]',X*[1 0.5]']';
    X_data = X_data(:);
    Y_data = [X*[0 1]',X*[0 1]',[X(2:end,2);1]]';
    Y_data = Y_data(:);
    figure;
    p=line(X_data(1:end-1),Y_data(1:end-1));
    axis normal
    axis([X(1,1)-0.5*X(1,2)-eps X(end,1)+0.5*X(end,2)+eps 0 max(X(:,2))+eps])
end
% Color the grid acoording to the solution of the problem
colormap jet
if dim == 1
%    X=getappdata(handles.pushbutton2,'RepresentativePoints');
    X_data = (X*[ones(1,4);0.5*[-1,1,1,-1]])';
    Y_data = (X*[zeros(1,4);[0,0,1,1]])';
    C_data = ones(4,size(X,1));
    figure;
    hold on
    p=patch(X_data,Y_data,C_data,'FaceColor','w');
    hold off
    set(p,'FaceColor','flat','CData',Solution,'EdgeAlpha',0);
elseif dim == 2
    set(p,'FaceColor','flat','CData',Solution,'EdgeAlpha',0);
elseif dim == 3
    set(p,'EdgeColor','flat','CData',kron(Solution,ones(16,1)),'Linewidth',10/m^(1/3));
end
colorbar('location','EastOutside')
