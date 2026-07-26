# AI Tutor — Backend Endpoints

## Endpoints already live

| Method | Path                                 | Purpose                                                               |
| ------ | ------------------------------------ | --------------------------------------------------------------------- |
| `POST` | `/api/v1/ai-mentor/career-goal`      | Persists the selected career to the user's profile                    |
| `POST` | `/ai-mentor/career-path/generate`    | Generates the full career roadmap after goal is saved                 |
| `GET`  | `/ai-mentor/recommendations/:userId` | Fetches learning content recommendations (used on career goal screen) |

---

## Endpoint that needs to be built

### `POST /ai-mentor/discovery/recommendations`

This is the only step currently running client-side. The app runs a local keyword scoring algorithm over a hardcoded career list instead of calling the network. When this endpoint is live, the client switches to it with a one-line change.

#### Request body

```json
{
  "userId": "string",
  "goals": ["Learn Web3", "Get a better job"],
  "experience": "beginner",
  "topics": ["Blockchain & Web3", "Software Development"]
}
```

**`experience`** is one of: `beginner`, `intermediate`, `advanced`

**`goals`** possible values:

- Learn digital skills
- Get a better job
- Earn money online
- Learn AI
- Learn Web3
- Improve financial literacy
- Start a business
- Prepare for university

**`topics`** possible values:

- AI & Automation
- Software Development
- Design & Creativity
- Digital Marketing
- Finance & Investing
- Blockchain & Web3
- Data & Analytics
- Entrepreneurship
- Cybersecurity

#### Response

```json
{
  "success": true,
  "data": [
    {
      "id": "blockchain_dev",
      "title": "Blockchain Developer",
      "description": "Build decentralized applications on blockchain networks",
      "emoji": "⛓️",
      "matchScore": 5,
      "skills": ["Solidity", "Ethereum", "DApps", "Web3.js"]
    },
    {
      "id": "smart_contract",
      "title": "Smart Contract Engineer",
      "description": "Write secure, audited smart contracts for DeFi protocols",
      "emoji": "📜",
      "matchScore": 4,
      "skills": ["Solidity", "Auditing", "Foundry", "EVM"]
    },
    {
      "id": "defi_analyst",
      "title": "DeFi Analyst",
      "description": "Analyze and research decentralized finance opportunities",
      "emoji": "📊",
      "matchScore": 3,
      "skills": ["DeFi", "Analytics", "Tokenomics", "Risk Analysis"]
    }
  ]
}
```

The app expects **exactly 3 items** in `data`, ordered by `matchScore` descending. The first item is displayed as "Best Match."

#### What the backend should do

1. Accept `userId`, `goals[]`, `experience`, `topics[]`
2. Match those inputs against the career path catalogue — use AI or keyword scoring
3. Return the top 3 ranked `CareerRecommendation` objects in the shape above

The current client-side reference implementation (scoring logic + full career catalogue) lives in:
`packages/ai_tutor/lib/src/career_goal/data_source/career_goal_data_source.dart` — methods `_computeRecommendations` and `_careerMappings`.

#### Error response

```json
{
  "success": false,
  "message": "Failed to fetch recommendations"
}
```

---
