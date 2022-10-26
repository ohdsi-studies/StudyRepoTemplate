-- create subject age table
IF OBJECT_ID('#subject_age', 'U') IS NOT NULL
   DROP TABLE #subject_age;
SELECT tab.cohort_definition_id,
       tab.person_id,
       tab.cohort_start_date,
       DATEDIFF(year, DATEFROMPARTS(tab.year_of_birth, tab.month_of_birth, tab.day_of_birth),
                tab.cohort_start_date) AS age
INTO #subject_age
FROM (
     SELECT c.cohort_definition_id, p.person_id, c.cohort_start_date, p.year_of_birth,
               CASE WHEN ISNUMERIC(p.month_of_birth) = 1 THEN p.month_of_birth ELSE 1 END AS month_of_birth,
               CASE WHEN ISNUMERIC(p.day_of_birth) = 1 THEN p.day_of_birth ELSE 1 END AS day_of_birth
     FROM @cohort_database_schema.@cohort_table c
     JOIN @cdm_database_schema.person p
         ON p.person_id = c.subject_id
     WHERE c.cohort_definition_id IN (@target_ids)
     ) tab
;

-- Charlson analysis
IF OBJECT_ID('#charlson_concepts', 'U') IS NOT NULL
   DROP TABLE #charlson_concepts;
CREATE TABLE #charlson_concepts
(
    diag_category_id INT,
    concept_id       INT
);

IF OBJECT_ID('#charlson_scoring', 'U') IS NOT NULL
   DROP TABLE #charlson_scoring;
CREATE TABLE #charlson_scoring
(
    diag_category_id   INT,
    diag_category_name VARCHAR(255),
    weight             INT
);


--acute myocardial infarction
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (1, 'Myocardial infarction', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 1, descendant_concept_id
FROM @cdm_database_schema.concept_ancestor
WHERE ancestor_concept_id IN (4329847);


--Congestive heart failure
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (2, 'Congestive heart failure', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 2, descendant_concept_id
FROM @cdm_database_schema.concept_ancestor
WHERE ancestor_concept_id IN (316139);


--Peripheral vascular disease
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (3, 'Peripheral vascular disease', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 3,
	c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (317585,312934,315558,195834,4099184,4247790,4188336,199064,320739,321882,37312529,4045408,321052,317305,312939,4134603)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (317585,312934,315558,195834,4099184,4247790,4188336,199064,320739,321882,37312529,4045408,321052,317305,312939,4134603)
  and c.invalid_reason is null
) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4243371,3184873,42599607,42572961,4289307,321822,42597028,4202511,4263089,42597030)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4243371,321822)
  and c.invalid_reason is null
) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C;


--Cerebrovascular disease
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (4, 'Cerebrovascular disease', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 4, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (381591,434056,4112026,43530727,4148906)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (381591,434056,4112026,43530727,4148906)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4121629,4119617,37204809,4062269,435875,372721,4267553,441406,762585,765899,762583,762584,37108913,37117075,432346,192763,43021816,379778,37017075,4061473,4088927,4173794,380943,762351,4079430,4079433,4082161,764707,42536193,4079431,4079432,4079434,4082162,42536192,45766085,4111707,4120104,4079120,4079021,4082163,42535879,42535880,4046364,4234089,313543,4180026,4121637)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4121629,4119617,37204809,4062269,435875,372721,4267553,441406,762585,765899,762583,762584,37108913,37117075,432346,192763,43021816,379778,37017075,4061473,4088927,4173794,380943,762351,4079430,4079433,4082161,764707,42536193,4079431,4079432,4079434,4082162,42536192,45766085,4111707,4120104,4079120,4079021,4082163,42535879,42535880,4046364,4234089,313543,4180026,4121637)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C;


--Dementia
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (5, 'Dementia', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 5, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4182210,373179)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4182210,373179)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (378726,37311999,376095,377788,4139421,372610,4009647,375504,4108943,4047745)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (378726,37311999,376095,377788,4139421,372610,4009647,375504,4108943,4047745)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C;


