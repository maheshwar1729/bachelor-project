function varargout = tri_lateral(varargin)
% TRI_LATERAL M-file for tri_lateral.fig
%      TRI_LATERAL, by itself, creates a new TRI_LATERAL or raises the existing
%      singleton*.
%
%      H = TRI_LATERAL returns the handle to a new TRI_LATERAL or the handle to
%      the existing singleton*.
%
%      TRI_LATERAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRI_LATERAL.M with the given input arguments.
%
%      TRI_LATERAL('Property','Value',...) creates a new TRI_LATERAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tri_lateral_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tri_lateral_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tri_lateral

% Last Modified by GUIDE v2.5 01-Dec-2016 13:15:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tri_lateral_OpeningFcn, ...
                   'gui_OutputFcn',  @tri_lateral_OutputFcn, ...
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


% --- Executes just before tri_lateral is made visible.
function tri_lateral_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tri_lateral (see VARARGIN)

% Choose default command line output for tri_lateral
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tri_lateral wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tri_lateral_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd Images
file=uigetfile('*.jpg');
inp=imread(file);
cd ..
inp=imresize(inp,[256 256]);
axes(handles.axes1);
imshow(inp);
title('Input Image');
% inp = double(inp)/255;
% inp = inp+0.03*randn(size(inp));
% inp(inp<0) = 0; inp(inp>1) = 1;


handles.inp=inp;

% Update handles structure
guidata(hObject, handles);
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inp=handles.inp;
 R=inp(:,:,1);
 G=inp(:,:,2);
 B=inp(:,:,3);
cd trilateralFilter_matlab

inputImage = imresize(double(R),0.25);

sigmaC = 8;
epsilon = 0.1;
outputImage = trilateralFilter(inputImage,sigmaC,epsilon);
cd ..
CH = outputImage 
axes(handles.axes2);
imshow(R);
 title('BILATERAL FILTERING ON  Image');
handles.G=G;
handles.R=R;
handles.B=B;
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
R = handles.R;
G = handles.G;
B = handles.B;

H = histeq(R);
S = histeq(G);
V = histeq(B);
OUT(:,:,1) = H;
OUT(:,:,2) = S;
OUT(:,:,3) = V;
axes(handles.axes3);
imshow(OUT);
title('HOG removed Image');
handles.OUT= OUT;
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


inp=handles.inp;
OUT=handles.OUT;

Input=uint8(rgb2gray(inp));
Output=uint8(rgb2gray(OUT));
Input=imresize(Input,[256 256]);
Output=imresize(Output,[256 256]);

[m n]=size(Input);
RMSE =(sum(sum((Input-Output))))/((m*n)^2);
PSNR = 10*log10(255.^2/RMSE);
Entropy = entropy(Output);
ccoef = corr2(Input,Output);
ssim = ssim_index(Input,Output);
set(handles.edit1,'string',RMSE);
set(handles.edit2,'string',PSNR);
set(handles.edit3,'string',ssim);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
