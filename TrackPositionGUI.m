function varargout = TrackPositionGUI(varargin)
% TRACKPOSITIONGUI M-file for TrackPositionGUI.fig
%      TRACKPOSITIONGUI, by itself, creates a new TRACKPOSITIONGUI or raises the existing
%      singleton*.
%
%      H = TRACKPOSITIONGUI returns the handle to a new TRACKPOSITIONGUI or the handle to
%      the existing singleton*.
%
%      TRACKPOSITIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKPOSITIONGUI.M with the given input arguments.
%
%      TRACKPOSITIONGUI('Property','Value',...) creates a new TRACKPOSITIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrackPositionGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrackPositionGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrackPositionGUI

% Last Modified by GUIDE v2.5 20-Sep-2010 13:54:11


% global ACTIVE_CLUST_NUM             % Current Cluster number (as selected in ACTIVE_CLUSTER_MENU)
% global CLUSTER_POSITIONS            % Origional Cluster Position: CLUSTER_POSITIONS{Cluster#,X/Y}(point number)  = value(pixels) [X/Y: 1 = X, 2 = Y]
% global CLUSTER_TIMESTAMPS           % Timestamp value associated with CLUSTER_POSITIONS: CLUSTER_TIMESTAMPS{Cluster#}(point number) = timestamp
% global CLUSTER_LENGTH               % Number of point in the given cluster: CLUSTER_LENGTH(Cluster#) = # of point in cluster
% global CLUSTER_FILES                % Whole path to cluster cut file: CLUSTER_FILES{Cluster#} = whole file
% global CLUSTER_NAMES                % Just the file name for the cluster file: CLUSTER_NAMES{Cluster#} = file name
% global JTRACK_FINDER_OBJECT         % Java object for the track finder app
% global JTRACK_FINDER_CREATED        % is set when JTRACK_FINDER_OBJECT is first created
% global LAP_DIVISIONS                % position of lap divisions: LAP_DIVISIONS{cluster#}(:)
% global LAPS_IN_CLUST                % Number of laps in the cluster: LAPS_IN_CLUST(cluster#) = number of laps
% global LONG_LEN                     % length (cm) of the long side of track (would be in the middle of the track, not the very inside or outside)
% global NUM_OF_CLUSTS                % Number of clusters loaded into program
% global ORIG_TRACK_COORDS            % Cell array containing coordinates retrieved from JTRACK_FINDER_OBJECT: ORIG_TRACK_COORDS{Cluster#,Track#,X/Y}(corner#) = value(pixels); for track#: 1=inside, 2=middle, 3=outside
% global PLACE_FIELD_BOUNDS           % Array containing start + stop of place field: PLACE_FIELD_BOUNDS(1/2) = start/stop  [very start of track = 0, end = 1]
% global ROOT_DIR                     % Root Directory of where the Sleepscorer and SleepData directories are placed
% global ROTATED_CLUSTER              % Position of rotated cluster points ROTATED_CLUSTER{Cluster#,X/Y}(point number)  = value(pixels) [X/Y: 1 = X, 2 = Y]
% global ROTATED_TRACK_COORDS         % Position of rotated track corners ROTATED_TRACK_COORDS{Cluster#,Track#,X/Y}(corner#) = value(pixels); for track#: 1=inside, 2=middle, 3=outside
% global SHORT_LEN                    % Length (cm) of the short side of track (would be in the middle of the track, not the very inside or outside)
% global SIDE_LEN                     % Array of cumulative lengths (cm) of sides of track: SIDE_LEN(side#) = total length(cm)
% global SNAPPED_CLUSTER              % Position of cluster data snapped to the middle track: SNAPPED_CLUSTER{Cluster#,X/Y}(point number)  = value(pixels) [X/Y: 1 = X, 2 = Y]
% global SN_CLUST_TOT_POS             % Total position on trac in range of 0 to 1: SN_CLUST_TOT_POS{clust#}(point#)
% global SN_CLUST_POS_ON_ARM_PXLS     % Position of SNAPPED_CLUSTER from previous corner on the arm it is snapped onto in pixels: SN_CLUST_POS_ON_ARM_PXLS{Cluster#}(point#) = pixels from previous corner
% global SN_ARM_IND                   % Arm of track that the corresponding point # is attached to: SN_ARM_IND{Cluster#}(point#) = arm index
% global TOTAL_TRK_LEN                % Length (cm) of the whole length of the track
% global TRACKS_RETRIEVED             % set when the track for the corresponding Cluster is retrieved from JTRACK_FINDER_OBJECT: TRACKS_RETRIEVED(Cluster#)
% global TRK_LEN_PXLS                 % Length of track in pixels for given Cluster#: TRK_LEN_PXLS(Cluster#) = length(pixels)
% global TRK_LONG_LEN_PXLS            % Length of the long side of the track in pixels: TRK_LONG_LEN_PXLS(Cluster#) = length(pixels)
% global TRK_SHORT_LEN_PXLS           % Length of the short side of the track in pixels: TRK_SHORT_LEN_PXLS(Cluster#) = length(pixels)
% global TT_POSITIONS                 % Array of all points in CLUSTER_FILES between the start & end timestamp of the associated cluster #:  TT_POSITIONS{Cluster#,X/Y}(corner#) = value(pixels)
% global TT_TIMESTAMPS                % Array containing timestamps associated with TT_POSITIONS:   TT_TIMESTAMPS{Cluster#}(point#) = timestamp 
% global TT_LENGTH                    % # of points in givin track training array: TT_LENGTH(Cluster#) = length(TT_TIMESTAMPS{Cluster#}(:))
% global VT_NAMES                     % Cell aray containing names of *.Nvt files: VT_NAMES{Cluster#} = name of file
% global VT_FILES                     % Full path and name of *.Nvt file: VT_FILES{Cluster#} = path and name of file
% 
% global CLUSTER_COLOR

% global CLUSTER_COLOR_INDEX
% 
% global CLUSTER_TYPE                 % vector containing 1 if Plexon output cluster or 0 if Winclust output cluster
% global PLX_CLUSTER_INDX             % vector array containing cluster/unit number of desired cluster in Plexon output file

%DATADIR = 'C:\Rat 159\2004-4-22RUN';
%DATADIR = 'C:\Rat 182\2004-8-15RUN';







% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrackPositionGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TrackPositionGUI_OutputFcn, ...
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

function TrackPositionGUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
global snapTrack
global DATADIR

DATADIR = 'C:\Sleepdata';
handles.output = hObject;
guidata(hObject, handles);
snapTrack = 500;
Init_Vars(handles);
    


function varargout = TrackPositionGUI_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;


%==========================================================================
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
% Create Functions
function PF_STOP_TEXT_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function PF_START_TEXT_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function PF_START_SLIDER_CreateFcn(hObject, eventdata, handles)
% usewhitebg = 1;
% if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);

function PF_STOP_SLIDER_CreateFcn(hObject, eventdata, handles)
% usewhitebg = 1;
% if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);

function NUM_OF_LAPS_SLIDER_CreateFcn(hObject, eventdata, handles)
% usewhitebg = 1;
% if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);

function NUM_OF_LAPS_TXT_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ACTIVE_CLUSTER_MENU_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function CLUSTER_NVT_TEXT_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ClusterColorSelect_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% END Create Functions
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%==========================================================================


function Init_Vars(handles)
    global ACTIVE_CLUST_NUM             % Current Cluster number (as selected in ACTIVE_CLUSTER_MENU)
    global CLUSTER_POSITIONS            % Origional Cluster Position: CLUSTER_POSITIONS{Cluster#,X/Y}(point number)  = value(pixels) [X/Y: 1 = X, 2 = Y]
    global CLUSTER_TIMESTAMPS           % Timestamp value associated with CLUSTER_POSITIONS: CLUSTER_TIMESTAMPS{Cluster#}(point number) = timestamp
    global CLUSTER_LENGTH               % Number of point in the given cluster: CLUSTER_LENGTH(Cluster#) = # of point in cluster
    global CLUSTER_FILES                % Whole path to cluster cut file: CLUSTER_FILES{Cluster#} = whole file
    global CLUSTER_NAMES                % Just the file name for the cluster file: CLUSTER_NAMES{Cluster#} = file name
    global JTRACK_FINDER_CREATED        % is set when JTRACK_FINDER_OBJECT is first created
    global LAP_DIVISIONS                % position of lap divisions: LAP_DIVISIONS{cluster#}(:)
    global LAPS_IN_CLUST                % Number of laps in the cluster: LAPS_IN_CLUST(cluster#) = number of laps
    global LONG_LEN                     % length (cm) of the long side of track (would be in the middle of the track, not the very inside or outside)
    global NUM_OF_CLUSTS                % Number of clusters loaded into program
    global ORIG_TRACK_COORDS            % Cell array containing coordinates retrieved from JTRACK_FINDER_OBJECT: ORIG_TRACK_COORDS{Cluster#,Track#,X/Y}(corner#) = value(pixels); for track#: 1=inside, 2=middle, 3=outside
    global PLACE_FIELD_BOUNDS           % Array containing start + stop of place field: PLACE_FIELD_BOUNDS(1/2) = start/stop  [very start of track = 0, end = 1]
    global ROOT_DIR                     % Root Directory of where the Sleepscorer and SleepData directories are placed
    global ROTATED_CLUSTER              % Position of rotated cluster points ROTATED_CLUSTER{Cluster#,X/Y}(point number)  = value(pixels) [X/Y: 1 = X, 2 = Y]
    global ROTATED_TRACK_COORDS         % Position of rotated track corners ROTATED_TRACK_COORDS{Cluster#,Track#,X/Y}(corner#) = value(pixels); for track#: 1=inside, 2=middle, 3=outside
    global SHORT_LEN                    % Length (cm) of the short side of track (would be in the middle of the track, not the very inside or outside)
    global SIDE_LEN                     % Array of cumulative lengths (cm) of sides of track: SIDE_LEN(side#) = total length(cm)
    global SNAPPED_CLUSTER              % Position of cluster data snapped to the middle track: SNAPPED_CLUSTER{Cluster#,X/Y}(point number)  = value(pixels) [X/Y: 1 = X, 2 = Y]
    global SN_CLUST_TOT_POS             % Total position on trac in range of 0 to 1: SN_CLUST_TOT_POS{clust#}(point#)
    global SN_CLUST_POS_ON_ARM_PXLS     % Position of SNAPPED_CLUSTER from previous corner on the arm it is snapped onto in pixels: SN_CLUST_POS_ON_ARM_PXLS{Cluster#}(point#) = pixels from previous corner
    global SN_ARM_IND                   % Arm of track that the corresponding point # is attached to: SN_ARM_IND{Cluster#}(point#) = arm index
    global TOTAL_TRK_LEN                % Length (cm) of the whole length of the track
    global TRACKS_RETRIEVED             % set when the track for the corresponding Cluster is retrieved from JTRACK_FINDER_OBJECT: TRACKS_RETRIEVED(Cluster#)
    global TRK_LEN_PXLS                 % Length of track in pixels for given Cluster#: TRK_LEN_PXLS(Cluster#) = length(pixels)
    global TRK_LONG_LEN_PXLS            % Length of the long side of the track in pixels: TRK_LONG_LEN_PXLS(Cluster#) = length(pixels)
    global TRK_SHORT_LEN_PXLS           % Length of the short side of the track in pixels: TRK_SHORT_LEN_PXLS(Cluster#) = length(pixels)
    global TT_POSITIONS                 % Array of all points in CLUSTER_FILES between the start & end timestamp of the associated cluster #:  TT_POSITIONS{Cluster#,X/Y}(corner#) = value(pixels)
    global TT_TIMESTAMPS                % Array containing timestamps associated with TT_POSITIONS:   TT_TIMESTAMPS{Cluster#}(point#) = timestamp 
    global TT_LENGTH                    % # of points in givin track training array: TT_LENGTH(Cluster#) = length(TT_TIMESTAMPS{Cluster#}(:))
    global VT_NAMES                     % Cell aray containing names of *.Nvt files: VT_NAMES{Cluster#} = name of file
    global VT_FILES                     % Full path and name of *.Nvt file: VT_FILES{Cluster#} = path and name of file
    global CLUSTER_COLOR_INDEX
    global CLUSTER_COLOR snapTrack
    global CLUSTER_TYPE                 % Cell array containing 1 if Plexon output cluster or 0 if Winclust output cluster
    global PLX_CLUSTER_INDX             % Cell array containing cluster/unit number of desired cluster in Plexon output file


    set(handles.snapTrackCutOff, 'String', snapTrack)
    ACTIVE_CLUST_NUM = 1;
    CLUSTER_COLOR = {};
    CLUSTER_COLOR_INDEX = [];
    CLUSTER_POSITIONS = [];
    CLUSTER_TIMESTAMPS = [];
    CLUSTER_LENGTH = [];
    CLUSTER_FILES = {};
    CLUSTER_NAMES = {};
    CLUSTER_TYPE = [];
    JTRACK_FINDER_CREATED = 0;
    LAP_DIVISIONS = {};
    LAPS_IN_CLUST = 1;
    NUM_OF_CLUSTS = 1;
    ORIG_TRACK_COORDS = {};
    PLACE_FIELD_BOUNDS = [0 1];
    PLX_CLUSTER_INDX = [];
    ROOT_DIR = 'C:\';
    ROTATED_CLUSTER = {};
    ROTATED_TRACK_COORDS = {};
    SNAPPED_CLUSTER = {};
    SN_ARM_IND = {};
    SN_CLUST_POS_ON_ARM_PXLS = {};
    SN_CLUST_TOT_POS = {};
    TRACKS_RETRIEVED = [];
    TRK_LEN_PXLS = [];
    TRK_LONG_LEN_PXLS = [];
    TRK_SHORT_LEN_PXLS = [];
    TT_POSITIONS = {};
    TT_TIMESTAMPS = {};
    TT_LENGTH = [];
    VT_FILES = {};
    VT_NAMES = {};
   
    % Middle track measured dimension:
    % 82.8 cm long x 36.8 cm wide
    LONG_LEN = 82.8;
    SHORT_LEN = 36.8;
    SIDE_LEN = [];
    SIDE_LEN(1) = LONG_LEN;
    SIDE_LEN(2) = SHORT_LEN + SIDE_LEN(1);
    SIDE_LEN(3) = LONG_LEN + SIDE_LEN(2);
    SIDE_LEN(4) = SHORT_LEN + SIDE_LEN(3);
    TOTAL_TRK_LEN = 2 * (LONG_LEN + SHORT_LEN);

    
    set(handles.PF_START_SLIDER,'Min',0,'Max',1,'Value',0,'sliderstep',[1/100 1/100]);
    set(handles.PF_START_TEXT,'String','0');
    set(handles.PF_STOP_SLIDER,'Min',0,'Max',1,'Value',1,'sliderstep',[1/100 1/100]);
    set(handles.PF_STOP_TEXT,'String',num2str(1*TOTAL_TRK_LEN));
    
    set(handles.NUM_OF_LAPS_SLIDER,'Min',1,'Max',15,'Value',1,'sliderstep',[1/15 1/15]);
    set(handles.NUM_OF_LAPS_TXT,'String','1');
    
    set(handles.CLUSTER_NVT_TEXT,'String','Video File');
    set(handles.ACTIVE_CLUSTER_MENU,'String','Clusters');
    
    set(handles.CW_CHECK,'Value',0.0);
    set(handles.CW_CHECK,'Enable','off');
        
    axes(handles.ALL_POSITIONS_AXIS); %#ok<*MAXES>
    plot(0,0,'b  ');
    axes(handles.ROTATED_AXIS);
    plot(0,0,'b  ');
    axes(handles.POS_VS_TIME_AXIS);
    plot(0,0,'b  ');
    axes(handles.SNAPPED_POSITIONS_AXIS);
    plot(0,0,'b  ');
    axes(handles.ROLLED_OUT_POSITIONS_AXIS);
    plot(0,0,'b  ');    
%END function Init_Vars(handles)

function OVERLAY_PF_MENU_Callback(hObject, eventdata, handles)
    Overlay_CPF_Files;
%END function OVERLAY_PF_MENU_Callback(hObject, eventdata, handles)

%==========================================================================
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%
% Callback Functions

function Load_Data_Menu_Callback(hObject, eventdata, handles)
%     global ROOT_DIR
    global NUM_OF_CLUSTS
%     global CLUSTER_TIMESTAMPS
    global CLUSTER_FILES
    global VT_FILES
%     global TT_POSITIONS                 % TT_POSITIONS(cluster_#, x-y_pair_#, :) = [x y]
%     global TT_TIMESTAMPS                % TT_TIMESTAMPS(cluster_#, x-y_pair_#) = timestamp
    global CLUSTER_NAMES
    global VT_NAMES
%     global ACTIVE_CLUST_NUM
%     global TRACKS_RETRIEVED
%     global ROTATED_TRACK_COORDS
%     global LAPS_IN_CLUST
%     global LAP_DIVISIONS 
    global DATADIR
    global CLUSTER_COLOR
    global CLUSTER_COLOR_INDEX
    global CLUSTER_TYPE
    global PLX_CLUSTER_INDX
    
    Init_Vars(handles);
    working_dir = pwd;
    %data_dir = horzcat(ROOT_DIR,'SleepData\Datafiles');
%     data_dir = DATADIR;
    
    % set up variable for Plexon output file prompts
    prompt = {'Enter cluster / unit number:'};
    dlg_title = 'Plexon Output File Cluster/Unit Number';
    num_lines = 1;
    def = {'1'};
    
    open_cluster = 1;
    while(open_cluster)
        cd(DATADIR);
        [clust_pos_file, clust_pos_path] = uigetfile({'*.1;*.2;*.3;*.4;*.5;*.6;*.7;*.8;*.9;*.1*;*.txt',...
            'Spike Position File (*.#;*.txt)'},'Select a Cluster Cut Timestamp File');
        
        % if Plexon output file, prompt for cluster number
        if(findstr(clust_pos_file,'.txt'))
            CLUSTER_TYPE(NUM_OF_CLUSTS)=1;
            fprintf(1,'plexon file detected\n');
            tempunitnum = inputdlg(prompt,dlg_title,num_lines,def);
            PLX_CLUSTER_INDX(NUM_OF_CLUSTS)=str2double(tempunitnum{1});
        else
            fprintf(1,'Winclust file detected\n');
            CLUSTER_TYPE(NUM_OF_CLUSTS)=0;
            PLX_CLUSTER_INDX(NUM_OF_CLUSTS)=0;
        end
        fprintf(1,'plexon cluster number = %10f\n',PLX_CLUSTER_INDX(NUM_OF_CLUSTS))
            
        cluster_file = fullfile(clust_pos_path, clust_pos_file);
        CLUSTER_FILES{NUM_OF_CLUSTS} = cluster_file;
        CLUSTER_NAMES{NUM_OF_CLUSTS} = clust_pos_file;
        CLUSTER_COLOR{NUM_OF_CLUSTS} = [0 .3 0];
        CLUSTER_COLOR_INDEX(NUM_OF_CLUSTS) = 1;
%         DATADIR = clust_pos_path;
        cd(clust_pos_path);
        [nvt_file, nvt_path] = uigetfile({'*.Nvt',...
            'Neuralynx Video File (*.Nvt)'; '*.xls','Cleane VT File (*.xls)'},'Select a Corresponding Video Position File');
        vt_file = fullfile(nvt_path, nvt_file);
        VT_FILES{NUM_OF_CLUSTS} = vt_file;
        VT_NAMES{NUM_OF_CLUSTS} = nvt_file;
        DATADIR = nvt_path;
        cd(working_dir);
        
        if (strcmp(questdlg('Would you like to load an additional cluster file','Additional Cluster File Question'),'Yes'))
            NUM_OF_CLUSTS = NUM_OF_CLUSTS + 1;
        else
            open_cluster = 0;
        end
    end
   
    for i=1:NUM_OF_CLUSTS
        load_cluster_data(handles, i);
    end
    update_cluster_menu(handles);
    
    
    
    
    %TT_TIMESTAMPS
    %load_track_training_file(handles);
    %load_cluster_cut_pos_file(handles);
    %launch_track_finder_app(handles);

%END function Load_Data_Menu_Callback(hObject, eventdata, handles)

function ACTIVE_CLUSTER_MENU_Callback(hObject, eventdata, handles)
    global ACTIVE_CLUST_NUM
    global VT_NAMES
    global NUM_OF_CLUSTS
    global LAPS_IN_CLUST
    global CW
    global CLUSTER_COLOR_INDEX
    
    ACTIVE_CLUST_NUM = get(handles.ACTIVE_CLUSTER_MENU,'Value');
    if(ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        set(handles.CLUSTER_NVT_TEXT,'String',VT_NAMES{ACTIVE_CLUST_NUM});
        
        set(handles.NUM_OF_LAPS_TXT,'Enable','on');
        set(handles.NUM_OF_LAPS_SLIDER,'Enable','on');
        set(handles.NUM_OF_LAPS_SLIDER,'Min',1,'Max',15,'Value',LAPS_IN_CLUST(ACTIVE_CLUST_NUM),'sliderstep',[1/15 1/15]);
        set(handles.NUM_OF_LAPS_TXT,'String',num2str(LAPS_IN_CLUST(ACTIVE_CLUST_NUM)));
        set(handles.CW_CHECK,'Enable','on');
        set(handles.CW_CHECK,'Value',CW(ACTIVE_CLUST_NUM));
        set(handles.ClusterColorSelect,'Value',CLUSTER_COLOR_INDEX(ACTIVE_CLUST_NUM));
        set(handles.ClusterColorSelect,'Enable','on');
    else
        set(handles.CLUSTER_NVT_TEXT,'String','');
        
        set(handles.NUM_OF_LAPS_TXT,'String','---');
        
        set(handles.NUM_OF_LAPS_TXT,'Enable','off');
        set(handles.NUM_OF_LAPS_SLIDER,'Enable','off');
        set(handles.CW_CHECK,'Value',0.0);
        set(handles.CW_CHECK,'Enable','off');
        %set(handles.ClusterColorSelect,'Value',0.0);
        set(handles.ClusterColorSelect,'Enable','off');
        
    end
    plot_orig_data(handles);
 
%END function ACTIVE_CLUSTER_MENU_Callback(hObject, eventdata, handles)
    
function CLUSTER_NVT_TEXT_Callback(hObject, eventdata, handles)

%END function CLUSTER_NVT_TEXT_Callback(hObject, eventdata, handles)

%launch the java app
function TRK_FINDR_BUTTON_Callback(hObject, eventdata, handles)
    global ACTIVE_CLUST_NUM
    global NUM_OF_CLUSTS
    global TT_POSITIONS
    global JTRACK_FINDER_OBJECT
%     global CLUSTER_LENGTH
    global TT_LENGTH
    global JTRACK_FINDER_CREATED
    
    if(JTRACK_FINDER_CREATED)
        JTRACK_FINDER_OBJECT.close;
    end
    
    if(ACTIVE_CLUST_NUM > NUM_OF_CLUSTS)
        errordlg('Select a valid cluster to run the track finder application.','Cluster Selection Error');
    else    
        the_length = TT_LENGTH(ACTIVE_CLUST_NUM);
        
        my_jarray = javaArray('IntPoint',the_length);
        for i=1:the_length
            my_jarray(i) = javaObject('IntPoint',TT_POSITIONS{ACTIVE_CLUST_NUM,1}(i),TT_POSITIONS{ACTIVE_CLUST_NUM,2}(i));
        end
        
        JTRACK_FINDER_OBJECT = javaObject('JTrackFinder',my_jarray,800,600);
        JTRACK_FINDER_CREATED = 1;
    end
    
    
%END function TRK_FINDR_BUTTON_Callback(hObject, eventdata, handles)

function CHANGE_VIDEO_MENU_Callback(hObject, eventdata, handles)
    global VT_NAMES
    global VT_FILES
    global ACTIVE_CLUST_NUM
    global NUM_OF_CLUSTS
%     global ROOT_DIR
    global DATADIR
    
    if(ACTIVE_CLUST_NUM > NUM_OF_CLUSTS)
        errordlg('Select a valid cluster to replace video file.','Cluster Selection Error');
    else
        working_dir = pwd;
        %data_dir = horzcat(ROOT_DIR,'SleepData\Datafiles');
%         data_dir = DATADIR;
        cd(DATADIR);
        [nvt_file, nvt_path] = uigetfile({'*.Nvt',...
            'Neuralynx Video File (*.Nvt)'},'Select a Corresponding Video Position File');
        DATADIR = nvt_path;
        cd(working_dir);
        vt_file = fullfile(nvt_path, nvt_file);
        VT_FILES{ACTIVE_CLUST_NUM} = vt_file;
        VT_NAMES{ACTIVE_CLUST_NUM} = nvt_file;
        set(handles.CLUSTER_NVT_TEXT,'String',VT_NAMES{ACTIVE_CLUST_NUM});
        load_cluster_data(handles,ACTIVE_CLUST_NUM);
        plot_orig_data(handles);

    end
%END function CHANGE_VIDEO_MENU_Callback(hObject, eventdata, handles)


function REMOVE_CLUST_MENU_Callback(hObject, eventdata, handles)
    global ACTIVE_CLUST_NUM             % Current Cluster number (as selected in ACTIVE_CLUSTER_MENU)
    global CLUSTER_POSITIONS            % d
    global CLUSTER_TIMESTAMPS           % d
    global CLUSTER_LENGTH               % d
    global CLUSTER_FILES                % d
    global CLUSTER_NAMES                % d
    global LAP_DIVISIONS                % d
    global LAPS_IN_CLUST                % d
    global NUM_OF_CLUSTS                % d
    global ORIG_TRACK_COORDS            % d
    global ROTATED_CLUSTER              % d
    global ROTATED_TRACK_COORDS         % d
    global SNAPPED_CLUSTER              % d
    global SN_CLUST_POS_ON_ARM_PXLS     % d
    global SN_CLUST_TOT_POS             % Total position on trac in range of 0 to 1: SN_CLUST_TOT_POS{clust#}(point#)
    global SN_ARM_IND                   % d
    global TRACKS_RETRIEVED             % d
    global TRK_LEN_PXLS                 % d
    global TRK_LONG_LEN_PXLS            % d
    global TRK_SHORT_LEN_PXLS           % d
    global TT_POSITIONS                 % d
    global TT_TIMESTAMPS                % d
    global TT_LENGTH                    % d
    global VT_NAMES                     % Cell aray containing names of *.Nvt files: VT_NAMES{Cluster#} = name of file
    global VT_FILES                     % Full path and name of *.Nvt file: VT_FILES{Cluster#} = path and name of file
    global CLUSTER_COLOR
    global CLUSTER_COLOR_INDEX
    
    
    if(ACTIVE_CLUST_NUM > NUM_OF_CLUSTS)
        errordlg('Select a valid cluster to remove.','Cluster Selection Error');
    else
    for i=ACTIVE_CLUST_NUM:(NUM_OF_CLUSTS-1)
        
        CLUSTER_FILES{i} = CLUSTER_FILES{i+1};
        CLUSTER_NAMES{i} = CLUSTER_NAMES{i+1};
        
        CLUSTER_COLOR{i} = CLUSTER_COLOR{i+1};
        CLUSTER_COLOR_INDEX(i) = CLUSTER_COLOR_INDEX(i+1);
        
        CLUSTER_TIMESTAMPS{i} = [];
        CLUSTER_POSITIONS{i,1} = [];
        CLUSTER_POSITIONS{i,2} = [];
        
        CLUSTER_TIMESTAMPS{i} = CLUSTER_TIMESTAMPS{i+1}(1:CLUSTER_LENGTH(i+1));
        CLUSTER_POSITIONS{i,1} = CLUSTER_POSITIONS{i+1,1}(1:CLUSTER_LENGTH(i+1));
        CLUSTER_POSITIONS{i,2} = CLUSTER_POSITIONS{i+1,2}(1:CLUSTER_LENGTH(i+1));
        
        CLUSTER_LENGTH(i) = CLUSTER_LENGTH(i+1);
        
        TT_POSITIONS{i,1} = [];
        TT_POSITIONS{i,2} = [];
        TT_TIMESTAMPS{i} = [];
        
        TT_POSITIONS{i,1} = TT_POSITIONS{i+1,1}(1:TT_LENGTH(i+1));
        TT_POSITIONS{i,2} = TT_POSITIONS{i+1,2}(1:TT_LENGTH(i+1));
        TT_TIMESTAMPS{i} = TT_TIMESTAMPS{i+1}(1:TT_LENGTH(i+1));
        
        TT_LENGTH(i) = TT_LENGTH(i+1);
        
        VT_NAMES{i} = VT_NAMES{i+1};
        VT_FILES{i} = VT_FILES{i+1};
        
        LAP_DIVISIONS{i} = LAP_DIVISIONS{i+1};
        LAPS_IN_CLUST(i) = LAPS_IN_CLUST(i+1);
        
        if(TRACKS_RETRIEVED(i+1))
            for j=1:3
                for t=1:2
                    ORIG_TRACK_COORDS{i,j,t} = ORIG_TRACK_COORDS{i+1,j,t};
                    ROTATED_TRACK_COORDS{i,j,t} = ROTATED_TRACK_COORDS{i+1,j,t};
                end
            end
            ROTATED_CLUSTER{i,1} = ROTATED_CLUSTER{i+1,1};
            ROTATED_CLUSTER{i,2} = ROTATED_CLUSTER{i+1,2};
            SNAPPED_CLUSTER{i,1} = SNAPPED_CLUSTER{i+1,1};
            SNAPPED_CLUSTER{i,2} = SNAPPED_CLUSTER{i+1,2};
            SN_CLUST_POS_ON_ARM_PXLS{i} = SN_CLUST_POS_ON_ARM_PXLS{i+1};
            SN_CLUST_TOT_POS{i} = SN_CLUST_TOT_POS{i+1};
            SN_ARM_IND{i} = SN_ARM_IND{i+1};
            TRK_LEN_PXLS(i) = TRK_LEN_PXLS(i+1);
            TRK_LONG_LEN_PXLS(i) = TRK_LONG_LEN_PXLS(i+1);
            TRK_SHORT_LEN_PXLS(i) = TRK_SHORT_LEN_PXLS(i+1);
        elseif(TRACKS_RETRIEVED(i)) 
            for j=1:3
                for t=1:2
                    ORIG_TRACK_COORDS{i,j,t} = [];
                    ROTATED_TRACK_COORDS{i,j,t} = [];
                end
            end
            ROTATED_CLUSTER{i,1} = [];
            ROTATED_CLUSTER{i,2} = [];
            SNAPPED_CLUSTER{i,1} = [];
            SNAPPED_CLUSTER{i,2} = [];
            SN_CLUST_TOT_POS{i} = [];
            SN_CLUST_POS_ON_ARM_PXLS{i} = [];
            SN_ARM_IND{i} = [];
            TRK_LEN_PXLS(i) = [];
            TRK_LONG_LEN_PXLS(i) = [];
            TRK_SHORT_LEN_PXLS(i) = [];
        end
   
        TRACKS_RETRIEVED(i) = TRACKS_RETRIEVED(i+1);
        
    end
    
    LAP_DIVISIONS{NUM_OF_CLUSTS} = [];
    LAPS_IN_CLUST(NUM_OF_CLUSTS) = [];
    
    ROTATED_CLUSTER{NUM_OF_CLUSTS,1} = [];
    ROTATED_CLUSTER{NUM_OF_CLUSTS,2} = [];
    SNAPPED_CLUSTER{NUM_OF_CLUSTS,1} = [];
    SNAPPED_CLUSTER{NUM_OF_CLUSTS,2} = [];
    SN_CLUST_POS_ON_ARM_PXLS{NUM_OF_CLUSTS} = [];
    SN_CLUST_TOT_POS{NUM_OF_CLUSTS} = [];
    SN_ARM_IND{NUM_OF_CLUSTS} = [];
    TRK_LEN_PXLS(NUM_OF_CLUSTS) = [];
    TRK_LONG_LEN_PXLS(NUM_OF_CLUSTS) = [];
    TRK_SHORT_LEN_PXLS(NUM_OF_CLUSTS) = [];
    for j=1:3
        for t=1:2
            ORIG_TRACK_COORDS{NUM_OF_CLUSTS,j,t} = [];
            ROTATED_TRACK_COORDS{NUM_OF_CLUSTS,j,t} = [];
        end
    end
    
    
    TRACKS_RETRIEVED(NUM_OF_CLUSTS) = 0;
    TT_POSITIONS{NUM_OF_CLUSTS,1} = [];
    TT_POSITIONS{NUM_OF_CLUSTS,2} = [];
    TT_TIMESTAMPS{NUM_OF_CLUSTS} = [];
    TT_LENGTH(NUM_OF_CLUSTS) = [];
    
    CLUSTER_FILES{NUM_OF_CLUSTS} = [];
    CLUSTER_NAMES{NUM_OF_CLUSTS} = [];
    CLUSTER_TIMESTAMPS{NUM_OF_CLUSTS} = [];
    CLUSTER_POSITIONS{NUM_OF_CLUSTS,1} = [];
    CLUSTER_POSITIONS{NUM_OF_CLUSTS,2} = [];
    CLUSTER_LENGTH(NUM_OF_CLUSTS) = [];
    
    VT_NAMES{NUM_OF_CLUSTS} = [];
    VT_FILES{NUM_OF_CLUSTS} = [];
    
    NUM_OF_CLUSTS = NUM_OF_CLUSTS - 1;

    if(ACTIVE_CLUST_NUM > NUM_OF_CLUSTS)
        ACTIVE_CLUST_NUM = NUM_OF_CLUSTS;
    end
    update_cluster_menu(handles);
    end
%END function REMOVE_CLUST_MENU_Callback(hObject, eventdata, handles)

function ADD_CLUST_MENU_Callback(hObject, eventdata, handles)
%     global ROOT_DIR
    global NUM_OF_CLUSTS
    global CLUSTER_FILES
    global CLUSTER_NAMES
    global VT_FILES
    global VT_NAMES
%     global TRACKS_RETRIEVED
%     global ROTATED_TRACK_COORDS
%     global LAPS_IN_CLUST
    global ACTIVE_CLUST_NUM
    global DATADIR
    global CLUSTER_COLOR
    global CLUSTER_COLOR_INDEX
    global CLUSTER_TYPE
    global PLX_CLUSTER_INDX

    init_clust = NUM_OF_CLUSTS + 1;
    working_dir = pwd;
    %data_dir = horzcat(ROOT_DIR,'SleepData\Datafiles');
%     data_dir = DATADIR;
    
    % set up variable for Plexon output file prompts
    prompt = {'Enter cluster / unit number:'};
    dlg_title = 'Plexon Output File Cluster/Unit Number';
    num_lines = 1;
    def = {'1'};
    
    NUM_OF_CLUSTS = NUM_OF_CLUSTS + 1;
    open_cluster = 1;
    while(open_cluster)
        cd(DATADIR);
        
        [clust_pos_file, clust_pos_path] = uigetfile({'*.1;*.2;*.3;*.4;*.5;*.6;*.7;*.8;*.9;*.1*;*.txt',...
            'Spike Position File (*.#;*.txt)'},'Select a Cluster Cut Timestamp File');
        
         % if Plexon output file, prompt for cluster number
        if(findstr(clust_pos_file,'.txt'))
            CLUSTER_TYPE(NUM_OF_CLUSTS)=1;
            fprintf(1,'plexon file detected\n');
            tempunitnum = inputdlg(prompt,dlg_title,num_lines,def);
            PLX_CLUSTER_INDX(NUM_OF_CLUSTS)=str2double(tempunitnum{1});
        else
            fprintf(1,'Winclust file detected\n');
            CLUSTER_TYPE(NUM_OF_CLUSTS)=0;
            PLX_CLUSTER_INDX(NUM_OF_CLUSTS)=0;
        end
        fprintf(1,'plexon cluster number = %10f\n',PLX_CLUSTER_INDX(NUM_OF_CLUSTS))
    
        cluster_file = fullfile(clust_pos_path, clust_pos_file);
        CLUSTER_FILES{NUM_OF_CLUSTS} = cluster_file;
        CLUSTER_NAMES{NUM_OF_CLUSTS} = clust_pos_file;
        cd(clust_pos_path);
        CLUSTER_COLOR_INDEX(NUM_OF_CLUSTS) = 1;
        CLUSTER_COLOR{NUM_OF_CLUSTS} = [0 .3 0];
        
        [nvt_file, nvt_path] = uigetfile({'*.Nvt',...
            'Neuralynx Video File (*.Nvt)'},'Select a Corresponding Video Position File');
        vt_file = fullfile(nvt_path, nvt_file);
        VT_FILES{NUM_OF_CLUSTS} = vt_file;
        VT_NAMES{NUM_OF_CLUSTS} = nvt_file;
        DATADIR = nvt_path;
        cd(working_dir);
    
        if (strcmp(questdlg('Would you like to load an additional cluster file','Additional Cluster File Question'),'Yes'))
            NUM_OF_CLUSTS = NUM_OF_CLUSTS + 1;
        else
            open_cluster = 0;
        end
    end
   
    for i=init_clust:NUM_OF_CLUSTS
        load_cluster_data(handles, i);
    end
    
    ACTIVE_CLUST_NUM = NUM_OF_CLUSTS;
    update_cluster_menu(handles);
%END function ADD_CLUST_MENU_Callback(hObject, eventdata, handles)

function GET_TRACK_POS_BUTTON_Callback(hObject, eventdata, handles)
    global JTRACK_FINDER_OBJECT
    global ORIG_TRACK_COORDS
%     global ROTATED_TRACK_COORDS
    global CW
    global ACTIVE_CLUST_NUM
    global NUM_OF_CLUSTS
    global TRACKS_RETRIEVED
    
    if(ACTIVE_CLUST_NUM > NUM_OF_CLUSTS)
        errordlg('Select a valid cluster.','Cluster Selection Error');
    else
        middle_coords = JTRACK_FINDER_OBJECT.getTrackCoords;
        inner_coords = JTRACK_FINDER_OBJECT.getInnerCoords;
        outer_coords = JTRACK_FINDER_OBJECT.getOuterCoords;
        
        
%         corner_order = [];
        CW(ACTIVE_CLUST_NUM) = JTRACK_FINDER_OBJECT.clockwiseCheck;
        set(handles.CW_CHECK,'Enable','on');
        set(handles.CW_CHECK,'Value',CW(ACTIVE_CLUST_NUM));
        
        corner_order = [1 2 3 4];
        %if(CW(ACTIVE_CLUST_NUM))       %clockwise
        %    corner_order = [1 2 3 4];
        %else
        %    orner_order = [1 4 3 2];
        %end
        for i=1:4
            ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,1}(i) = inner_coords(corner_order(i)).getX;
            ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,2}(i) = inner_coords(corner_order(i)).getY;
            ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(i) = middle_coords(corner_order(i)).getX;
            ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(i) = middle_coords(corner_order(i)).getY;
            ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,1}(i) = outer_coords(corner_order(i)).getX;
            ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,2}(i) = outer_coords(corner_order(i)).getY;
        end
        
        TRACKS_RETRIEVED(ACTIVE_CLUST_NUM) = 1;
        rotate_axis(handles);
        plot_orig_data(handles);
        
    end
    
    
%END function GET_TRACK_POS_BUTTON_Callback(hObject, eventdata, handles)


function STRAIGHTENED_LOCK_CHECK_Callback(hObject, eventdata, handles)
    plot_straightened_plus(handles);
%END function STRAIGHTENED_LOCK_CHECK_Callback(hObject, eventdata, handles)

function PF_START_SLIDER_Callback(hObject, eventdata, handles)
    global PLACE_FIELD_BOUNDS
    global TOTAL_TRK_LEN

    PLACE_FIELD_BOUNDS(1) = get(handles.PF_START_SLIDER,'Value');
    set(handles.PF_START_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(1)));
    if(PLACE_FIELD_BOUNDS(1) > PLACE_FIELD_BOUNDS(2))
        PLACE_FIELD_BOUNDS(2) =  PLACE_FIELD_BOUNDS(1);
        set(handles.PF_STOP_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(2)));
        set(handles.PF_STOP_SLIDER,'Value',PLACE_FIELD_BOUNDS(2));
    end
    find_laps_in_clust(handles);
    plot_straightened_plus(handles);
    
%END function PF_START_SLIDER_Callback(hObject, eventdata, handles)

function PF_STOP_SLIDER_Callback(hObject, eventdata, handles)
    global PLACE_FIELD_BOUNDS
    global TOTAL_TRK_LEN
    
    PLACE_FIELD_BOUNDS(2) = get(handles.PF_STOP_SLIDER,'Value');
    set(handles.PF_STOP_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(2)));
    if(PLACE_FIELD_BOUNDS(1) > PLACE_FIELD_BOUNDS(2))
        PLACE_FIELD_BOUNDS(1) = PLACE_FIELD_BOUNDS(2);
        set(handles.PF_START_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(1)));
        set(handles.PF_START_SLIDER,'Value',PLACE_FIELD_BOUNDS(1));
    end
    find_laps_in_clust(handles);
    plot_straightened_plus(handles);
    
%END function PF_STOP_SLIDER_Callback(hObject, eventdata, handles)

function PF_START_TEXT_Callback(hObject, eventdata, handles)
    global PLACE_FIELD_BOUNDS
    global TOTAL_TRK_LEN
    
    if(str2double(get(handles.PF_START_TEXT,'String')) > TOTAL_TRK_LEN)
        % reset text
        set(handles.PF_START_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(1)));
    elseif(str2double(get(handles.PF_START_TEXT,'String')) > (TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(2)))
        PLACE_FIELD_BOUNDS(1) = str2double(get(handles.PF_START_TEXT,'String'))/TOTAL_TRK_LEN;
        PLACE_FIELD_BOUNDS(2) = PLACE_FIELD_BOUNDS(1);
        set(handles.PF_STOP_TEXT,'String',sprintf('%6.1f',PLACE_FIELD_BOUNDS(2)*TOTAL_TRK_LEN));
        set(handles.PF_START_SLIDER,'Value',PLACE_FIELD_BOUNDS(1));
        set(handles.PF_STOP_SLIDER,'Value',PLACE_FIELD_BOUNDS(2));
    else
        PLACE_FIELD_BOUNDS(1) = str2double(get(handles.PF_START_TEXT,'String'))/TOTAL_TRK_LEN;
        set(handles.PF_START_SLIDER,'Value',PLACE_FIELD_BOUNDS(1));
    end
    find_laps_in_clust(handles);
    plot_straightened_plus(handles);
%END function PF_START_TEXT_Callback(hObject, eventdata, handles)

function PF_STOP_TEXT_Callback(hObject, eventdata, handles)
    global PLACE_FIELD_BOUNDS
    global TOTAL_TRK_LEN
    
    if(str2double(get(handles.PF_STOP_TEXT,'String')) > TOTAL_TRK_LEN)
        % reset text
        set(handles.PF_STOP_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(2)));
    elseif(str2double(get(handles.PF_STOP_TEXT,'String')) < (TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(1)))
        %fprintf('Move Start!!!\n');
        PLACE_FIELD_BOUNDS(1) = str2double(get(handles.PF_STOP_TEXT,'String'))/TOTAL_TRK_LEN;
        PLACE_FIELD_BOUNDS(2) = PLACE_FIELD_BOUNDS(1);
        set(handles.PF_START_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(1)));
        set(handles.PF_START_SLIDER,'Value',PLACE_FIELD_BOUNDS(1));
        set(handles.PF_STOP_SLIDER,'Value',PLACE_FIELD_BOUNDS(2));
    else
        PLACE_FIELD_BOUNDS(2) = str2double(get(handles.PF_STOP_TEXT,'String'))/TOTAL_TRK_LEN;
        set(handles.PF_STOP_SLIDER,'Value',PLACE_FIELD_BOUNDS(2));
    end
    find_laps_in_clust(handles);
    plot_straightened_plus(handles);
    
%END function PF_STOP_TEXT_Callback(hObject, eventdata, handles)


function POS_V_TIME_LOCK_CHEC_Callback(hObject, eventdata, handles)
    plot_pos_v_time(handles);
%END function POS_V_TIME_LOCK_CHEC_Callback(hObject, eventdata, handles)

function NUM_OF_LAPS_TXT_Callback(hObject, eventdata, handles)
    global LAPS_IN_CLUST
    global ACTIVE_CLUST_NUM
    
    if(str2double(get(handles.NUM_OF_LAPS_TXT,'String')) < 16)
        LAPS_IN_CLUST(ACTIVE_CLUST_NUM) = str2double(get(handles.NUM_OF_LAPS_TXT,'String'));
        set(handles.NUM_OF_LAPS_SLIDER,'Value',LAPS_IN_CLUST(ACTIVE_CLUST_NUM));
    else
        set(handles.NUM_OF_LAPS_TXT,'String',num2str(LAPS_IN_CLUST(ACTIVE_CLUST_NUM)));
    end
    find_laps_in_clust(handles);
    plot_pos_v_time(handles);
%END function NUM_OF_LAPS_TXT_Callback(hObject, eventdata, handles)

function NUM_OF_LAPS_SLIDER_Callback(hObject, eventdata, handles)
    global LAPS_IN_CLUST
    global ACTIVE_CLUST_NUM
    
    set(handles.NUM_OF_LAPS_SLIDER,'Value',round(get(handles.NUM_OF_LAPS_SLIDER,'Value')));
    LAPS_IN_CLUST(ACTIVE_CLUST_NUM) = get(handles.NUM_OF_LAPS_SLIDER,'Value');
    set(handles.NUM_OF_LAPS_TXT,'String',num2str(LAPS_IN_CLUST(ACTIVE_CLUST_NUM)));
    
    find_laps_in_clust(handles);
    plot_pos_v_time(handles);
%END function NUM_OF_LAPS_SLIDER_Callback(hObject, eventdata, handles)

function SAVE_DATA_MENU_Callback(hObject, eventdata, handles)
    global ACTIVE_CLUST_NUM
%     global ROOT_DIR
    global NUM_OF_CLUSTS
    global TRACKS_RETRIEVED
    global ROTATED_CLUSTER              
    global ROTATED_TRACK_COORDS
%     global LAPS_IN_CLUST
    global LAP_DIVISIONS 
    global TOTAL_TRK_LEN
    global SN_CLUST_TOT_POS
    global CLUSTER_TIMESTAMPS
    global PLACE_FIELD_BOUNDS
    global CLUSTER_LENGTH
%     global CW
    global CLUSTER_NAMES
    global DATADIR
    
    clusts = (1:NUM_OF_CLUSTS);
    if (ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        clusts = ACTIVE_CLUST_NUM;
    end
    clusts_to_an = [];
    ctr = 1;
    for i=1:length(clusts)
        if(TRACKS_RETRIEVED(clusts(i)) == 1)
            clusts_to_an(ctr) = clusts(i);
            ctr = ctr + 1;
        end
    end
    
    for i = clusts_to_an
%         data_dir = horzcat(ROOT_DIR,'SleepData\TrackData');
        working_dir = pwd;
        cd(DATADIR);
        [filename, pathname] = uiputfile({'*.cpf',...
            'Cluster Place-Field File (*.cpf)'},sprintf('Save Cluster Place-Field File for %s',CLUSTER_NAMES{i}));

        cd(working_dir);
        output_file_name= fullfile(pathname, filename);
        
        OUTPUT_FILE = fopen(output_file_name,'w');
        
        fprintf(OUTPUT_FILE,'This is a cluster place-field file.  All values are in pixels.\nTrack Definition:\n');
        fprintf(OUTPUT_FILE,'Inner Edge X,Inner Edge Y,Middle of Track X,Middle of Track Y,Outside Edge X,Outside Edge Y\n');
        for j=1:4
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,1,1}(j));
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,1,2}(j));
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,2,1}(j));
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,2,2}(j));
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,3,1}(j));
            fprintf(OUTPUT_FILE,'%12.7f\n',ROTATED_TRACK_COORDS{i,3,2}(j));
        end
        fprintf(OUTPUT_FILE,'Place Field:\nStart (cm),Stop (cm),Total Track Length (cm)\n');
        fprintf(OUTPUT_FILE,'%12.7f,%12.7f,%12.7f\n',PLACE_FIELD_BOUNDS(1)*TOTAL_TRK_LEN,PLACE_FIELD_BOUNDS(2)*TOTAL_TRK_LEN,TOTAL_TRK_LEN)
        fprintf(OUTPUT_FILE,'Cluster Data:\n');
        fprintf(OUTPUT_FILE,'Timestamp,X,Y,Position on Track (cm), Lap #\n');
        ordered_divs = sort(LAP_DIVISIONS{i});
        for j=1:CLUSTER_LENGTH(i)
            if(SN_CLUST_TOT_POS{i}(j) < PLACE_FIELD_BOUNDS(1))
                continue;       % before place field... ignore
            elseif(SN_CLUST_TOT_POS{i}(j) > PLACE_FIELD_BOUNDS(2))
                continue;       % after place field... ignore
            end
            
            %find the lap number
            lap_numb = 1;
            while(CLUSTER_TIMESTAMPS{i}(j) > ordered_divs(lap_numb))
                lap_numb = lap_numb + 1;
                if(lap_numb > length(LAP_DIVISIONS{i}))
                    lap_numb = lap_numb - 1;    % make up for last false incriment
                    break;
                end
            end
            %lap_numb = lap_numb - 1;    % make up for last false incriment
            %fprintf(OUTPUT_FILE,'%d,%12.7f,%12.7f,%12.7f, %d\n',...
            %       CLUSTER_TIMESTAMPS{i}(j),ROTATED_CLUSTER{i,1}(j),ROTATED_CLUSTER{i,2}(j),SN_CLUST_TOT_POS{i}(j)*TOTAL_TRK_LEN,lap_numb);
            %VB 1/24/05
            fprintf(OUTPUT_FILE,'%-14.0f,%12.7f,%12.7f,%12.7f, %d\n',...
                    CLUSTER_TIMESTAMPS{i}(j),ROTATED_CLUSTER{i,1}(j),ROTATED_CLUSTER{i,2}(j),SN_CLUST_TOT_POS{i}(j)*TOTAL_TRK_LEN,lap_numb);
        end
        fclose(OUTPUT_FILE);
    end
    
    %kzkz
    
%END function SAVE_DATA_MENU_Callback(hObject, eventdata, handles)

function SAVE_TRACK_MENU_Callback(hObject, eventdata, handles)
    global ORIG_TRACK_COORDS
    global ACTIVE_CLUST_NUM
%     global ROOT_DIR
    global NUM_OF_CLUSTS
    global TRACKS_RETRIEVED
    global DATADIR  
    
    if((ACTIVE_CLUST_NUM > NUM_OF_CLUSTS) && (TRACKS_RETRIEVED(ACTIVE_CLUST_NUM) == 1))
        errordlg('Select a valid cluster.','Cluster Selection Error');
    else
%         data_dir = horzcat(ROOT_DIR,'SleepData\TrackData');
        working_dir = pwd;
        cd(DATADIR);
        [filename, pathname] = uiputfile({'*.trk',...
            'Track File (*.trk)'},'Save Track File');

        cd(working_dir);
        output_file_name= fullfile(pathname, filename);

        OUTPUT_FILE = fopen(output_file_name,'w');
        
        fprintf(OUTPUT_FILE,'This is a Track Definition file.  All values are in pixels.\n\n');
        fprintf(OUTPUT_FILE,'Inner Edge X,Inner Edge Y,Middle of Track X,Middle of Track Y,Outside Edge X,Outside Edge Y\n');
        for i=1:4
            fprintf(OUTPUT_FILE,'%d,',ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,1}(i));
            fprintf(OUTPUT_FILE,'%d,',ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,2}(i));
            fprintf(OUTPUT_FILE,'%d,',ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(i));
            fprintf(OUTPUT_FILE,'%d,',ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(i));
            fprintf(OUTPUT_FILE,'%d,',ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,1}(i));
            fprintf(OUTPUT_FILE,'%d\n',ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,2}(i));
        end
        fclose(OUTPUT_FILE);
            
    end

%END function SAVE_TRACK_MENU_Callback(hObject, eventdata, handles)





function LOAD_TRACK_MENU_Callback(hObject, eventdata, handles)
    global ORIG_TRACK_COORDS
    global ACTIVE_CLUST_NUM
%     global ROOT_DIR
    global NUM_OF_CLUSTS
    global TRACKS_RETRIEVED
    global DATADIR
    
    if(ACTIVE_CLUST_NUM > NUM_OF_CLUSTS)
        errordlg('Select a valid cluster.','Cluster Selection Error');
    else
        %data_dir = horzcat(ROOT_DIR,'SleepData\TrackData');
%         data_dir = DATADIR;
        working_dir = pwd;
        cd(DATADIR);
        [filename, pathname] = uigetfile({'*.trk',...
            'Track File (*.trk)'},'Load Track File');
        DATADIR = pathname;
        cd(working_dir);
        trk_file = fullfile(pathname, filename);
        corners = csvread(trk_file,3,0);
        
        ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,1} = corners(:,1)';
        ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,2} = corners(:,2)';
        ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1} = corners(:,3)';
        ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2} = corners(:,4)';
        ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,1} = corners(:,5)';
        ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,2} = corners(:,6)';
        
        CW(ACTIVE_CLUST_NUM) = 1;
        set(handles.CW_CHECK,'Enable','on');
        set(handles.CW_CHECK,'Value',CW(ACTIVE_CLUST_NUM));
        
        TRACKS_RETRIEVED(ACTIVE_CLUST_NUM) = 1;
        rotate_axis(handles);
        plot_orig_data(handles);
        
        
    end
%END function LOAD_TRACK_MENU_Callback(hObject, eventdata, handles)

function LOAD_PF_MENU_Callback(hObject, eventdata, handles)
    global PLACE_FIELD_BOUNDS
    global TOTAL_TRK_LEN
%     global ROOT_DIR
    global DATADIR
    
    %data_dir = horzcat(ROOT_DIR,'SleepData\TrackData');
%     data_dir = DATADIR;
    working_dir = pwd;
    cd(DATADIR);
    [filename, pathname] = uigetfile({'*.plf',...
         'Place-Field File (*.plf)'},'Load Place-Field File');
    DATADIR = pathname;
    cd(working_dir);
    plf_file = fullfile(pathname, filename);
    data = csvread(plf_file,3,0);
    PLACE_FIELD_BOUNDS(1) = data(1)/data(3);
    PLACE_FIELD_BOUNDS(2) = data(2)/data(3);
    
    
    set(handles.PF_START_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(1)));
    set(handles.PF_STOP_TEXT,'String',sprintf('%6.1f',TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(2)));
    set(handles.PF_START_SLIDER,'Value',PLACE_FIELD_BOUNDS(1));
    set(handles.PF_STOP_SLIDER,'Value',PLACE_FIELD_BOUNDS(2));
        
    find_laps_in_clust(handles);
    plot_orig_data(handles);
%END function LOAD_PF_MENU_Callback(hObject, eventdata, handles)

function SAVE_PF_MENU_Callback(hObject, eventdata, handles)
    global PLACE_FIELD_BOUNDS
    global TOTAL_TRK_LEN
%     global ROOT_DIR
    global DATADIR

    
%     data_dir = horzcat(ROOT_DIR,'SleepData\TrackData');
    working_dir = pwd;
    cd(DATADIR);
    [filename, pathname] = uiputfile({'*.plf',...
            'Place-Field File (*.plf)'},'Save Place-Field File');

    cd(working_dir);
    output_file_name= fullfile(pathname, filename);

    OUTPUT_FILE = fopen(output_file_name,'w');
        
    fprintf(OUTPUT_FILE,'This is a Place-Field Definition file.  All values are in cm.\n\n');
    fprintf(OUTPUT_FILE,'Start,Stop,Total Length of Track\n');
    fprintf(OUTPUT_FILE,'%8.4f,%8.4f,%8.4f\n',TOTAL_TRK_LEN*PLACE_FIELD_BOUNDS(1), TOTAL_TRK_LEN*PLACE_FIELD_BOUNDS(2), TOTAL_TRK_LEN);
    
    fclose(OUTPUT_FILE);
%END function SAVE_PF_MENU_Callback(hObject, eventdata, handles)

function CW_CHECK_Callback(hObject, eventdata, handles)
    global CW
    global ACTIVE_CLUST_NUM
    
    CW(ACTIVE_CLUST_NUM) = get(handles.CW_CHECK,'Value');
    rotate_axis(handles);
    plot_orig_data(handles);
    
%END function CW_CHECK_Callback(hObject, eventdata, handles)

function ClusterColorSelect_Callback(hObject, eventdata, handles)
    global CLUSTER_COLOR
    global ACTIVE_CLUST_NUM
    global NUM_OF_CLUSTS
    global CLUSTER_COLOR_INDEX
    
    clusterColors = {[0.0,0.3,0.0] [1 0 0]  [1 .44 .15] [.8 0 .6] [.5 .2 0] 'y' }; 
    CLUSTER_COLOR_INDEX(ACTIVE_CLUST_NUM) = get(handles.ClusterColorSelect,'Value');

    if(ACTIVE_CLUST_NUM > NUM_OF_CLUSTS)
        errordlg('Select a valid cluster.','Cluster Selection Error');
    else
        CLUSTER_COLOR{ACTIVE_CLUST_NUM} = clusterColors{get(handles.ClusterColorSelect,'Value')};
        
        plot_orig_data(handles);
        
        
    end
%
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%==========================================================================



function load_cluster_data(handles, clust_numb)
    global CLUSTER_POSITIONS            % CLUSTER_POSITIONS(cluster_#, x-y_pair_#, :) = [x y]
    global CLUSTER_TIMESTAMPS           % CLUSTER_TIMESTAMPS(cluster_#, x-y_pair_#) = timestamp
    global CLUSTER_LENGTH               % number of spikes in each cluster
    global VT_FILES
    global VT_NAMES
    global CLUSTER_FILES
    global CLUSTER_NAMES
    global TT_POSITIONS                 % TT_POSITIONS(cluster_#, x-y_pair_#, :) = [x y]
    global TT_TIMESTAMPS                % TT_TIMESTAMPS(cluster_#, x-y_pair_#) = timestamp
    global TT_LENGTH
%     global ROOT_DIR
    global LAP_DIVISIONS 
    global LAPS_IN_CLUST
    global TRACKS_RETRIEVED
    global ROTATED_TRACK_COORDS
    global CW
    global DATADIR
    global CLUSTER_TYPE
    global PLX_CLUSTER_INDX
    
    %my_array = csvread(CLUSTER_FILES{clust_numb},13,15);
    %timestamps = my_array(:,3);
    %CLUSTER_POSITIONS{clust_numb,1} = my_array(:,1);
    %CLUSTER_POSITIONS{clust_numb,2} = my_array(:,2);
    timestamps = [];
outputLinearVT = strfind(VT_FILES{clust_numb}, '.xls');
if isempty(outputLinearVT) % Use Track Position as normal.
    if(CLUSTER_TYPE(clust_numb))  % = 1 Plexon output file
        fprintf(1,'plexon file detected in load_cluster_data function\n')
%         plx_file = [];
        plx_file = csvread(CLUSTER_FILES{clust_numb});
        ctr = 1;
        for i=1:size(plx_file,1)
            if(plx_file(i,1) == PLX_CLUSTER_INDX(clust_numb))
                timestamps(ctr) = plx_file(i,2)*10^(6);
                %fprintf(1,'plx timestamps\n; %20f\n',timestamps(ctr));
                ctr = ctr + 1;
            end
        end
    else    % = 0 Winclust output file
       timestamps = csvread(CLUSTER_FILES{clust_numb},13,17);
    end
   %     VT_FILES{clust_numb};
    %fprintf('tstamps start: %18.9f, tstamp_stop: %18.9f\n',timestamps(1),timestamps(length(timestamps)));
    [tstamps xpos ypos] = Read_NVT_File(VT_FILES{clust_numb},timestamps(1),timestamps(length(timestamps)),1);

else % Linearize track position of CleanVT file.
    tstamps = xlsread(VT_FILES{clust_numb});
    xpos = tstamps(:,2);
    ypos = tstamps(:,3);
    tstamps = tstamps(:,1);
    timestamps = tstamps;
end
CLUSTER_LENGTH(clust_numb) = length(timestamps);
CLUSTER_TIMESTAMPS{clust_numb} = timestamps;

    while(abs(mean(xpos)) < 100)
        working_dir = pwd;
        %data_dir = horzcat(ROOT_DIR,'SleepData\Datafiles');
%         data_dir = DATADIR;
        cd(DATADIR);
        
        [nvt_file, nvt_path] = uigetfile({'*.Nvt',...
            'Neuralynx Video File (*.Nvt)'},sprintf('Select a different Video Position File for %s',CLUSTER_NAMES{clust_numb}));
        vt_file = fullfile(nvt_path, nvt_file);
        VT_FILES{clust_numb} = vt_file;
        VT_NAMES{clust_numb} = nvt_file;
        DATADIR = nvt_path;
        cd(working_dir);
        [tstamps xpos ypos] = Read_NVT_File(VT_FILES{clust_numb},timestamps(1),timestamps(length(timestamps)),1);
        
    end
    TT_POSITIONS{clust_numb,1} = xpos;
    TT_POSITIONS{clust_numb,2} = ypos;
    TT_TIMESTAMPS{clust_numb} = tstamps;
    
    TT_LENGTH(clust_numb) = length(xpos);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%    % linearly interpolate (0,0) VT data 
%    for i=1:TT_LENGTH(clust_numb)
%        if(TT_POSITIONS{clust_numb,1}(i) == 0 && TT_POSITIONS{clust_numb,2}(i) == 0)
%            TT_prev_ind = i-1;
%            TT_next_ind = i+1;
%            %while previous position is at (0,0) - find previous index
%            while((TT_prev_ind > 1) && (TT_POSITIONS{clust_numb,1}(TT_prev_ind) == 0) && (TT_POSITIONS{clust_numb,2}(TT_prev_ind) == 0))
%                TT_prev_ind = TT_prev_ind - 1;
%            end
%            
%            %while next position is at (0,0) - find next index
%            while((TT_next_ind < TT_LENGTH(clust_numb)) && (TT_POSITIONS{clust_numb,1}(TT_next_ind) == 0) && (TT_POSITIONS{clust_numb,2}(TT_next_ind) == 0))
%                TT_next_ind = TT_next_ind + 1;
%            end
%            
%            %if last point, use previous 2 points for interpolation
%            if(i == TT_LENGTH(clust_numb))
%                TT_next_ind = TT_prev_ind -1;
%            end
%            
%            %if first point, use next 2 points for interpolation
%            if(i == 1)
%                TT_prev_ind = TT_next_ind + 1;
%            end
%            
%            TT_ts_diff_tot = TT_TIMESTAMPS{clust_numb}(TT_next_ind) - TT_TIMESTAMPS{clust_numb}(TT_prev_ind);
%            for j=TT_prev_ind+1:TT_next_ind-1
%                TT_this_ts_diff = TT_TIMESTAMPS{clust_numb}(j) - TT_TIMESTAMPS{clust_numb}(TT_prev_ind);
%                frac_1 = TT_this_ts_diff/TT_ts_diff_tot;
%                frac_2 = 1 - frac_1;
%                TT_POSITIONS{clust_numb,1}(j) = frac_1 * TT_POSITIONS{clust_numb,1}(TT_next_ind) + frac_2 * TT_POSITIONS{clust_numb,1}(TT_prev_ind);
%                TT_POSITIONS{clust_numb,1}(j) = frac_1 * TT_POSITIONS{clust_numb,2}(TT_next_ind) + frac_2 * TT_POSITIONS{clust_numb,2}(TT_prev_ind);
%            end
%        end
%    end
%         
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% smooth out raw VT data replacing each point with a 15 pt average in a
%% moving window centered at the point%
%
%    for i=1:TT_LENGTH(clust_numb)
%        
%        sum_start = i - 7;
%        if (i <= 8)
%            sum_start = 1;
%        end
%        sum_end = i + 7;
%        if (sum_end > TT_LENGTH(clust_numb))
%            sum_end = TT_LENGTH(clust_numb);
%        end
%        
%        xsum = sum(TT_POSITIONS{clust_numb,1}(sum_start:sum_end));
%        ysum = sum(TT_POSITIONS{clust_numb,2}(sum_start:sum_end));
%        
%        %check for zero positions - although there shouldn't be any
%        zero_ctr = 0;
%        if ((~all(TT_POSITIONS{clust_numb,1}(sum_start:sum_end))) && (~all(TT_POSITIONS{clust_numb,2}(sum_start:sum_end))))
%            for j=sum_start:sum_end
%                if ((TT_POSITIONS{clust_numb,1}(j) == 0) && (TT_POSITIONS{clust_numb,2}(j) == 0))
%                    zero_ctr = zero_ctr + 1;
%                end
%            end
%        end
%        
%        num_in_avg = sum_end - sum_start + 1 - zero_ctr;
%        TT_POSITIONS{clust_numb,1}(i) = xsum/num_in_avg;
%        TT_POSITIONS{clust_numb,2}(i) = ysum/num_in_avg;
%        
%    end
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    tt_ctr = 1;
    prev_ind = 1;
    for i=1:length(timestamps)
        while (TT_TIMESTAMPS{clust_numb}(tt_ctr) < timestamps(i))
%             prev_ts = TT_TIMESTAMPS{clust_numb}(tt_ctr);
            tt_ctr = tt_ctr + 1;
        end
        % if timestamps are equal and position is not at (0,0)
        if((TT_TIMESTAMPS{clust_numb}(tt_ctr) == timestamps(i)) && ~((TT_POSITIONS{clust_numb,1}(prev_ind) == 0) && (TT_POSITIONS{clust_numb,2}(prev_ind) == 0)))
            CLUSTER_POSITIONS{clust_numb,1}(i) = TT_POSITIONS{clust_numb,1}(tt_ctr);
            CLUSTER_POSITIONS{clust_numb,2}(i) = TT_POSITIONS{clust_numb,2}(tt_ctr);
        else
            prev_ind = tt_ctr-1;
            next_ind = tt_ctr;
            %while previous position is at (0,0) - find previous index
            while((prev_ind > 1) && (TT_POSITIONS{clust_numb,1}(prev_ind) == 0) && (TT_POSITIONS{clust_numb,2}(prev_ind) == 0))
                prev_ind = prev_ind - 1;
            end
            
            %while next position is at (0,0) - find next index
            while((next_ind < length(tstamps)) && (TT_POSITIONS{clust_numb,1}(next_ind) == 0) && (TT_POSITIONS{clust_numb,2}(next_ind) == 0))
                next_ind = next_ind + 1;
            end
            
            ts_diff_tot = TT_TIMESTAMPS{clust_numb}(next_ind) - TT_TIMESTAMPS{clust_numb}(prev_ind);
            this_ts_diff = timestamps(i) - TT_TIMESTAMPS{clust_numb}(prev_ind);
            frac_1 = this_ts_diff/ts_diff_tot;
            frac_2 = 1 - frac_1;
            CLUSTER_POSITIONS{clust_numb,1}(i) = frac_1 * TT_POSITIONS{clust_numb,1}(next_ind) + frac_2 * TT_POSITIONS{clust_numb,1}(prev_ind);
            CLUSTER_POSITIONS{clust_numb,2}(i) = frac_1 * TT_POSITIONS{clust_numb,2}(next_ind) + frac_2 * TT_POSITIONS{clust_numb,2}(prev_ind);
            
            %if((CLUSTER_POSITIONS{clust_numb,1}(i) > 100) && (CLUSTER_POSITIONS{clust_numb,1}(i) < 200) && (CLUSTER_POSITIONS{clust_numb,2}(i) < 250) && (CLUSTER_POSITIONS{clust_numb,2}(i) > 200))
            %    fprintf('Possible error - prev_ts: %d | next_ts: %d | des_ts: %d\n',TT_TIMESTAMPS{clust_numb}(prev_ind),TT_TIMESTAMPS{clust_numb}(next_ind),timestamps(i));
            %    fprintf('               - prev_y:  %d | next_y:  %d | calc_y: %6.1f\n',TT_POSITIONS{clust_numb,2}(prev_ind),TT_POSITIONS{clust_numb,2}(next_ind),CLUSTER_POSITIONS{clust_numb,2}(i));
            %    fprintf('               - prev_x:  %d | next_x:  %d | calc_x: %6.1f\n',TT_POSITIONS{clust_numb,1}(prev_ind),TT_POSITIONS{clust_numb,1}(next_ind),CLUSTER_POSITIONS{clust_numb,1}(i));
            %end
            
        end
    end
    TRACKS_RETRIEVED(clust_numb) = 0;
    ROTATED_TRACK_COORDS{clust_numb,2,1} = 0;
    LAPS_IN_CLUST(clust_numb) = 1;
    LAP_DIVISIONS{clust_numb} = (tstamps(length(tstamps))+1);
    CW(clust_numb) = 1;
%     tstamps;
    
%END function load_cluster_data(handles, clust_numb)

function plot_orig_data(handles)
    global TT_POSITIONS
    global CLUSTER_POSITIONS
    global NUM_OF_CLUSTS
    global ACTIVE_CLUST_NUM
    global TRACKS_RETRIEVED
    global ORIG_TRACK_COORDS
%     global CLUSTER_LENGTH
    global CLUSTER_COLOR
    
    axes(handles.ALL_POSITIONS_AXIS);
    if(ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        plot(TT_POSITIONS{ACTIVE_CLUST_NUM,1}(:),-TT_POSITIONS{ACTIVE_CLUST_NUM,2}(:),'bx ');
        hold on;
        plot(CLUSTER_POSITIONS{ACTIVE_CLUST_NUM,1}(:),-CLUSTER_POSITIONS{ACTIVE_CLUST_NUM,2}(:),'x ','MarkerEdgeColor',CLUSTER_COLOR{ACTIVE_CLUST_NUM});
        if(TRACKS_RETRIEVED(ACTIVE_CLUST_NUM))
            plot([ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,1} ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,1}(1)],...
                 -[ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,2} ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,1,2}(1)],'k -');
            plot([ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1} ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(1)],...
                 -[ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2} ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(1)],'r -');
            plot([ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,1} ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,1}(1)],...
                 -[ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,2} ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,3,2}(1)],'k -');
        end
        hold off;
    else
        plot(1,1,'b -');
        hold on;
        for i=1:NUM_OF_CLUSTS
            plot(TT_POSITIONS{i,1}(:),-TT_POSITIONS{i,2}(:),'bx ');
        end
        for i=1:NUM_OF_CLUSTS
            %plot(CLUSTER_POSITIONS{i,1}(:),-CLUSTER_POSITIONS{i,2}(:),'x ','MarkerEdgeColor',[0.0,0.3,0.0]);
            plot(CLUSTER_POSITIONS{i,1}(:),-CLUSTER_POSITIONS{i,2}(:),'x ','MarkerEdgeColor',CLUSTER_COLOR{i});
        end
        for i=1:NUM_OF_CLUSTS
            if(TRACKS_RETRIEVED(i))
                plot([ORIG_TRACK_COORDS{i,1,1} ORIG_TRACK_COORDS{i,1,1}(1)],...
                     -[ORIG_TRACK_COORDS{i,1,2} ORIG_TRACK_COORDS{i,1,2}(1)],'k -');
                plot([ORIG_TRACK_COORDS{i,2,1} ORIG_TRACK_COORDS{i,2,1}(1)],...
                     -[ORIG_TRACK_COORDS{i,2,2} ORIG_TRACK_COORDS{i,2,2}(1)],'r -');
                plot([ORIG_TRACK_COORDS{i,3,1} ORIG_TRACK_COORDS{i,3,1}(1)],...
                     -[ORIG_TRACK_COORDS{i,3,2} ORIG_TRACK_COORDS{i,3,2}(1)],'k -');
            end
        end
        hold off;
    end
    set(handles.ALL_POSITIONS_AXIS,'DataAspectRatio',[1 1 1]);
    plot_rotated_plus(handles);
%END function plot_orig_data(handles)

function plot_rotated_plus(handles)
    global NUM_OF_CLUSTS
%     global ORIG_TRACK_COORDS
    global ACTIVE_CLUST_NUM
    global ROTATED_TRACK_COORDS
    global ROTATED_CLUSTER
%     global CW
    global CLUSTER_COLOR
    
    
    axes(handles.ROTATED_AXIS);
    plot(200,-150,'b -');
    hold on;
        
    clusts_to_an = (1:NUM_OF_CLUSTS);
    
    if (ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        clusts_to_an = ACTIVE_CLUST_NUM;
    end
    for i = clusts_to_an
        if~((ROTATED_TRACK_COORDS{i,2,1}) == 0)
            plot( [ROTATED_TRACK_COORDS{i,1,1} ROTATED_TRACK_COORDS{i,1,1}(1)],...
                 -[ROTATED_TRACK_COORDS{i,1,2} ROTATED_TRACK_COORDS{i,1,2}(1)],'k -');
            plot( [ROTATED_TRACK_COORDS{i,2,1} ROTATED_TRACK_COORDS{i,2,1}(1)],...
                 -[ROTATED_TRACK_COORDS{i,2,2} ROTATED_TRACK_COORDS{i,2,2}(1)],'r -');
            plot( [ROTATED_TRACK_COORDS{i,3,1} ROTATED_TRACK_COORDS{i,3,1}(1)],...
                 -[ROTATED_TRACK_COORDS{i,3,2} ROTATED_TRACK_COORDS{i,3,2}(1)],'k -');
            plot(ROTATED_CLUSTER{i,1},-ROTATED_CLUSTER{i,2},'x ','MarkerEdgeColor',CLUSTER_COLOR{i});
        end
    end
    hold off;
    set(handles.ROTATED_AXIS,'DataAspectRatio',[1 1 1]);
    plot_snapped_plus(handles);
    
%END function plot_rotated_plus(handles)


function plot_snapped_plus(handles)
    global NUM_OF_CLUSTS
%     global ORIG_TRACK_COORDS
    global ACTIVE_CLUST_NUM
    global ROTATED_TRACK_COORDS
%     global ROTATED_CLUSTER
%     global CW
    global SNAPPED_CLUSTER
    global CLUSTER_COLOR
    
    
    axes(handles.SNAPPED_POSITIONS_AXIS);
    plot(200,-150,'b -');
    hold on;
        
    clusts_to_an = (1:NUM_OF_CLUSTS);
    
    if (ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        clusts_to_an = ACTIVE_CLUST_NUM;
    end
    for i = clusts_to_an
        if~((ROTATED_TRACK_COORDS{i,2,1}) == 0)
            plot( [ROTATED_TRACK_COORDS{i,1,1} ROTATED_TRACK_COORDS{i,1,1}(1)],...
                 -[ROTATED_TRACK_COORDS{i,1,2} ROTATED_TRACK_COORDS{i,1,2}(1)],'k -');
            plot( [ROTATED_TRACK_COORDS{i,2,1} ROTATED_TRACK_COORDS{i,2,1}(1)],...
                 -[ROTATED_TRACK_COORDS{i,2,2} ROTATED_TRACK_COORDS{i,2,2}(1)],'r -');
            plot( [ROTATED_TRACK_COORDS{i,3,1} ROTATED_TRACK_COORDS{i,3,1}(1)],...
                 -[ROTATED_TRACK_COORDS{i,3,2} ROTATED_TRACK_COORDS{i,3,2}(1)],'k -');
            plot(SNAPPED_CLUSTER{i,1},-SNAPPED_CLUSTER{i,2},'x ','MarkerEdgeColor',CLUSTER_COLOR{i});
        end
    end
    hold off;
    set(handles.SNAPPED_POSITIONS_AXIS,'DataAspectRatio',[1 1 1]);
    plot_straightened_plus(handles);
%END function plot_snapped_plus(handles)


function update_cluster_menu(handles)
    global NUM_OF_CLUSTS
    global ACTIVE_CLUST_NUM
    global CLUSTER_NAMES
    global CW
    global VT_NAMES
    
    ca = {};
    for i=1:NUM_OF_CLUSTS
        ca{i} = CLUSTER_NAMES{i};
    end

    ca{NUM_OF_CLUSTS+1} = 'All Clusters';
    set(handles.ACTIVE_CLUSTER_MENU,'String',ca);
    set(handles.ACTIVE_CLUSTER_MENU,'Value',ACTIVE_CLUST_NUM);
    set(handles.CLUSTER_NVT_TEXT,'String',VT_NAMES{ACTIVE_CLUST_NUM});
    set(handles.CW_CHECK,'Value',CW(ACTIVE_CLUST_NUM));
    plot_orig_data(handles);
    

    
%END function plot_with_track(handles)


function rotate_axis(handles)
    global ACTIVE_CLUST_NUM
    global ORIG_TRACK_COORDS
    global ROTATED_TRACK_COORDS
    global ROTATED_CLUSTER
%     global CW
    global CLUSTER_POSITIONS
    global CLUSTER_LENGTH
    global TRK_LEN_PXLS
    
%     global LONG_LEN
    global TRK_LONG_LEN_PXLS
    global TRK_SHORT_LEN_PXLS
%     global TOTAL_TRK_LEN
    
    
    % find the index of the closest corner to the origin.
    min_val = 99999999999999;
    min_ind = 0;
    for i=1:4
        if(ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(i)^2 + ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(i)^2 < min_val)
            min_ind = i;
            min_val = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(i).^2+ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(i).^2;
        end
    end
    trk_ofst_ang = []; %#ok<NASGU>
    trk_anchor = []; %#ok<NASGU>
    if((min_ind == 1) || (min_ind == 3))
        trk_ofst_ang = atan( (ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(min_ind+1) - ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(min_ind)) /...
                             (ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(min_ind+1) - ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(min_ind)) );
        trk_anchor = min_ind;
    else
        trk_ofst_ang = atan( (ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(min_ind-1) - ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(min_ind)) /...
                             (ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(min_ind-1) - ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(min_ind)) );
        trk_anchor = min_ind-1;                
    end
    
    %rotate the track
    for i=1:4
        if (i == trk_anchor)
            ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(i) = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(i);
            ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(i) = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(i);
            for track = [1 3]
                zeroedX = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(i)-ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(trk_anchor);
                zeroedY = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(i)-ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(trk_anchor);
            
                [phase,mag] = cart2pol(zeroedX,zeroedY);
                phase = phase - trk_ofst_ang;
                [x,y] = pol2cart(phase,mag);
                ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(i) = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(trk_anchor) + x;
                ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(i) = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(trk_anchor) + y;
            end 
        else
            for track = [1 2 3]
                zeroedX = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(i)-ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(trk_anchor);
                zeroedY = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(i)-ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(trk_anchor);
            
                [phase,mag] = cart2pol(zeroedX,zeroedY);
                phase = phase - trk_ofst_ang;
                [x,y] = pol2cart(phase,mag);
                ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(i) = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(trk_anchor) + x;
                ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(i) = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(trk_anchor) + y;
            end
        end
    end
    %plot_rotated_plus(handles);
    
    % now... readjust track!!!  This needs to be done because the points
    % don't exactly straiten after the transformation (rounding error).
    horz_corn = 2;
    vert_corn = 4;
    diag_corn = 3;
    if(trk_anchor == 3)
        horz_corn = 4;
        vert_corn = 2;
        diag_corn = 1;
    end

    for track = 1:3
        %fprintf('\nlocked corner: (%4.1f, %4.1f)\n',ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(trk_anchor),ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(trk_anchor));
        %fprintf('Horizontal corner (pre): (%4.1f, %4.1f)\n',ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(horz_corn),ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(horz_corn));
        ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(horz_corn) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(trk_anchor);
        %fprintf('Horizontal corner (post): (%4.1f, %4.1f)\n',ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(horz_corn),ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(horz_corn));
        
        %fprintf('Vertical corner (pre): (%4.1f, %4.1f)\n',ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(vert_corn),ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(vert_corn));
        ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(vert_corn) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(trk_anchor);
        %fprintf('Vertical corner (post): (%4.1f, %4.1f)\n',ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(vert_corn),ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(vert_corn));
       
        %fprintf('Diag corner (pre): (%4.1f, %4.1f)\n',ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(diag_corn),ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(diag_corn));
        ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(diag_corn) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(vert_corn);
        ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(diag_corn) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(horz_corn);
        %fprintf('Diag corner (post): (%4.1f, %4.1f)\n',ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,1}(diag_corn),ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,track,2}(diag_corn));
    end
    
    for i=1:CLUSTER_LENGTH(ACTIVE_CLUST_NUM)
        
        zeroedX = CLUSTER_POSITIONS{ACTIVE_CLUST_NUM,1}(i)-ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(trk_anchor);
        zeroedY = CLUSTER_POSITIONS{ACTIVE_CLUST_NUM,2}(i)-ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(trk_anchor);
            
        [phase,mag] = cart2pol(zeroedX,zeroedY);
        phase = phase - trk_ofst_ang;      
        [x,y] = pol2cart(phase,mag);
        ROTATED_CLUSTER{ACTIVE_CLUST_NUM,1}(i) = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(trk_anchor) + x;
        ROTATED_CLUSTER{ACTIVE_CLUST_NUM,2}(i) = ORIG_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(trk_anchor) + y;
           
    end
    TRK_SHORT_LEN_PXLS(ACTIVE_CLUST_NUM) = abs(ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(3) - ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(2));
    TRK_LONG_LEN_PXLS(ACTIVE_CLUST_NUM) = abs(ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(2) - ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(1));
    TRK_LEN_PXLS(ACTIVE_CLUST_NUM) = 2*(TRK_SHORT_LEN_PXLS(ACTIVE_CLUST_NUM) + TRK_LONG_LEN_PXLS(ACTIVE_CLUST_NUM));
    
    
    
    snap_to_track(handles);           
    straighten_cluster(handles);         
                
    plot_rotated_plus(handles);
%END function rotate_axis(handles);


function snap_to_track(handles)
    global ACTIVE_CLUST_NUM snapTrack
    global ROTATED_TRACK_COORDS
    global ROTATED_CLUSTER
%     global CW
    global CLUSTER_LENGTH
    global SNAPPED_CLUSTER
    global SN_CLUST_POS_ON_ARM_PXLS
    global SN_ARM_IND
    global CLUSTER_TIMESTAMPS
    
    minX = [];
    maxX = [];
    minY = [];
    maxY = [];
    % find the min + max (x,y) for each leg of the track.
    for j=1:4
        next_ind = j+1;
        if(next_ind > 4)
            next_ind = 1;
        end
        if( ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(j) < ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(next_ind) )
            maxX(j) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(next_ind);
            minX(j) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(j);
        else
            minX(j) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(next_ind);
            maxX(j) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(j);
        end
        if( ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(j) < ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(next_ind) )
            maxY(j) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(next_ind);
            minY(j) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(j);
        else
            minY(j) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(next_ind);
            maxY(j) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(j);
        end
    end
    
    % find closest leg + snap
    modIndex = 1;
    for i=1:CLUSTER_LENGTH(ACTIVE_CLUST_NUM)
        
        deltaX = [];
        deltaY = [];
        total_dists = [];
        closestX = 0;
        closestY = 0;
        for j=1:4
            if( ( ROTATED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) > minX(j) ) && ( ROTATED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) < maxX(j) ) )
                % within x-range for leg - x distance = 0
                deltaX(j) = 0;
            else
                % find closer x corner, assign the x difference to be the x
                % distance.
                [deltaX(j),theind] = min([abs(maxX(j) - ROTATED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex)), abs(minX(j) - ROTATED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex))]);
                if(theind == 1)
                    closestX = maxX(j);
                else
                    closestX = minX(j);
                end
            end
            if( ( ROTATED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) > minY(j) ) && ( ROTATED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) < maxY(j) ) )
                % within y-range for leg - y distance = 0
                deltaY(j) = 0;
            else
                % find closer y corner, assign the y difference to be the y
                % distance.
                [deltaY(j),theind] = min([abs(maxY(j) - ROTATED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex)), abs(minY(j) - ROTATED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex))]);
                if(theind == 1)
                    closestY = maxY(j);
                else
                    closestY = minY(j);
                end
            end
            dist = (deltaX(j)) + (deltaY(j));
            total_dists(modIndex,j) = dist;
        end
        [~,min_ind] = min(total_dists(modIndex,:));
