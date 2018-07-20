function varargout = FAUST2(varargin)
% FAUST2 MATLAB code for FAUST2.fig
%      FAUST2, by itself, creates a new FAUST2 or raises the existing
%      singleton*.
%
%      H = FAUST2 returns the handle to a new FAUST2 or the handle to
%      the existing singleton*.
%
%      FAUST2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FAUST2.M with the given input arguments.
%
%      FAUST2('Property','Value',...) creates a new FAUST2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the FAUST2 before FAUST2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FAUST2_OpeningFcn via varargin.
%
%      *See FAUST2 Options on GUIDE's Tools menu.  Choose "FAUST2 allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FAUST2

% Last Modified by GUIDE v2.5 06-Feb-2014 17:14:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FAUST2_OpeningFcn, ...
                   'gui_OutputFcn',  @FAUST2_OutputFcn, ...
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


% --- Executes just before FAUST2 is made visible.
function FAUST2_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FAUST2 (see VARARGIN)

% Choose default command line output for FAUST2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Add the gui location to the path
gui_pathname=which('FAUST2.m');
gui_pathname=gui_pathname(1:end-8);
addpath(genpath(gui_pathname));

% UIWAIT makes FAUST2 wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FAUST2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles;%.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.m','Select the MATLAB code file');
FileName=num2str(FileName); PathName=num2str(PathName);
if strcmp({FileName,PathName},{'0','0'})
    PathName='';
    FileName=get(handles.edit3,'String');
end
set(handles.edit3,'String',[FileName]);
addpath(PathName);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
selection = get(hObject,'Value');
Label=getappdata(handles.listbox5,'Labels');
if selection==2
    set(handles.edit8,'enable','off') % Target Set selection
    set(handles.pushbutton4,'enable','off') % Target Set selection
    if get(handles.checkbox3,'Value')==1
        set(handles.pushbutton10,'enable','on') % color the grid button
    end
    set(handles.edit6,'enable','on') % Initial Condition Selection
    set(handles.edit12,'enable','inactive') % Initial Condition Selection
    set(handles.pushbutton5,'enable','on') % Initial Condition Selection
    set(handles.pushbutton9,'enable','on') % Initial Condition Selection
    set(handles.pushbutton14,'enable','on') % Initial Condition Properties
    set(handles.text10,'string','Safe set') % Set selection
elseif selection==3
    set(handles.edit8,'enable','on') % Target Set selection
    set(handles.pushbutton4,'enable','on') % Target Set selection
    if get(handles.checkbox3,'Value')==1
        set(handles.pushbutton10,'enable','on') % color the grid button
    end
    set(handles.edit6,'enable','on') % Initial Condition Selection
    set(handles.edit12,'enable','inactive') % Initial Condition Selection
    set(handles.pushbutton5,'enable','on') % Initial Condition Selection
    set(handles.pushbutton9,'enable','on') % Initial Condition Selection
    set(handles.pushbutton14,'enable','on') % Initial Condition Properties
    set(handles.text10,'string','Safe set') % Set selection
elseif selection==1
    set(handles.edit8,'enable','off') % Target Set selection
    set(handles.pushbutton4,'enable','off') % Target Set selection
    set(handles.pushbutton10,'enable','off') % color the grid button
    set(handles.edit6,'enable','off') % Initial Condition Selection
    set(handles.edit12,'enable','off') % Initial Condition Selection
    set(handles.pushbutton5,'enable','off') % Initial Condition Selection
    set(handles.pushbutton9,'enable','off') % Initial Condition Selection
    set(handles.pushbutton14,'enable','off') % Initial Condition Properties
    set(handles.text10,'string','Domain') % Set selection
end


% options = get(hObject,'String');
% selection = options(selection);
% set(handles.text2,'String',selection) % display the selected option

% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
ProblemSelection = [{'Formula free'},{'PCTL Safety'}, {'PCTL Reach-Avoid'}];
set(hObject,'String', ProblemSelection);
set(hObject,'Value', 1);
setappdata(hObject,'OriginalText',ProblemSelection)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)

Grid=get(hObject,'Value');
Bounds=get(handles.listbox3,'Value');
Gridcontents = cellstr(getappdata(handles.listbox2,'OriginalText'));
Boundcontents = cellstr(getappdata(handles.listbox3,'OriginalText'));

% Reset the color of the possible grids
NewColor1 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{1});
NewColor2 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{2});
NewColor3 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{3});
set(handles.listbox2,'String', {NewColor1, NewColor2,NewColor3})
    
if Grid==1
    NewColor1 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{1});
    NewColor2 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{2});
    NewColor3 = sprintf('<HTML><FONT COLOR="%s">%s', 'silver', Boundcontents{3});
    %NewColor4 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{4});
    set(handles.listbox3,'String', {NewColor1, NewColor2,NewColor3});
    if Bounds==3
        set(handles.listbox3,'Value',1)
        %display('Min-Max must be combined with local->local gridding')
    end
elseif Grid==2
    NewColor1 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{1});
    NewColor2 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{2});
    NewColor3 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{3});
    %NewColor4 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{4});
    set(handles.listbox3,'String', {NewColor1, NewColor2,NewColor3});

elseif Grid==3
    NewColor1 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{1});
    NewColor2 = sprintf('<HTML><FONT COLOR="%s">%s', 'silver', Boundcontents{2});
    NewColor3 = sprintf('<HTML><FONT COLOR="%s">%s', 'silver', Boundcontents{3});
    %NewColor4 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{4});
    set(handles.listbox3,'String', {NewColor1, NewColor2,NewColor3});
    if (Bounds==2|Bounds==3)
        set(handles.listbox3,'Value',1)
        %display('Lipschitz with formal MC approximation error must be combined with uniform gridding')
    end
end


% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
GriddingSelection = [{'Uniform gridding'}, {'Adaptive gridding: local->local'},{'Adaptive gridding: local->global'}];
set(hObject,'String', GriddingSelection);
setappdata(hObject,'OriginalText',GriddingSelection)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
epsilon = get(handles.slider1,'Value');
epsilon=round(epsilon*(1e2))/(1e2);
set(handles.edit2,'String',epsilon);
% assignin('base','epsilon',epsilon);
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider



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
epsilon = str2double(get(hObject,'String'));
if epsilon<=0
    msgbox('epsilon must be greater than zero','Error','Error')
    epsilon=0.01;
end
set(hObject,'String',epsilon);
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',0.01);
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
kernel = get(hObject,'String');
if exist(kernel) ~= 2
  % The kernel is not in the current folder
  warningMessage = sprintf('Warning: The file does not exist or is not a .m file:\n%s');
  uiwait(msgbox(warningMessage));
  %set(hObject,'String','KernelFunction.m')
  set(hObject,'String','')
end

% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
%set(hObject,'String','KernelFunction.m');
set(hObject,'String','')
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
N = str2double(get(hObject,'String'));
N=round(N);
if N<0
    msgbox('N must be greater than zero','Error','Error')
    N=1;