--Chronic pulmonary disease
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (6, 'Chronic pulmonary disease', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 6, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (312940,256450,317009,256449,4063381,4112814,4279553,444084,259044)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (256450,317009,256449,4063381,4112814,4279553,444084,259044)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (257583,4250128,42535716,432347,37396824,4073287,24970,441321,26711,4080753,259848,257012,255362,4166508,4244339,4049965,4334649,4110492,4256228,4280726)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (257583,4250128,42535716,432347,4073287,24970,441321,26711,4080753,259848,257012,255362,4166508,4244339,4049965,4334649,4110492,4256228,4280726)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;


--Rheumatologic disease
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (7, 'Rheumatologic disease', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 7, descendant_concept_id
FROM @cdm_database_schema.concept_ancestor
WHERE ancestor_concept_id IN (80182,4079978,255348,80800,80809,256197,438688,254443,257628,134442);


--Peptic ulcer disease
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (8, 'Peptic ulcer disease', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 8,c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4027663)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4027663)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (42575826,42598770,42572784,42598976,42598722,4340230,42572805,4341234,201340,37203820,4206524)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (42575826,42598770,42572784,42598976,42598722,4340230,42572805,4341234,201340,37203820,4206524)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;


--Mild liver disease
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (9, 'Mild liver disease', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 9,c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (201612,4212540,4064161,4267417,194417,4159144,4240725,4059290,4055224)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (201612,4212540,4064161,4267417,194417,4159144,4240725,4059290,4055224)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4048083,4340386,197654,4194229,37396401,42599120,36716035,42599522,4342775,4026136)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (197654,4194229,37396401,36716035,42599522,4342775)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;


--Diabetes (mild to moderate)
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (10, 'Diabetes (mild to moderate)', 1);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 10,c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (46270484,36684827,4008576,4159742,443727,37311673,4226238,4029423,37110593,45770902,45757277)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (46270484,36684827,4008576,4159742,443727,37311673,4226238,4029423,37110593,45770902,45757277)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (1567906,37016355,44809809,44789319,44789318,4096041,3180411,195771)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (1567906,37016355,44809809,44789319,44789318,4096041,3180411,195771)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;


--Diabetes with chronic complications
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (11, 'Diabetes with chronic complications', 2);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 11, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (442793)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (442793)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (46270484,761051,1567906,4159742,443727,4317258,761048,37311673,4226238,37109305,4029423,37110593,37016356,37016358,37016357,134398,195771,197304)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (46270484,761051,1567906,4159742,443727,4317258,761048,37311673,4226238,37109305,4029423,37110593,37016356,37016358,37016357,134398,195771,197304)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;



--Hemoplegia or paralegia
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (12, 'Hemoplegia or paralegia', 2);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 12, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4102342,132617,374022,381548,192606,44806793,374914)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4102342,132617,374022,381548,192606,44806793,374914)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4044233,4219507,42537693,81425,4008510,4136090,37396338,37204522,36684263,374336,35622325,4222487,434056,36716141,4077819,43530607,4013309,372654,37116389,37312156,37111591,37116294,35622086,37116656,36716260,37117747,35622085,37110771,37109775,4318559,40483180)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4008510,434056,4013309,372654)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;


--Renal disease
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (13, 'Renal disease', 2);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 13,  c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (312358,44782429,4019967,439695,443919,4298809,4030518,197921,42539502)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (312358,44782429,4019967,439695,443919,4298809,4030518,197921,42539502)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (37016359,4054915,4189531,4126305,442793,4149398,45552372,192279,35205724)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4054915,4189531,4126305,442793,192279)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C UNION ALL 
SELECT 1 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4147716,4019967,2617400,2617401,2617545,2213597,2213592,2213591,2213593,2213590,2101833,40664693,40664745,2108567,2108564,2108566,4286500,313232,2514586,46270032,2108568,2101834)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4147716,4019967,2617400,2617401,2617545,2213597,2213592,2213591,2213593,2213590,2101833,40664693,40664745,2108567,2108564,2108566,4286500,313232,2514586,46270032,2108568,2101834)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (2313999,4059475)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (2313999,4059475)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C UNION ALL 
SELECT 2 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4300839,4146536)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4300839,4146536)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (46270934,46270933,37396069,3171077,4139443,2213596,2213595,2213597,2213594,2213592,2213591,2213593,2213590,2213586,2213585,2213584,2213583,2213582,2213581,2213589,2213588,2213587,2213580,2213579,2213578,2101833,40664693,40664745,2108567,2108564,2108566,4286500,2514586,2108568,2101834)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (2213596,2213595,2213597,2213594,2213592,2213591,2213593,2213590,2213586,2213585,2213584,2213583,2213582,2213581,2213589,2213588,2213587,2213580,2213579,2213578)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C UNION ALL 
SELECT 3 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4021107,4197300,2833286,2877118,45888790,4322471)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4021107,4197300,2833286,2877118,45888790,4322471)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4022474,45887599,2109583,2109584,2109582,2109580,2109581)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4022474)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;