%**************************************************************************
        % Determine if the data point is too far off of the maze.
        if deltaX(min_ind) > snapTrack || deltaY(min_ind) > snapTrack %Change pixel value to improve what data snaps to the track.
            ROTATED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) = [];
            ROTATED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) = [];
            CLUSTER_TIMESTAMPS{ACTIVE_CLUST_NUM}(modIndex) = [];
%**************************************************************************
        else
        % min_ind is now the probable arm of the track.  If either deltaX
        % or deltaY is zero, just snap the other value to the track.
            switch min_ind
                case 1      % arm 1 - horizontal - y val same as y of corner 1 & 2
                    SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(1);
                    if(deltaX(min_ind) == 0)
                        SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) = ROTATED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex);
                    else
                        SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) = closestX; %???Always ends up being side 4 values.
                    end
                    SN_CLUST_POS_ON_ARM_PXLS{ACTIVE_CLUST_NUM}(modIndex) = abs((SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) - ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(1)));


                case 2      % arm 2 - vertical - x val same as x of corner 2 & 3
                    SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(2);
                    if(deltaY(min_ind) == 0)
                        SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) = ROTATED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex);
                    else
                        SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) = closestY;
                    end
                    SN_CLUST_POS_ON_ARM_PXLS{ACTIVE_CLUST_NUM}(modIndex) = abs( (SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) - ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(2)));

                case 3      % arm 3 - horizontal - y val same as y of corner 3 & 4
                    SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(3);
                    if(deltaX(min_ind) == 0)
                        SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) = ROTATED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex);
                    else
                        SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) = closestX;
                    end
                    SN_CLUST_POS_ON_ARM_PXLS{ACTIVE_CLUST_NUM}(modIndex) = abs( (SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) - ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(3)));

                case 4      % arm 4 - vertical - x val same as x of corner 4 & 1
                    SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,1}(modIndex) = ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,1}(4);
                    if(deltaY(min_ind) == 0)
                        SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) = ROTATED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex);
                    else
                        SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) = closestY;
                    end
                    SN_CLUST_POS_ON_ARM_PXLS{ACTIVE_CLUST_NUM}(modIndex) = abs( (SNAPPED_CLUSTER{ACTIVE_CLUST_NUM,2}(modIndex) - ROTATED_TRACK_COORDS{ACTIVE_CLUST_NUM,2,2}(4)));
            end
        SN_ARM_IND{ACTIVE_CLUST_NUM}(modIndex) = min_ind;
        modIndex = modIndex + 1;
        end
    end
    CLUSTER_LENGTH(ACTIVE_CLUST_NUM) = length(SN_ARM_IND{ACTIVE_CLUST_NUM});
