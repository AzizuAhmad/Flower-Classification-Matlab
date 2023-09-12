clc; clear;close all;warning off all;

%memanggil menu "browse file";

[nama_file,nama_folder] = uigetfile('*.jpg');


%jika ada nama file yang dipiih maka akan mengeksekusi perintah dibwah ini
if ~isequal(nama_file,0)
    
    
     %membaca file citra rgb
    img = imread(fullfile(nama_folder,nama_file));
    figure, imshow(img);
   
    
     rataR= mean(mean(img(:,:,1)));
     rataG= mean(mean(img(:,:,2)));
     rataB= mean(mean(img(:,:,3)));
     stdR = std(std(double(img(:,:,1))));
     stdG = std(std(double(img(:,:,2))));
     stdB = std(std(double(img(:,:,3))));
     skewnR = skewness(skewness(double(img(:,:,1))));
     skewnG = skewness(skewness(double(img(:,:,2))));
     skewnB = skewness(skewness(double(img(:,:,3))));
     HSV = rgb2hsv(img);
     Hue = mean(mean(HSV(:,:,1)));
     Saturation = mean(mean(HSV(:,:,2)));
     Value = mean(mean(HSV(:,:,3)));
   
    
     
    %konversi citra rgb ke grayscale
    img_gray = rgb2gray(img);
    %figure,imshow(img_gray);
    
    lbpB1 =  extractLBPFeatures(img_gray,'Upright',false);
    lb1 = sum(lbpB1);
    
    %melakukan ekstraksi ciri tekstur menggunkan metode glcm
    
    GLCM = graycomatrix(img_gray,'offset',[2,0]);
    stats = graycoprops(GLCM,'correlation','energy');
    stats2 = graycoprops(GLCM,'contrast','homogeneity');
    
    Correlation = stats.Correlation;
    Homogeneity = stats2.Homogeneity;
    Contrast = stats2.Contrast;
    Energy = stats.Energy;
    
    %menyusun variabel data latih
    data_uji(1,1) = Correlation;
    data_uji(1,2) = Energy;
    data_uji(1,3)= Homogeneity;
    data_uji(1,4) = Contrast;
    data_uji(1,5) = lb1;
    data_uji(1,6) = rataR;
    data_uji(1,7) = rataG;
    data_uji(1,8) = rataB;
    data_uji(1,9) = stdR;
    data_uji(1,10) = stdG;
    data_uji(1,11) = stdB;
    data_uji(1,12) = skewnR;
    data_uji(1,13) = skewnG;
    data_uji(1,14) = skewnB;
    data_uji(1,15) = Hue;
    data_uji(1,16) = Saturation;
    data_uji(1,17) = Value;
    
    
     %memanggil variabel Mdl hasil dari pelatihan
    load Mdl

    %membaca kelas keluaran hasil pengujian 
    kelas_keluaran = predict(Mdl,data_uji);
    
    %menampilkan citra asli dan kelas pengeluaran hasil pengujian
    figure, imshow(img);
    title({['Nama File : ',nama_file],['kelas Keluaran : ',kelas_keluaran{1}]});
else
    %jika tidak ada nama file yang dipilih maka akan kemabali
    return 
end
