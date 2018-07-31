
line=uint8([0:1:255,0:1:255]);
B=uint8(zeros(1536,2048,3));

for i=1:1:512
    for j=1:1:4   
        B(:,(i-1)*4+j,1)=line(1,i);
    end
end
    B(:,:,2)=B(:,:,1);
    B(:,:,3)=B(:,:,1);
imwrite(B,'1.bmp')

    