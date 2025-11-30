% MATLAB script to design IIR filters for a 3-band audio equalizer

clear;
clc;
close all;

%% 1. Define System Parameters
fs = 44100;         % Sampling Frequency in Hz (standard for audio)
N = 2;              % Filter Order (2nd order is a biquad, efficient for DSP)

% Crossover frequencies in Hz
f_low = 300;        % Cutoff for Low-Pass filter (Bass)
f_high = 3000;      % Cutoff for High-Pass filter (Treble)

%% 2. Design the IIR Filters
[b_lp, a_lp] = butter(N, f_low / (fs/2), 'low');
[b_bp, a_bp] = butter(N, [f_low, f_high] / (fs/2), 'bandpass');
[b_hp, a_hp] = butter(N, f_high / (fs/2), 'high');

%% 3. Display the Coefficients for C Implementation
fprintf('--- Low-Pass Filter Coefficients (Bass) ---\n');
fprintf('b_lp = {%.8f, %.8f, %.8f};\n', b_lp(1), b_lp(2), b_lp(3));
fprintf('a_lp = {%.8f, %.8f, %.8f};\n\n', a_lp(1), a_lp(2), a_lp(3));

fprintf('--- Band-Pass Filter Coefficients (Mids) ---\n');
fprintf('b_bp = {%.8f, %.8f, %.8f, %.8f, %.8f};\n', b_bp(1), b_bp(2), b_bp(3), b_bp(4), b_bp(5));
fprintf('a_bp = {%.8f, %.8f, %.8f, %.8f, %.8f};\n\n', a_bp(1), a_bp(2), a_bp(3), a_bp(4), a_bp(5));

fprintf('--- High-Pass Filter Coefficients (Treble) ---\n');
fprintf('b_hp = {%.8f, %.8f, %.8f};\n', b_hp(1), b_hp(2), b_hp(3));
fprintf('a_hp = {%.8f, %.8f, %.8f};\n\n', a_hp(1), a_hp(2), a_hp(3));

%% 4. Visualize and Verify the Filter Responses (Corrected)
% First, get the frequency response data from freqz without plotting
[h_lp, f] = freqz(b_lp, a_lp, 2048, fs);
[h_bp, ~] = freqz(b_bp, a_bp, 2048, fs);
[h_hp, ~] = freqz(b_hp, a_hp, 2048, fs);

% Now, create the plot manually using the data
figure;
hold on;
plot(f, 20*log10(abs(h_lp)), 'b', 'LineWidth', 2); % Plot Bass
plot(f, 20*log10(abs(h_bp)), 'g', 'LineWidth', 2); % Plot Mids
plot(f, 20*log10(abs(h_hp)), 'r', 'LineWidth', 2); % Plot Treble
hold off;

title('Frequency Response of 3-Band EQ Filters');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend('Low-Pass (Bass)', 'Band-Pass (Mids)', 'High-Pass (Treble)');
grid on;
axis([0 fs/2 -60 5]); % Focus the plot on the relevant frequency range


