/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     07.03.2023 0:45:27                           */
/*==============================================================*/


drop index if exists aircraft_type_name_unique cascade;

drop table if exists aircraft_types_dim cascade;

drop index if exists aircraft_registration_unique cascade;

drop table if exists aircrafts_dim cascade;

drop index if exists airline_code_unique cascade;

drop table if exists airlines_dim cascade;

drop index if exists airport_code_unique cascade;

drop table if exists airports_dim cascade;

drop index if exists airport_type_name_unique cascade;

drop table if exists airports_types_dim cascade;

drop index if exists continent_code_unique cascade;

drop table if exists continents_dim cascade;

drop index if exists country_code_unique cascade;

drop table if exists countries_dim cascade;

drop index if exists time_date_unique cascade;

drop table if exists dates_dim cascade;

drop index if exists designator_unique cascade;

drop table if exists designators_dim cascade;

drop index if exists engine_type_name_unique cascade;

drop table if exists engine_types_dim cascade;

drop table if exists flights_fact cascade;

drop index if exists manufacturer_name_unique cascade;

drop table if exists manufacturers_dim cascade;

drop index if exists model_description_name_unique cascade;

drop table if exists models_descriptions_dim cascade;

drop index if exists region_code_unique cascade;

drop table if exists regions_dim cascade;

drop index if exists route_code_unique cascade;

drop table if exists routes_dim cascade;

drop index if exists turbulence_name cascade;

drop table if exists turbulence_categories_dim cascade;

/*==============================================================*/
/* Table: aircraft_types_dim                                    */
/*==============================================================*/
create table aircraft_types_dim (
                                    type_id              SERIAL               not null,
                                    name                 VARCHAR(20)          not null,
                                    constraint PK_AIRCRAFT_TYPES_DIM primary key (type_id)
);

/*==============================================================*/
/* Index: aircraft_type_name_unique                             */
/*==============================================================*/
create unique index aircraft_type_name_unique on aircraft_types_dim (
                                                                     name
    );

/*==============================================================*/
/* Table: aircrafts_dim                                         */
/*==============================================================*/
create table aircrafts_dim (
                               aircraft_id          SERIAL               not null,
                               registration         VARCHAR(12)          not null,
                               model_id             INT4                 null,
                               model_text           VARCHAR(100)         null,
                               country_id           INT4                 null,
                               production_date_id   INT4                 null,
                               owner_id             INT4                 null,
                               constraint PK_AIRCRAFTS_DIM primary key (aircraft_id)
);

/*==============================================================*/
/* Index: aircraft_registration_unique                          */
/*==============================================================*/
create unique index aircraft_registration_unique on aircrafts_dim (
                                                                   registration
    );

/*==============================================================*/
/* Table: airlines_dim                                          */
/*==============================================================*/
create table airlines_dim (
                              airline_id           SERIAL               not null,
                              name                 VARCHAR(100)         null,
                              alias                VARCHAR(64)          null,
                              code                 VARCHAR(8)           null,
                              callsign             VARCHAR(50)          null,
                              country_id           INT4                 null,
                              active               BOOL                 null,
                              constraint PK_AIRLINES_DIM primary key (airline_id)
);

/*==============================================================*/
/* Index: airline_code_unique                                   */
/*==============================================================*/
create unique index airline_code_unique on airlines_dim (
                                                         code
    );

/*==============================================================*/
/* Table: airports_dim                                          */
/*==============================================================*/
create table airports_dim (
                              airport_id           SERIAL               not null,
                              code                 VARCHAR(8)           null,
                              type_id              INT4                 null,
                              name                 VARCHAR(200)         null,
                              latitude             FLOAT8               null,
                              longitude            FLOAT8               null,
                              elevation            INT4                 null,
                              region_id            INT4                 null,
                              gps_code             VARCHAR(8)           null,
                              constraint PK_AIRPORTS_DIM primary key (airport_id)
);

/*==============================================================*/
/* Index: airport_code_unique                                   */
/*==============================================================*/
create unique index airport_code_unique on airports_dim (
                                                         code
    );

/*==============================================================*/
/* Table: airports_types_dim                                    */
/*==============================================================*/
create table airports_types_dim (
                                    type_id              SERIAL               not null,
                                    name                 VARCHAR(16)          not null,
                                    constraint PK_AIRPORTS_TYPES_DIM primary key (type_id)
);

/*==============================================================*/
/* Index: airport_type_name_unique                              */
/*==============================================================*/
create unique index airport_type_name_unique on airports_types_dim (
                                                                    name
    );

/*==============================================================*/
/* Table: continents_dim                                        */
/*==============================================================*/
create table continents_dim (
                                continent_id         SERIAL               not null,
                                code                 VARCHAR(2)           not null,
                                name                 VARCHAR(20)          not null,
                                constraint PK_CONTINENTS_DIM primary key (continent_id)
);

/*==============================================================*/
/* Index: continent_code_unique                                 */
/*==============================================================*/
create unique index continent_code_unique on continents_dim (
                                                             code
    );

