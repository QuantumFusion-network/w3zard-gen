  # w3zard-gen

  Temporary configuration repository for QFN dApp generation.

  ## What is this?

  This repository hosts temporary configuration branches created by the w3zard dApp generator. Each branch contains the configuration needed to scaffold a new QFN project.

  **Note:** This repository is infrastructure. Users should not interact with it directly - the w3zard provides the necessary commands.

  ## How it works

  1. **User completes w3zard** - Selects project type, features, and configuration
  2. **Backend creates branch** - Unique branch with configuration files (e.g., `gen-1730123456-abc123`)
  3. **User runs command** - `degit qfn-org/w3zard-gen#gen-1730123456-abc123 my-project`
  4. **Degit composes project** - Clones the appropriate template and adds configuration
  5. **Branch cleanup** - Branch automatically deleted after 24 hours or first use

  ## What's in a branch?

  Each temporary branch contains:

  **degit.json** - Points to the correct template based on project type
  ```json
  [
    {
      "action": "clone",
      "src": "qfn-org/react-vite-template"
    }
  ]
```

  SETUP_PROMPT.md - User's specific configuration
  - Feature selections
  - Environment configuration
  - Project metadata
  - Instructions for Claude Code

  User workflow

  # 1. Run the degit command provided by w3zard
  degit qfn-org/w3zard-gen#gen-1730123456-abc123 my-project

  # 2. Install dependencies
  cd my-project
  pnpm install

  # 3. Generate features with Claude Code
  claude .
  # Type: /setup

  Branch lifecycle

  - Created: When user completes w3zard
  - Expires: 24 hours after creation
  - Deleted: Automatically removed after expiration

  Template repositories

  The actual project templates live in separate repositories:

  - qfn-org/react-vite-template - Client-side React + Vite + TypeScript
  - qfn-org/nextjs-template - Full-stack Next.js (future)
  - qfn-org/react-native-template - Mobile React Native (future)
