%% Session 9 - Fourier transform
% Today, we'll talk about everything that is absolutely necessary to
% understand what the Fourier transform does. There is a lot more to come.
% Next time.
% 04/07/2016

%% 0 Init

clear all
close all
clc 
format short
format compact
fs = 1000; %Sampling frequency in Hz - number of times we sample our dependent variable, per second
dur = 10; %Signal persists for dur seconds
t = 0:1/fs:dur; %Make a timebase. You always want to go from 0 to duration, in steps of sampling frequency
%You could totally use linspace for this
n = length(t); %Count the total number of samples
%We could throw in amplitude and frequency, but I just want to show what it
%looks like for now
A = 10; 
freq = 2; 

%% 1 Understand that a fourier transform amounts to an integration of complex sine waves
% What does a complex sine wave look like? Let's find out. 

figure
csw = A.* exp(i*2*pi*freq*t);
plot3(t,real(csw),imag(csw)) %3d plot of real vs. imaginary parts of the sine wave over time
xlabel('time')
ylabel('real part')
zlabel('imaginary part')
rotate3d

%% 2 Sounds - as good a place as any to introduce Matlab's sound handling
% I wasn't going to do it at all - but it lends itself to a periodic
% analysis. 

% a) Handel
load handel %Load the predefined handel dataset that comes with Matlab
sound(y,Fs) %Play it, namely Matrix y, at sampling rate Fs
%Faster/higher
sound(y,Fs*2)
%Slower/lower
sound(y,Fs/2)
%Quieter
sound(y./2,Fs)

% b) Make white noise and listen
y = rand(1e5,1); %Make a random draw
fs = 44100; %High sampling rate of 44100 is standard in audio
sound(y,fs)

% c) Soothing white noise
kernel = ones(8,1);
yc = conv(y,kernel)./length(kernel);
sound(yc,fs)

%%
figure
plot(y)
shg

%% Simple tones
freq1 = 440; %Frequency 1. Pure tones contain a single frequency. I think this is an A. 
freq2 = 880; %Frequency 2. Again a pure tone, again an A. But an octave higher. 
dur = 1; %1 second long
t = 0:1/fs:dur; %New timebase, because we have a much higher sampling rate
y1 = sin(2.*pi.*freq1.*t); %This creates a pure sine wave at the desired frequency
y2 = sin(2.*pi.*freq2.*t); %This creates a pure sine wave at the desired frequency
sound(y1,fs) %Sounds like the dialing signal of a 1980s telephone
pause(2)
sound(y2,fs) %Second tone

y3 = y1 + y2; %Adding sounds together
sound(y3,fs)

%% Visualizing this. 
%Once you created a vector, you can listen to it, you can look at it, you
%can 3d print it and touch it. Let's look at it. 
figure
subplot(2,2,1)
plot(y1(1:1000)); %Plotting the first thousand samples of the first sine wave
subplot(2,2,2)
plot(y2(1:1000)); %Plotting the first thousand samples of the second sine wave
subplot(2,2,3)
plot(y3(1:1000)); %Plotting the chord
y4 = y3 + randn(1,length(y3)); %Make a signal where the chord is buried in noise
sound(y4,fs)
subplot(2,2,4)
plot(y4(1:1000)); %Plotting the noisy chord

%%
%We can not really reverse this process by visual inspection in the time
%domain. We can not see this. So if the frequency components matter, e.g.
%alpha is associated with relaxation, theta with memory, and so on, we need
%to assess this in the frequency domain. 

%In order to look at our time-varying signal in the frequency domain, we need to
%take the fourier transform. Lucky for you, you live in the 21st century,
%so Matlab will do this for you. All you have to do is to know what you're
%doing and how tell Matlab what to do.
%So let's do that.
nyquist = fs/2; %Let's define our nyquist frequency. The reason for this is that we will plot everything from 
%0 to nyquist. In reality, the fft returns a duplicated signal from nyquist
%to the full frequency. 
freqbase = 1:nyquist; %We want to plot power as a function of frequency. For that, we need to define a base
Y1 = fft(y1); %Do the fft by calling the fft function and giving it the signal to fourier transform
Y2 = fft(y2); %Higher A
Y3 = fft(y3); %Both of them
Y4 = fft(y4); %Both of them in noise

%Question: Can FFT recover the components of Y3 and Y4, we could not, by
%visual inspection in the time domain.

%The fft function yields a representation of the time series in frequency
%space. Because frequency space includes phase, it is represented as
%complex numbers.

%Something like a power spectrum *throws away* the phase information. It
%just plots amplitude squared. If you care about phase, you have to make a
%second plot, where you plot something like the phase coherence. 
figure
subplot(2,2,1)
plot(freqbase,abs(Y1(1:length(freqbase))))
subplot(2,2,2)
plot(freqbase,abs(Y2(1:length(freqbase))))
subplot(2,2,3)
plot(freqbase,abs(Y3(1:length(freqbase))))
subplot(2,2,4)
plot(freqbase,abs(Y4(1:length(freqbase))))
%xlabel('Frequency')
%ylabel('Amplitude')

%%
%Do not do this - very confusing. If you plot all frequencies, not just
%until nyquist, the signal will repeat in a mirror-symmetric fashion. It's
%not real. 
figure
subplot(2,1,1) %This shows what is going on - fft gives you the complex solution and its complex conjugat
plot(Y1)
subplot(2,1,2) %Let's plot the absolute value, which will duplicate half the information
plot(abs(Y1))

%% 4 Preview of spectrogram - we'll do this for real next time
wvtool(hamming(64))