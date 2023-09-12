clc;clear;close all;warning off all;

%menetapkan nama folder
nama_folder = 'data latih';
%membaca nama file ekstensi jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file ekstensi jpg
jumlah_file = numel(nama_file);

%inisilaisasi variabel data latih
data_latih = zeros(jumlah_file,17);

for k = 1:jumlah_file
    %membaca citra rgb
    img = imread(fullfile(nama_folder,nama_file(k).name));
    
    rataR= mean(mean(img(:,:,1)));
    rataG= mean(mean(img(:,:,2)));
    rataB= mean(mean(img(:,:,3)));
    stdR= std(std(double(img(:,:,1))));
    stdG= std(std(double(img(:,:,2))));
    stdB= std(std(double(img(:,:,3))));
    skewnR = skewness(skewness(double(img(:,:,1))));
    skewnG = skewness(skewness(double(img(:,:,2))));
    skewnB = skewness(skewness(double(img(:,:,3))));
    HSV = rgb2hsv(img);
    Hue = mean(mean(HSV(:,:,1)));
    Saturation = mean(mean(HSV(:,:,2)));
    Value = mean(mean(HSV(:,:,3)));
    
    %konversi ke gray
    img_gray = rgb2gray(img);
    
    lbpB1 = extractLBPFeatures(img_gray,'Upright',false);
    lb1 = sum(lbpB1);
    
    %glcm
    GLCM = graycomatrix(img_gray,'offset',[2, 0]);
    stats = graycoprops(GLCM,'correlation','energy');
    stats2 = graycoprops(GLCM,'contrast','homogeneity');
    
    Correlation = stats.Correlation;
    Homogeneity = stats2.Homogeneity;
    Contrast = stats2.Contrast;
    Energy = stats.Energy;
    
    %menyusun variabel data latih
    data_latih(k,1) = Correlation;
    data_latih(k,2) = Energy;
    data_latih(k,3)= Homogeneity;
    data_latih(k,4) = Contrast;
    data_latih(k,5) = lb1;
    data_latih(k,6) = rataR;
    data_latih(k,7) = rataG;
    data_latih(k,8) = rataB;
    data_latih(k,9) = stdR;
    data_latih(k,10) = stdG;
    data_latih(k,11) = stdB;
    data_latih(k,12) = skewnR;
    data_latih(k,13) = skewnG;
    data_latih(k,14) = skewnB;
    data_latih(k,15) = Hue;
    data_latih(k,16) = Saturation;
    data_latih(k,17) = Value;
    
end

%menetapkan target data latih
target_latih = cell(jumlah_file,1);
for k =1:434
    target_latih{k} = 'rose';
end

for k =435:848
    target_latih{k}= 'sunflower';
end

%algortima svm
Mdl= fitcsvm(data_latih,target_latih);

%membacah hasil keluaran
kelas_keluaran = predict(Mdl,data_latih);

%menghitung akurasi
jumlah_benar = 0;
for k =1:jumlah_file
    if isequal(kelas_keluaran{k},target_latih{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_pelatihan = jumlah_benar/jumlah_file*100

save Mdl Mdl

