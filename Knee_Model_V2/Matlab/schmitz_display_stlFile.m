function [p,v,f,c] = schmitz_display_stlFile(filename,dir)

[f,v,c] = load_stlFile([dir filename]);
p = patch('faces', f, 'vertices' ,v);
set(p, 'FaceColor',[0.4 0.3 0.1]); % Set the face color
set(p, 'FaceLighting','flat');       % other options: 'gouraud', 'phong' a good (and slow) renderer, 'flat'
set(p, 'BackFaceLighting','lit');       
set(p, 'EdgeColor','none','Clipping','on');           % Don't show the edges
set(p, 'EdgeLighting', 'flat');
set(p, 'FaceAlpha',0.8,'AmbientStrength',1,'DiffuseStrength',1,'SpecularColorReflectance',1);           % Make bone transperant 
% Make the bone glow brighter
daspect([1 1 1])                      % Ensure equal scaling in alldirections
view(3)                               % Isometric view
material dull