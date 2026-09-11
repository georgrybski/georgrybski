# Freedom to choose the work, not to expand the grant.
def within($grants):
  select(all(.needs[]; IN($grants[])));

["repo:read", "workspace:write", "tests:run"] as $grants
| [
    {task: "build",  needs: ["repo:read", "workspace:write"]},
    {task: "test",   needs: ["tests:run"]},
    {task: "deploy", needs: ["production:write"]}
  ]
| map(within($grants) | .task)
# => ["build", "test"]
