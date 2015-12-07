require 'cass_schema'

# Initialize CassSchema
CassSchema::Runner.setup(
  datastores: CassSchema::YamlHelper.datastores('config/datastores.yml'),
  schema_base_path: 'cass_schema')

# Create the Cassandra keyspace
CassSchema::Runner.create_all

require 'event_example/event'
require 'event_example/event_interface'