--Any malignancy
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (14, 'Any malignancy', 2);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 14, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (438701,443392)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (438701,443392)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (36403050,36403028,36403071,36402997,36403059,36403077,36403012,36402991,36403070,36403044,36403007,36403014,36403066,36403006,36403031,36403020,36403061,36403004,36403009,36403056,36403010,36403042,36403046,36403036,36403143,36403115,36403083,36403138,36403141,36403128,36403152,36403107,36403090,36403132,36403091,36403142,36403134,36403148,36403120,36403095,36403112,36403093,36403139,36403145,36403109,42512800,42511869,42512038,42511724,42511824,42511643,36403149,42512747,42512286,42512532,42512028,36403081,36403026,36403058,36403034,36402992,36403054,36403041,36403043,36403073,435506,36403030,36403024,36403117,36403102,433435,36402628,36403078,36402440,36403047,36403129,36403013,36403049,36402466,36402579,42514272,42514300,42514069,42514087,42513173,42513168,42514220,42514355,42514250,42514287,42514264,42514252,42514189,42514379,42514157,42514198,42514109,42514206,42514341,42514251,42514168,42514350,42514129,42514102,42514156,42514291,42514378,42514367,42514217,42514165,42514372,42514202,42514326,42514143,42514304,42514180,42514373,42514103,42514334,42514182,42513234,42514239,42514278,42514169,42514212,42514362,42514093,42514097,42514376,42514163,42514297,42514369,42514363,42514178,42514307,42514214,42514288,42514208,42514263,42514201,42514175,42514303,42514290,42514100,42514327,42514271,42514329,42514240,42514144,42514254,42514294,42514170,42514147,42514215,42514104,42514374,42514126,42514199,42514338,42514173,42514315,42514225,42514107,42514131,42514277,42514231,42514211,42514108,42514141,42514091,42514232,42514260,42514302,42514191,42514365,42514136,42514237,42514325,42514337,42514359,42514110,42514324,42514228,42514098,42514048,42514137,42514218,42514125,42514080,42514209,42514357,42514348,42514335,42514305,432582,36402451,36402490,42512086,36402509,36402513,36402587,36402575,42512566,4283739,432851,36402471,42512846,36403151,36403082,36403123,36403080,36402645,36403076,36403068,36403039,36403033,36403057,36403001,36403069,36403072,36403003,36403048,36403086,36403154,36402417,36402373,42512691,36402391,36402644)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (36403050,36403028,36403071,36402997,36403059,36403077,36403012,36402991,36403070,36403044,36403007,36403014,36403066,36403006,36403031,36403020,36403061,36403004,36403009,36403056,36403010,36403042,36403046,36403036,36403143,36403115,36403083,36403138,36403141,36403128,36403152,36403107,36403090,36403132,36403091,36403142,36403134,36403148,36403120,36403095,36403112,36403093,36403139,36403145,36403109,42512800,42511869,42512038,42511724,42511824,42511643,36403149,42512747,42512286,42512532,42512028,36403081,36403026,36403058,36403034,36402992,36403054,36403041,36403043,36403073,435506,36403030,36403024,36403117,36403102,433435,36402628,36403078,36402440,36403047,36403129,36403013,36403049,36402466,36402579,42514272,42514300,42514069,42514087,42513173,42513168,42514220,42514355,42514250,42514287,42514264,42514252,42514189,42514379,42514157,42514198,42514109,42514206,42514341,42514251,42514168,42514350,42514129,42514102,42514156,42514291,42514378,42514367,42514217,42514165,42514372,42514202,42514326,42514143,42514304,42514180,42514373,42514103,42514334,42514182,42513234,42514239,42514278,42514169,42514212,42514362,42514093,42514097,42514376,42514163,42514297,42514369,42514363,42514178,42514307,42514214,42514288,42514208,42514263,42514201,42514175,42514303,42514290,42514100,42514327,42514271,42514329,42514240,42514144,42514254,42514294,42514170,42514147,42514215,42514104,42514374,42514126,42514199,42514338,42514173,42514315,42514225,42514107,42514131,42514277,42514231,42514211,42514108,42514141,42514091,42514232,42514260,42514302,42514191,42514365,42514136,42514237,42514325,42514337,42514359,42514110,42514324,42514228,42514098,42514048,42514137,42514218,42514125,42514080,42514209,42514357,42514348,42514335,42514305,432582,36402451,36402490,42512086,36402509,36402513,36402587,36402575,42512566,4283739,432851,36402471,42512846,36403151,36403082,36403123,36403080,36402645,36403076,36403068,36403039,36403033,36403057,36403001,36403069,36403072,36403003,36403048,36403086,36403154,36402417,36402373,42512691,36402391,36402644)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;


