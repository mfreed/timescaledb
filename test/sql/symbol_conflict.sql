-- This file and its contents are licensed under the Apache License 2.0.
-- Please see the included NOTICE for copyright information and
-- LICENSE-APACHE for a copy of the license.

\c :TEST_DBNAME :ROLE_SUPERUSER

-- Test for symbol conflicts between the loader module and the
-- versioned extension module.
-- This test fails on, e.g. Linux, unless compiled with -fvisibility=hidden
CREATE OR REPLACE FUNCTION hello_loader() RETURNS TEXT
AS 'timescaledb', 'loader_hello' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

SELECT hello_loader();

CREATE OR REPLACE FUNCTION hello_timescaledb() RETURNS TEXT
AS :MODULE_PATHNAME, 'timescaledb_hello' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

-- This calls an internal function with a conflicting name in the loader
SELECT hello_loader();
-- This calls the identically named internal function in the versioned extension
SELECT hello_timescaledb();