%END function snap_to_track(handles

function straighten_cluster(handles)
    global ACTIVE_CLUST_NUM
%     global CW
    global CLUSTER_LENGTH   
    global SN_CLUST_POS_ON_ARM_PXLS
    global SN_ARM_IND
%     global SIDE_LEN
    
    global SN_CLUST_TOT_POS
%     global TOTAL_TRK_LEN
    global TRK_LONG_LEN_PXLS
    global TRK_SHORT_LEN_PXLS
    global TRK_LEN_PXLS
    
    for i=1:CLUSTER_LENGTH(ACTIVE_CLUST_NUM)
        switch SN_ARM_IND{ACTIVE_CLUST_NUM}(i)
            case 1
                tot_num_of_pxls = SN_CLUST_POS_ON_ARM_PXLS{ACTIVE_CLUST_NUM}(i);
            case 2
                tot_num_of_pxls = SN_CLUST_POS_ON_ARM_PXLS{ACTIVE_CLUST_NUM}(i) + TRK_LONG_LEN_PXLS(ACTIVE_CLUST_NUM);
            case 3
                tot_num_of_pxls = SN_CLUST_POS_ON_ARM_PXLS{ACTIVE_CLUST_NUM}(i) + TRK_LONG_LEN_PXLS(ACTIVE_CLUST_NUM)...
                                  + TRK_SHORT_LEN_PXLS(ACTIVE_CLUST_NUM);
            case 4
                tot_num_of_pxls = SN_CLUST_POS_ON_ARM_PXLS{ACTIVE_CLUST_NUM}(i) + 2* TRK_LONG_LEN_PXLS(ACTIVE_CLUST_NUM)...
                                  + TRK_SHORT_LEN_PXLS(ACTIVE_CLUST_NUM);
        end
        
        SN_CLUST_TOT_POS{ACTIVE_CLUST_NUM}(i) = tot_num_of_pxls/TRK_LEN_PXLS(ACTIVE_CLUST_NUM);
        %fprintf('Arm: %d\t|\tPxls: %4.1f\t|\tPercent: %4.1f\n',SN_ARM_IND{ACTIVE_CLUST_NUM}(i),tot_num_of_pxls,100*SN_CLUST_TOT_POS{ACTIVE_CLUST_NUM}(i));
        
    end
    
    %SN_CLUST_TOT_POS{ACTIVE_CLUST_NUM};
   
%END function straighten_cluster(handles)

function plot_straightened_plus(handles)
    global ACTIVE_CLUST_NUM
    global CW
    global CLUSTER_LENGTH   
    global SN_CLUST_TOT_POS
%     global TRK_LEN_PXLS
%     global LONG_LEN
%     global SHORT_LEN
    global ROTATED_TRACK_COORDS
    global SIDE_LEN
    global NUM_OF_CLUSTS
%     global TRK_LONG_LEN_PXLS
%     global TRK_SHORT_LEN_PXLS
    global PLACE_FIELD_BOUNDS
    global TOTAL_TRK_LEN
    global TRACKS_RETRIEVED
    global CLUSTER_COLOR
    
    axes(handles.ROLLED_OUT_POSITIONS_AXIS);
    plot(0,0,'b -');
    hold on;
    
    clusts = (1:NUM_OF_CLUSTS);
    if (ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        clusts = ACTIVE_CLUST_NUM;
    end
    clusts_to_an = [];
    ctr = 1;
    for i=1:length(clusts)
        if(TRACKS_RETRIEVED(clusts(i)) == 1)
            clusts_to_an(ctr) = clusts(i);
            ctr = ctr + 1;
        end
    end
    themax = 1;
    
    for i = clusts_to_an
        if(length(ROTATED_TRACK_COORDS{i,2,1}) > 2)
            %fprintf('PLOT\n');
%             track_corns = [0 ...
%                           TRK_LONG_LEN_PXLS(i) ...
%                           (TRK_LONG_LEN_PXLS(i)+TRK_SHORT_LEN_PXLS(i)) ...
%                           (2*TRK_LONG_LEN_PXLS(i)+TRK_SHORT_LEN_PXLS(i)) ...
%                           (2*TRK_LONG_LEN_PXLS(i)+2*TRK_SHORT_LEN_PXLS(i)) ];
            if(CW(i))
                %plot(track_corns,[i i i i i],'rs-');
                %plot(TRK_LEN_PXLS(i) * SN_CLUST_TOT_POS{i}, i * ones(1,CLUSTER_LENGTH(i)),'x ','MarkerEdgeColor',[0.0,0.3,0.0]);
                plot([0 SIDE_LEN],[i i i i i],'rs-');
                %size(SN_CLUST_TOT_POS{i})
                %size(ones(1,CLUSTER_LENGTH(i)))
                plot((TOTAL_TRK_LEN * SN_CLUST_TOT_POS{i}(1:CLUSTER_LENGTH(i))), i * ones(1,CLUSTER_LENGTH(i)),'x ','MarkerEdgeColor',CLUSTER_COLOR{i});
            else
                plot(TOTAL_TRK_LEN - [0 SIDE_LEN],[i i i i i],'rs-');
                plot(TOTAL_TRK_LEN - (TOTAL_TRK_LEN * (SN_CLUST_TOT_POS{i}(1:CLUSTER_LENGTH(i)))), i * ones(1,CLUSTER_LENGTH(i)),'x ','MarkerEdgeColor',CLUSTER_COLOR{i});
            end
        end
        themax = i;
    end
    if(isempty(clusts_to_an))
        
    else
        if(get(handles.STRAIGHTENED_LOCK_CHECK,'Value') == 1)
            xlim(TOTAL_TRK_LEN*[PLACE_FIELD_BOUNDS(1) PLACE_FIELD_BOUNDS(2)]);
        else
            xlim([0 TOTAL_TRK_LEN]);
        end
        ylim([(clusts_to_an(1)-1) (clusts_to_an(length(clusts_to_an))+1)]);
    
    
        plot(TOTAL_TRK_LEN*[PLACE_FIELD_BOUNDS(1) PLACE_FIELD_BOUNDS(1)],[clusts_to_an(1)-1 themax+1],'go-','MarkerFaceColor',[0 1 0]);
        plot(TOTAL_TRK_LEN*[PLACE_FIELD_BOUNDS(2) PLACE_FIELD_BOUNDS(2)],[clusts_to_an(1)-1 themax+1],'ro-','MarkerFaceColor',[1 0 0]);
    end
    hold off;
    plot_pos_v_time(handles);
%END function plot_straightened_plus(handles)

function plot_pos_v_time(handles)
%     global LAPS_IN_CLUST
    global LAP_DIVISIONS 
    global ACTIVE_CLUST_NUM
    global NUM_OF_CLUSTS
    global TOTAL_TRK_LEN
    global SN_CLUST_TOT_POS
    global CLUSTER_TIMESTAMPS
    global PLACE_FIELD_BOUNDS
    global CLUSTER_LENGTH
    global CW
    global TRACKS_RETRIEVED
    global CLUSTER_COLOR
    
    axes(handles.POS_VS_TIME_AXIS);
    plot(0,0,'b -');
    hold on;
    
  %  plot(1:length(CLUSTER_TIMESTAMPS{ACTIVE_CLUST_NUM}),CLUSTER_TIMESTAMPS{ACTIVE_CLUST_NUM},'b -');
  %  xlim([1080 1120]);
  %  ylim((10^8)*[7.6 7.8]);
    
    clusts = (1:NUM_OF_CLUSTS);
    if (ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        clusts = ACTIVE_CLUST_NUM;
    end
    clusts_to_an = [];
    ctr = 1;
    for i=1:length(clusts)
        if(TRACKS_RETRIEVED(clusts(i)) == 1)
            clusts_to_an(ctr) = clusts(i);
            ctr = ctr + 1;
        end
    end
    
    
    thexmin = 99999999999999;
    thexmax = 0;
    for i = clusts_to_an
        if(TRACKS_RETRIEVED(i) == 1)
            
            if( min(CLUSTER_TIMESTAMPS{i}) < thexmin)
                thexmin = min(CLUSTER_TIMESTAMPS{i});
            end
            if( max(CLUSTER_TIMESTAMPS{i}) > thexmax)
                thexmax = max(CLUSTER_TIMESTAMPS{i});
            end
            if(CW(i))
                plot(CLUSTER_TIMESTAMPS{i}/1000000, TOTAL_TRK_LEN * SN_CLUST_TOT_POS{i}(1:CLUSTER_LENGTH(i)), 'x ','MarkerEdgeColor',CLUSTER_COLOR{i});
            else
                plot(CLUSTER_TIMESTAMPS{i}/1000000, TOTAL_TRK_LEN- (TOTAL_TRK_LEN * SN_CLUST_TOT_POS{i}(1:CLUSTER_LENGTH(i))), 'x ','MarkerEdgeColor',CLUSTER_COLOR{i});
            end
            for j=1:length(LAP_DIVISIONS{i})
                
                plot([LAP_DIVISIONS{i}(j) LAP_DIVISIONS{i}(j)]/1000000, TOTAL_TRK_LEN * [PLACE_FIELD_BOUNDS(1) PLACE_FIELD_BOUNDS(2)], 'ko-');
                %plot(LAP_DIVISIONS{i}(j),TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(1),'go ','MarkerFaceColor',[0 1 0]);
                %plot(LAP_DIVISIONS{i}(j),TOTAL_TRK_LEN * PLACE_FIELD_BOUNDS(2),'ro ','MarkerFaceColor',[1 0 0]);
            end
            xlim([thexmin thexmax]/1000000);
        end
    end
    if(get(handles.POS_V_TIME_LOCK_CHEC,'Value') == 1)
        ylim(TOTAL_TRK_LEN * [PLACE_FIELD_BOUNDS(1) PLACE_FIELD_BOUNDS(2)]);
    end
    
    hold off;
%END function plot_pos_v_time(handles)


function find_laps_in_clust(handles)
%     global ACTIVE_CLUST_NUM
%     global CW
    global CLUSTER_LENGTH   
    global CLUSTER_TIMESTAMPS
    global SN_CLUST_TOT_POS
%     global TRK_LEN_PXLS
%     global LONG_LEN
%     global SHORT_LEN
%     global ROTATED_TRACK_COORDS
%     global SIDE_LEN
    global NUM_OF_CLUSTS
%     global TRK_LONG_LEN_PXLS
%     global TRK_SHORT_LEN_PXLS
    global PLACE_FIELD_BOUNDS
%     global TOTAL_TRK_LEN
    global LAPS_IN_CLUST
    global LAP_DIVISIONS 
    global TRACKS_RETRIEVED
    
    
    clusts = (1:NUM_OF_CLUSTS);
    
    clusts_to_an = [];
    ctr = 1;
    for i=1:length(clusts)
        if(TRACKS_RETRIEVED(clusts(i)) == 1)
            clusts_to_an(ctr) = clusts(i); %#ok<*AGROW>
            ctr = ctr + 1;
        end
    end
        
    
    for i = clusts_to_an
        interest_ctr = 1;
        prev_ts = 0;
%         time_diff = 0;
        time_diff_array = [];
        the_max = 0;
%         the_bound = 0;
        % find the timestamp difference between 2 points that fall within
        % the place field.
        for j=1:CLUSTER_LENGTH(i)
            if((SN_CLUST_TOT_POS{i}(j) < PLACE_FIELD_BOUNDS(1)) && (j < CLUSTER_LENGTH(i)))
                continue;       % before place field... ignore
            elseif((SN_CLUST_TOT_POS{i}(j) > PLACE_FIELD_BOUNDS(2)) && (j < CLUSTER_LENGTH(i)))
                continue;       % after place field... ignore
            end
            if(interest_ctr == 1)
                time_diff = 0;
                the_bound = 0;
            elseif(j == CLUSTER_LENGTH(i))
                time_diff = the_max + 1;
                the_bound = CLUSTER_TIMESTAMPS{i}(j) + 1;
            else
                time_diff = CLUSTER_TIMESTAMPS{i}(j) - prev_ts;
                the_bound = CLUSTER_TIMESTAMPS{i}(j) - (time_diff/2);
                if(time_diff > the_max)
                    the_max = time_diff;
                end
            end
            time_diff_array(interest_ctr,1) = time_diff;
            time_diff_array(interest_ctr,2) = the_bound;
            prev_ts = CLUSTER_TIMESTAMPS{i}(j);
            interest_ctr = interest_ctr + 1;
        end
        sorted_time_diff_array = sortrows(time_diff_array,[1 2]);
        LAP_DIVISIONS{i} = [];
        for j=1:LAPS_IN_CLUST(i)
            if(size(sorted_time_diff_array,1) >= j)
                LAP_DIVISIONS{i}(j) = sorted_time_diff_array(size(sorted_time_diff_array,1)-j+1,2);
            else
                LAP_DIVISIONS{i}(j) = sorted_time_diff_array(1,2);
            end
        end
    end
    
    
%END function find_laps_in_clust(handles)



% --------------------------------------------------------------------
function SAVE_CLUSTER_POSITIONS_MENU_Callback(hObject, eventdata, handles)
% hObject    handle to SAVE_CLUSTER_POSITIONS_MENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ACTIVE_CLUST_NUM
%     global ROOT_DIR
    global NUM_OF_CLUSTS
    global TRACKS_RETRIEVED
    global ROTATED_CLUSTER              
    global ROTATED_TRACK_COORDS
    global TOTAL_TRK_LEN
    global SN_CLUST_TOT_POS
    global CLUSTER_TIMESTAMPS
    global CLUSTER_LENGTH
%     global CW
    global CLUSTER_NAMES
    global DATADIR
    global CLUSTER_POSITIONS
    
    clusts = (1:NUM_OF_CLUSTS);
    if (ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        clusts = ACTIVE_CLUST_NUM;
    end
    clusts_to_an = [];
    ctr = 1;
    for i=1:length(clusts)
        if(TRACKS_RETRIEVED(clusts(i)) == 1)
            clusts_to_an(ctr) = clusts(i);
            ctr = ctr + 1;
        end
    end
    
    for i = clusts_to_an
%         data_dir = horzcat(ROOT_DIR,'SleepData\TrackData');
        working_dir = pwd;
        cd(DATADIR);
        [filename, pathname] = uiputfile({'*.csv',...
            'Cluster Positions File (*.csv)'},sprintf('Save Cluster Positions File for %s',CLUSTER_NAMES{i}));

        cd(working_dir);
        output_file_name= fullfile(pathname, filename);
        
        OUTPUT_FILE = fopen(output_file_name,'w');
        
        fprintf(OUTPUT_FILE,'This is a cluster positions file.  All values are in pixels.\nTrack Definition:\n');
        fprintf(OUTPUT_FILE,'Inner Edge X,Inner Edge Y,Middle of Track X,Middle of Track Y,Outside Edge X,Outside Edge Y\n');
        for j=1:4
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,1,1}(j));
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,1,2}(j));
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,2,1}(j));
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,2,2}(j));
            fprintf(OUTPUT_FILE,'%12.7f,',ROTATED_TRACK_COORDS{i,3,1}(j));
            fprintf(OUTPUT_FILE,'%12.7f\n',ROTATED_TRACK_COORDS{i,3,2}(j));
        end
        fprintf(OUTPUT_FILE,'Total Track Length (cm)\n');
        fprintf(OUTPUT_FILE,'%12.7f\n',TOTAL_TRK_LEN)
        fprintf(OUTPUT_FILE,'Cluster Data:\n');
        fprintf(OUTPUT_FILE,'Timestamp, Raw X, Raw Y, Rotated X, Rotated Y, Position on Straightened Track (cm)\n');
        for j=1:CLUSTER_LENGTH(i)
              fprintf(OUTPUT_FILE,'%-14.0f,%12.7f,%12.7f,%12.7f,%12.7f,%12.7f\n',...
                    CLUSTER_TIMESTAMPS{i}(j),CLUSTER_POSITIONS{i,1}(j),CLUSTER_POSITIONS{i,2}(j),...
                    ROTATED_CLUSTER{i,1}(j),ROTATED_CLUSTER{i,2}(j),SN_CLUST_TOT_POS{i}(j)*TOTAL_TRK_LEN);
        end
        fclose(OUTPUT_FILE);
    end
        
