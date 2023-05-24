options validvarname=v7 msglevel=i; 
libname moldova "/home/u60739998/ILE";
filename tb "/home/u60739998/ILE/Moldova_data.xlsx";

proc import  
	datafile=tb
	out=moldova.tb
	dbms=xlsx
	replace;
	getnames=yes;
run;

proc contents data=moldova.tb; run;

data moldova.tb_clean1;
	set moldova.tb;
	*drop 108 variables from total 218 - final # of vars: 110;
	drop p0 p1 p1_a p2 p2_a p3 p3_1 p3_2 p4 rayon_p5_a p5_a2 p5_b p5_b_2 p12 p17 p18 p21_b p22
	p25 p27 p30 p31 p17_a p29_1 p29_2 p29_3 p13_b docdate p28lastchanged p21_number p9_c
	p00 p1_1 p1_2 p1_3 p1_4 p17_1_1 p17_2_1 p17_3_1 p17_4_1 p22_1 p22_2 p22_3 p22_4 bp28 p32_1 
	p32_2 p32_3 p32_4 p33_1_data p33_2_data p33_3_data p33_4_data p33_1_primit p33_2_primit
	p33_3_primit p33_4_primit p33_1_primit_data p33_2_primit_data p33_3_primit_data
	p33_4_primit_data p35_a p30_1 p30_2 p30_3 p30_4 p31_1 p31_2 p31_3 p31_4 p21_1_number
	p21_2_number p21_3_number p21_4_number p33_1_institution p33_2_institution p33_3_institution
	p33_4_institution p1_5 p36_1 p37_1 p31_5 refins_code refins_name_ro refreg_name_ro 
	a_UserGUID a_InstitutionGUID a_ReportGUID a_SendStatus a_LastUserGUID a_DocType b_ID
	b_UserGUID b_ref_fne_a_id b_InstitutionGUID b_fnea_reportguid b_ReportGUID b_SendStatus 
	b_LastUserGUID b_DocType c_ID c_UserGUID c_ref_fne_a_id c_InstitutionGUID c_fnea_reportguid 
	c_ReportGUID c_SendStatus c_LastUserGUID;
run;

proc contents data=moldova.tb_clean1; run;

proc freq data=moldova.tb_clean1;
	table p11 p23 ap28 gender_p6 urban_rural_p5_c citizenship p9_b ocupation_p9 homless_p5_d;
run;

data moldova.tb_clean2;
	set moldova.tb_clean1;
	if p11 < 1 then delete; *remove obs with missing detention data;
	if p9_b < 1 then delete; *remove obs with missing education data;
	if ocupation_p9 =" " then delete; *remove obs with missing occupation data (char var);
	if homless_p5_d=" " then delete; *remove obs with missing homelessness data (char var);
	if ap28 = 2 or ap28= 3; *keep only cases with confirmed HIV results;
run;

proc freq data=moldova.tb_clean2;
	table p11 p23 ap28 gender_p6 urban_rural_p5_c citizenship p9_b ocupation_p9 homless_p5_d p21_h p21_r;
run;

proc format;
	value sexf 0="Male" 1="Female";
	value residencef 0="Rural" 1="Urban";
	value unhousedf 0="Not unhoused" 1="Unhoused";
	value citizenf 0="Other" 1="Moldova";
	value detentionf 0="No detention" 1="Detention";
	value MDRf 0="DS-TB" 1="MDR-TB";
	value HIVf 0="No HIV" 1="Concurrent HIV";
	value pTBf 0="No previous TB treatment" 1="Previous TB treatment";
	value eduf 1="Primary" 2="Secondary" 3="Specialized secondary" 4="Higher edu"
	0="No education";
	value occupationf 0="Unemployed" 1="Employed" 2="Disabled" 3="Retired" 4="Student";
run;

