# Event Example

Example code that builds an Event data model with several access patterns,
backed by Cassandra.

The example uses the [virtus](https://github.com/solnic/virtus) gem to create the data model,
the [pyper](https://github.com/backupify/pyper) gem to manage serialization and persistence,
and [cass_schema](https://github.com/backupify/cass_schema) to manage the Cassandra schema.

## Usage

Install and start a console:

```
bundle install
bundle exec rake console
```

Create an event:

```ruby
event = Event.new(user_id: 1, id: 'my_event', event_data: 'data', event_type: 'notification')
```

Get all events for a user:

```ruby
events, next_page_token = EventInterface.events_by_id(user_id)
```

Get all events for a user:

```ruby
events, next_page_token = EventInterface.events_by_type(user_id, 'notification')
```

Get a specific event for a user:

```ruby
event = EventInterface.find(user_id, event_id)
```
