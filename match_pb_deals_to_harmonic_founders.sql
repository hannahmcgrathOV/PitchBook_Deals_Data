

create or replace table openviewdb.public.founder_linkedins_from_offshore  

(

COMPANIES varchar
, CEO_AT_TIME_OF_DEAL varchar
, linkedin_link varchar


)

select * from openviewdb.public.founder_linkedins_from_offshore

create or replace table openviewdb.public.founder_linkedins_from_offshore_2  as

select distinct companies, ceo_at_time_of_deal, linkedin_link
from openviewdb.public.founder_linkedins_from_offshore 


-- deals relevant to this
with deals as (
    select t1.deal_id
        , t2.companies
        , t2.ceo_at_time_of_deal
        , replace(t2.linkedin_link, 'www.') as link1
        , case when right(link1,1) = '/' then left(link1, len(link1)-1) else link1 end as link2
    from openviewdb.public.canal_train_test_deals_pichbook_enriched t1
    join openviewdb.public.founder_linkedins_from_offshore t2
        on t1.companies = t2.companies
        and t1.ceo_at_time_of_deal = t2.ceo_at_time_of_deal
), harmonic_founders as (
    select full_name, replace(socials:linkedin:url, '""') as linkedin_url
    from openviewdb.public.canal_train_test_founders_harmonic_enriched
    ---where current_job_company_name = 'PayFit'
    --union all 
    --select full_name, replace(socials:linkedin:url, '""') as linkedin_url
    --from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
), to_match as (
    select ceo_at_time_of_deal, link2
    from deals d
    left join harmonic_founders h
        on d.link2 = h.linkedin_url
    where h.linkedin_url is null
    and link2 is not null
)
    select distinct *
    from to_match
    join openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC h
        on to_match.link2 = replace(socials:linkedin:url, '""')
    where cast(h.experience as varchar) = '[]'


-- soon we'll have all the founders in snowflake...
-- pull the relevant fields from this dataset

select full_name
    , education
    , highlights
    , highlights_categories
    , employee_highlights_categories
    , employee_highlights_formatted
    , experience
from openviewdb.public.canal_train_test_founders_harmonic_enriched

-- can we extract values from the experience field?

select full_name, experience
    , flat.value:title::string as job_title
    , flat.value:department::string as job_dept
    , flat.value:company::string as company
    , flat.value:company:entityUrn:string as company_urn
    , flat.value:company:name:string as company_name    
from openviewdb.public.canal_train_test_founders_harmonic_enriched t,
lateral flatten(input => t.experience) as flat
where entity_urn = 'urn:harmonic:person:364161'

select full_name, experience
    , array_slice(experience,0,0)[0]:title::string as first_title
    , array_slice(experience,0,0)[0]:department::string as first_dept
from openviewdb.public.canal_train_test_founders_harmonic_enriched t
--lateral flatten(input => t.experience) as flat
where entity_urn = 'urn:harmonic:person:364161'


-- let's join all the ceos to harmonic data
create or replace table openviewdb.public.canal_train_test_founders_matched_pb_harm  as

