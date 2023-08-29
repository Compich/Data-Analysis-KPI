-- Aircrafts
SELECT *
FROM temp_aircrafts;
INSERT INTO public.aircrafts_dim (registration, model_id, model_text, country_id, production_date_id, owner_id)
SELECT DISTINCT ON (temp_aircrafts.registration) temp_aircrafts.registration,
                                                 public.designators_dim.model_id,
                                                 temp_aircrafts.model_text,
                                                 public.countries_dim.country_id,
                                                 public.dates_dim.date_id,
                                                 public.airlines_dim.airline_id
FROM temp_aircrafts
         LEFT JOIN public.designators_dim ON temp_aircrafts.model_code = public.designators_dim.designator AND
                                             temp_aircrafts.linked_model_text = public.designators_dim.name
         LEFT JOIN public.countries_dim ON temp_aircrafts.country_code = public.countries_dim.code
         LEFT JOIN public.dates_dim ON temp_aircrafts.production_date = public.dates_dim.the_date
         LEFT JOIN public.airlines_dim ON temp_aircrafts.owner_icao = public.airlines_dim.code
ORDER BY temp_aircrafts.registration, temp_aircrafts.aircraft_id DESC
ON CONFLICT (registration) DO UPDATE SET model_id           = excluded.model_id,
                                         model_text         = excluded.model_text,
                                         country_id         = excluded.country_id,
                                         production_date_id = excluded.production_date_id,
                                         owner_id           = excluded.owner_id;
DROP TABLE IF EXISTS temp_aircrafts;

INSERT INTO public.flights_fact (flight_id, route_id, aircraft_id, airline_id, airport_origin_id,
                                 airport_destination_id, scheduled_departure_date_id, scheduled_departure_time,
                                 scheduled_arrival_date_id, scheduled_arrival_time, real_departure_date_id,
                                 real_departure_time, real_arrival_date_id, real_arrival_time)
SELECT flight_id,
       public.routes_dim.route_id,
       public.aircrafts_dim.aircraft_id,
       public.airlines_dim.airline_id,
       ap1.airport_id,
       ap2.airport_id,
       d1.date_id,
       scheduled_departure::TIME,
       d2.date_id,
       scheduled_arrival::TIME,
       d3.date_id,
       real_departure::TIME,
       d4.date_id,
       real_arrival::TIME
FROM (SELECT DISTINCT ON (stage.flights.flight_id) stage.flights.flight_id,
                                                   stage.flights.route_number,
                                                   stage.flights.aircraft_registration,
                                                   stage.flights.airline_icao,
                                                   stage.flights.airport_origin,
                                                   stage.flights.airport_destination,
                                                   TO_TIMESTAMP(stage.flights.scheduled_departure) AS scheduled_departure,
                                                   TO_TIMESTAMP(stage.flights.scheduled_arrival)   AS scheduled_arrival,
                                                   TO_TIMESTAMP(stage.flights.real_departure)      AS real_departure,
                                                   TO_TIMESTAMP(stage.flights.real_arrival)        AS real_arrival
      FROM stage.flights
      ORDER BY flight_id DESC) AS flights_subq
         LEFT JOIN public.routes_dim ON route_number = public.routes_dim.code
         LEFT JOIN public.aircrafts_dim ON aircraft_registration = public.aircrafts_dim.registration
         LEFT JOIN public.airlines_dim ON airline_icao = public.airlines_dim.code
         LEFT JOIN public.airports_dim ap1 ON airport_origin = ap1.code
         LEFT JOIN public.airports_dim ap2 ON airport_destination = ap2.code
         LEFT JOIN public.dates_dim d1 ON scheduled_departure::date = d1.the_date
         LEFT JOIN public.dates_dim d2 ON scheduled_arrival::date = d2.the_date
         LEFT JOIN public.dates_dim d3 ON real_departure::date = d3.the_date
         LEFT JOIN public.dates_dim d4 ON real_arrival::date = d4.the_date
ON CONFLICT (flight_id) DO UPDATE SET route_id                    = excluded.route_id,
                                      aircraft_id                 = excluded.aircraft_id,
                                      airline_id                  = excluded.airline_id,
                                      airport_origin_id           = excluded.airport_origin_id,
                                      airport_destination_id      = excluded.airport_destination_id,
                                      scheduled_departure_date_id = excluded.scheduled_departure_date_id,
                                      scheduled_departure_time    = excluded.scheduled_departure_time,
                                      scheduled_arrival_date_id   = excluded.scheduled_arrival_date_id,
                                      scheduled_arrival_time      = excluded.scheduled_arrival_time,
                                      real_departure_date_id      = excluded.real_departure_date_id,
                                      real_departure_time         = excluded.real_departure_time,
                                      real_arrival_date_id        = excluded.real_arrival_date_id,
                                      real_arrival_time           = excluded.real_arrival_time;