function plotP(varargin)
% Modified: 17.08.07 (correct cell nr by shifting back one cell!)
% Modified: 14.11.07 (implement different colors)
% Modified: 26.03.08 (implement polytope plot)


%no color specified
if nargin==2
    obj=varargin{1};
    p=varargin{2};
    color='b'; %b=blue
    plotStyle='fill';
    newfigure=0;
    
%color specified
elseif nargin==3
    obj=varargin{1};
    p=varargin{2};
    color=varargin{3};
    plotStyle='fill';
    newfigure=0;
    
%color and newfigure specified
elseif nargin==5
    obj=varargin{1};
    p=varargin{2};
    color=varargin{3};
    plotStyle=varargin{4};
    newfigure=varargin{5};  
end

if newfigure
    figure; 
end

l=linspace(1,0,100)';
o=ones(100,1);

%prepare colormap
switch color
  case 'b' %blue
    colormap([l,l,o]);
  case 'r' %red
    colormap([o,l,l]);
  case 'g' %green
    colormap([l,o,l]);
  case 'k' %black
    colormap([l,l,l]);    
  otherwise
    disp('Error: unspecified color');
end


hold on
%get maximum probability for normalization
pMax=max(p);
%find nonzero probabilities
ind=find(p);
for i=1:length(ind)
    cellNr=ind(i)-1;
    if cellNr~=0
        %generate polytope out of cell
        IHP=segmentPolytope(obj,cellNr); %IHP:interval hull polytope        
        if strcmp(plotStyle,'polytope')
            options.color=color;
            options.linestyle='none';
            options.shade=p(cellNr+1)/pMax;
            plot(IHP,options);            
        else
            %get vertices
            V=vertices(IHP);
            x=V(1,:);
            y=V(2,:);
            k=convhull(x,y);
            fill(x(k),y(k),0,'EdgeColor','none'); %workaround to adjust colorbar
            fill(x(k),y(k),p(cellNr+1),'EdgeColor','none');
        end
    end
end
%-------------------------------------------------------