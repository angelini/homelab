CREATE TABLE IF NOT EXISTS tripdata (
   vendorid integer,
   tpep_pickup_datetime varchar,
   tpep_dropoff_datetime varchar,
   passenger_count integer,
   trip_distance double,
   ratecodeid integer,
   store_and_fwd_flag varchar,
   pulocationid integer,
   dolocationid integer,
   payment_type integer,
   fare_amount double,
   extra double,
   mta_tax double,
   tip_amount double,
   tolls_amount double,
   improvement_surcharge double,
   total_amount double,
   congestion_surcharge double,
   pickup_ts timestamp,
   pickup_year varchar,
   pickup_month varchar
)
WITH (
   external_location = 's3a://b001/tripdata',
   format = 'PARQUET',
   partitioned_by = ARRAY['pickup_year', 'pickup_month']
);

CALL system.sync_partition_metadata('default', 'tripdata', 'add');

ANALYZE tripdata;
