CREATE TABLE events_by_id(
  id text,
  user_id int,
  event_type text,
  event_data text,
  PRIMARY KEY ((user_id), id)
)

CREATE TABLE events_by_type(
  id text,
  user_id int,
  event_type text,
  event_data text,
  PRIMARY KEY ((user_id, event_type), id)
)
