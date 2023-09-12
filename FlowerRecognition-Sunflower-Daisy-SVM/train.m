clc; clear;close all; warning off all;

%mentapkan nama folder
nama_folder = 'data latih';
%membaca nama file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file yang berekstensi .jpg
jumlah_file = numel(nama_file);

%menginisialisasi variabel data latih
data_latih = zeros(jumlah_file,17);

%melakukan pengolahan citra terhadap seluruh file
for k = 1:jumlah_file
    %membaca file citra jpg
    img = imread(fullfile(nama_folder,nama_file(k).name));
    %konversi citra rgb ke grayscale
    img_gray = rgb2gray(img);
    
    %melakukan ekstrak ciri gambar menggunakan metode dilasi menggunakan
    %bentuk diamond
    se = strel('diamond',4);
    dil  = imdilate(img_gray,se); 
    bw = imbinarize(dil);
    
    %melakukan ekstrak ciri gambar menggunakan metode RGB dengan rata2/komponen warna 
    rataR= mean(mean(img(:,:,1)))/mean(mean(bw));
    rataG= mean(mean(img(:,:,2)))/mean(mean(bw));
    rataB= mean(mean(img(:,:,3)))/mean(mean(bw));
    
    %melakukan ekstrak ciri gambar menggunakan metode STD
    %std : mengembalikan standard devisiasi elemen pada dimensi array
    %pertama
    stdR= std(std(double(img(:,:,1))));
    stdG = std(std(double(img(:,:,2))));
    stdB = std(std(double(img(:,:,3))));
    
    %melakukan ekstrak ciri gambar menggunakan metode skewnes
    %skewnes : mengembalikan kemencengan diatas dimensi yang ditentukan
    %dalam vektor
    skewnR = skewness(skewness(double(img(:,:,1))));
    skewnG = skewness(skewness(double(img(:,:,2))));
    skewnB = skewness(skewness(double(img(:,:,3))));
    
    %melakukan ekstrak ciri gambar menggunakan metode HSV dengan rata2/komponen warna 
    HSV = rgb2hsv(img);
    Hue = mean(mean(HSV(:,:,1)))/mean(mean(bw));
    Saturation = mean(mean(HSV(:,:,2)))/mean(mean(bw));
    Value = mean(mean(HSV(:,:,3)))/mean(mean(bw));
   
    %%melakukan ekstrak ciri gambar menggunakan metode LPB 
    %mengembalikan pola biner lokan dari citra grayscale
    lbpB1 =  extractLBPFeatures(img_gray,'Upright',false);
    lb1 = sum(lbpB1);
    
    %melakukan ekstraksi ciri tekstur gambar menggunkan metode glcm
    %GLCM : menghitung antara 2 pixel yagn berdekatan pada jarak tertentu
    GLCM = graycomatrix(img_gray,'offset',[2,0]);
    stats = graycoprops(GLCM,'correlation','energy');
    stats2 = graycoprops(GLCM,'contrast','homogeneity');
    
    %corre : mempresentasikan keterkaitan linear dari derajat citra
    %grayscale
    Correlation = stats.Correlation;
    %homo : mempresentasikan ukuran keserbasamaan
    Homogeneity = stats2.Homogeneity;
    %contrast:mempresentasikan perbedaan tingkat warna atau skala keabuan yagn muncul pada citra
    Contrast = stats2.Contrast; 
    %energy:mempresentasikan ukuran keseragaman pada citra
    %semakin tinggi kemiripan makan akan tinggi nilai energy
    Energy = stats.Energy;
    
    %menyusun variabel data latih dan memasukan fitur kedalam data latih
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

%menetapkan target latih yang berupa label atau nama dari masing masing dataset
target_latih = cell(jumlah_file,1); 
for k =1:414
    target_latih{k} = 'daisy';
end

for k =415:828
    target_latih{k}= 'sunflower';
end

%melakuakn pelatihan menggunakan algoritma svm
Mdl = fitcsvm(data_latih,target_latih);

%membaca kelas keluaran hasil latihan 
kelas_keluaran = predict(Mdl,data_latih);

%menghitung akurasi pelatihan
jumlah_benar = 0;
for k =1:jumlah_file
    if isequal(kelas_keluaran{k},target_latih{k})
        jumlah_benar = jumlah_benar +1;
    end
end

akurasi_pelatihan = jumlah_benar/jumlah_file*100

%menyimpan variabel Mdl hasil Pelatihan
save Mdl Mdl




