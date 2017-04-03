function [ c ] = RLE2huff_byte( b )
%takes input a zero run length encoded mx2 matrix and returns an vector
length=size(b,1) ;
c=zeros(length,1) ;% initializing the output vector
for i=1:length
    nibb1=de2bi(b(i,1),4) ; %lower nibble will store the  consecutive run of zeros
    d=de2bi(abs(b(i,2)));
    e=size(d,2) ;
    nibb2=de2bi(e,4);% higher nibble will store the minimum number of bits required to store the absolute value of second element in run length pair
    c(i,1)=b(i,1) ;
    c(i,2)=b(i,2) ;
    c(i,3)=bi2de(horzcat(nibb1,nibb2)); %value of the huffman byte
end
end