%END function SAVE_CLUSTER_POSITIONS_MENU_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function SAVE_VTFILE_DATA_MENU_Callback(hObject, eventdata, handles)
% hObject    handle to SAVE_VTFILE_DATA_MENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ACTIVE_CLUST_NUM
%     global ROOT_DIR
    global NUM_OF_CLUSTS
 %   global TRACKS_RETRIEVED
 %   global ROTATED_CLUSTER              
 %   global ROTATED_TRACK_COORDS
 %   global TOTAL_TRK_LEN
 %   global SN_CLUST_TOT_POS
    global TT_TIMESTAMPS
    global TT_LENGTH
 %   global CW
    global CLUSTER_NAMES
    global DATADIR
    global TT_POSITIONS
    
%    clusts = (1:NUM_OF_CLUSTS);
 if (ACTIVE_CLUST_NUM <= NUM_OF_CLUSTS)
        clusts = ACTIVE_CLUST_NUM;
        %   end
 %   clusts_to_an = [];
 %   ctr = 1;
 %   for i=1:length(clusts)
 %       if(TRACKS_RETRIEVED(clusts(i)) == 1)
 %           clusts_to_an(ctr) = clusts(i);
 %           ctr = ctr + 1;
 %       end
 %    end
    
    for i = clusts