with linkedin_join as ( --553 deals, 553 distinct founders
    select replace(linkedin_link, 'www.') as link1
        , case when right(link1,1) = '/' then left(link1, len(link1)-1) else link1 end as link2
        , deal_id
        , t1.ceo_at_time_of_deal
        , h.entity_urn
        , h.full_name as harmonic_full_name
    from openviewdb.public.canal_train_test_deals_pichbook_enriched t1
    join openviewdb.public.founder_linkedins_from_offshore_2 t2
        on t1.companies = t2.companies
        and t1.ceo_at_time_of_deal = t2.ceo_at_time_of_deal
    join (select * from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
            union all
            select * from  openviewdb.public.canal_train_test_founders_harmonic_enriched) h
        on link2 = replace(socials:linkedin:url, '""')
    where h.entity_urn not in ('urn:harmonic:person:166806623', 'urn:harmonic:person:166807241', 'urn:harmonic:person:166788893', 'urn:harmonic:person:166800437',
'urn:harmonic:person:166689897') -- get rid of some dupes 
), name_match_easy as (
    select p.deal_id, count(*)
    from openviewdb.public.canal_train_test_deals_pichbook_enriched p
    join openviewdb.public.canal_train_test_founders_harmonic_enriched h
        on p.ceo_at_time_of_deal = h.full_name
    group by 1
    having count(*) = 1
), easy_matched as ( -- 1100 ish deals, 1100ish founders
    select distinct d.deal_id, ceo_at_time_of_deal, h.entity_urn, h.full_name as harmonic_name
    from name_match_easy nme
    join openviewdb.public.canal_train_test_deals_pichbook_enriched  d
        on nme.deal_id = d.deal_id
    join openviewdb.public.canal_train_test_founders_harmonic_enriched h
        on d.ceo_at_time_of_deal = h.full_name
), no_matches as ( --1093
    select d.deal_id, d.ceo_at_time_of_deal, d.companies
    from openviewdb.public.canal_train_test_deals_pichbook_enriched  d
    left join openviewdb.public.canal_train_test_founders_harmonic_enriched c
        on d.ceo_at_time_of_deal = c.full_name
    where c.full_name is null
), looser_match as (
    select d.deal_id, d.ceo_at_time_of_deal
        , c.full_name, d.companies, c.first_name, c.last_name, c.current_job_company_name, c.current_job_title, c.experience --627
        , c.entity_urn
    from no_matches  d
    join openviewdb.public.canal_train_test_founders_harmonic_enriched c
        on d.companies = c.current_job_company_name
        and (lower(c.current_job_title) like '%founder%'
        or lower(c.current_job_title) like '%ceo%')
    order by 1
), matched as (
    select left(ceo_at_time_of_deal, position(' ', ceo_at_time_of_deal)) as pb_first_name
        , right(ceo_at_time_of_deal, len(ceo_at_time_of_deal) - position(' ', ceo_at_time_of_deal)) as pb_last_name
        , deal_id, ceo_at_time_of_deal, entity_urn, full_name
    from looser_match
    where pb_first_name = first_name
        or pb_last_name = last_name
    order by deal_id
), matched_good as (
    select deal_id, count(*)
    from matched
    group by 1
    having count(*) = 1
), matched_clean as (
    select matched.*
    from matched
    join matched_good
        on matched.deal_id = matched_good.deal_id
), matched_dupe as (
    select matched.*, h.experience, h.education, h.highlights
    from matched
    left join matched_good
        on matched.deal_id = matched_good.deal_id
    join openviewdb.public.canal_train_test_founders_harmonic_enriched h
        on matched.entity_urn = h.entity_urn
    where matched_good.deal_id is null
    order by 1,2
), matched_dupe_exceptions as (
    select *
    from matched_dupe
    where entity_urn in ('urn:harmonic:person:174049'
    , 'urn:harmonic:person:117071'
    , 'urn:harmonic:person:146810'
    , 'urn:harmonic:person:4130'
    , 'urn:harmonic:person:146102'
    , 'urn:harmonic:person:48263')
), pick_matched_dupe_exceptions as (
    select md.*
    from matched_dupe md
    join matched_dupe_exceptions mde
        where md.deal_id = mde.deal_id
        and md.entity_urn = mde.entity_urn
), pick_higher_ranking_dupe as (
    select t1.deal_id, t1.full_name, len(cast(t1.experience as varchar)) as len_exp1
        , len(cast(t1.education as varchar)) as len_edu1
        , len(cast(t1.highlights as varchar)) as len_high1
        , len_exp1+len_edu1+len_high1 as len_fields
        , rank() over( partition by t1.full_name order by len_fields desc) as rank
        , t1.entity_urn
        , t1.experience
        , t1.education
    from matched_dupe t1
    left join pick_matched_dupe_exceptions mde
        on t1.deal_id = mde.deal_id
    where mde.deal_id is null
    qualify rank = 1
), matched_2 as (
    select m.*
    from matched m
    left join pick_matched_dupe_exceptions pm on m.deal_id = pm.deal_id
    left join pick_higher_ranking_dupe ph on m.deal_id = ph.deal_id
    where pm.deal_id is null and ph.deal_id is null
)
-- query to run to check math. currently have 270 deals left to match.
/*  select count(d.deal_id), count(distinct d.deal_id)
        , count(d.ceo_at_time_of_deal), count(distinct d.ceo_at_time_of_deal)
    from openviewdb.public.canal_train_test_deals_pichbook_enriched d
    left join linkedin_join l
        on d.deal_id = l.deal_id
    left join easy_matched e
       on d.deal_id = e.deal_id
    left join matched m
        on d.deal_id = m.deal_id
    left join pick_matched_dupe_exceptions pmde
        on d.deal_id = pmde.deal_id
    left join pick_higher_ranking_dupe phrd
        on d.deal_id = phrd.deal_id
    where l.deal_id is null and e.deal_id is null and m.deal_id is null and pmde.deal_id is null and phrd.deal_id is null
*/
    select d.deal_id 
        , coalesce(l.entity_urn, e.entity_urn, m.entity_urn, pmde.entity_urn, phrd.entity_urn) as ent
        --, l.deal_id as l_deal_id
        --, e.deal_id as e_deal_id
        --, m.deal_id as m_deal_id
        --, pmde.deal_id as pmde_deal_id
        --, phrd.deal_id as phrd_deal_id
    from openviewdb.public.canal_train_test_deals_pichbook_enriched d
    left join linkedin_join l
        on d.deal_id = l.deal_id
    left join easy_matched e
       on d.deal_id = e.deal_id
    left join matched_2 m
        on d.deal_id = m.deal_id
    left join pick_matched_dupe_exceptions pmde
        on d.deal_id = pmde.deal_id
    left join pick_higher_ranking_dupe phrd
        on d.deal_id = phrd.deal_id
    