elseif N == 0 
    msgbox(['For N=0 the solution is trivial. ',...
        'This GUI can be used for N>0'],'Warning','warn')
    N=1;
end
set(hObject,'String',N);

% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',1);
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
Bounds=get(hObject,'Value');
Grid=get(handles.listbox2,'Value');
Gridcontents = cellstr(getappdata(handles.listbox2,'OriginalText'));
Boundcontents = cellstr(getappdata(handles.listbox3,'OriginalText'));

% Reset the color of the possible bounds
NewColor1 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{1});
NewColor2 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{2});
NewColor3 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{3});
%NewColor4 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Boundcontents{4});
set(handles.listbox3,'String', {NewColor1, NewColor2,NewColor3}); 

if Bounds==3
    NewColor1 = sprintf('<HTML><FONT COLOR="%s">%s', 'silver', Gridcontents{1});
    NewColor2 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{2});
    NewColor3 = sprintf('<HTML><FONT COLOR="%s">%s', 'silver', Gridcontents{3});
    set(handles.listbox2,'String', {NewColor1, NewColor2,NewColor3})
    if Grid~=2
        set(handles.listbox2,'Value',2)
        %display('Min-Max must be combined with local->local gridding')
    end
elseif Bounds==2
    NewColor1 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{1});
    NewColor2 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{2});
    NewColor3 = sprintf('<HTML><FONT COLOR="%s">%s', 'silver', Gridcontents{3});
    set(handles.listbox2,'String', {NewColor1, NewColor2,NewColor3})
    if Grid==3
        set(handles.listbox2,'Value',1)
        %display('Lipschitz with formal MC approximation error must be combined with uniform gridding')
    end
else
    NewColor1 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{1});
    NewColor2 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{2});
    NewColor3 = sprintf('<HTML><FONT COLOR="%s">%s', 'grey', Gridcontents{3});
    set(handles.listbox2,'String', {NewColor1, NewColor2,NewColor3})   
end
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
BoundsSelection = [{'Lipschitz via integral'}, {'Lipschitz via sample'}, {'Max-Min'}];
set(hObject,'String', BoundsSelection);
set(hObject,'Value', 1);
setappdata(hObject,'OriginalText',BoundsSelection)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','off') % Initially it is off
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)

% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String','')
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','off')
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
Delta = str2double(get(hObject,'String'));
if Delta <=0
    msgbox('Delta must be greater than zero','Error','Error')
    Delta=1;
    set(hObject,'String',N);
end
assignin('base','Delta',Delta);
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',1);
set(hObject,'enable','off') % I might implement this in a later stage


% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
selection=get(hObject,'Value');

if selection == 1
    set(handles.edit3,'enable','on')
    set(handles.pushbutton1,'enable','on') 
elseif selection == 2
    set(handles.edit3,'enable','off')
    set(handles.pushbutton1,'enable','off')
elseif selection == 3
    set(handles.edit3,'enable','on')
    set(handles.pushbutton1,'enable','on') 
end

% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
KernelSelection = [{'User-defined'},{'Linear Gaussian model'},{'Non-linear Gaussian model'}]; 
set(hObject,'String', KernelSelection);


% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text11_CreateFcn(hObject, eventdata, handles)


% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% Check for presence of requierd toolboxes
tic;
v=ver;
if ~(any(strcmp('Symbolic Math Toolbox', {v.Name})) & any(strcmp('Optimization Toolbox', {v.Name})))
    msgbox(sprintf('For this GUI to run, the Optimization Toolbox and Symbolic Math Toolbox of Matlab are required.\nPlease add the required toolboxes to the Matlab directory.'),'Warning','warn')
    return
end

% Acquire inputs

% Problem Definition
Problem = get(handles.listbox1,'Value');
Gridding = get(handles.listbox2,'Value');
Bounds = get(handles.listbox3,'Value');
Distribution = get(handles.listbox4,'Value');
Control = get(handles.checkbox3,'Value');
tic;
% Modify the Problem Value (implemented due to late change in sequence)
if Problem==1
    Problem=3;
else 
    Problem=Problem-1;
end


% Problem variables
epsilon = str2double(get(handles.edit2,'String'));
N = str2double(get(handles.edit4,'String'));

% Store N in object
setappdata(hObject,'TimeHorizon',N);


% Definition of the kernel
if Distribution == 1
    KernelFunction = get(handles.edit3,'String');
    if exist(KernelFunction,'file')==0
        errordlg('The given kernelfunction is not an existing m-file.')
        return
    end
    KernelFunction = eval(KernelFunction(1:end-2));
elseif Distribution == 2
    try
        A=evalin('base','A');
        Sigma=evalin('base','Sigma');
    catch
        warndlg('Please define A and Sigma in the base Workspace');
        return
    end
    try
        drift=evalin('base','drift');
    catch
        drift=zeros(size(A,1),1);
    end
    % Check if Sigma is full rank
    if det(Sigma)==0
        errordlg('The matrix Sigma is not full rank')
        return
    end
    if Control==0
        KernelFunction = eval(['NormDistSymb(',mat2str(A),',',mat2str(Sigma),',',mat2str(drift),')']);
    elseif Control == 1
        try
            B=evalin('base','B');
            Sigma=evalin('base','Sigma');
        catch
            warndlg('Please define B in the base Workspace');
            return
        end
        KernelFunction = eval(['NormDistSymb_Contr(',mat2str(A),',',mat2str(B),',',mat2str(Sigma),')']);
    end
elseif Distribution == 3
    NonlinKernel = get(handles.edit3,'String');
    if exist(NonlinKernel,'file')==0
        errordlg('The given kernelfunction is not an existing m-file.')
        return
    end
    if Control==0
        [NonLinMean,NonLinSigma] = eval(NonlinKernel(1:end-2));
        [KernelFunction] = NonLin2Kernel(NonLinMean,NonLinSigma);
    elseif Control == 1
        [NonLinMean,NonLinSigma,dimension] = eval(NonlinKernel(1:end-2));
        [KernelFunction] = NonLin2Kernel_Contr(NonLinMean,NonLinSigma,dimension);
    end
    
end

% Get the SafeSet variable
try
    SafeSet = eval(get(handles.edit7,'String'));
catch
    errordlg('There is no correctly defined Safe Set');
    return
end

setappdata(hObject,'SafeSet',SafeSet);

% Get the InputSet variable
if Control ==1
    try
        InputSet = eval(get(handles.edit15,'String'));
    catch
        errordlg('There is no correctly defined Input Set');
        return
    end
else
    InputSet = [];
end

% Checks of correctness of the SafeSet input
if size(SafeSet,2)~=2
    error('Set must have 2 columns, the lower and the upper bounds');
    return
end
if sum((SafeSet(:,2)-SafeSet(:,1))<0)>0
    errordlg(['The edges of the Safe Set must have positive length. ',...
        'Make sure that the first column is the lower bound and the second column is the upper bound']);
    return
end

% Check if the dimensions are correct
if nargin(KernelFunction) ~= 2*numel(SafeSet(:,1))+size(InputSet,1)
    errordlg('The dimension of the kernel does not match the dimension of the Safe Set (combined with the Input Set in case of a controlled system).');
    return