/*==============================================================*/
/* Table: countries_dim                                         */
/*==============================================================*/
create table countries_dim (
                               country_id           SERIAL               not null,
                               continent_id         INT4                 not null,
                               code                 VARCHAR(2)           not null,
                               name                 VARCHAR(64)          not null,
                               constraint PK_COUNTRIES_DIM primary key (country_id)
);

/*==============================================================*/
/* Index: country_code_unique                                   */
/*==============================================================*/
create unique index country_code_unique on countries_dim (
                                                          code
    );

/*==============================================================*/
/* Table: dates_dim                                             */
/*==============================================================*/
create table dates_dim (
                           date_id              SERIAL               not null,
                           the_date             DATE                 not null,
                           weekday              INT2                 not null,
                           month                INT4                 not null,
                           year                 INT2                 not null,
                           quarter              INT2                 not null,
                           day_of_year          INT2                 not null,
                           weekend              BOOL                 not null,
                           week_of_year         INT2                 not null,
                           constraint PK_DATES_DIM primary key (date_id)
);

/*==============================================================*/
/* Index: time_date_unique                                      */
/*==============================================================*/
create unique index time_date_unique on dates_dim (
                                                   the_date
    );

/*==============================================================*/
/* Table: designators_dim                                       */
/*==============================================================*/
create table designators_dim (
                                 model_id             SERIAL               not null,
                                 name                 VARCHAR(255)         null,
                                 description_id       INT4                 null,
                                 turbulence_category_id INT4                 null,
                                 designator           VARCHAR(4)           null,
                                 manufacturer_id      INT4                 null,
                                 type_id              INT4                 null,
                                 engine_count         INT2                 null,
                                 engine_type_id       INT4                 null,
                                 constraint PK_DESIGNATORS_DIM primary key (model_id)
);

/*==============================================================*/
/* Index: designator_unique                                     */
/*==============================================================*/
create unique index designator_unique on designators_dim (
                                                          designator,
                                                          name
    );

/*==============================================================*/
/* Table: engine_types_dim                                      */
/*==============================================================*/
create table engine_types_dim (
                                  engine_type_id       SERIAL               not null,
                                  name                 VARCHAR(30)          not null,
                                  constraint PK_ENGINE_TYPES_DIM primary key (engine_type_id)
);

/*==============================================================*/
/* Index: engine_type_name_unique                               */
/*==============================================================*/
create unique index engine_type_name_unique on engine_types_dim (
                                                                 name
    );

/*==============================================================*/
/* Table: flights_fact                                          */
/*==============================================================*/
create table flights_fact (
                              flight_id            INT8                 not null,
                              route_id             INT4                 null,
                              aircraft_id          INT4                 null,
                              airline_id           INT4                 null,
                              airport_origin_id    INT4                 null,
                              airport_destination_id INT4                 null,
                              scheduled_departure_date_id INT4                 null,
                              scheduled_departure_time TIME                 null,
                              scheduled_arrival_date_id INT4                 null,
                              scheduled_arrival_time TIME                 null,
                              real_departure_date_id INT4                 null,
                              real_departure_time  TIME                 null,
                              real_arrival_date_id INT4                 null,
                              real_arrival_time    TIME                 null,
                              constraint PK_FLIGHTS_FACT primary key (flight_id)
);

/*==============================================================*/
/* Table: manufacturers_dim                                     */
/*==============================================================*/
create table manufacturers_dim (
                                   manufacturer_id      SERIAL               not null,
                                   name                 VARCHAR(64)          not null,
                                   constraint PK_MANUFACTURERS_DIM primary key (manufacturer_id)
);

/*==============================================================*/
/* Index: manufacturer_name_unique                              */
/*==============================================================*/
create unique index manufacturer_name_unique on manufacturers_dim (
                                                                   name
    );

/*==============================================================*/
/* Table: models_descriptions_dim                               */
/*==============================================================*/
create table models_descriptions_dim (
                                         description_id       SERIAL               not null,
                                         name                 VARCHAR(3)           not null,
                                         constraint PK_MODELS_DESCRIPTIONS_DIM primary key (description_id)
);

/*==============================================================*/
/* Index: model_description_name_unique                         */
/*==============================================================*/
create unique index model_description_name_unique on models_descriptions_dim (
                                                                              name
    );

/*==============================================================*/
/* Table: regions_dim                                           */
/*==============================================================*/
create table regions_dim (
                             region_id            SERIAL               not null,
                             country_id           INT4                 not null,
                             code                 VARCHAR(8)           not null,
                             name                 VARCHAR(100)         not null,
                             constraint PK_REGIONS_DIM primary key (region_id)
);

/*==============================================================*/
/* Index: region_code_unique                                    */
/*==============================================================*/
create unique index region_code_unique on regions_dim (
                                                       code
    );

/*==============================================================*/
/* Table: routes_dim                                            */
/*==============================================================*/
create table routes_dim (
                            route_id             SERIAL               not null,
                            code                 VARCHAR(12)          not null,
                            constraint PK_ROUTES_DIM primary key (route_id)
);

/*==============================================================*/
/* Index: route_code_unique                                     */
/*==============================================================*/
create unique index route_code_unique on routes_dim (
                                                     code
    );

