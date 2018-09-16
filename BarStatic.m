%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This program presents a very simple problem
% of bar loading
%Written by: Mohammad Tawfik
%Video explaining the code: https://youtu.be/0XxM8spIS0o
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
NE=2; %number of elements
Length=2.0; %bar length
Width=0.01; %bar width
Thickness=0.01; %bar thickness
Modulus=71e9; %Aluminum modulus of elasticity
%Cross-section area
Area=Width*Thickness;
Le=Length/NE; %Element Length
%Element stiffness matrix
Ke=Modulus*Area*[1 -1; -1 1]/Le;
%Global stiffness and mass matrix assembly
%Initializing an empty matrix
KGlobal=zeros(NE+1,NE+1);
%Assembling the global matrix
for ii=1:NE
    KGlobal(ii:ii+1,ii:ii+1)= ...
                  KGlobal(ii:ii+1,ii:ii+1)+Ke;
end
%For a fixed-free bar the first degree of freedom is zero
%Obtaining the auxiliary equations
KAux=KGlobal(1, 2:NE+1);
%Applying the boundary conditions
KGlobal(1,:)=[];
KGlobal(:,1)=[];
%force Vector
FGlobal=zeros(NE,1); %This is the empty force fector
FGlobal(NE)=1000; %Adding a single point load at the tip of 1000N
%Obtainning the solution displacement field
WW=inv(KGlobal)*FGlobal
%Obtaining the support reaction
Reactions= KAux*WW