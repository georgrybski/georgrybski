<p align="center">
  <img src="./assets/engineering-surface.svg" alt="Georg Rybski, full-stack engineer. Build the software. Build what builds it. Give agents room to work, not the keys to everything." width="100%" />
</p>

<p align="center">
  <a href="https://github.com/rybskiworks"><kbd>rybskiworks</kbd></a>
  &nbsp;&nbsp;
  <a href="https://www.linkedin.com/in/georg-rybski"><kbd>linkedin</kbd></a>
</p>

I'm a **full-stack software engineer**. I build interfaces, APIs, and the systems underneath them, with TypeScript and Java on the product side, and Rust, Nix, and Linux in the workshop.

Part of the work at **rybskiworks** is making room for agents to explore, implement, and test freely inside deliberately scoped environments. **Fewer permission prompts, not more privilege.**

### `01 / the workshop`

A high-level map of the components I'm working with, not a deployment specification.

```mermaid
flowchart TB
    accTitle: The Rybskiworks workshop
    accDescr: Shared Nix tooling supports Workestrate, which orchestrates declared workloads through Microsandbox. The runtime uses libkrun and its libkrunfw guest kernel bundle. Pi, OpenCode, and T3MP3ST are example agent workloads, each in its own microVM, with LiteLLM providing model routing. Several components are maintained forks.

    N["nix-tooling<br/>shared pins + dev environments"] --> W["workestrate<br/>configuration + orchestration"]
    W --> M["microsandbox<br/>VM lifecycle + guest control"]
    M --> K["libkrun<br/>virtual machine monitor"]
    K --> F["libkrunfw<br/>guest kernel bundle"]

    subgraph G["example workloads / separate microVMs"]
        P["Pi"]
        O["OpenCode"]
        T["T3MP3ST"]
    end
    M --> G
    G --> L["LiteLLM<br/>model routing"]

    classDef default fill:#eef2f6,stroke:#8c99a8,color:#243342,stroke-width:1px,font-family:monospace,font-size:16px;
    classDef control fill:#dceeff,stroke:#4c87b6,color:#123653,stroke-width:2px;
    classDef agent fill:#f6f8fa,stroke:#8c99a8,color:#243342;
    class W control;
    class P,O,T agent;
    style G fill:transparent,stroke:#8c99a8,stroke-dasharray:5 5;

    click N href "https://github.com/rybskiworks/nix-tooling" "Shared Nix tooling"
    click W href "https://github.com/rybskiworks/workestrate/tree/migration/tool-model" "Workestrate (private repository, development branch)"
    click M href "https://github.com/rybskiworks/microsandbox" "Maintained Microsandbox fork"
    click K href "https://github.com/rybskiworks/libkrun" "Maintained libkrun fork"
    click F href "https://github.com/rybskiworks/libkrunfw" "Maintained libkrunfw fork"
    click P href "https://github.com/rybskiworks/pi" "Pi fork (private repository)"
    click O href "https://github.com/rybskiworks/opencode" "OpenCode fork (private repository)"
    click T href "https://github.com/rybskiworks/T3MP3ST" "T3MP3ST fork (private repository)"
    click L href "https://github.com/BerriAI/litellm" "LiteLLM upstream"
```

<p align="center">
  <a href="https://github.com/rybskiworks/workestrate/tree/migration/tool-model"><kbd>workestrate</kbd></a>
  <a href="https://github.com/rybskiworks/nix-tooling"><kbd>nix-tooling</kbd></a>
  <a href="https://github.com/rybskiworks/microsandbox"><kbd>microsandbox</kbd></a>
  <a href="https://github.com/rybskiworks/libkrun"><kbd>libkrun</kbd></a>
  <a href="https://github.com/rybskiworks/libkrunfw"><kbd>libkrunfw</kbd></a>
  <br>
  <a href="https://github.com/rybskiworks/pi"><kbd>Pi</kbd></a>
  <a href="https://github.com/rybskiworks/opencode"><kbd>OpenCode</kbd></a>
  <a href="https://github.com/rybskiworks/T3MP3ST"><kbd>T3MP3ST</kbd></a>
  <a href="https://github.com/BerriAI/litellm"><kbd>LiteLLM</kbd></a>
</p>

<sub>Several runtime and agent components are maintained forks. Workestrate and the agent forks are private; LiteLLM links to upstream. Workestrate points to the development branch. Repository links also appear outside the diagram.</sub>

### `02 / a small rule`

Choose the work. Keep the grant. A small capability filter in **jq**.

```jq
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
```

<details>
<summary><samp>run it / read the intent</samp></summary>

From a clone of this profile repository, with jq installed:

```sh
jq -c -n -f examples/autonomy.jq
# ["build","test"]
```

The agent can choose from the work its existing grant permits. Building and testing fit; deploying to production does not.

This is a small policy model, not a sandbox or an authorization service. In a real system, the host enforces the boundary; the agent does not get to edit its own grant.

</details>
