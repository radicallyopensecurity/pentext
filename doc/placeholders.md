PenText 2.0 Placeholders

###client_long
*Refers to:* /*/meta//client/full_name
Client's full name (e.g. Sitting Duck B.V.)

###client_short
*Refers to:* /*/meta//client/short_name
Client's shorter name (e.g. Sitting Duck)

###client_street
*Refers to:* /*/meta//client/address
Client's street + number

###client_postalcode
*Refers to:* /*/meta//client/postal_code
Client's postal code

###client_city
*Refers to:* /*/meta//client/city
Client's city

###client_country
*Refers to:* /*/meta//client/country
Client's country

###client_postal_code
*Refers to:* /*/meta//client/postal_code
Client's postal code

###client_legal_rep
*Refers to:* /*/meta//client/legal_rep
Name of client's legal representative (to sign quotes)

###client_waiver_rep
*Refers to:* /*/meta//client/waiver_rep
Name of client's waiver-signing representative (to sign waiver)

###client_poc1
*Refers to:* /*/meta//client/poc1
Name of client's first point of contact when the pentest is underway

###client_coc
*Refers to:* /*/meta//client/coc
Client's chamber of commerce number

###client_ref
*Refers to:* /*/meta/client_reference
Client's reference number for the project (sometimes they want this to be shown in the quote/report/invoice)

###client_rate
*Refers to:* /*/meta//client/rates/rate[@title = $roleTitle] (rate per role category)

###company_long
*Refers to:* /*/meta/company/full_name
Company's full name (e.g. Radically Open Security B.V.)

###company_short
*Refers to:* /*/meta/company/short_name
Company's short name (e.g. ROS)

###company_address
*Refers to:* /*/meta/company/address
Company's street name & number

###company_city
*Refers to:* /*/meta/company/city
Company's city

###company_postalcode
*Refers to:* /*/meta/company/postal_code
Company's postal code

###company_country
*Refers to:* /*/meta/company/country
Company's country

###company_svc_long
*Refers to:* /*/meta/offered_service_long
Long name of service offered (e.g. Pentesting Services)

###company_svc_short
*Refers to:* /*/meta/offered_service_short
Short name of service offered (e.g. Pentest)

###company_legal_rep
*Refers to:* /*/meta/company/legal_rep
Company's legal representative

###company_poc1
*Refers to:* /*/meta/company/poc1
Company's first point of contact during the pentest

###company_email
*Refers to:* /*/meta/company/email
Company's email address

## Application / project

###t_app
*Refers to:* /*/meta/activityinfo/target_application
Name of the tested application (if any)

###t_app_producer
*Refers to:* /*/meta/activityinfo/target_application_producer
Name of the company producing the tested application

###p_duration
*Refers to:* /*/meta/activityinfo/duration
Test duration

###p_persondays
*Refers to:* /*/meta/activityinfo/persondays
Persondays allotted to test

###p_boxtype
*Refers to:* /*/meta/activityinfo/type
Pentest boxtype (crystal, black, ...)

###p_fee*
Refers to:* /offerte/meta/activityinfo/fee"
Agreed fee (can be used in QUOTES only!)

###p_startdate
*Refers to:* /*/meta/activityinfo/planning/start
Start date of test

###p_draftdue
*Refers to:* /*/meta/activityinfo/planning/draft
When the first draft version is due

###p_enddate
*Refers to:* /*/meta/activityinfo/planning/end
End date of test

###p_reportdue
*Refers to:* /*/meta/activityinfo/report_due
Due date of pentest report

###p_location
*Refers to:* /*/meta/activityinfo/location
Location of project

###p_participants
*Refers to:* /*/meta/activityinfo/participants
Maximum number of participants

###finding_count
*Refers to:* total finding count. Use @threatLevel or @status in this placeholder to filter by threatlevel or status. Can be used only in reports!

###todo
Inserts a highly visible 'todo' reminder in snippets (or elsewhere) as a reminder to the editor that info is missing at that point.


## Contract-specific placeholders
###engagement_description
*Refers to:* /contract/meta/scope/engagement_description
###secondpartyrole
*Refers to:* /contract/meta/scope/secondpartyrole
###contract_start_date
*Refers to:* /contract/meta/work/start_date
###contract_end_date
*Refers to:* /contract/meta/work/end_date
###contract_period
*Refers to:* difference between /contract/meta/work/start_date and /contract/meta/work/end_date (i.e. a period of time)
###contract_total_fee
*Refers to:* calculated total fee
###contract_planned_hours
*Refers to:* /contract/meta/work/planning/hours
###contract_period_unit
*Refers to:* /contract/meta/work/planning/per
###contract_activities
*Refers to:* /contract/meta/work/activities/activity (multiple activities possible)
###contractor_name_company
*Refers to:* /contract/meta/contractor/name (and /contract/meta/contractor/ctcompany, if present)
###contractor_name
*Refers to:* /contract/meta/contractor/name
###contractor_company
*Refers to:* /contract/meta/contractor/ctcompany
###contractor_address
*Refers to:* /contract/meta/contractor/address
###contractor_city
*Refers to:* /contract/meta/contractor/city
###contractor_postalcode
*Refers to:* /contract/meta/contractor/postal_code
###contractor_country
*Refers to:* /contract/meta/contractor/country
###contractor_hourly_fee
*Refers to:* /contract/meta/contractor/hourly_fee
###contractor_email
*Refers to:* /contract/meta/contractor/email
###contractor_possessive_pronoun
*Refers to:* /contract/meta/contractor/@sex (will show as his/her/their depending on sex)
###contractor_subject_pronoun
*Refers to:* /contract/meta/contractor/@sex (will show as he/she/xe depending on sex)
###contractor_object_pronoun
*Refers to:* /contract/meta/contractor/@sex (will show as him/her/them depending on sex)
###generate_raterevisiondate
*Refers to:* //meta//client/rates/@lastrevisiondate

## Incident Response Quote Specific Placeholders
###ir_ora_rate
*Refers to:* /*/meta/activityinfo/organizational_readiness_assessment/rate
###ir_sim_rate
*Refers to:* /*/meta/activityinfo/security_incident_management/rate
###ir_taa_rate
*Refers to:* /*/meta/activityinfo/technical_artefact_analysis/rate
