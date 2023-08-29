/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     07.03.2023 0:44:41                           */
/*==============================================================*/


drop table if exists stage.aircrafts;

drop table if exists stage.airlines;

drop table if exists stage.airports;

drop table if exists stage.continents;

drop table if exists stage.countries;

drop table if exists stage.dates;

drop table if exists stage.designators;

drop table if exists stage.flights;

drop table if exists stage.regions;

/*==============================================================*/
/* Table: aircrafts                                             */
/*==============================================================*/
create table stage.aircrafts
(
    aircraft_id     SERIAL       not null,
    registration    VARCHAR(12)  not null,
    model_code      VARCHAR(4)   null,
    model_text      VARCHAR(100) null,
    country_code    VARCHAR(2)   null,
    production_date DATE         null,
    owner_icao      VARCHAR(3)   null,
    constraint PK_AIRCRAFTS primary key (aircraft_id)
);

/*==============================================================*/
/* Table: airlines                                              */
/*==============================================================*/
create table stage.airlines
(
    airline_pk_ser SERIAL       not null,
    airline_id     INT4         not null,
    name           VARCHAR(100) not null,
    alias          VARCHAR(64)  null,
    code           VARCHAR(8)   null,
    callsign       VARCHAR(50)  null,
    country        VARCHAR(64)  null,
    active         BOOL         not null,
    constraint PK_AIRLINES primary key (airline_pk_ser)
);

/*==============================================================*/
/* Table: airports                                              */
/*==============================================================*/
create table stage.airports
(
    airport_id SERIAL       not null,
    code       VARCHAR(8)   null,
    type       VARCHAR(16)  not null,
    name       VARCHAR(200) not null,
    latitude   FLOAT8       not null,
    longitude  FLOAT8       not null,
    elevation  INT4         null,
    region     VARCHAR(8)   not null,
    gps_code   VARCHAR(8)   null,
    constraint PK_AIRPORTS primary key (airport_id)
);

/*==============================================================*/
/* Table: continents                                            */
/*==============================================================*/
create table stage.continents
(
    continent_id SERIAL      not null,
    code         VARCHAR(2)  not null,
    name         VARCHAR(20) not null,
    constraint PK_CONTINENTS primary key (continent_id)
);

/*==============================================================*/
/* Table: countries                                             */
/*==============================================================*/
create table stage.countries
(
    country_id SERIAL      not null,
    code       VARCHAR(2)  not null,
    name       VARCHAR(64) not null,
    continent  VARCHAR(2)  not null,
    constraint PK_COUNTRIES primary key (country_id)
);

/*==============================================================*/
/* Table: dates                                                 */
/*==============================================================*/
create table stage.dates
(
    date_id      SERIAL not null,
    the_date     DATE   not null,
    weekday      INT2   not null,
    month        INT4   not null,
    year         INT2   not null,
    quarter      INT2   not null,
    day_of_year  INT2   not null,
    weekend      BOOL   not null,
    week_of_year INT2   not null,
    constraint PK_DATES primary key (date_id)
);

/*==============================================================*/
/* Table: designators                                           */
/*==============================================================*/
create table stage.designators
(
    model_id            SERIAL       not null,
    name                VARCHAR(255) not null,
    description         VARCHAR(3)   null,
    turbulence_category VARCHAR(3)   null,
    designator          VARCHAR(4)   not null,
    manufacturer        VARCHAR(64)  null,
    type                VARCHAR(20)  null,
    engine_count        INT2         null,
    engine_type         VARCHAR(30)  null,
    constraint PK_DESIGNATORS primary key (model_id)
);

/*==============================================================*/
/* Table: flights                                               */
/*==============================================================*/
create table stage.flights
(
    flight_pk_ser         SERIAL      not null,
    flight_id             INT8        not null,
    route_number          VARCHAR(12) not null,
    aircraft_registration VARCHAR(10) null,
    airline_icao          VARCHAR(5)  null,
    airport_origin        VARCHAR(5)  null,
    airport_destination   VARCHAR(5)  null,
    scheduled_departure   FLOAT8      null,
    scheduled_arrival     FLOAT8      null,
    real_departure        FLOAT8      null,
    real_arrival          FLOAT8      null,
    constraint PK_FLIGHTS primary key (flight_pk_ser)
);

/*==============================================================*/
/* Table: regions                                               */
/*==============================================================*/
create table stage.regions
(
    region_id SERIAL       not null,
    code      VARCHAR(8)   not null,
    name      VARCHAR(100) not null,
    country   VARCHAR(2)   not null,
    constraint PK_REGIONS primary key (region_id)
);

