
clc,clear
a=double(imread('2.jpg'));
b=double(imread('1.jpg'));
[row_a,col_a,g_a]=size(a);%目标文件
[row_b,col_b,g_b]=size(b);%背景文件
mask_A=zeros(row_a,col_a);
imshow(uint8(b));
flat=1;
while flat==1
    [y_start,x_start]=ginput(1);
    x_end=x_start+row_a-1;
    y_end=y_start+col_a-1;
    flat=0;
    if x_end>row_b||y_end>col_b
        disp('Array out of line');
        flat=1;
    end
end
mask_B=ones(row_b,col_b); % x_start y_start: 上层图像开始坐标
mask_B(x_start:x_end,y_start:y_end)=0;
global number
number=1; % a顶部 b背景
%%
[A,B]=create_AB(a(:,:,1),mask_A,b(:,:,1),mask_B);
x_R= A\B;
%%
[~,B]=create_AB(a(:,:,2),mask_A,b(:,:,2),mask_B);
x_G= A\B;
%%
[~,B]=create_AB(a(:,:,3),mask_A,b(:,:,3),mask_B);
x_B= A\B;
%%
[hxb,lxb,l]=find(mask_B==0);%他是按照一列列进行遍历的
s=[hxb';lxb'];
[s1,id1]=sort(s(1,:));
s_z=[s1;s(2,id1)];
hxb=s_z(1,:);
lxb=s_z(2,:);
for i=1:length(l)
    b(hxb(i),lxb(i),1)=x_R(i);
    b(hxb(i),lxb(i),2)=x_G(i);
    b(hxb(i),lxb(i),3)=x_B(i);
end
imshow(uint8(b))