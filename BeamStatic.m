%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This program presents a very simple problem
% of beam bending
%Written by: Mohammad Tawfik
%Video explaining the code: https://youtu.be/iOYLNoCDRuk
%Text about Finite Element Analysis:
% https://www.researchgate.net/publication/321850256_Finite_Element_Analysis_Book_Draft
%Book DOI: 10.13140/RG.2.2.32391.70560
%
%For the Finite Element Course and other courses
% visit http://AcademyOfKnowledge.org
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Clearing the memory and display
clear all
clc
%Problem Data
NE=2;      %number of elements
NN=NE+1;   %number of nodes
NDOF=NN*2; %number of degrees of freedom

Length=2.0;     %beam length
Width=0.02;     %beam width
Thickness=0.01; %beam thickness
Modulus=71e9;   %Modulus of Elasticity Aluminum (GPa)
Rho=2700;       %Density (Kg/m^3)
Alpha=22.5e-6;  %Thermal Expansion coefficientt
%Cross-section area
Area=Width*Thickness;
%Second moment of area
Imoment=Width*Thickness*Thickness*Thickness/12;
Le=Length/NE; %Element Length
%Element stiffness matrix
Ke=Modulus*Imoment*[12  ,6*Le   ,-12  ,6*Le; ...
                    6*Le,4*Le*Le,-6*Le,2*Le*Le; ...
                    -12 ,-6*Le  ,12   ,-6*Le; ...
                    6*Le,2*Le*Le,-6*Le,4*Le*Le]/Le/Le/Le;
%Global stiffness and mass matrix assembly
%Initializing an empty matrix
KGlobal=zeros(NDOF,NDOF);
%Assembling the global matrix
for ii=1:NE
    KGlobal(2*ii-1:2*(ii+1),2*ii-1:2*(ii+1))= ...
                  KGlobal(2*ii-1:2*(ii+1),2*ii-1:2*(ii+1))+Ke;
end
%For a cantilever beam the first and second degree of freedom are fixed
BCs=[1,2];
%Obtaining the auxiliary equations
KAux=KGlobal(BCs,:);
KAux(:,BCs)=[]; %Removing the columns 
%Applying the boundary conditions
KGlobal(BCs,:)=[];
KGlobal(:,BCs)=[];
%force Vector
FGlobal=zeros(NDOF,1); %This is the empty force fector
FGlobal(BCs)=[];
FGlobal(2*NE-1)=1; %Adding a single point load at the tip
%Obtainning the solution displacement field
WW=inv(KGlobal)*FGlobal
%Obtaining the support reaction
Reactions= KAux*WW