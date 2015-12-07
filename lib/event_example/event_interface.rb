class EventInterface
  # @param event [Event] The event to store
  def self.store(event)
    pipeline = Pyper::Pipeline.create do
      # First, serialize any hash/array fields on the attribute hash.
      # This is not needed for the event model and just for demonstration
      add Pyper::WritePipes::AttributeSerializer.new

      # Write to the events_by_id table
      add Pyper::WritePipes::CassandraWriter.new(:events_by_id, client)

      # Write to the events_by_type table
      add Pyper::WritePipes::CassandraWriter.new(:events_by_type, client)
    end

    # Push the event's attribute hash down the pipeline
    pipeline.push(event.attributes)
  end

  # Returns all events of a specific type for a specific user
  # @param user_id [Integer]
  # @param event_type [String]
  # @option options [String] :paging_state If provided, fetch this page of results
  # @return [Array] A pair containing an Array of results along with a next page token, if any
  def self.events_by_type(user_id, event_type, options = {})
    # Create a read pipeline that reads from the events_by_type table
    pipeline = read_pipeline_from_table(:events_by_type)

    # Push the specified user_id and event_type down the pipeline. These will be used by the
    # CassandraItems pipe to determine which events are retrieved. Subsequent pipes will
    # deserialize the data and instantiate the Event objects.
    result = pipeline.push(user_id: user_id, event_type: event_type)
    [result.value.to_a, result.status[:paging_state]]
  end

  # Returns all events for a given user
  # @param user_id [Integer]
  # @option options [String] :paging_state If provided, fetch this page of results
  # @return [Array] A pair containing an Array of results along with a next page token, if any
  def self.events_by_id(user_id, options = {})
    # Create a read pipeline that reads from the events_by_id table
    pipeline = read_pipeline_from_table(:events_by_id)

    # Push the specified user_id down the pipeline. These will be used by the
    # CassandraItems pipe to determine which events are retrieved. Subsequent pipes will
    # deserialize the data and instantiate the Event objects.
    result = pipeline.push(user_id: user_id)
    [result.value.to_a, result.status[:paging_state]]
  end

  # Returns a specific event by ID
  # @param user_id [Integer]
  # @param event_id [Integer]
  # @option options [String] :paging_state If provided, fetch this page of results
  # @return [Event|NilClass] The Event, or nil if not found
  def self.find(user_id, event_id, options = {})
    # Create a read pipeline that reads from the events_by_id table
    pipeline = read_pipeline_from_table(:events_by_id)

    # Push the specified user_id down the pipeline. These will be used by the
    # CassandraItems pipe to determine which events are retrieved. Subsequent pipes will
    # deserialize the data and instantiate the Event objects.
    result = pipeline.push(user_id: user_id, id: event_id)
    result.value.first
  end

  # Constructs a read pipeline, paramaterized by the table name. Each pipeline will read, deserialize,
  # and instantiate Events.
  def self.read_pipeline_from_table(table)
    Pyper::Pipeline.create do
      # Fetch the raw items from the specified table, as specified by the parameters sent down the pipeline.
      add Pyper::ReadPipes::CassandraItems.new(table, client)

      # Deserialize Hash and Array fields of each event based on the the attributes
      # declared within the Event class. Not strictly needed since Event has no
      # fields of this type
      add Pyper::ReadPipes::VirtusDeserializer.new(Event.attribute_set)

      # Create new Event objects from the raw attribute hashes
      add Pyper::ReadPipes::VirtusParser.new(Event)
    end
  end

  # @return [Cassava::Client] The connection to the datastore
  def self.client
    @client ||= Cassava::Client.new(CassSchema::Runner.datastore_lookup(:event).client)
  end
end
