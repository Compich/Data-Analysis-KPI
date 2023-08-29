-- Designators
INSERT INTO public.manufacturers_dim (name)
SELECT DISTINCT manufacturer
FROM stage.designators
WHERE manufacturer IS NOT NULL
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.turbulence_categories_dim (name)
SELECT DISTINCT turbulence_category
FROM stage.designators
WHERE turbulence_category IS NOT NULL
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.aircraft_types_dim (name)
SELECT DISTINCT type
FROM stage.designators
WHERE type IS NOT NULL
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.models_descriptions_dim (name)
SELECT DISTINCT description
FROM stage.designators
WHERE description IS NOT NULL
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.engine_types_dim (name)
SELECT DISTINCT engine_type
FROM stage.designators
WHERE designators.engine_type IS NOT NULL
ON CONFLICT (name) DO NOTHING;


-- Geo zones
INSERT INTO public.continents_dim (code, name)
SELECT DISTINCT ON (stage.continents.code) code, name
FROM stage.continents
ORDER BY code, stage.continents.continent_id DESC
ON CONFLICT (code) DO UPDATE SET name = excluded.name;

INSERT INTO public.countries_dim (code, continent_id, name)
SELECT DISTINCT ON (stage.countries.code) stage.countries.code,
                                          public.continents_dim.continent_id,
                                          stage.countries.name
FROM stage.countries
         INNER JOIN public.continents_dim ON stage.countries.continent = public.continents_dim.code
ORDER BY code, stage.countries.country_id DESC
ON CONFLICT (code) DO UPDATE SET continent_id = excluded.continent_id,
                                 name         = excluded.name;

INSERT INTO public.regions_dim (code, country_id, name)
SELECT DISTINCT ON (stage.regions.code) stage.regions.code,
                                        public.countries_dim.country_id,
                                        stage.regions.name
FROM stage.regions
         INNER JOIN public.countries_dim ON stage.regions.country = public.countries_dim.code
ORDER BY code, stage.regions.region_id DESC
ON CONFLICT (code) DO UPDATE SET country_id = excluded.country_id,
                                 name       = excluded.name;


-- Airports
INSERT INTO public.airports_types_dim (name)
SELECT DISTINCT stage.airports.type
FROM stage.airports
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.airports_dim (code, type_id, name, latitude, longitude, elevation, region_id, gps_code)
SELECT DISTINCT ON (stage.airports.code) stage.airports.code,
                                         public.airports_types_dim.type_id,
                                         stage.airports.name,
                                         stage.airports.latitude,
                                         stage.airports.longitude,
                                         stage.airports.elevation,
                                         public.regions_dim.region_id,
                                         stage.airports.gps_code
FROM stage.airports
         LEFT JOIN public.airports_types_dim ON stage.airports.type = public.airports_types_dim.name
         LEFT JOIN public.regions_dim ON stage.airports.region = public.regions_dim.code
ORDER BY stage.airports.code, stage.airports.airport_id DESC
ON CONFLICT (code) DO UPDATE SET type_id   = excluded.type_id,
                                 name      = excluded.name,
                                 latitude  = excluded.latitude,
                                 longitude = excluded.longitude,
                                 elevation = excluded.elevation,
                                 region_id = excluded.region_id,
                                 gps_code  = excluded.gps_code;


-- Airlines
INSERT INTO public.airlines_dim (code, airline_id, name, alias, callsign, country_id, active)
SELECT DISTINCT ON (stage.airlines.code) stage.airlines.code,
                                         stage.airlines.airline_id,
                                         stage.airlines.name,
                                         stage.airlines.alias,
                                         stage.airlines.callsign,
                                         public.countries_dim.country_id,
                                         stage.airlines.active
FROM stage.airlines
         LEFT JOIN public.countries_dim ON stage.airlines.country = public.countries_dim.name
ORDER BY stage.airlines.code, stage.airlines.airline_pk_ser DESC
ON CONFLICT (airline_id) DO UPDATE SET alias      = excluded.alias,
                                       code       = excluded.code,
                                       callsign   = excluded.callsign,
                                       country_id = excluded.country_id,
                                       active     = excluded.active;


-- Routes
INSERT INTO public.routes_dim (code)
SELECT DISTINCT stage.flights.route_number
FROM stage.flights
ON CONFLICT (code) DO NOTHING;

-- Dates
INSERT INTO public.dates_dim (the_date, weekday, month, year, quarter, day_of_year, weekend, week_of_year)
SELECT DISTINCT ON (stage.dates.the_date) stage.dates.the_date,
                                          stage.dates.weekday,
                                          stage.dates.month,
                                          stage.dates.year,
                                          stage.dates.quarter,
                                          stage.dates.day_of_year,
                                          stage.dates.weekend,
                                          stage.dates.week_of_year
FROM stage.dates
ORDER BY stage.dates.the_date, stage.dates.date_id DESC
ON CONFLICT (the_date) DO UPDATE SET weekend = excluded.weekend;


-- Designators
INSERT INTO designators_dim (name, designator, description_id, turbulence_category_id, manufacturer_id, type_id,
                             engine_count, engine_type_id)
SELECT DISTINCT ON (stage.designators.name, stage.designators.designator) stage.designators.name,
                                                                          stage.designators.designator,
                                                                          public.models_descriptions_dim.description_id,
                                                                          public.turbulence_categories_dim.category_id,
                                                                          public.manufacturers_dim.manufacturer_id,
                                                                          public.aircraft_types_dim.type_id,
                                                                          stage.designators.engine_count,
                                                                          public.engine_types_dim.engine_type_id
FROM stage.designators
         LEFT JOIN public.models_descriptions_dim ON public.models_descriptions_dim.name = stage.designators.description
         LEFT JOIN public.turbulence_categories_dim
                   ON public.turbulence_categories_dim.name = stage.designators.turbulence_category
         LEFT JOIN public.manufacturers_dim ON public.manufacturers_dim.name = stage.designators.manufacturer
         LEFT JOIN public.aircraft_types_dim ON public.aircraft_types_dim.name = stage.designators.type
         LEFT JOIN public.engine_types_dim ON public.engine_types_dim.name = stage.designators.engine_type
ORDER BY stage.designators.name, stage.designators.designator, stage.designators.model_id DESC
ON CONFLICT (name, designator) DO UPDATE SET description_id         = excluded.description_id,
                                             turbulence_category_id = excluded.turbulence_category_id,
                                             manufacturer_id        = excluded.manufacturer_id,
                                             type_id                = excluded.type_id,
                                             engine_count           = excluded.engine_count,
                                             engine_type_id         = excluded.engine_type_id;

DROP TABLE IF EXISTS temp_aircrafts;