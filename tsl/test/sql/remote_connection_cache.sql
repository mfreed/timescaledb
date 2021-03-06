-- This file and its contents are licensed under the Timescale License.
-- Please see the included NOTICE for copyright information and
-- LICENSE-TIMESCALE for a copy of the license.

\c :TEST_DBNAME :ROLE_SUPERUSER

\set DN_DBNAME_1 :TEST_DBNAME _1
\set DN_DBNAME_2 :TEST_DBNAME _2

CREATE FUNCTION _timescaledb_internal.test_remote_connection_cache()
RETURNS void
AS :TSL_MODULE_PATHNAME, 'ts_test_remote_connection_cache'
LANGUAGE C STRICT;

CREATE FUNCTION _timescaledb_internal.test_alter_data_node(node_name NAME)
RETURNS BOOL
AS :TSL_MODULE_PATHNAME, 'ts_test_alter_data_node'
LANGUAGE C STRICT;

DO $d$
    BEGIN
        EXECUTE $$SELECT add_data_node('loopback_1', host => 'localhost',
                database => 'db_remote_connection_cache_1',
                port => current_setting('port')::int)$$;
        EXECUTE $$SELECT add_data_node('loopback_2', host => 'localhost',
                database => 'db_remote_connection_cache_2',
                port => current_setting('port')::int)$$;
    END;
$d$;

SELECT _timescaledb_internal.test_remote_connection_cache();

DROP DATABASE :DN_DBNAME_1;
DROP DATABASE :DN_DBNAME_2;