%         data_dir = horzcat(ROOT_DIR,'SleepData\TrackData');
        working_dir = pwd;
        cd(DATADIR);
        [filename, pathname] = uiputfile({'*.csv',...
            'Video Data File (*.csv)'},sprintf('Save Video Data File for %s',CLUSTER_NAMES{i}));

        cd(working_dir);
        output_file_name= fullfile(pathname, filename);
        
        OUTPUT_FILE = fopen(output_file_name,'w');
        
        fprintf(OUTPUT_FILE,'This is a video data file.  All values are in pixels.\n');
        fprintf(OUTPUT_FILE,'Video Data:\n');
        fprintf(OUTPUT_FILE,'Timestamp, Raw X, Raw Y\n');
        for j=1:TT_LENGTH(i)
              fprintf(OUTPUT_FILE,'%-14.0f,%12.7f,%12.7f\n',...
                    TT_TIMESTAMPS{i}(j),TT_POSITIONS{i,1}(j),TT_POSITIONS{i,2}(j));
        end
        fclose(OUTPUT_FILE);
    end
else
    fprintf(1,'!!!!! ERROR in Save Video Data !!!!!\n Individual Cluster must be selected\n')
end
        
%END function SAVE_VTFILE_DATA_MENU_Callback(hObject, eventdata, handles)





function snapTrackCutOff_Callback(hObject, eventdata, handles)
global snapTrack
snapTrack = str2double(get(hObject,'String'));   % returns contents of EEG_cutoff as a double
if isnan(snapTrack)
    set(hObject, 'String', 500);
    errordlg('Input must be a number','Error');
end
if snapTrack < 0
    set(hObject, 'String', 500);
    errordlg('Input must be a positive number','Error');
end


% --- Executes during object creation, after setting all properties.
function snapTrackCutOff_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
