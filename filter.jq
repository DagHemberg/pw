def censor_fields: ["password", "secret", "token", "key", "number", "code"];
def hide_fields: ["history"];
def is_empty_value:
  . == null or
  . == "" or
  . == [] or
  . == {};
def censor_value:
  if type == "string" then ("*" * (. | length))
  elif type == "number" then ("*" * (. | tostring | length))
  else . end;
walk(
  if type == "object" then
    if has("fields") and (.fields | type == "array") then
      .fields |= map(
        if .type == "hidden" then
          .value |= censor_value
        else . end
      )
    else . end
    | with_entries(
      if (.key | IN(censor_fields[])) then
        .value |= censor_value
      else . end
    )
    | with_entries(select(
        (.value | is_empty_value | not) and 
        (.key | IN(hide_fields[]) | not)
      ))
  else . end
)
