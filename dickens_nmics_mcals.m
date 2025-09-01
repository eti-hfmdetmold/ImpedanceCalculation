function [Zmeas] = dickens_nmics_mcals(bmeas,Z,b0,varargin)
% INPUT
% bmeas   : the multichannel measurement of the unknown load (nfrq x nmic)
% Z       : the theorectical impedances of the calibration tubes  (nfrq x ncal)
% b0      : the multichannel measurement of the impedance head closed at refplane (nfrq x 1) 
% varargin: the m multichannel measurements bk of the m calibration loads,
%           each bk is (nfrq x nmic)
% OUTPUT
% Zmeas   : impedance at reference plane for the unknown load (nfrq x 1)

% generalized calibration of a multiple microphone impedance head, with any
% number of mics and calibrations
% according to Dickens2007 (JASA)
% here: n mics, m calibrations 

%Timo Grothe, ETI, 02.03.2016

% !! note !!
% varargin must be 2 or more datasets
% the measurement with closed impedance head is not counted as a
% calibration.
% example: 
% [] = dickens_nmics_mcals(bmeas,Z,b0,b1,b2) is the
% Two-Mic-Two-Calibrations algorithm with ncal = size(Z,2) = 2;

% Timo Grothe, ETI, 26.04.2016

%% reorganisation of data
ncal = size(varargin,2); %ncal must also equal size(Z,2)!!
[nfrq,nmic] = size(b0);

% %lets reorganize all bk into one 3D-matrix b which is (nfreq x ncal x mics)
% %(note, that we don't reorgainze b0!!)
%initialize the b-matrix
b    = zeros(nfrq,ncal,nmic);
for k = 1:ncal
    bk = varargin{k};
    b(:,k,:) = reshape(bk,nfrq,1,nmic);
end


%% unknown 
% calibration matrix A (nmic x 2)

%evaluate for one frequency at a time
for i = 1:nfrq %loop over frequencies

%% solving for A
%% step1 
%solve for first column in A (Eq. 7) 
A11 = 1;
A1 = A11*b0(i,:).'/b0(i,1); %"zeroth" calibration

%% step2
%solve for second column in A 
B_Z = zeros(ncal*(nmic-1),nmic); %initialize B_Z- matrix
B = B_Z;                         %initialize B matrix
for k = 1:ncal %loop over calibrations
    
Zk = Z(i,k); %kth calibration
Bk = zeros(nmic-1,nmic); %initialize 
for j = 1:nmic-1 %loop over mics
    Bk(j,j)   = b(i,k,j+1);
    Bk(j,j+1) =-b(i,k,j);
end %loop over mics

%indices handling for matrix concatenation
idx1 = (k-1)*(nmic-1)+1;
idx2 = k*(nmic-1); 

B_Z([idx1:idx2],:)  = -Bk/Zk; %divide the kth B-coefficients by the kth calibration
B([idx1:idx2],:)    =  Bk;
end %loop over calibrations

BA1 = B*A1;

% the overdetermined system (Eq. 8) is
% B_Z A2 = BA1; to be solved with
A2 = B_Z\BA1; 

%% result
%calibration matrix A (n x 2) (see Eq. 1)
A(:,:,i) = [A1,A2];

%% solve for input impedance
% to get from the measurements bmeas to the impedance in the reference plane xref
P = A(:,:,i)\bmeas(i,:).'; %solve Eq. (1)
% P = [p;Z0*U]; 
Z0 = 1;

Zmeas(i) = P(1)/(P(2)/Z0);% solve for the impedance

end %loop over frequencies

