

# Real-Time Digital Audio Equalizer on Embedded Platform

## 📌 Project Overview

This project implements a **real-time, three-band digital audio equalizer** on an **STM32 NUCLEO-F446RE** microcontroller. It allows users to independently adjust the gain of **Bass (Low)**, **Mid-range**, and **Treble (High)** frequencies using external potentiometers.

The core signal processing uses **Infinite Impulse Response (IIR) Butterworth filters** to separate frequency bands. While initially designed to take live input from an I2S microphone, the final implementation utilizes pre-recorded audio samples stored in the microcontroller's memory (converted via Python) and outputs the processed audio via an **I2S DAC**.

### 🎯 Objectives

  * **Filter Design:** Design efficient IIR filters (Low-pass, Band-pass, High-pass) using MATLAB.
  * **Simulation:** Verify the filter logic and gain control in a Python simulation environment.
  * **Embedded Implementation:** Implement the DSP algorithms in C on an STM32 ARM Cortex-M4 processor.
  * **Real-time Control:** Map analog potentiometer readings to digital gain coefficients.

-----

## 📂 Repository Contents

| File Name | Description |
| :--- | :--- |
| `filter_design_dsp.m` | **MATLAB Script.** Designs the 2nd-order IIR Butterworth filters (300Hz / 3000Hz cutoffs) and exports the `b` (numerator) and `a` (denominator) coefficients required for the C implementation. |
| `preliminary_simulation...ipynb` | **Jupyter Notebook.** A Python simulation of the equalizer. It loads an audio file, applies the `scipy.signal` filters using the calculated coefficients, and simulates gain adjustment to verify audio quality before hardware deployment. |
| `converter.py` *(found in header file.h)* | **Python Utility.** A script used to convert standard `.wav` audio files into a C array (header file). This allows audio to be stored in the STM32's internal flash memory for playback since the microphone interface was replaced in the final prototype. |
| `DSP_PROJECT_REPORT_combined.pdf` | **Full Project Documentation.** Contains detailed methodology, block diagrams, filter frequency response graphs, hardware pinouts, and testing results. |

-----

## ⚙️ System Architecture

1.  **Input Stage:** Audio data is stored as a raw C array in the microcontroller's flash memory (converted from WAV).
2.  **Processing Stage (STM32F446RE):**
      * **ADC Input:** Reads 3 potentiometer values to determine gain for Bass, Mids, and Treble.
      * **Filtering:** The input signal splits into three parallel IIR filters.
      * **Mixing:** The output of each filter is multiplied by its respective gain and summed.
3.  **Output Stage:** The processed digital signal is sent via **I2S (Inter-IC Sound)** protocol to the **UDA1334A DAC** for analog conversion and playback.

### Hardware Components

  * **Microcontroller:** STM32 NUCLEO-F446RE
  * **DAC Module:** UDA1334A I2S Stereo DAC
  * **Control:** 3x 10kΩ Linear Potentiometers
  * **Audio Output:** Speakers or Headphones (via DAC)

-----

## 🚀 Getting Started

### 1\. Filter Coefficient Generation

Run `filter_design_dsp.m` in MATLAB to generate new coefficients if you wish to change the crossover frequencies (Default: 300Hz and 3000Hz).

```matlab
% Example output from script
b_lp = {0.00044327, 0.00088655, 0.00044327};
a_lp = {1.00000000, -1.93957021, 0.94134330};
```

### 2\. Simulation

Open `preliminary_simulation_gain_control_using_matlab_derived_coefficients.ipynb` in Jupyter or Google Colab.

1.  Upload a test `.wav` file.
2.  Run the cells to process the audio.
3.  Listen to the "Original" vs "Equalized" output to verify the math.

### 3\. Audio Conversion (For Embedded Board)

If not using a live microphone, use the `converter.py` script to prepare your audio file:

```bash
python converter.py your_audio.wav
```

*This will generate a `.h` file containing a `const uint16_t wave_data[]` array to be included in your STM32 C project.*

### 4\. Hardware Setup

  * **DAC Connections:**
      * `DIN` -\> `PB15` (MOSI)
      * `BCLK` -\> `PB10` (SCK)
      * `WSEL` -\> `PB12` (LRCK)
  * **Potentiometers:** Connect wipers to ADC pins `PA0`, `PA1`, and `PA4`.

-----

## 📊 Results

  * **Simulation:** The Python simulation confirms that the parallel IIR filter bank correctly boosts or cuts specific frequency ranges without introducing significant distortion (clipping protection logic included).
  * **Hardware:** The STM32 successfully streams the audio from flash memory, applies the filters in real-time based on potentiometer positions, and outputs clean audio via the I2S DAC.

-----
