# ImpedanceCalculation
Impedance calculation algorithm for an acoustic impedance probe with multiple microphones. 
The code in this repository is a generalized implementation of the calibration procedure introduced by Dickens, Smith and Wolfe, shown exemplarily in [1] for two mics and three calibrations.
The implementation presented here can be used for any number n of mics and any number m of calibrations (n,m > 2)
Some results basing on the presented code applied to an n = 4, m = 4 probe are shown in [2]. The algorithm implemented in Matlab is detailed in Eqs. 1-3, in the accompanying poster Eddy2016_poster.pdf in this repository.

References:
Paul Dickens, John Smith, Joe Wolfe: "Improved precision in measurements of acoustic impedance spectra using resonance-free calibration loads and controlled error distribution", J. Acoust. Soc. Am. 121, 1471–1481 (2007)
https://doi.org/10.1121/1.2434764

Dustin Eddy: "Acoustic Impedance Probe for Oboes, Bassoons, and Similar Narrow-bored Wind Instruments", In: Fortschritte der Akustik - DAGA2016; 42nd German Annual Con­ference on Acoustics, March 14.-17. 2016 in Aachen, (2016) 
https://pub.dega-akustik.de/DAGA_2016/data/articles/000484.pdf