--Moderate to severe liver disease
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (15, 'Moderate to severe liver disease', 3);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 15, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (4340386,24966,4237824,4029488,4245975,192680,4026136,4277276)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4340386,24966,4237824,4029488,4245975,192680,4026136,4277276)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @cdm_database_schema.CONCEPT where concept_id in (36716708,763021,4163687,4314443,439675,46270037,4308946,46270152,46270142,196029,194856,200031,439672,4331292,3183806,4291005)
UNION  select c.concept_id
  from @cdm_database_schema.CONCEPT c
  join @cdm_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (36716708,763021,4163687,4314443,439675,46270037,4308946,46270152,46270142,196029,194856,200031,439672,4331292,3183806,4291005)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;


--Metastatic solid tumor
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (16, 'Metastatic solid tumor', 6);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 16, descendant_concept_id
FROM @cdm_database_schema.concept_ancestor
WHERE ancestor_concept_id IN (432851);


--AIDS
INSERT INTO #charlson_scoring (diag_category_id, diag_category_name, weight)
VALUES (17, 'AIDS', 6);

INSERT INTO #charlson_concepts (diag_category_id, concept_id)
SELECT 17, descendant_concept_id
FROM @cdm_database_schema.concept_ancestor
WHERE ancestor_concept_id IN  (4013106,439727);



IF OBJECT_ID('#charlson_map', 'U') IS NOT NULL
   DROP TABLE #charlson_map;
SELECT DISTINCT diag_category_id,
                weight,
                c.cohort_definition_id,
                c.subject_id,
                c.cohort_start_date
INTO #charlson_map
FROM (SELECT concepts.diag_category_id, score.weight, cohort.subject_id, cohort.cohort_definition_id
	FROM 
	@cohort_database_schema.@cohort_table cohort
	INNER JOIN @cdm_database_schema.condition_era condition_era
		ON cohort.subject_id = condition_era.person_id
	INNER JOIN #charlson_concepts concepts
		ON condition_era.condition_concept_id = concepts.concept_id
	INNER JOIN #charlson_scoring score
		ON concepts.diag_category_id = score.diag_category_id
	WHERE condition_era_start_date < cohort.cohort_start_date	
	) temp
	RIGHT JOIN @cohort_database_schema.@cohort_table c
		ON c.subject_id = temp.subject_id and c.cohort_definition_id=temp.cohort_definition_id
	
	;


-- Update weights to avoid double counts of mild/severe course of the disease
-- Diabetes
UPDATE #charlson_map
SET weight = 0
FROM (
  SELECT
    t1.subject_id AS sub_id
  , t1.cohort_definition_id AS coh_id
  , t1.diag_category_id AS d1
  , t2.diag_category_id AS d2
  FROM #charlson_map t1
  INNER JOIN #charlson_map t2 ON
    t1.subject_id = t2.subject_id
    AND t1.cohort_definition_id = t2.cohort_definition_id
) x
WHERE
  subject_id = x.sub_id
  AND cohort_definition_id = x.coh_id
  AND diag_category_id = 10
  AND x.d1 = 10
  AND x.d2 = 11;

-- Liver disease
UPDATE #charlson_map
SET weight = 0
FROM (
  SELECT
    t1.subject_id AS sub_id
  , t1.cohort_definition_id AS coh_id
  , t1.diag_category_id AS d1
  , t2.diag_category_id AS d2
  FROM #charlson_map t1
  INNER JOIN #charlson_map t2 ON
    t1.subject_id = t2.subject_id
    AND t1.cohort_definition_id = t2.cohort_definition_id
) x
WHERE
  subject_id = x.sub_id
  AND cohort_definition_id = x.coh_id
  AND diag_category_id = 9
  AND x.d1 = 9
  AND x.d2 = 15;

-- Malignancy
UPDATE #charlson_map
SET weight = 0
FROM (
  SELECT
    t1.subject_id AS sub_id
  , t1.cohort_definition_id AS coh_id
  , t1.diag_category_id AS d1
  , t2.diag_category_id AS d2
  FROM #charlson_map t1
  INNER JOIN #charlson_map t2 ON
    t1.subject_id = t2.subject_id
    AND t1.cohort_definition_id = t2.cohort_definition_id
) x
WHERE
  subject_id = x.sub_id
  AND cohort_definition_id = x.coh_id
  AND diag_category_id = 14
  AND x.d1 = 14
  AND x.d2 = 16;


drop table if exists @cohort_database_schema.qf_pioneer_temp;
create table @cohort_database_schema.qf_pioneer_temp as 
select * from #charlson_map;

