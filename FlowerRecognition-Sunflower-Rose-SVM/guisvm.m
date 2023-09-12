function varargout = guisvm(varargin)
% GUISVM MATLAB code for guisvm.fig
%      GUISVM, by itself, creates a new GUISVM or raises the existing
%      singleton*.
%
%      H = GUISVM returns the handle to a new GUISVM or the handle to
%      the existing singleton*.
%
%      GUISVM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISVM.M with the given input arguments.
%
%      GUISVM('Property','Value',...) creates a new GUISVM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guisvm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guisvm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guisvm

% Last Modified by GUIDE v2.5 02-Oct-2022 16:07:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guisvm_OpeningFcn, ...
                   'gui_OutputFcn',  @guisvm_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guisvm is made visible.
function guisvm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guisvm (see VARARGIN)

% Choose default command line output for guisvm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject,'center')

% UIWAIT makes guisvm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guisvm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in inputimg.
function inputimg_Callback(hObject, eventdata, handles)
% hObject    handle to inputimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nama_file,nama_folder] = uigetfile('*.jpg');


%jika ada nama file yang dipiih maka akan mengeksekusi perintah dibwah ini
if ~isequal(nama_file,0)
    
    
     %membaca file citra rgb
    img = imread(fullfile(nama_folder,nama_file));
    axes(handles.imgasli)
    imshow(img);
    title('Citra RGB')
    %menampilkan nama file
    set(handles.namaimg,'String',nama_file)
    %menyimpan variabel img pada handles
    handles.img = img;
    guidata(hObject,handles)
else
    return
end


% --- Executes on button press in grayscale.
function grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.img
img_gray = rgb2gray(img);
axes(handles.imggray)
imshow(img_gray);
title('Citra Grayscale')
handles.img_gray = img_gray;
guidata(hObject,handles)


% --- Executes on button press in ekstraksi.
function ekstraksi_Callback(hObject, eventdata, handles)
% hObject    handle to ekstraksi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    img = handles.img;
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
    img_gray = handles.img_gray
    
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
    
     %menampilkan ciri hasil ekstraksi pada tabel
    data_tabel = cell(17,17);
    data_tabel{1,1} = 'Correlation' ;
    data_tabel{2,1} = 'Energy' ;
    data_tabel{3,1} = 'Homogenity' ;
    data_tabel{4,1} = 'Contrast' ;
    data_tabel{5,1} = 'lb1' ;
    data_tabel{6,1} = 'rataR' ;
    data_tabel{7,1} = 'rataG' ;
    data_tabel{8,1} = 'rataB' ;
    data_tabel{9,1} = 'stdR' ;
    data_tabel{10,1} = 'stdG' ;
    data_tabel{11,1} = 'stdB' ;
    data_tabel{12,1} = 'skewnR' ;
    data_tabel{13,1} = 'skewnG' ;
    data_tabel{14,1} = 'skewnB' ;
    data_tabel{15,1} = 'Hue' ;
    data_tabel{16,1} = 'Saturation' ;
    data_tabel{17,1} = 'Value' ;
    data_tabel{1,2} = num2str(Correlation);
    data_tabel{2,2} = num2str(Energy);
    data_tabel{3,2} = num2str(Homogeneity);
    data_tabel{4,2} = num2str(Contrast);
    data_tabel{5,2} = num2str(lb1);
    data_tabel{6,2} = num2str(rataR);
    data_tabel{7,2} = num2str(rataG);
    data_tabel{8,2} = num2str(rataB);
    data_tabel{9,2} = num2str(stdR);
    data_tabel{10,2} = num2str(stdG);
    data_tabel{11,2} = num2str(stdB);
    data_tabel{12,2} = num2str(skewnR);
    data_tabel{13,2} = num2str(skewnG);
    data_tabel{14,2} = num2str(skewnB);
    data_tabel{15,2} = num2str(Hue);
    data_tabel{16,2} = num2str(Saturation);
    data_tabel{17,2} = num2str(Value);
               
    set(handles.uitable1,'Data',data_tabel,'RowName',14:14)
     %mentimpan variabel data_uji pada lokasi handles agar dapat dipanggil push
    %button lain
    handles.data_uji = data_uji;
    guidata(hObject,handles)

% --- Executes on button press in klasifikasi.
function klasifikasi_Callback(hObject, eventdata, handles)
% hObject    handle to klasifikasi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data_uji = handles.data_uji;
%memanggil variabel Mdl hasil dari pelatihan
load Mdl

%membaca kelas keluaran hasil pengujian 
kelas_keluaran = predict(Mdl,data_uji);
%menampilkan kelas keluaran hasil pengujian pada endit text
set(handles.klasifikasi_image,'String',kelas_keluaran{1});


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%mereset tampilan gui
set(handles.namaimg,'String',[])
set(handles.klasifikasi_image,'String',[])

axes(handles.imgasli)
cla reset
set(gca,'Xtick',[])
set(gca,'Ytick',[])

axes(handles.imggray)
cla reset
set(gca,'Xtick',[])
set(gca,'Ytick',[])

set(handles.uitable1,'Data',[],'RowName',{'' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' ''})


function namaimg_Callback(hObject, eventdata, handles)
% hObject    handle to namaimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of namaimg as text
%        str2double(get(hObject,'String')) returns contents of namaimg as a double


% --- Executes during object creation, after setting all properties.
function namaimg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to namaimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function klasifikasi_image_Callback(hObject, eventdata, handles)
% hObject    handle to klasifikasi_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of klasifikasi_image as text
%        str2double(get(hObject,'String')) returns contents of klasifikasi_image as a double


% --- Executes during object creation, after setting all properties.
function klasifikasi_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to klasifikasi_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
