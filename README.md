# Reproducibility Package for "Neural coding for tactile motion: Scanning speed or temporal frequency?"

This repository contains the links to the data and MATLAB code to reproduce the figures presented in our manuscript, "Neural coding for tactile motion: Scanning speed or temporal frequency?".

The analysis is built around an object-oriented framework where all electrophysiological data and metadata for a single unit are encapsulated in a `SingleUnit` object. This approach ensures data integrity and simplifies the analysis pipeline.

---

## Access the Data

|── data/  
|  |── Processed_core_data.mat # The complete pre-processed dataset (https://figshare.com/s/2cb969d8134181197322)  
|  |── MyColorMaps.mat # The parameters used to generate result figures (https://figshare.com/s/6a8d4bba4583bd8851f9)  
|  |── Processed.mat # (Optional) The pre-processed dataset with temporary variables (https://figshare.com/s/8155ddd963997b4965da)  
|  |── Raw data/ # (Optional) A small sample of raw data files (provided for transparency) (https://figshare.com/s/30d7de62cdc911131c0f)  

---

## How to Reproduce All Figures

1.  Download the data and code. Create folders following the `Project Structure` below and place data and code accordingly. Set all folders in the `MATLAB search path` (https://www.mathworks.com/help/matlab/matlab_env/add-remove-or-reorder-folders-on-the-search-path.html). Make sure the `../results` directory is created.
2.  Change the working directory to the `../code` directory (https://www.mathworks.com/help/matlab/ref/cd.html).
3.  Execute the main script `run.m` in `MATLAB`. This script loads the pre-processed data and generates the base version of all figures from the manuscript. Note: These are the direct outputs from the code, prior to any minor cosmetic adjustments (e.g., adding titles or changing font sizes) made for publication.
4.  Upon completion, the generated figures will appear in the `../results` directory.

---

## Code and Data Overview

This repository contains the complete pre-processed dataset `Processed_core_data.mat` used to generate all manuscript figures. For methodological transparency, and due to file size constraints, a representative sample of the raw data files is also included in the `/data/Raw_data/` directory.

### The `SingleUnit` Data Class

The core of this project is the `SingleUnit` class, an object designed to store all relevant information for an isolated single unit. Pre-processed data, stored as a collection of these objects, can be found in `/data/Processed_core_data.mat`.

Key properties of the `SingleUnit` class include:
*   `site`: Identifier combining subject and recording site number (e.g., 'c2i_site1_depth2').
*   `area`: Postulated brain area (e.g., '3b', 'a1', 'a2').
*   `name`: Unique unit identifier (e.g., 'ch23_u1').
*   `waveform`: Average spike waveform.
*   `spike_data`: Spike timestamps for the unit. 
*   `raw_data`: Placeholder for continuous voltage data (unused in this analysis).
*   `event`: Timestamps for tactile stimulation events.
*   `parameter`: Struct containing stimulus parameters and source file information.
*   `rasters`: Perievent spike raster plots.
*   `psth`: Peri-stimulus time histogram.
*   `prefer_digit`: Preferred digit (e.g., 'd2') based on the highest evoked spiking rate.
*   `responsiveness`: Flag indicating if the unit's response is statistically significant.
*   `low_rate`: Flag for low-spiking-rate units (e.g., evoked rate < 5 Hz)
*   `excit_or_inhib`: Categorical label ('excitatory' or 'inhibitory') for the response type.

### Project Structure 

|── code/  
│    |── Figure_generation/ # Scripts to generate each figure, called by `run.m`  
│    |── Functions/  
│    │    |── `warmup.m` # Loads project object classes (called by `run.m`)  
│    |── Object_classes/  
│    │    |── SingleUnit/ # Defines the `SingleUnit` class  
│    │    |── BrainArea/ # Defines the `BrainArea` class  
│    |── Raw_data_functions/ # (Optional) Scripts to generate `Processed_core_data.mat` from raw data  
│    |── `run.m` # Main script to execute for the Reproducible Run  
|── data/  
│    |── Raw_data/ # A small sample of raw data files (provided for transparency)  
│    |── Processed_core_data.mat # The complete pre-processed dataset used for all figures  
|── results/ # Output directory for generated figures  

---

## (For Reference) Workflow for Processing Raw Data

⚠️ Disclaimer: The following workflow is provided for methodological transparency only. Due to file size constraints, the `/data/Raw_data/` directory contains only a small sample of the full dataset. Therefore, running these steps will not reproduce the complete `Processed_core_data.mat` file.

The primary "Reproducible Run" uses pre-processed data for efficiency. The following describes how the raw `.plx` data was converted into the `SingleUnit` objects. **These steps are not executed during the Reproducible Run.**

Dependency: `Matlab Offline Files SDK` from Plexon software.

1.  **Initialize Environment:** The `warmup.m` script loads the `Object_classes` in MATLAB.
2.  **Create Initial Objects:** The `CreateUnits.m` script reads the raw `.plx` files from the `/data/Raw_data/` directory, creates a `SingleUnit` object for each identified neuron, and saves each object as a separate `.mat` file in the `/results/` directory. The `CreateUnits.m` script requires scripts in the Matlab Offline Files SDK, in the `/code/Raw_data_functions/` directory, provided by **Plexon**. 
3.  **Assemble Units by Brain Areas:** The `CreateUnitAssemblyByBA.m` function gathers all `SingleUnit` objects in the `/results/` directory and build `BrainArea` objects based on the single unit's postulated location and response properties.  
4.  **Perform Final Computation and Save:** The `SU_add_whitenoise_autocFFT.m` function runs final analyses on temporal pattern of spiking activities and saves all objects into the single, final data file: `Processed_core_data.mat`. This is the file used by `run.m`.
5.  **Inspect Objects (Optional):** At any stage, a helper function can be used to visualize a loaded unit's properties. For example, after loading an object into a variable named my_unit, you would run `SUdisplay(my_unit)`.
