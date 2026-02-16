# Planning Guide: Infrastructure / DevOps

Additional planning requirements when the project involves Docker, deployment, CI/CD, server configuration, or operational systems.

Consulted by the **pre-plan** skill during Stage 1.

## Runtime Model

The plan must state what kind of system this is:

- **Service** — long-running process, needs health checks, logging, restart policy
- **Scheduled job** — start, run, exit. Needs meaningful exit codes and run output
- **CLI tool** — interactive or one-shot. Needs clear argument handling and help text

This affects almost every downstream decision. State it early.

## Configuration Hierarchy

The plan must specify how configuration works:

- What is configurable? (models, endpoints, thresholds, paths)
- What is the precedence? (CLI args → env vars → config file → defaults)
- Where does each config value live in production?

The rule: **if you might want to change it in production, it shouldn't require a code change or image rebuild.** Env vars for runtime config, mounted files for content.

## Security Boundaries

If the system processes external input (web content, API responses, user uploads):

- What is the isolation model? (container, sandbox, network policy)
- What persists after a run? What gets torn down?
- Where are the trust boundaries? What input is trusted vs. untrusted?

For containerized agents specifically: the container is a security boundary. Ensure the agent can't persist changes to the host, and that the environment is torn down after each run.

## Observability and Failure Modes

The plan must answer:

- **How do you know it worked?** Exit codes, output files, log entries.
- **How do you know it failed?** What errors are surfaced and where?
- **How do you debug a failure?** What logs or output are available after the fact?
- **What does the operator check first?** Point them to the right file or log.

## Deployment and Environment Documentation

The plan must include:

- `.env.example` or equivalent showing all configuration knobs
- Clear setup instructions for a fresh environment
- Any dependencies that need to be installed or configured outside the codebase

This is especially critical for solo dev work — you are the ops team. If setup isn't documented, you'll reverse-engineer it six months from now.
