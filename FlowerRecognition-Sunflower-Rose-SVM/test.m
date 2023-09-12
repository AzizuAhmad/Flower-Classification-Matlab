clc; clear;close all; warning off all;

%mentapkan nama folder
nama_folder = 'data uji';
%membaca nama file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file yang berekstensi .jpg
jumlah_file = numel(nama_file);

%menginisialisasi variabel data latih
data_uji = zeros(jumlah_file,17);

%melakukan pengolahan citra terhadap seluruh file
for k = 1:jumlah_file
    %membaca file citra jpg
    img = imread(fullfile(nama_folder,nama_file(k).name));
    %figure, imshow(img);
    
     rataR= mean(mean(img(:,:,1)));
     rataG= mean(mean(img(:,:,2)));
     rataB= mean(mean(img(:,:,3)));
     stdR= std(std(double(img(:,:,1))));
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
    %pixel_dist = 1;
    GLCM = graycomatrix(img_gray,'offset',[2,0]);
    stats = graycoprops(GLCM,'correlation','energy');
    stats2 = graycoprops(GLCM,'contrast','homogeneity');
    
    Correlation = stats.Correlation;
    Homogeneity = stats2.Homogeneity;
    Contrast = stats2.Contrast;
    Energy = stats.Energy;
    
    %menyusun variabel data latih
    data_uji(k,1) = Correlation;
    data_uji(k,2) = Energy;
    data_uji(k,3)= Homogeneity;
    data_uji(k,4) = Contrast;
    data_uji(k,5) = lb1;
    data_uji(k,6) = rataR;
    data_uji(k,7) = rataG;
    data_uji(k,8) = rataB;
    data_uji(k,9) = stdR;
    data_uji(k,10) = stdG;
    data_uji(k,11) = stdB;
    data_uji(k,12) = skewnR;
    data_uji(k,13) = skewnG;
    data_uji(k,14) = skewnB;
    data_uji(k,15) = Hue;
    data_uji(k,16) = Saturation;
    data_uji(k,17) = Value;
    
end

%menetapkan target latih
target_uji = cell(jumlah_file,1);
for k =1:195
    target_uji{k} = 'rose';
end

for k =196:377
    target_uji{k}= 'sunflower';
end

load Mdl
%membaca kelas keluaran hasil latihan 
kelas_keluaran = predict(Mdl,data_uji);

%menghitung akurasi pelatihan
jumlah_benar = 0;
for k =1:jumlah_file
    if isequal(kelas_keluaran{k},target_uji{k})
        jumlah_benar = jumlah_benar +1;
    end
end

akurasi_pengujian = jumlah_benar/jumlah_file*100