end

if Problem == 2
    try
        TargetSet = eval(get(handles.edit8,'String'));
    catch
        errordlg('The Target Set is not or not correctly defined.');
        return
    end
    setappdata(hObject,'TargetSet',TargetSet); 
    % Checks of correctness of the TargetSet input
    if size(TargetSet,2)~=2
        errordlg('Set must have 2 columns, the lower and the upper bounds.');
        return
    end
    if sum((TargetSet(:,2)-TargetSet(:,1))<0)>0
        errordlg(['The edges of Set must have positive length.',...
            'Make sure that the first column is the lower bound and the second column is the upper bound.']);
        return
    end

    % Check if the dimensions are correct
    if numel(SafeSet(:,1)) ~= numel(TargetSet(:,1))
        errordlg('The dimension of the Sarget Set does not match the dimension of the Safe Set.');
        return
    end
    
    % Check if TargetSet is inside SafeSet
    if ~isequal([(SafeSet-TargetSet)>0],[zeros(size(SafeSet,1),1),ones(size(SafeSet,1),1)])
        if ~isequal([(SafeSet-TargetSet)>=0],[zeros(size(SafeSet,1),1),ones(size(SafeSet,1),1)])
            errordlg('The Target Set can not be outside the Safe Set');
            return
        end
    end
end

% Save Problem selection in data structure
setappdata(hObject,'ProblemSelection',Problem);

% For Formula Free abstractions use Safety for the bounded state space
if Problem == 3
    Problem = 1;
end

% Because of taking the center point, the error will be twice as small.
% This allows to make epsilon twice as large.
epsilon=2*epsilon;