-- qa this table...    
    where d.deal_id in ('75576-34T'
,'118052-56T'
,'35391-43T'
,'180475-66T')


select count(deal_id), count(distinct deal_id) from CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM

with dupes as (
select deal_id, count(*)
from CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM
group by 1
having count(*) >1 
)
    select distinct dupes.deal_id --dupes.*, p.companies, p.ceo_at_time_of_deal
    from dupes
    join CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM c
        on dupes.deal_id = c.deal_id
    join canal_train_test_deals_pichbook_enriched p
        on dupes.deal_id = p.deal_id


    select replace(linkedin_link, 'www.') as link1
        , case when right(link1,1) = '/' then left(link1, len(link1)-1) else link1 end as link2
        , deal_id
        , t1.ceo_at_time_of_deal
        , h.entity_urn
        , h.full_name as harmonic_full_name
        , len(cast(h.experience as varchar)) as len_exp1
        , len(cast(h.education as varchar)) as len_edu1
        , len(cast(h.highlights as varchar)) as len_high1
        , len_exp1+len_edu1+len_high1 as len_fields
    from openviewdb.public.canal_train_test_deals_pichbook_enriched t1
    join openviewdb.public.founder_linkedins_from_offshore_2 t2
        on t1.companies = t2.companies
        and t1.ceo_at_time_of_deal = t2.ceo_at_time_of_deal
    join (select * from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
            union all
            select * from  openviewdb.public.canal_train_test_founders_harmonic_enriched) h
        on link2 = replace(socials:linkedin:url, '""')
    where t1.deal_id in ('75576-34T'
,'118052-56T'
,'35391-43T'
,'180475-66T')
order by 1

select * from CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM where deal_id = '82079-29T' -- two dif entity urns, so need to get distincts but also elim one 

