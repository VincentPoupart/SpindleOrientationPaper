%%%%%%%%%%% Graphics in 3D of the surfaces, spindle vectors, normal vectors
%%%%%%%%%%% and sphere



%%%%%% chose a cell %%%%%%

i = 1;
gonad = Celloutput(i).gonad;
for i = 1:1:length(Germlineoutput)
    Germlines{i,1} = Germlineoutput(i).gonad;
end
specific_gonad = matches(Germlines,gonad);
specific_gonad = num2cell(specific_gonad);
for op=1:1:length(specific_gonad)
    if isequal(specific_gonad{op,1},0)
        specific_gonad{op,1}=[];
    end
end
ffoo = find(~cellfun('isempty', specific_gonad));




%%%%% chose a frame %%%%%%

k = 1;



%%%%%%%%%%   A three-dimensional quiver plot displays vectors with components (u,v,w) at the points (x,y,z), where u, v, w, x, y, and z all have real (non-complex) values.


%%%% area of the patch



r = Celloutput(i).meas(k,17);

rachcentr = Celloutput(i).sp_centroids{1,k};
rachvects = Celloutput(i).sp_rach_vecs{1,k};
rachvectsum = sum(Celloutput(i).sp_rach_vecs{1,k});

xrachcentr = rachcentr(:,1);
yrachcentr = rachcentr(:,2);
zrachcentr = rachcentr(:,3);

minx = nanmin(real(xrachcentr));
maxx = nanmax(real(xrachcentr));
miny = nanmin(real(yrachcentr));
maxy = nanmax(real(yrachcentr));
minz = nanmin(real(zrachcentr));
maxz = nanmax(real(zrachcentr));



%rachvectsum = Celloutput(i).meas(k,14:16);

racho = [mean(rachcentr(:,1)),mean(rachcentr(:,2)),mean(rachcentr(:,3))];
spinvect = Celloutput(i).meas(k,7:9);
spinmid = Celloutput(i).meas(k,4:6);


aa = ((spinmid * 2) - spinvect)./2; 
ab = spinvect + aa;


centa = aa;
centb = ab;
centab(1,:) = centa;
centab(2,:) = centb;

ma = spinmid(1,1);
mb = spinmid(1,2);
mc = spinmid(1,3);





d = rachcentr(:,1);
e = rachcentr(:,2);
f = rachcentr(:,3);

a = rachvects(:,1);
b = rachvects(:,2);
c = rachvects(:,3);


x = racho(1,1);
y = racho(1,2);
z = racho(1,3);

u = rachvectsum(1,1);
v = rachvectsum(1,2);
w = rachvectsum(1,3);

Vv1 = Germlineoutput(ffoo).V1{1,k};
Vv2 = Germlineoutput(ffoo).V2{1,k};
Vv3 = Germlineoutput(ffoo).V3{1,k};

Vvs1 = Celloutput(i).sp_V1{1,k};
Vvs2 = Celloutput(i).sp_V2{1,k};
Vvs3 = Celloutput(i).sp_V3{1,k};

X = zeros(length(Vvs1),3);
X(:,3) = Vvs1(:,1);
X(:,2) = Vvs2(:,1);
X(:,1) = Vvs3(:,1);

Y = zeros(length(Vvs1),3);
Y(:,3) = Vvs1(:,2);
Y(:,2) = Vvs2(:,2);
Y(:,1) = Vvs3(:,2);

Z = zeros(length(Vvs1),3);
Z(:,3) = Vvs1(:,3);
Z(:,2) = Vvs2(:,3);
Z(:,1) = Vvs3(:,3);

X = X';
Y = Y';
Z = Z';

C = ones(3,length(Vvs1));



% % %% Complete rachis


cX = zeros(length(Vv1),3);
cX(:,3) = Vv1(:,1);
cX(:,2) = Vv2(:,1);
cX(:,1) = Vv3(:,1);

cY = zeros(length(Vv1),3);
cY(:,3) = Vv1(:,2);
cY(:,2) = Vv2(:,2);
cY(:,1) = Vv3(:,2);

cZ = zeros(length(Vv1),3);
cZ(:,3) = Vv1(:,3);
cZ(:,2) = Vv2(:,3);
cZ(:,1) = Vv3(:,3);

cX =cX';
cY = cY';
cZ = cZ';

cC = ones(3,length(Vv1));







[O,U,P] = sphere;



% figure(k)
%
% scatter3(centab(:,1), centab(:,2), centab(:,3),'or','MarkerFaceColor', [1 0 0]);
% hold on
% scatter3(spinmid(1,1), spinmid(1,2), spinmid(1,3),'ob','MarkerFaceColor', [0 0 1]);
% hold on
% ss = fill3(X,Y,Z,C);
% set(ss, 'FaceColor', [0 1 1]);
% hold on
% s = surf(O*r+ma, U*r+mb, P*r+mc);
% set(s, 'FaceAlpha', 0.5);
% view([-5,-210]);
% %xlim([40 60]);
% % set(gca,'ZDir','reverse');
% set(gca,'YDir','reverse');
% % set(gca,'XDir','reverse');
% xlabel('x');
% ylabel('y');
% zlabel('z');





% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.5]);
% hold off
% F(k) = getframe(gca) ;
%
%
%
%
%
%
% figure(k)
% l=fill3(X,Y,Z,C);
% set(l, 'FaceColor', [0 1 1]);
% hold on;
% scatter3(centab(:,1), centab(:,2), centab(:,3),'or','MarkerFaceColor', [1 0 0]);
% hold on ;
% scatter3(spinmid(1,1), spinmid(1,2), spinmid(1,3),'ob','MarkerFaceColor', [0 0 1]);
% hold on;
% quiver3(d,e,f,a,b,c);
% view([-5,-210]);
% s = surf(O*r+ma, U*r+mb, P*r+mc);
% set(s, 'FaceAlpha', 0.5);
% view([-5,-210]);
% %xlim([40 60]);
% set(gca,'YDir','reverse');
% %
% figure(k);
% quiver3(d,e,f,a,b,c);
% hold on;
% l = fill3(X,Y,Z,C);
% set(l, 'FaceColor', [0 1 1]);
% hold on;
% scatter3(centab(:,1), centab(:,2), centab(:,3),'or','MarkerFaceColor', [1 0 0]);
% hold on;
% scatter3(spinmid(1,1), spinmid(1,2), spinmid(1,3),'ob','MarkerFaceColor', [0 0 1]);
% hold on;
% quiver3(x,y,z,u,v,w);
% hold on;
% %quiver3(centa(1,1),centa(1,2),centa(1,3),spinvect(1,1),spinvect(1,2),spinvect(1,3),1);
% set(gca,'YDir','reverse');
% view([-5,-210]);
%%xlim([40 60]);
% % F(k) = getframe(gcf) ;
% %
% % frame = getframe(gcf);
% % writeVideo(vid,frame);
% %
% % axis([minx-3 maxx+3 miny-3 maxy+3 minz-3 maxz+3]);
%
%
% set(gca,'YDir','reverse');
% xlim([40 60]);
% % ylim([25 40]);
% % zlim([6 14]);
%
%
%
% figure(k);
% quiver3(d,e,f,a,b,c,1);
% hold on;
% l = fill3(X,Y,Z,C);
% set(l, 'FaceColor', [0 1 1]);
% hold on;
% scatter3(centab(:,1), centab(:,2), centab(:,3),'or','MarkerFaceColor', [1 0 0]);
% hold on;
% scatter3(spinmid(1,1), spinmid(1,2), spinmid(1,3),'ob','MarkerFaceColor', [0 0 1]);
% hold on;
% quiver3(spinmid(1,1),spinmid(1,2),spinmid(1,3),u,v,w,1);
% hold on;
% quiver3(centa(1,1),centa(1,2),centa(1,3),spinvect(1,1),spinvect(1,2),spinvect(1,3),1);
% view([-5,-210]);
% xlim([40 60]);
% set(gca,'YDir','reverse');
% %set(gca,'XDir','reverse');
%
%
% figure(k);
% scatter3(centab(:,1), centab(:,2), centab(:,3),'or','MarkerFaceColor', [1 0 0]);
% hold on ;
% scatter3(spinmid(1,1), spinmid(1,2), spinmid(1,3),'ob','MarkerFaceColor', [0 0 1]);
% hold on;
% quiver3(spinmid(1,1),spinmid(1,2),spinmid(1,3),u,v,w,1,'c');
% hold on;
% quiver3(centa(1,1),centa(1,2),centa(1,3),spinvect(1,1),spinvect(1,2),spinvect(1,3),1,'m');
% view([-5,-210]);
% xlim([40 60]);
% set(gca,'YDir','reverse');




hold on;
figure(1)

% scatter3(centab(:,1), centab(:,2), centab(:,3),200,'MarkerFaceColor', [1 0 0],'MarkerEdgeColor',[1 0 0]);

% xlim([20 140]);
% ylim([5 40]);
% zlim([-2 16]);
% scatter3(spinmid(1,1), spinmid(1,2), spinmid(1,3),'ob','MarkerFaceColor',[0 0 1]);
% s = surf(O*r+ma, U*r+mb, P*r+mc); set(s, 'FaceAlpha', 0.5);
hold on;
l = fill3(cX,cY,cZ,cC);
set(l, 'FaceColor', [0.8 0.8 0.8],'EdgeColor', [0.5 0.5 0.5]);
xlabel('x');
ylabel('y');
zlabel('z');
view([176.242191,-77.753512]);
% set(gca,'YDir','reverse');
% set(gca,'ZDir','reverse');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.05, 1, 0.7]);
axis equal
hold off
F(k) = getframe(gcf) ;
drawnow









%%%%%%% create the video writer with 1 fps
%   writerObj = VideoWriter('myVideo.avi');
%   writerObj.FrameRate = 5;
%   % set the seconds per image
% % open the video writer
% open(writerObj);
% % write the frames to the video
% for i=1:length(F)
%     % convert the image to a frame
%     frame = F(i) ;
%     writeVideo(writerObj, frame);
% end
% % close the writer object
% close(writerObj);