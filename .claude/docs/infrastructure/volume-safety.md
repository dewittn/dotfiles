# Volume Safety

Docker volumes contain persistent data. Deleting them causes **permanent data loss**.

## Safe vs Dangerous Operations

| Action | Safe? | Notes |
|--------|-------|-------|
| `docker stack rm` | Yes | Removes services, keeps data |
| `docker network rm` | Yes | Can recreate |
| `docker volume rm` | **NO** | Data loss — ask user first |
| `docker volume prune` | **NO** | Data loss — ask user first |

## Rule

**Never delete remote volumes without explicit user permission.**

This applies especially on the `coto-v3` context where volumes contain production data.