/*==============================================================*/
/* Table: turbulence_categories_dim                             */
/*==============================================================*/
create table turbulence_categories_dim (
                                           category_id          SERIAL               not null,
                                           name                 VARCHAR(3)           not null,
                                           constraint PK_TURBULENCE_CATEGORIES_DIM primary key (category_id)
);

/*==============================================================*/
/* Index: turbulence_name                                       */
/*==============================================================*/
create unique index turbulence_name on turbulence_categories_dim (
                                                                  name
    );

alter table aircrafts_dim
    add constraint FK_AIRCRAFT_REFERENCE_DATES_DI foreign key (production_date_id)
        references dates_dim (date_id)
        on delete restrict on update cascade;

alter table aircrafts_dim
    add constraint FK_AIRCRAFT_REFERENCE_COUNTRIE foreign key (country_id)
        references countries_dim (country_id)
        on delete restrict on update restrict;

alter table aircrafts_dim
    add constraint FK_AIRCRAFT_REFERENCE_DESIGNAT foreign key (model_id)
        references designators_dim (model_id)
        on delete restrict on update restrict;

alter table aircrafts_dim
    add constraint FK_AIRCRAFT_REFERENCE_AIRLINES foreign key (owner_id)
        references airlines_dim (airline_id)
        on delete restrict on update restrict;

alter table airlines_dim
    add constraint FK_AIRLINES_REFERENCE_COUNTRIE foreign key (country_id)
        references countries_dim (country_id)
        on delete restrict on update restrict;

alter table airports_dim
    add constraint FK_AIRPORTS_REFERENCE_REGIONS_ foreign key (region_id)
        references regions_dim (region_id)
        on delete restrict on update restrict;

alter table airports_dim
    add constraint FK_AIRPORTS_REFERENCE_AIRPORTS foreign key (type_id)
        references airports_types_dim (type_id)
        on delete restrict on update restrict;

alter table countries_dim
    add constraint FK_COUNTRIE_REFERENCE_CONTINEN foreign key (continent_id)
        references continents_dim (continent_id)
        on delete restrict on update restrict;

alter table designators_dim
    add constraint FK_DESIGNAT_REFERENCE_ENGINE_T foreign key (engine_type_id)
        references engine_types_dim (engine_type_id)
        on delete restrict on update restrict;

alter table designators_dim
    add constraint FK_DESIGNAT_REFERENCE_MODELS_D foreign key (description_id)
        references models_descriptions_dim (description_id)
        on delete restrict on update restrict;

alter table designators_dim
    add constraint FK_DESIGNAT_REFERENCE_AIRCRAFT foreign key (type_id)
        references aircraft_types_dim (type_id)
        on delete restrict on update restrict;

alter table designators_dim
    add constraint FK_DESIGNAT_REFERENCE_TURBULEN foreign key (turbulence_category_id)
        references turbulence_categories_dim (category_id)
        on delete restrict on update restrict;

alter table designators_dim
    add constraint FK_DESIGNAT_REFERENCE_MANUFACT foreign key (manufacturer_id)
        references manufacturers_dim (manufacturer_id)
        on delete restrict on update restrict;

alter table flights_fact
    add constraint FK_FLIGHTS__REFERENCE_ROUTES_D foreign key (route_id)
        references routes_dim (route_id)
        on delete restrict on update restrict;

alter table flights_fact
    add constraint FK_FLIGHTS__REFERENCE_AIRCRAFT foreign key (aircraft_id)
        references aircrafts_dim (aircraft_id)
        on delete restrict on update cascade;

alter table flights_fact
    add constraint FK_FLIGHTS__REFERENCE_AIRLINES foreign key (airline_id)
        references airlines_dim (airline_id)
        on delete restrict on update cascade;

alter table flights_fact
    add constraint FK_FLIGHTS__AIRPORT_D_AIRPORTS foreign key (airport_destination_id)
        references airports_dim (airport_id)
        on delete restrict on update cascade;

alter table flights_fact
    add constraint FK_FLIGHTS__FLIGHT_AI_AIRPORTS foreign key (airport_origin_id)
        references airports_dim (airport_id)
        on delete restrict on update cascade;

alter table flights_fact
    add constraint FK_FLIGHTS__FLIGHT_RE_ARR_t foreign key (real_arrival_date_id)
        references dates_dim (date_id)
        on delete restrict on update cascade;

alter table flights_fact
    add constraint FK_FLIGHTS__FLIGHT_RE_DATES_DI foreign key (real_departure_date_id)
        references dates_dim (date_id)
        on delete restrict on update cascade;

alter table flights_fact
    add constraint FK_FLIGHTS__FLIGHT_SC_ARR foreign key (scheduled_arrival_date_id)
        references dates_dim (date_id)
        on delete restrict on update cascade;

alter table flights_fact
    add constraint FK_FLIGHTS__FLIGHT_SC_DEP foreign key (scheduled_departure_date_id)
        references dates_dim (date_id)
        on delete restrict on update cascade;

alter table regions_dim
    add constraint FK_REGIONS__REFERENCE_COUNTRIE foreign key (country_id)
        references countries_dim (country_id)
        on delete restrict on update restrict;