% Computational part
switch Control
    case 0 %Uncontrolled System
        if [Problem,Gridding,Bounds]==[1,1,1]
            [X,E] = Uniform_grid(epsilon,KernelFunction,N,SafeSet);
        elseif [Problem,Gridding,Bounds]==[1,2,1]
            [X,E] = Uniform_grid(10*epsilon,KernelFunction,N,SafeSet);
            [X,E] = Adaptive_grid_multicell(epsilon,KernelFunction,N,X);
        elseif [Problem,Gridding,Bounds]==[1,3,1]
            [X,E] = Uniform_grid(10*epsilon,KernelFunction,N,SafeSet);
            [X,E] = Adaptive_grid_multicell_semilocal(epsilon,KernelFunction,N,X,SafeSet);
        elseif [Problem,Gridding,Bounds]==[2,1,1]
            [X,E] = Uniform_grid_ReachAvoid(epsilon,KernelFunction,N,SafeSet,TargetSet);
        elseif [Problem,Gridding,Bounds]==[2,2,1]
            [X,E] = Uniform_grid_ReachAvoid(10*epsilon,KernelFunction,N,SafeSet,TargetSet);
            [X,E] = Adaptive_grid_ReachAvoid(epsilon,KernelFunction,N,X,TargetSet);
        elseif [Problem,Gridding,Bounds]==[2,3,1]
            [X,E] = Uniform_grid_ReachAvoid(10*epsilon,KernelFunction,N,SafeSet,TargetSet);
            [X,E] = Adaptive_grid_ReachAvoid_semilocal(epsilon,KernelFunction,N,X,SafeSet,TargetSet);
        elseif [Problem,Gridding,Bounds]==[1,2,3]
            [X,E] = Adaptive_grid_multicell_minmax(epsilon,KernelFunction,N,SafeSet);
        elseif [Problem,Gridding,Bounds]==[2,2,3]
            [X,E] = Adaptive_grid_multicell_ReachAvoid_minmax(epsilon,KernelFunction,N,SafeSet,TargetSet);
        elseif [Problem,Gridding,Bounds]==[1,1,2]
            [X,E] = Uniform_gridMCapprox(epsilon,KernelFunction,N,SafeSet);
        elseif [Problem,Gridding,Bounds]==[2,1,2]    
            [X,E] = Uniform_grid_ReachAvoidMCapprox(epsilon,KernelFunction,N,SafeSet,TargetSet);
        elseif [Problem,Gridding,Bounds]==[1,2,2]    
            [X,E] = Adaptive_grid_MCapprox(epsilon,KernelFunction,N,SafeSet);
        elseif [Problem,Gridding,Bounds]==[2,2,2]    
            [X,E] = Adaptive_grid_ReachAvoidMCapprox(epsilon,KernelFunction,N,SafeSet,TargetSet);
        else
              errordlg('Work in progress. This option is not yet available.')
              return
        end
        display(['The abtraction consists of ',num2str(size(X,1)),' representative points.']);
        setappdata(hObject,'RepresentativePointsInput',[]);

    case 1 % Controlled System
        if [Problem,Gridding,Bounds]==[1,1,1]
            [X,U,E] = Uniform_grid_Contr(epsilon,KernelFunction,N,SafeSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[1,2,1]
            [X,U,E] = Uniform_grid_Contr(10*epsilon,KernelFunction,N,SafeSet,InputSet);
            [X,U,E] = Adaptive_grid_multicell_Contr(epsilon,KernelFunction,N,X,U,SafeSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[1,3,1]
            [X,U,E] = Uniform_grid_Contr(5*epsilon,KernelFunction,N,SafeSet,InputSet);
            [X,U,E] = Adaptive_grid_multicell_semilocal_Contr(epsilon,KernelFunction,N,X,U,SafeSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[2,1,1]
            [X,U,E] = Uniform_grid_ReachAvoid_Contr(epsilon,KernelFunction,N,SafeSet,TargetSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[2,2,1]
            [X,U,E] = Uniform_grid_ReachAvoid_Contr(5*epsilon,KernelFunction,N,SafeSet,TargetSet,InputSet);
            [X,U,E] = Adaptive_grid_ReachAvoid_Contr(epsilon,KernelFunction,N,X,U,SafeSet,TargetSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[2,3,1]
            [X,U,E] = Uniform_grid_ReachAvoid_Contr(5*epsilon,KernelFunction,N,SafeSet,TargetSet,InputSet);
            [X,U,E] = Adaptive_grid_ReachAvoid_semilocal_Contr(epsilon,KernelFunction,N,X,U,SafeSet,TargetSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[1,2,3]
            [X,U,E] = Adaptive_grid_multicell_minmax_Contr(epsilon,KernelFunction,N,SafeSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[2,2,3]
            [X,U,E] = Adaptive_grid_ReachAvoid_multicell_minmax_Contr(epsilon,KernelFunction,N,SafeSet,TargetSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[1,1,2]
            [X,U,E] = Uniform_gridMCapprox_Contr(epsilon,KernelFunction,N,SafeSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[2,1,2]    
            [X,U,E] = Uniform_grid_ReachAvoidMCapprox_Contr(epsilon,KernelFunction,N,SafeSet,TargetSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[1,2,2]    
            [X,U,E] = Adaptive_grid_MCapprox_Contr(epsilon,KernelFunction,N,SafeSet,InputSet);
        elseif [Problem,Gridding,Bounds]==[2,2,2]    
            [X,U,E] = Adaptive_grid_ReachAvoid_MCapprox_Contr(epsilon,KernelFunction,N,SafeSet,TargetSet,InputSet);
        else
              errordlg('Work in progress. This option is not yet available.')
              return
        end
        display(['The abtraction consists of ',num2str(size(X,1)),' representative points of the system.']);
        display(['The abtraction consists of ',num2str(size(U,1)),' representative points of the input.']);
        setappdata(hObject,'RepresentativePointsInput',U); 
        
end
% Because of taking the center points as representative points the
% resulting error is half of the outcome error.
E=0.5*E;

% Store data in object
setappdata(hObject,'RepresentativePoints',X);

% Creation of the Markov Chain
switch Control
    case 0
        if (Bounds==1|Bounds==4)
            Tp=MCcreator(KernelFunction,X);
        else
            Tp=MCapprox(KernelFunction,X);
        end
    case 1
        if (Bounds==1|Bounds==4)
            Tp=MCcreator_Contr(KernelFunction,X,U);
        else
            Tp=MCapprox_Contr(KernelFunction,X,U);
        end
end

% Store data in object
setappdata(hObject,'TransitionMatrix',Tp);


% Display the resulting error
format shortE
set(handles.edit13,'String',sprintf('%3.3e',E));
format SHORT

% End code if Tp is not created.
if isempty(Tp)
    return
end

% Calculatinon of the problem result
switch Control
    case 0
        if Problem==1
            [V] = StandardProbSafety(N,Tp);
            setappdata(hObject,'ProblemSolution',V);
            toc
        elseif Problem == 2
            [W] = StandardReachAvoid(N,Tp,X,TargetSet);
            setappdata(hObject,'ProblemSolution',W);
            toc
        end
        
    case 1
        if Problem==1
            [V,OptimPol] = StandardProbSafety_Contr(N,Tp);
            setappdata(hObject,'ProblemSolution',V);
        elseif Problem == 2
            [W,OptimPol] = StandardReachAvoid_Contr(N,Tp,X,TargetSet);
            setappdata(hObject,'ProblemSolution',W);
        end
        setappdata(hObject,'OptimalPolicy',OptimPol);
    otherwise
        [];
        
 toc
end



% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','inactive')
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

prompt={'Lower bounds x',...
        'Upper bounds x'};
name='SafeSet Bounds';
numlines=1;
defaultanswer={'[x1_l,x2_l,...]','[x1_u,x2_u,...]'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
try
    xs_l=eval(answer{1})';
    xs_u=eval(answer{2})';
    SafeSet=mat2str([xs_l,xs_u]);
catch
    SafeSet='';
end
set(handles.edit7,'String',SafeSet);

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
prompt={'Lower bounds x',...
        'Upper bounds x'};
name='TargetSet Bounds';
numlines=1;
defaultanswer={'[x1_l,x2_l,...]','[x1_u,x2_u,...]'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
try
    xs_l=eval(answer{1})';
    xs_u=eval(answer{2})';
    TargetSet=mat2str([xs_l,xs_u]);
catch
    TargetSet='';
end
set(handles.edit8,'String',TargetSet);

% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
prompt={'Input s0'};
name='Selection of s0';
numlines=1;
defaultanswer={'[a,b,...]'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
try
s0=mat2str(eval(answer{1})');
catch
    s0='';
end
set(handles.edit6,'String',s0);
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% This is the PRISM button
% Check if the program has run and get the necessary data
X=getappdata(handles.pushbutton2,'RepresentativePoints');
Tp=getappdata(handles.pushbutton2,'TransitionMatrix');
Problem=getappdata(handles.pushbutton2,'ProblemSelection'); %Problem selection related to the solution
ProblemComp=get(handles.listbox1,'Value'); %Current problem selection
% Changed order causes this change
if ProblemComp ==1
    ProblemComp=3;
else
    ProblemComp=ProblemComp-1;
end

if isempty(Tp)
    errordlg(sprintf('In order to make PRISM files, the program should have run fully.\r\nRepresentative points and a transition matrix have to be made first.\r\nThis can be done be clicking on the ''Generate the abstraction''-button'));
    return
end
if Problem ~= ProblemComp
    warndlg(sprintf('For the computation of the solution a different problem selection was used.\r\nPlease either select the problem that corresponds tot the last computed solution or rerun the program.'));
    return
end

% The dimension of the system 
dim = size(X,2)/2;

% Cardinality of the partition of the SafeSet
m=size(X,1);

% Let the user choose the output file making
str = [{'PRISM GUI output'},{'PRISM command-line output'}];
[s,v] = listdlg('PromptString','Select an output method version',...
                'SelectionMode','single','ListSize',[200 50],...
                'ListString',str);
choice=s*v;


% Creation of the output files
if choice==1
    if numel(size(Tp))==2
        [a] = Matlab2PRISM(Tp,'GUI');
    elseif numel(size(Tp))==3
        [a] = Matlab2PRISM_Contr(Tp,'GUI');
    end
    % Open the .prism file
    fid = fopen('PRISM/PRISM.prism','a');
    
    if Problem==1
        % Add the labels
        fprintf(fid,'label "SafeSet" = s<=%u;\r\n',m);
        fprintf(fid,'label "nonSafeSet" = s=%u;\r\n',m+1);
    elseif Problem ==2
        Solution=getappdata(handles.pushbutton2,'ProblemSolution')'; % Needed for definition of the Target Set
        % Add the labels
        fprintf(fid,'label "SafeSet" = s<=%u;\r\n',m);
        TargetText=['label "','TargetSet','" = '];
        for j=[find(Solution==1)] % Assumed is that only inside the target set P=1
            TargetText=[TargetText,'s=',num2str(j-1),' | ']; %j-1 is correction for PRISM states which start at 0
        end
        TargetText=[TargetText(1:end-3),';'];
        fprintf(fid,'%s\r\n',TargetText);
        fprintf(fid,'label "nonSafeSet" = s=%u;\r\n',m+1);
    elseif Problem == 3
        % Add the labels
        fprintf(fid,'label "StateSpace" = s<=%u;\r\n',m);
        fprintf(fid,'label "nonStateSpace" = s=%u;  // Notice that the probablity to go to this state should be zero.\r\n',m+1);
    end
    % Add other defined labels 
    Label=getappdata(handles.listbox5,'Labels');
    
    for i=1:numel(Label)
        A=eval(Label(i).A{1});
        B=eval(Label(i).B{1});
        Index=prod(double(A*X(:,1:dim)'<=repmat(B,1,size(X,1))),1);
        if ~isempty(find(Index==1))
            LabelText=['label "',Label(i).Name,'" = '];
            for j=[find(Index==1)]
                LabelText=[LabelText,'s=',num2str(j-1),' | ']; %j-1 is correction for PRISM states which start at 0
            end
            LabelText=[LabelText(1:end-3),';'];
            fprintf(fid,'%s\r\n',LabelText);
        end
    end
    a=fclose(fid); % closes the .prism file
    
    % For Safety and Reach Avoid a property file can be created with the
    % standard property of the problem.
    if Problem==1
        N=getappdata(handles.pushbutton2,'TimeHorizon');
        % Create the .props file
        if numel(size(Tp))==2
            fid = fopen('PRISM/PRISM.props','w+');
            fprintf(fid,'P=? [ (G<=%u "SafeSet") ]\r\n',N);
            fprintf(fid,'filter(first, P=? [ (G<=%u "SafeSet") ],s=1)',N);
            a=fclose(fid); % closes the .props file    
        elseif numel(size(Tp))==3
            fid = fopen('PRISM/PRISM.props','w+');
            fprintf(fid,'Pmax=? [ (G<=%u "SafeSet") ]\r\n',N);
            fprintf(fid,'filter(first, Pmax=? [ (G<=%u "SafeSet") ],s=1)',N);
            a=fclose(fid); % closes the .props file    
        end
  
    elseif Problem==2
        N=getappdata(handles.pushbutton2,'TimeHorizon');
        % Create the .props file
        if numel(size(Tp))==2
            fid = fopen('PRISM/PRISM.props','w+');
            fprintf(fid,'P=? [ ("SafeSet") U<=%u ("TargetSet") ]\r\n',N);
            fprintf(fid,'filter(first, P=? [ ("SafeSet") U<=%u ("TargetSet") ],s=1)',N);
            a=fclose(fid); % closes the .props file  
        elseif numel(size(Tp))==3
            fid = fopen('PRISM/PRISM.props','w+');
            fprintf(fid,'Pmax=? [ ("SafeSet") U<=%u ("TargetSet") ]\r\n',N);
            fprintf(fid,'filter(first, Pmax=? [ ("SafeSet") U<=%u ("TargetSet") ],s=1)',N);
            a=fclose(fid); % closes the .props file  
        end

    end

elseif choice==2 % Second Choice
    warndlg('In this mode no labels can be admitted to the output files. The user will have to do this manually')
    if numel(size(Tp))==2
        [a] = Matlab2PRISM(Tp,'Normal');
    elseif numel(size(Tp))==3
        [a] = Matlab2PRISM_Contr(Tp,'Normal');
    end
end



% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
X=getappdata(handles.pushbutton2,'RepresentativePoints');
U=getappdata(handles.pushbutton2,'RepresentativePointsInput');
Tp=getappdata(handles.pushbutton2,'TransitionMatrix');
dim=size(X,2)/2;
dim_u=size(U,2)/2;

if isempty(X)
    errordlg(sprintf('In order to plot the grid, representative points should have been made.\r\nPlease run the program first.\r\nNotice that it is not necessary to let the program compute the transition matrix.'));
    return
end

cla(handles.axes1,'reset');
rotate3d off
if dim==3
    rotate3d(handles.axes1)
end

if dim > 3
    error('Plotting the grid is only possible for systems up to 3 dimensions.');
    return
elseif dim == 3
    X_data = (X*[ones(1,16);zeros(2,16);0.5*[-1,1,1,-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1];zeros(2,16)])';
    Y_data = (X*[zeros(1,16);ones(1,16);zeros(2,16);0.5*[-1,-1,-1,-1,1,1,-1,1,1,-1,1,1,-1,1,1,-1];zeros(1,16)])';
    Z_data = (X*[zeros(2,16);ones(1,16);zeros(2,16);0.5*[-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,1,1]])';
    C_data = ones(size(X_data));
    axes(handles.axes1)
    p=patch(X_data,Y_data,Z_data,C_data,'FaceColor','none');
    axis equal tight
elseif dim == 2
    X_data = (X*[ones(1,dim*2);zeros(1,dim*2);0.5*[-1,1,1,-1];zeros(1,dim*2)])';
    Y_data = (X*[zeros(1,dim*2);ones(1,dim*2);zeros(1,dim*2);0.5*[-1,-1,1,1]])';
    C_data = ones(4,size(X,1));
    axes(handles.axes1)
    p=patch(X_data,Y_data,C_data,'FaceColor','w');
    axis equal tight
elseif dim == 1
    X=sortrows(X,1);
    X_data = [X*[1 -0.5]',X*[1 0.5]',X*[1 0.5]']';
    X_data = X_data(:);
    Y_data = [X*[0 1]',X*[0 1]',[X(2:end,2);1]]';
    Y_data = Y_data(:);
    axes(handles.axes1)
    p=line(X_data(1:end-1),Y_data(1:end-1));
    axis normal
    axis([X(1,1)-0.5*X(1,2)-eps X(end,1)+0.5*X(end,2)+eps 0 max(X(:,2))+eps])
end
setappdata(hObject,'PlotHandle',p);  

if dim_u>0
    button=questdlg(sprintf('Do you want to plot the gridded input as well?\nThis will be displayed in a separate figure'),'Plotting the input grid','Yes','No','Yes');
    switch button,
        case 'Yes',
            if dim_u > 3
                error('Plotting the grid is only possible for systems up to 3 dimensions.');
                return
            elseif dim_u == 3
                X_data = (U*[ones(1,16);zeros(2,16);0.5*[-1,1,1,-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1];zeros(2,16)])';
                Y_data = (U*[zeros(1,16);ones(1,16);zeros(2,16);0.5*[-1,-1,-1,-1,1,1,-1,1,1,-1,1,1,-1,1,1,-1];zeros(1,16)])';
                Z_data = (U*[zeros(2,16);ones(1,16);zeros(2,16);0.5*[-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,1,1]])';
                C_data = ones(size(X_data));
                figure(1)
                cla
                p=patch(X_data,Y_data,Z_data,C_data,'FaceColor','none');
                axis equal tight
            elseif dim_u == 2
                X_data = (U*[ones(1,dim_u*2);zeros(1,dim_u*2);0.5*[-1,1,1,-1];zeros(1,dim_u*2)])';
                Y_data = (U*[zeros(1,dim_u*2);ones(1,dim_u*2);zeros(1,dim_u*2);0.5*[-1,-1,1,1]])';
                C_data = ones(4,size(U,1));
                figure(1)
                cla
                p=patch(X_data,Y_data,C_data,'FaceColor','w');
                axis equal tight
            elseif dim_u == 1
                U=sortrows(U,1);
                X_data = [U*[1 -0.5]',U*[1 0.5]',U*[1 0.5]']';
                X_data = X_data(:);
                Y_data = [U*[0 1]',U*[0 1]',[U(2:end,2);1]]';
                Y_data = Y_data(:);
                figure(1)
                cla
                p=line(X_data(1:end-1),Y_data(1:end-1));
                axis normal
                axis([U(1,1)-0.5*U(1,2)-eps U(end,1)+0.5*U(end,2)+eps 0 max(U(:,2))+eps])
            end
        otherwise
            return
    end
    % Coloring button

% Dimension of the system
X=getappdata(handles.pushbutton2,'RepresentativePoints');
dim=size(X,2)/2;
m=size(X,1);
clear X;

p=getappdata(handles.pushbutton7,'PlotHandle');
if isempty(p)
    errordlg(sprintf('In order to color the grid, the program should have run fully and a grid should have been made.\r\nRepresentative points and a transition matrix have to be made and plotted first.\r\nThis can be done be clicking on the ''Generate the abstraction''-button and next on the ''Plot the grid''-button'));
    return
end

Solution=getappdata(handles.pushbutton2,'ProblemSolution');
if length(Solution) ~= m
    errordlg(sprintf('A new grid has been made, without transition matrix. Please let the program run fully in order to color the grid.'));
    return
end

if dim>1
    if size(get(p,'Cdata'),2) ~= m
        errordlg(sprintf('Please press ''Plot the grid'' first in order to create the grid for the coloring.'));
        return
    end
end

% Set the current axes
axes(handles.axes1);

% Color the grid acoording to the solution of the problem
colormap jet
if dim == 1
    X=getappdata(handles.pushbutton2,'RepresentativePoints');
    X_data = (X*[ones(1,4);0.5*[-1,1,1,-1]])';
    Y_data = (X*[zeros(1,4);[0,0,1,1]])';
    C_data = ones(4,size(X,1));
    axes(handles.axes1)
    hold on
    p=patch(X_data,Y_data,C_data,'FaceColor','w');
    hold off
    set(p,'FaceColor','flat','CData',Solution,'EdgeAlpha',0);
elseif dim == 2
    set(p,'FaceColor','flat','CData',Solution,'EdgeAlpha',0);
elseif dim == 3
    set(p,'EdgeColor','flat','CData',kron(Solution,ones(16,1)),'Linewidth',10/m^(1/3));
end
colorbar('location','EastOutside')
end

% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% this is the save button
X=getappdata(handles.pushbutton2,'RepresentativePoints');
U=getappdata(handles.pushbutton2,'RepresentativePointsInput');
Tp=getappdata(handles.pushbutton2,'TransitionMatrix');
Solution=getappdata(handles.pushbutton2,'ProblemSolution');
OptimPol=getappdata(handles.pushbutton2,'OptimalPolicy');
Problem=getappdata(handles.pushbutton2,'ProblemSelection');

if isempty(X)
    errordlg('The program must be run first, before output can be saved.');
    return
end


str = [{'Save to workspace'},{'Save to .mat file'}];
[s,v] = listdlg('PromptString','Save the representative points and transition matrix',...
                'SelectionMode','single','ListSize',[200 50],...
                'ListString',str);
choice=s*v;

switch Problem
    case 3
        if isempty(U)
            if choice==1
                assignin('base','Transition_matrix',Tp);
                assignin('base','Representative_points',X);
            elseif choice==2
                save('GUI_output.mat','Tp','X');
            end
        else
            if choice==1
                assignin('base','Transition_matrix',Tp);
                assignin('base','Representative_points',X);
                assignin('base','Representative_points_input',U);
            elseif choice==2
                save('GUI_output.mat','Tp','X','U');
            end
        end
    otherwise
        if isempty(U)
            if choice==1
                assignin('base','Transition_matrix',Tp);
                assignin('base','Representative_points',X);
                assignin('base','Problem_Solution',Solution);
            elseif choice==2
                save('GUI_output.mat','Tp','X','Solution');
            end
        else
            if choice==1
                assignin('base','Transition_matrix',Tp);
                assignin('base','Representative_points',X);
                assignin('base','Representative_points_input',U);
                assignin('base','Problem_Solution',Solution);
                assignin('base','Optimal_Policy',OptimPol);
            elseif choice==2
                save('GUI_output.mat','Tp','X','U','Solution','OptimPol');
            end
        end
end



% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
X=getappdata(handles.pushbutton2,'RepresentativePoints');
Tp=getappdata(handles.pushbutton2,'TransitionMatrix');
Problem=getappdata(handles.pushbutton2,'ProblemSelection');
Solution=getappdata(handles.pushbutton2,'ProblemSolution');

if isempty(Tp)
    errordlg(sprintf('In order to calculate the solution, the program should have run fully.\r\nRepresentative points and a transition matrix have to be made first.\r\nThis can be done be clicking on the ''Generate the abstraction''-button'));
    return
end

% Cardinality
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% Check if s0 exists
try
    s0 = eval(get(handles.edit6,'String'));
catch
    s0 = [];
    errordlg('The value of s0 must be defined in the corresponding input box')
    set(handles.edit12,'String','');
    return
end

% Check if s0 (if it exists) has the correct dimensions
if (size(X,2)/2 ~= size(s0,1) | size(s0,2)~=1)
    errordlg('s0 has not got the correct dimensions')
    set(handles.edit12,'String','');
    return
end

% Display the resulting probability for s0

% Find the index of value V or W which corresponds to s0
Index=prod(double([repmat(s0',m,1),-repmat(s0',m,1)]>[X(:,1:dim)-0.5*X(:,dim+1:2*dim),-(X(:,1:dim)+0.5*X(:,dim+1:2*dim))]),2);
if sum(Index)<1
    warndlg(sprintf(' s0 has not been found inside a cell. \n This might be caused by s0 being exactly on the edge of a partition set. \n Or this can be caused due to s0 being outside the Safe Set \n Please try a (slightly) different s0'))
    return
end
if sum(Index)>1
    warndlg(sprintf(' There have been multiple cells found for s0. \n This might be caused by s0 being exactly on the edge of a partition set. \n Please try a slightly different s0'))
    return
end

% The solution of the problem related to s0
ps0=Solution(find(Index==1));

% Write the result in the FAUST2
format shortE
set(handles.edit12,'String',sprintf('%3.3e',ps0));
format SHORT

% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% Coloring button

% Dimension of the system
X=getappdata(handles.pushbutton2,'RepresentativePoints');
dim=size(X,2)/2;
m=size(X,1);
clear X;

p=getappdata(handles.pushbutton7,'PlotHandle');
if isempty(p)
    errordlg(sprintf('In order to color the grid, the program should have run fully and a grid should have been made.\r\nRepresentative points and a transition matrix have to be made and plotted first.\r\nThis can be done be clicking on the ''Generate the abstraction''-button and next on the ''Plot the grid''-button'));
    return
end

Solution=getappdata(handles.pushbutton2,'ProblemSolution');
if length(Solution) ~= m
    errordlg(sprintf('A new grid has been made, without transition matrix. Please let the program run fully in order to color the grid.'));
    return
end

if dim>1
    if size(get(p,'Cdata'),2) ~= m
        errordlg(sprintf('Please press ''Plot the grid'' first in order to create the grid for the coloring.'));
        return
    end
end

% Set the current axes
axes(handles.axes1);

% Color the grid acoording to the solution of the problem
colormap jet
if dim == 1
    X=getappdata(handles.pushbutton2,'RepresentativePoints');
    X_data = (X*[ones(1,4);0.5*[-1,1,1,-1]])';
    Y_data = (X*[zeros(1,4);[0,0,1,1]])';
    C_data = ones(4,size(X,1));
    axes(handles.axes1)
    hold on
    p=patch(X_data,Y_data,C_data,'FaceColor','w');
    hold off
    set(p,'FaceColor','flat','CData',Solution,'EdgeAlpha',0);
elseif dim == 2
    set(p,'FaceColor','flat','CData',Solution,'EdgeAlpha',0);
elseif dim == 3
    set(p,'EdgeColor','flat','CData',kron(Solution,ones(16,1)),'Linewidth',10/m^(1/3));
end
colorbar('location','EastOutside')



% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% This is the add button
Label=getappdata(handles.listbox5,'Labels');


prompt={'Name of the Label',...
        'Matrix A of Ax<=B',...
        'Matrix B of Ax<=B'};
name='New Label';
numlines=1;
defaultanswer={'','',''};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if ~isempty(answer);
    NewLabel.Name=answer{1};
    NewLabel.A=answer(2);
    NewLabel.B=answer(3);
else
    NewLabel=[];
end

Label=[Label,NewLabel];

if numel(Label)~=0
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
end    
    
set(handles.listbox5,'String', {Label.Name});
setappdata(handles.listbox5,'Labels',Label);
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)

% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
Label=struct('Name','','A',0,'B',0);
Label(1)=[];
setappdata(hObject,'Labels',Label);

set(hObject,'String', {Label.Name});
set(hObject,'Enable','on');
set(hObject, 'Min', 0, 'Max', 10, 'Value', []);

% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% This is the Remove Button
Label=getappdata(handles.listbox5,'Labels');
CurrentLabelSelection = get(handles.listbox5,'Value');

Label(CurrentLabelSelection)=[];
set(handles.listbox5,'String', {Label.Name},'Value',[]);

if numel(Label)==0
    set(hObject,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
end

setappdata(handles.listbox5,'Labels',Label);

% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% This is the Edit Button
Label=getappdata(handles.listbox5,'Labels');
CurrentLabelSelection = get(handles.listbox5,'Value');

if  numel(CurrentLabelSelection) > 1
    warndlg('Please select one single Labeled Set to edit.');
    return
elseif numel(CurrentLabelSelection) == 0
    warndlg('Please select a Labeled Set to edit.');
    return
end


prompt={'Name of the Label',...
        'Matrix A of Ax<=B',...
        'Matrix B of Ax<=B'};
name='Editing Label';
numlines=1;

defaultanswer=[Label(CurrentLabelSelection).Name,Label(CurrentLabelSelection).A,Label(CurrentLabelSelection).B];
answer=inputdlg(prompt,name,numlines,defaultanswer);

if ~isempty(answer) % catches the cancel button
    NewLabel.Name=answer{1};
    NewLabel.A=answer(2);
    NewLabel.B=answer(3);
    Label=[Label(1:CurrentLabelSelection-1),NewLabel,Label(CurrentLabelSelection+1:end)];
end

set(handles.listbox5,'String', {Label.Name});

setappdata(handles.listbox5,'Labels',Label);

% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% Display properties of s0
X=getappdata(handles.pushbutton2,'RepresentativePoints');
if isempty(X)
    errordlg(sprintf('Representative points should have been made.\r\nPlease run the program first.'));
    return
end
Problem=getappdata(handles.pushbutton2,'ProblemSelection'); %Problem selection related to the solution
Label=getappdata(handles.listbox5,'Labels');


% Cardinality of the partition of the SafeSet
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% Check if s0 exists
try
    s0 = eval(get(handles.edit6,'String'));
catch
    s0 = [];
    errordlg('The value of s0 must be defined in the corresponding input box')
    set(handles.edit12,'String','');
    return
end
Index_num=prod(double([repmat(s0',m,1),-repmat(s0',m,1)]>[X(:,1:dim)-0.5*X(:,dim+1:2*dim),-(X(:,1:dim)+0.5*X(:,dim+1:2*dim))]),2);
num=find(Index_num==1);
if sum(Index_num)<1
    warndlg(sprintf(' s0 has not been found inside a cell. \n This might be caused by s0 being exactly on the edge of a partition set. \n Or this can be caused due to s0 being outside the Safe Set \n Please try a (slightly) different s0'))
    return
end
if sum(Index_num)>1
    warndlg(sprintf(' There have been multiple cells found for s0. \n This might be caused by s0 being exactly on the edge of a partition set. \n Please try a slightly different s0'))
    return
end

Index=[];
for i=1:numel(Label)
    A=eval(Label(i).A{1});
    B=eval(Label(i).B{1});
    Index(i)=prod(double((A*X(num,1:dim)')<=B));
end
assignin('base','Index',Index)
if ~isempty(find( Index == 1 ))
    text='';
    for i=find(Index==1)
        text=[text,Label(i).Name,', '];
    end
    msgbox(sprintf('s0 corresponds to representative point number %u.\r\nFor more information on this point, save the results.\r\nThis point is in the Labeled Sets:\r\n%s',num,text(1:end-2)),'Information on s0');
else
    msgbox(sprintf('s0 corresponds to representative point number %u.\r\nFor more information on this point, save the results.\r\nThis point is not in a Labeled Set.',num),'Information on s0');  
end



% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
X=getappdata(handles.pushbutton2,'RepresentativePoints');
Problem=getappdata(handles.pushbutton2,'ProblemSelection'); %Problem selection related to the solution
if isempty(X)
    errordlg(sprintf('Representative points should have been made.\r\nPlease run the program first.'));
    return
end
Label=getappdata(handles.listbox5,'Labels');

% Cardinality of the partition of the SafeSet
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

CurrentLabelSelection=get(handles.listbox5,'Value');
if  numel(CurrentLabelSelection) > 1
    warndlg('Please select one single Labeled Set.');
    return
elseif numel(CurrentLabelSelection) == 0
    warndlg('Please select a Labeled Set.');
    return
end

% Find the representative points that are in the Labeled Set
A=eval(Label(CurrentLabelSelection).A{1});
B=eval(Label(CurrentLabelSelection).B{1});
Index=prod(double(A*X(:,1:dim)'<=repmat(B,1,size(X,1))),1);
Nums=[find(Index==1)];
assignin('base','PointsOfLabeledSet',Nums)


button=questdlg(sprintf('The representative points that correspond to the selected set are now stored in the workspace.\r\nFor more information on these points click the "save the results"-button.\r\nDo you want to display the set on the grid?'),'Information on the Labeled Set','Yes','No','Yes');
switch button,
    case 'Yes',
        X=X(Nums,:);
        if dim > 3
            error('Using the grid is only possible for systems up to 3 dimensions.');
            return
        elseif dim == 3
            Solution=getappdata(handles.pushbutton2,'ProblemSolution')';
            X_data = (X*[ones(1,16);zeros(2,16);0.5*[-1,1,1,-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1];zeros(2,16)])';
            Y_data = (X*[zeros(1,16);ones(1,16);zeros(2,16);0.5*[-1,-1,-1,-1,1,1,-1,1,1,-1,1,1,-1,1,1,-1];zeros(1,16)])';
            Z_data = (X*[zeros(2,16);ones(1,16);zeros(2,16);0.5*[-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,1,1]])';
            try
                C_data = ones(16,size(X,1))*mean(Solution(:));
            catch
                C_data = ones(16,size(X,1)); % Catches if there is no solution
            end
            axes(handles.axes1)
            hold on
            q=patch(X_data,Y_data,Z_data,C_data,'FaceColor','y','linewidth',2.5);
            hold off
        elseif dim == 2
            Solution=getappdata(handles.pushbutton2,'ProblemSolution')';
            X_data = (X*[ones(1,dim*2);zeros(1,dim*2);0.5*[-1,1,1,-1];zeros(1,dim*2)])';
            Y_data = (X*[zeros(1,dim*2);ones(1,dim*2);zeros(1,dim*2);0.5*[-1,-1,1,1]])';
            %p=getappdata(handles.pushbutton7,'PlotHandle');
            try
                C_data = ones(4,size(X,1))*mean(Solution(:));
            catch
                C_data = ones(4,size(X,1)); % Catches if there is no solution
            end
            axes(handles.axes1)
            hold on
            q=patch(X_data,Y_data,C_data,'FaceColor','none','linewidth',1.75);
            hold off
        elseif dim == 1
            Solution=getappdata(handles.pushbutton2,'ProblemSolution')';
            X_data = (X*[ones(1,4);0.5*[-1,1,1,-1]])';
            Y_data = (X*[zeros(1,4);[0,0,1,1]])';
            try
                C_data = ones(4,size(X,1))*mean(Solution(:));
            catch
                C_data = ones(4,size(X,1)); % Catches if there is no solution
            end
            axes(handles.axes1)
            hold on
            q=patch(X_data,Y_data,C_data,'FaceColor','b','EdgeAlpha',0,'FaceAlpha',0.6);
            hold off
        end
    case 'No',
        return  
end % switch


% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)

prompt={'Lower bounds u',...
        'Upper bounds u'};
name='Input Bounds';
numlines=1;
defaultanswer={'[u1_l,u2_l,...]','[u1_u,u2_u,...]'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
try
    u_l=eval(answer{1})';
    u_u=eval(answer{2})';
    InputSet=mat2str([u_l,u_u]);
catch
    InputSet='';
end
set(handles.edit15,'String',InputSet);
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
Check=get(hObject,'Value');
if Check ==1
    set(handles.edit15,'Enable','on'); % Input Set
    set(handles.pushbutton16,'Enable','on'); % Input Set
    set(handles.pushbutton17,'Enable','off'); % MRMC
else
    set(handles.edit15,'Enable','off'); % Input Set
    set(handles.pushbutton16,'Enable','off'); % Input Set
    set(handles.pushbutton17,'Enable','on'); % MRMC
end
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% This is the MRMC button
% Check if the program has run and get the necessary data
X=getappdata(handles.pushbutton2,'RepresentativePoints');
Tp=getappdata(handles.pushbutton2,'TransitionMatrix');
Problem=getappdata(handles.pushbutton2,'ProblemSelection'); %Problem selection related to the solution
ProblemComp=get(handles.listbox1,'Value'); %Current problem selection
% Redefine because of changed order
if ProblemComp ==1
    ProblemComp=3;
else
    ProblemComp=ProblemComp-1;
end

if isempty(Tp)
    errordlg(sprintf('In order to make MRMC files, the program should have run fully.\r\nRepresentative points and a transition matrix have to be made first.\r\nThis can be done be clicking on the ''Generate the abstraction''-button'));
    return
end
if ndims(Tp)==3
    errordlg(sprintf('The generated transition matrix belongs to a controlled system.\r\nMRMC only supports uncontrolled systems.'));
    return
end
if Problem ~= ProblemComp
    warndlg(sprintf('For the computation of the solution a different problem selection was used.\r\nPlease either select the problem that corresponds tot the last computed solution or rerun the program.'));
    return
end

% The dimension of the system 
dim = size(X,2)/2;

% Cardinality of the partition of the SafeSet
m=size(X,1);


% The output of the transition possibilities
[a] = Matlab2MRMC(Tp); % creates the .tra file


% Load defined labels 
Label=getappdata(handles.listbox5,'Labels');
Label_length=numel(Label);

% Add Safe Set (and Target Set)
if Problem==1 % Safety
    SafeSet=getappdata(handles.pushbutton2,'SafeSet');
    Label(Label_length+1).Name='SafeSet';
    Label(Label_length+1).A={'[eye(dim);-eye(dim)]'};
    Label(Label_length+1).B={'[SafeSet(:,2);-SafeSet(:,1)]'};
elseif Problem==2 % Reach Avoid
    SafeSet=getappdata(handles.pushbutton2,'SafeSet');
    TargetSet=getappdata(handles.pushbutton2,'TargetSet');
    Label(Label_length+1).Name='SafeSet';
    Label(Label_length+1).A={'[eye(dim);-eye(dim)]'};
    Label(Label_length+1).B={'[SafeSet(:,2);-SafeSet(:,1)]'};
    Label(Label_length+2).Name='TargetSet';
    Label(Label_length+2).A={'[eye(dim);-eye(dim)]'};
    Label(Label_length+2).B={'[TargetSet(:,2);-TargetSet(:,1)]'};
else
    % Do nothing
end


fid = fopen('MRMC/MRMC.lab','w+');

fprintf(fid,'#DECLARATION\r\n');
fprintf(fid,'%s ',Label.Name);
fseek(fid,-1,0);
fprintf(fid,'\r\n#END\r\n');

LabelText=cell(1,m+1);
for i=1:numel(Label)
    A=eval(Label(i).A{1});
    B=eval(Label(i).B{1});
    Index=prod(double(A*X(:,1:dim)'<=repmat(B,1,size(X,1))),1);
    if ~isempty(find(Index==1))
        for j=[find(Index==1)]
            LabelText{j}=[LabelText{j},[Label(i).Name,' ']];
        end
    end
end

for i=[find(cellfun(@isempty,LabelText)==0)]
    fprintf(fid,'%u %s',i,LabelText{i});
    fseek(fid,-1,0);
    fprintf(fid,'\r\n');
end
if Problem==3
    fprintf(fid,'%u %s',m+1,'NonStateSpace');
else
    fprintf(fid,'%u %s',m+1,'NonSafeSet');
end
a=fclose(fid);


% --- Executes during object creation, after setting all properties.
function text9_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','on') % Initially it is on
% hObject    handle to text9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','Initial condition s0'); % Input Set


% --- Executes during object creation, after setting all properties.
function text16_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','on') % Initially it is on
% hObject    handle to text16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton5_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','off') % Initially it is off
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton9_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','off') % Initially it is off
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton14_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','off') % Initially it is off
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton10_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','off') % Initially it is off
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton15_CreateFcn(hObject, eventdata, handles)
set(hObject,'String','States with selected label')
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