select * from canal_train_test_deals_pichbook_enriched where deal_id = '82079-29T'


select * from openviewdb.public.canal_train_test_founders_harmonic_enriched where entity_urn in ('urn:harmonic:person:147860','urn:harmonic:person:333801','urn:harmonic:person:123007698')


-- this is growing in the join - fixed
    select replace(linkedin_link, 'www.') as link1
        , case when right(link1,1) = '/' then left(link1, len(link1)-1) else link1 end as link2
        , deal_id
        , t1.companies
        , t1.ceo_at_time_of_deal
        , h.entity_urn
        , h.full_name as harmonic_full_name
    from openviewdb.public.canal_train_test_deals_pichbook_enriched t1
    join openviewdb.public.founder_linkedins_from_offshore_2 t2
        on t1.companies = t2.companies
        and t1.ceo_at_time_of_deal = t2.ceo_at_time_of_deal
    order by 4,5
    join openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC h
        on link2 = replace(socials:linkedin:url, '""')

--106362-19T	Abstract (Multimedia and Design Software)	Joshua Brewer
--90546-22T	Abstract (Multimedia and Design Software)	Joshua Brewer
select * from openviewdb.public.canal_train_test_deals_pichbook_enriched where deal_id in ('106362-19T', '90546-22T')
select * from openviewdb.public.founder_linkedins_from_offshore_2 where companies = 'Abstract (Multimedia and Design Software)'

-- break it down some
    select count(t1.deal_id), count(distinct t1.deal_id),
        count(t1.ceo_at_time_of_deal), count(distinct t1.ceo_at_time_of_deal),
        count(distinct t1.companies, t1.ceo_at_time_of_deal)
    from openviewdb.public.canal_train_test_deals_pichbook_enriched t1
    join openviewdb.public.founder_linkedins_from_offshore_2 t2
        on t1.companies = t2.companies
        and t1.ceo_at_time_of_deal = t2.ceo_at_time_of_deal
    join openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC h
        on case when right(replace(linkedin_link, 'www.'),1) = '/' then left(replace(linkedin_link, 'www.'), len(replace(linkedin_link, 'www.'))-1) else replace(linkedin_link, 'www.') end = replace(socials:linkedin:url, '""')


select count(t1.deal_id), count(distinct t1.deal_id),
        count(t1.ceo_at_time_of_deal), count(distinct t1.ceo_at_time_of_deal),
        count(distinct t1.companies, t1.ceo_at_time_of_deal)
    from openviewdb.public.founder_linkedins_from_offshore  t1
    

with no_matches as ( --1093
    select d.ceo_at_time_of_deal, d.companies
    from openviewdb.public.canal_train_test_deals_pichbook_enriched  d
    left join  openviewdb.public.canal_train_test_founders_harmonic_enriched c
        on d.ceo_at_time_of_deal = c.full_name
    where c.full_name is null
), looser_match as (
    select d.ceo_at_time_of_deal, c.full_name, d.companies, c.first_name, c.last_name, c.current_job_company_name, c.current_job_title, c.experience --627
    from no_matches  d
    join openviewdb.public.canal_train_test_founders_harmonic_enriched c
        on d.companies = c.current_job_company_name
        and (lower(c.current_job_title) like '%founder%'
        or lower(c.current_job_title) like '%ceo%')
)--, matched as (
    select left(ceo_at_time_of_deal, position(' ', ceo_at_time_of_deal)) as pb_first_name
        , right(ceo_at_time_of_deal, len(ceo_at_time_of_deal) - position(' ', ceo_at_time_of_deal)) as pb_last_name
        , *
    from looser_match
    where pb_first_name = first_name
        or pb_last_name = last_name
)
    select *
    from no_matches t1
    left join matched t2
        on t1.ceo_at_time_of_deal = t2.ceo_at_time_of_deal
        and t1.companies = t2.companies
    where t2.companies is null;


;
-- how many did offshore team miss? 36

