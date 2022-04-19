% Create a timeline object to be saved in hardware.mat
% Configured for POPPY-TIMELINE (based on LILRIG-TIMELINE)

myComputerName = 'yourNameHere'; % (eg 'POPPY-TIMELINE')
% Instantiate the timeline object
timeline = hw.Timeline;

% Set sample rate
timeline.DaqSampleRate = 1000;

% Set up function for configuring inputs
daq_input = @(name, channelID, measurement, terminalConfig) ...
    struct('name', name,...
    'arrayColumn', -1,... % -1 is default indicating unused
    'daqChannelID', channelID,...
    'measurement', measurement,...
    'terminalConfig', terminalConfig, ...
    'axesScale', 1);

% Configure inputs
timeline.Inputs = [...
    daq_input('chrono', 'ai0', 'Voltage', 'SingleEnded')... % for reading back self timing wave
    daq_input('camSync', 'ai3', 'Voltage', 'SingleEnded')... % when IR light goes up/down 
    daq_input('rewardEcho', 'ai4', 'Voltage', 'SingleEnded')... % valve 
    daq_input('eyeCamStrobe', 'ai5', 'Voltage', 'SingleEnded')... % camera 
    daq_input('faceCamStrobe', 'ai7', 'Voltage', 'SingleEnded')... % camera 
    daq_input('acqLive', 'ai9', 'Voltage', 'SingleEnded'), ... % signals start/stop experiment
    daq_input('flipper', 'ai11', 'Voltage', 'SingleEnded'), ... % flipper (up/down generated by Poisson distribution on arduino) 
    daq_input('photoDiode', 'ai12', 'Voltage', 'SingleEnded'), ... % photodiode
    daq_input('rotaryEncoder','ctr0','Position',[]) % rotary encoder, go to NI Max > Devices > Pin outs to get read out of where 
    % CTR SCR (counts inputs ('source') )and CTR AUX (tells you whether SCR input is up/down i.e. left/right) are on your board 
    ];

% removed, don't have audio at poppy rig currently:  daq_input('audioOut', 'ai8', 'Voltage', 'SingleEnded'), ...
% removed, these are all widefield-elated: 
%   daq_input('blueLEDmonitor', 'ai6', 'Voltage', 'SingleEnded')...
%   daq_input('purpleLEDmonitor', 'ai13', 'Voltage', 'SingleEnded')...
%   daq_input('pcoExposure', 'ai2', 'Voltage', 'SingleEnded')...
%   daq_input('tlExposeClock', 'ai1', 'Voltage', 'SingleEnded'), ...
%   daq_input('stimScreen','ai10','Voltage', 'SingleEnded'),...

% Activate all defined inputs
timeline.UseInputs = {timeline.Inputs.name};

% Configure outputs (each output is a specialized object)

% (chrono - required timeline self-referential clock)
chronoOutput = hw.TLOutputChrono;
chronoOutput.DaqChannelID = 'port0/line0'; % this is digital output pin PO0 on the bnc breakout box 
% we route this to user2 and then can pull a bnc cable to input (record) chrono in timeline 

% (acq live output - for external triggering)
acqLiveOutput = hw.TLOutputAcqLive;
acqLiveOutput.Name = 'acqLive'; % rename for legacy compatability
acqLiveOutput.DaqChannelID = 'port0/line1'; % this is digital output pin PO1 on the bnc breakout box. 
% we route this to user1 and then can pull a bnc cable to input (record) acq live in timeline 

% (output to synchronize face camera)
camSyncOutput = hw.TLOutputCamSync;
camSyncOutput.Name = 'camSync'; % rename for legacy compatability
camSyncOutput.DaqChannelID = 'port0/line2'; % this is digital output pin PO2 on the bnc breakout box -> powers IR light. 
% When exp starts/stops, turns IR light off after 0.5 s for 0.2 s to be
% able to align the cameras 
camSyncOutput.PulseDuration = 0.2;
camSyncOutput.InitialDelay = 0.5;

% widefield related stuff:  % (ramp illumination + camera exposure)
% rampIlluminationOutput = hw.TLOutputRampIllumination;
% rampIlluminationOutput.DaqDeviceID = timeline.DaqIds;
% rampIlluminationOutput.exposureOutputChannelID =  'ao0';
% rampIlluminationOutput.lightOutputChannelID = 'ao1';
% rampIlluminationOutput.triggerChannelID = 'Dev1/PFI1';
% rampIlluminationOutput.framerate = 70;
% rampIlluminationOutput.lightExposeTime = 6.5;
% rampIlluminationOutput.lightRampTime = 1;

% Package the outputs (VERY IMPORTANT: acq triggers illum, so illum must be
% set up BEFORE starting acqLive output)
timeline.Outputs = [chronoOutput,acqLiveOutput,camSyncOutput];

% Configure live "oscilliscope"
timeline.LivePlot = true;

% Clear out all temporary variables
clearvars -except timeline

% save to "hardware" file
save(fullfile('\\zserver.cortexlab.net\Code\Rigging\config\', myComputerName, '\hardware.mat'))
disp(['Saved'  myComputerName ' config file'])






