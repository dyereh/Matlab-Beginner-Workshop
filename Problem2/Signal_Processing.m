% Read in the signal here

%signal = read audio ()

L = length(signal);         % Number of samples in the signal.
T = 1/Fs                    % Sampling period in seconds
t = (0:L-1)*T;              % Time vector in seconds

%% Speech with echo

% Now try and produce a new sound byte which is the old sound byte with a
% delay (hint try using loops to add a shifted version of the audio to
% itself

% Save the audio using audiowrite

% This will save it to the current directory - try playing it (maybe use
% headphones if you have any)

%% Speech with echo using convolution

% Create an impulse response (aka a vector that is mostly zeros but has a
% couple of 1's. The 1's should be separated by at least 500 zeros for
% there to be adequate delay for you to hear

% After making this vector, use the convolve function, conv, to convolve
% the original signal with this impulse response vector. Write the results
% out using audio write

%% Convolution with hall

% Read in the hall wav file. Convolve the original audio with this vector
% and output the result. This one should be the most interesting

%% Low pass filter

% Challenge - see if you can pass the signal through a low pass filter and
% output the result