select distinct companies, ceo_at_time_of_deal
from openviewdb.public.founder_linkedins_from_offshore_2
where linkedin_link is null

-- how many did harmonic miss? 95
select *, replace(linkedin_link, 'www.') as link1
        , case when right(link1,1) = '/' then left(link1, len(link1)-1) else link1 end as link2
from openviewdb.public.founder_linkedins_from_offshore_2 t1
left join (select * from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
            union all
            select * from  openviewdb.public.canal_train_test_founders_harmonic_enriched) t2
    on link2 = replace(socials:linkedin:url, '""')
where t2.socials is null
and t1.linkedin_link is not null

-- how many are dud harmonic links? 132
select *, replace(linkedin_link, 'www.') as link1
        , case when right(link1,1) = '/' then left(link1, len(link1)-1) else link1 end as link2
from openviewdb.public.founder_linkedins_from_offshore_2 t1
join (select * from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
            union all
            select * from  openviewdb.public.canal_train_test_founders_harmonic_enriched) t2
    on link2 = replace(socials:linkedin:url, '""')
where (cast(t2.experience as varchar) = '[]' and cast(t2.education as varchar) = '[]')
and t1.linkedin_link is not null


select 36+95+132


-- woo, now we have a good table. let's pull harmonic fields into it

-- first who's missing
select count(distinct d.deal_id), count(distinct ceo_at_time_of_deal) -- 159 deals, 117 founder
from openviewdb.public.canal_train_test_deals_pichbook_enriched d
left join openviewdb.public.CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM f
    on d.deal_id = f.deal_id
where f.ent is not null 

select count(*)
from openviewdb.public.canal_train_test_mapping_deals_to_founders
where experience is null or education is null

-- join to harmonic data now and pull in the right fields
create or replace table openviewdb.public.canal_train_test_mapping_deals_to_founders as 

with harmonic_union as (
    select * from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
            union 
    select * from  openviewdb.public.canal_train_test_founders_harmonic_enriched
), harmonic_clean as (
    select hu.*
        , rank() over(partition by hu.entity_urn order by polytomic_created_at desc) as rank
    from harmonic_union hu
    qualify rank = 1 -- only take the rank = 1
)
    select d.deal_id, d.companies, d.ceo_at_time_of_deal, h.full_name as harmonic_full_name, h.entity_urn
        , current_job_company_name, current_job_title
        , education, highlights
        , highlights_categories
        , highlights_formatted
        , experience
    from openviewdb.public.canal_train_test_deals_pichbook_enriched d
    join openviewdb.public.CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM f
        on d.deal_id = f.deal_id
    join harmonic_clean h
        on f.ent = h.entity_urn


        select * from openviewdb.public.canal_train_test_founders_experience 
-- now make the experience table
create or replace table openviewdb.public.canal_train_test_founders_experience as

select deal_id, companies, harmonic_full_name, entity_urn, experience
    , flat.value:title::string as job_title
    , flat.value:department::string as job_department
    , flat.value:description::string as job_description
    , flat.value:start_date::string as job_start_date
    , flat.value:end_date::string as job_end_date
    , flat.value:is_current_position::string as job_is_current_position
    , flat.value:location::string as job_location
    , flat.value:role_type::string as job_role_type
    , flat.value:company:entityUrn:string as job_company_urn
    , flat.value:company:name:string as job_company_name   
    , row_number() over(partition by entity_urn order by job_title) as job_number
from openviewdb.public.canal_train_test_mapping_deals_to_founders t,
lateral flatten(input => t.experience) as flat


-- now make the education table
create or replace table openviewdb.public.canal_train_test_founders_education as