data moldova.tb_clean3;
	set moldova.tb_clean2;
	if (p21_H=1 and p21_R=1) or (p21_1_H=1 and p21_1_R=1) or (p21_2_H=1 and p21_2_R=1)
	or (p21_3_H=1 and p21_3_R=1) or (p21_4_H=1 and p21_4_R=1) then MDR=1; 
	else MDR=0;
	
	if p21_H=1 and p21_R=1 then bMDR=1; else bMDR=0;
	
	if gender_p6="M" then sex=0; else if gender_p6="F" then sex=1;
	if urban_rural_p5_c="rural" then residence=0; else if urban_rural_p5_c="urban" then residence=1;
	if homless_p5_d="N" then unhoused=0; else if homless_p5_d="Y" then unhoused=1;
	if citizenship="other" then citizen=0; else if citizenship="Moldova" then citizen=1;
	if p11=2 then detention=0; else if p11=1 then detention=1;
	if p23=2 then pTB=0; else if p23=1 or p23=11 or p23=12 then pTB=1;
	if ap28=2 then HIV=1; else if ap28=3 then HIV=0;
	if ocupation_p9="unemployed" then occupation=0;
	else if ocupation_p9="worker" then occupation=1;
	else if ocupation_p9="disabled" then occupation=2;
	else if ocupation_p9="pensioner" then occupation=3;
	else if ocupation_p9="student" then occupation=4;
	if p9_b=5 then edu=0;
	else if p9_b=1 then edu=1; else if p9_b=2 then edu=2; else if p9_b=3 then edu=3;
	else if p9_b=4 then edu=4;
	
	keep a_ID MDR bMDR p21_H p21_R p21_1_H p21_2_H p21_3_H p21_4_H p21_1_R p21_2_R p21_3_R
	p21_4_R p11 p23 p9_b ocupation_p9 homless_p5_d ap28 gender_p6 urban_rural_p5_c
	citizenship sex residence unhoused citizen detention pTB HIV occupation edu;
run;

data moldova.tb_final;
	set moldova.tb_clean3;
	drop p11 p23 homless_p5_d ap28 gender_p6 urban_rural_p5_c citizenship ocupation_p9 p9_b ;
run;

proc sort data=moldova.tb_final;
	by detention;
run;

%macro chi(var, group);

proc freq data=moldova.tb_final;
	tables &var*&group / chisq measures nopercent norow;
	format sex sexf. residence residencef. unhoused unhousedf. citizen citizenf.
	detention detentionf. MDR MDRf. pTB pTBf. HIV HIVf. occupation occupationf. edu eduf.;
run;

%mend chi;

%chi(sex, detention);
%chi(residence, detention);
%chi(citizen, detention); *not significant;
%chi(edu, detention);
%chi(occupation, detention);
%chi(unhoused, detention);
%chi(pTB, detention);
%chi(HIV, detention);
%chi(MDR, detention);

%chi(detention, MDR);
%chi(sex, MDR);
%chi(residence, MDR);
%chi(citizen, MDR); *not significant;
%chi(edu, MDR);
%chi(occupation, MDR);
%chi(unhoused, MDR);
%chi(pTB, MDR);
%chi(HIV, MDR);

proc logistic data=moldova.tb_final descending; *descending to model MDR-TB and not DS-TB. Formats will lead SAS to model DS because alphebetically it comes before MDR;
	class detention (ref="0") /param=reference;
	model MDR=detention;
run;

proc logistic data=moldova.tb_final descending;
	class detention (ref="0") pTB (ref="0") HIV (ref="0") sex (ref="0") residence (ref="0")
	edu (ref="0") occupation (ref="0") unhoused (ref="0") / param=ref;
	model MDR=detention pTB HIV sex residence edu occupation unhoused;
run; *edu lost significance in the model;

*remove education - what changes?;
proc logistic data=moldova.tb_final descending;
	class detention (ref="0") pTB (ref="0") HIV (ref="0") sex (ref="0") residence (ref="0")
	occupation (ref="0") unhoused (ref="0") / param=ref;
	model MDR=detention pTB HIV sex residence occupation unhoused;
run; *AIC went down (good), sex got a little more significant, model still < 0.0001 and using up less df;