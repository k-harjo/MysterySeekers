
# 🛠️ Developer Guide – Mystery Seekers: Urban Legends

## 📦 Overview
This guide provides technical onboarding and architectural context for developers contributing to or expanding *Mystery Seekers: Urban Legends*. It includes system summaries, scripting conventions, and implementation notes for the project’s core gameplay, puzzle logic, and modular chapter design.

---

## 🔧 Core Architecture

### 🗂️ Structure
Each chapter is a separate `.rbxl` place file connected via **TeleportService** in a shared Roblox Universe:
```
[Prologue] → [Detective HQ] → [Chapter 1] → [Chapter 2] → [Chapter 3] → [Chapter 4] → [Chapter 5]
```

### 📂 Major Folders in Explorer:
- **StarterGui** – UI elements like task lists, puzzles, journal, inventory
- **ReplicatedStorage** – Shared assets, RemoteEvents, puzzle logic modules
- **ServerScriptService** – Core logic: inventory manager, quest handlers, badge triggers
- **Workspace** – NPCs, puzzles, triggers, interactables

---

## 🧩 System Descriptions

### 🧳 Inventory System
- Uses `DataStoreService` to persist across chapters.
- Scripts: `InventoryManager.lua`, `PlayerInventoryClient.lua`
- Items added via trigger scripts (e.g., touched parts or puzzle completions)
- Inventory shown via `PlayerGui.InventoryFrame`

### 🧠 Puzzle Logic
- Chapter-specific scripts are modular.
- Puzzle types:
  - Sequence (e.g., candle order, piano melody)
  - Collection (e.g., artifact pieces)
  - Environmental (e.g., seed planting, valve pressure)
- Triggers activate UI elements or RemoteEvents tied to state changes.

### 💬 Dialogue System
- Each NPC has a dialogue module table with conditional branches by chapter.
- Triggered by `ProximityPrompt` → RemoteEvent → GUI dialogue
- Future chapters can append new dialogue blocks based on `CurrentChapter` flag.

### 🌀 Chapter Transitions
- Portal boards or object triggers use `TeleportService:Teleport(placeId)`
- Badges used as gates (e.g., complete Ch1 → earn badge → unlock Ch2)

---

## 🧪 Testing Notes
- Each place has a test version (“sandbox”) for safe debugging.
- Testing checklist:
  - ProximityPrompt triggers (NPCs and puzzles)
  - Inventory updates on collect/use
  - Puzzle resolution triggers
  - Dialogue branching by chapter
  - Return-to-Hub teleport
- Use `print()` tracing and flags like `PuzzleSolved` to validate flow.

---

## 🛠️ Development Tips
- Use modular scripts (`ModuleScript`) for reusable puzzle logic and system tools.
- Comment puzzle scripts clearly—identify win conditions, required parts.
- Test GUI scaling across devices (PC, tablet, phone).
- Follow naming conventions:  
  `ChapterX_PuzzleType_ObjectName.lua` or `Puzzle_Piano_Mall.lua`

---

## 📈 Future Expansion
- **Alternate endings** based on collected artifacts or dialogue decisions
- **New chapters** added via additional `.rbxl` place files in the Universe
- Support for **multiplayer investigations**
- Player journal system with branching objectives

---

## 📬 Contact
Original Developer: KariAnn Harjo  
GitHub: [github.com/k-harjo/MysterySeekers](https://github.com/k-harjo/MysterySeekers)