select deal_id, companies, harmonic_full_name, entity_urn, education
    , flat.value:school::string as school
    , flat.value:school:name::string as school_name
    , flat.value:school:linkedin_url::string as school_linkedin
    , flat.value:school:website_url::string as school_website
    , flat.value:school:logo_url::string as school_logo
    , flat.value:school:entity_urn::string as school_entity_urn
    , flat.value:degree::string as school_degree
    , flat.value:field::string as school_field
    , flat.value:grade::string as school_grade
    , flat.value:start_date::string as school_start_date
    , flat.value:end_date::string as school_end_date
    , row_number() over(partition by entity_urn order by school_name) as job_number
from openviewdb.public.canal_train_test_mapping_deals_to_founders t,
lateral flatten(input => t.education) as flat

-- now make the highlights table
create or replace table openviewdb.public.canal_train_test_founders_highlights as

select deal_id, companies, harmonic_full_name, entity_urn
    , flat.value:category::string as highlights_category
    , flat.value:text::string as highlights_text
    , row_number() over(partition by entity_urn order by highlights_category) as highlight_number
from openviewdb.public.canal_train_test_mapping_deals_to_founders t,
lateral flatten(input => t.highlights) as flat


-- what do the blobs look like? pulled from https://console.harmonic.ai/docs/api-reference/enrich#enrich-a-person
            "school": {
                "name": "LaLaLand U",
                "linkedin_url": "https://linkedin.com/school/university-of-lalaland",
                "website_url": "lalalandu.com",
                "logo_url": "lalalandslogo.com",
                "entity_urn": "urn:harmonic:school:uuid"
            },
            "degree": "PhD",
            "field": "ESP",
            "grade": null,
            "start_date": "2012-01-01T00:00:00",
            "end_date": "2012-01-01T00:00:00"

select *
from  openviewdb.public.canal_train_test_mapping_deals_to_founders
where employee_highlights_formatted is not null
where cast(employee_highlights_categories as varchar) <> '[]'

            "contact": {
                "emails": ["vp@things.com"],
                "phone_numbers": ["123-456-7891"]
            },
            "title": "VP of Things",
            "department": "Other",
            "description": "...",
            "start_date": "2019-01-01T00:00:00",
            "end_date": null,
            "is_current_position": true,
            "location": "Denver, Colorado, United States",
            "role_type": "EMPLOYEE",
            "company": "urn:harmonic:company:123456",
            "company_name": "Harmonic Labs",



-- testing
select full_name, experience
    , flat.value:title::string as job_title
    , flat.value:department::string as job_dept
    , flat.value:company::string as company
    , flat.value:company:entityUrn:string as company_urn
    , flat.value:company:name:string as company_name    
from openviewdb.public.canal_train_test_founders_harmonic_enriched t,
lateral flatten(input => t.experience) as flat
where entity_urn = 'urn:harmonic:person:364161'

-- qa this query...
with dupes as (
select d.deal_id, count(*)
from openviewdb.public.canal_train_test_deals_pichbook_enriched d
join openviewdb.public.CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM f
    on d.deal_id = f.deal_id
join (select * from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
            union
            select * from  openviewdb.public.canal_train_test_founders_harmonic_enriched) h
    on f.ent = h.entity_urn
group by 1
having count(*) > 1
)
    select dupes.*, d.deal_id, d.ceo_at_time_of_deal, f.*, f.ent, h.entity_urn
    from dupes
    join openviewdb.public.canal_train_test_deals_pichbook_enriched d
        on dupes.deal_id = d.deal_id
join openviewdb.public.CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM f
    on d.deal_id = f.deal_id
join (select poly from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
            union
            select * from  openviewdb.public.canal_train_test_founders_harmonic_enriched) h
    on f.ent = h.entity_urn
    order by 1


    select * from CANAL_TRAIN_TEST_FOUNDERS_MATCHED_PB_HARM where deal_id = '116111-35T' ent = 'urn:harmonic:person:76956'

    select * from (select * from openviewdb.public.CANAL_EXTRA_FOUNDERS_FROM_HARMONIC
            union all
            select * from  openviewdb.public.canal_train_test_founders_harmonic_enriched)
            where entity_urn  = 'urn:harmonic:person:76956'

            
