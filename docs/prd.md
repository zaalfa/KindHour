# 📱 KindHour — Supportive Time Widget

## Product Requirements Document (PRD)

---

## 1. 📌 Product Overview

**KindHour** is a minimalist Android application with a home-screen widget that displays supportive, time-based messages throughout the day. The system automatically determines the current device time and shows an appropriate encouraging message together with a cute emoji or lightweight illustration.

Each time block contains multiple possible messages. The system randomly selects one message per time block and keeps it consistent for that period to avoid flickering or constant changes.

The widget is the primary user experience; the app itself serves as a preview and entry point.

**Core philosophy:**
`zero friction · emotionally comforting · automatic behavior · offline-first`

---

## 2. 🎯 Product Goals

### Primary Goals

* Provide passive emotional encouragement during daily routines
* Automatically show the correct message based on device time
* Display messages directly on the Android home screen widget
* Provide message variation while keeping display stable
* Offer calming visual themes (pastel and monochrome)

---

### Success Metrics

* Widget shows correct time category message
* Message remains stable within the same time block
* Random variation occurs only when time block changes
* App launches under 2 seconds
* Widget loads correctly after reboot
* Fully functional without internet

---

## Intended Usage

This app is designed for personal daily use and for anyone who wants a small supportive message during the day. 
The focus is on simplicity, low interaction, and calming visuals.

---

## 4. ⭐ Core Features (MVP)

---

### 4.1 Time-Based Message Engine

The application must determine the current local device time and map it to a predefined time category.

| Time Range  | Category  |
| ----------- | --------- |
| 05:00–10:59 | Morning   |
| 11:00–13:59 | Noon      |
| 14:00–17:59 | Afternoon |
| 18:00–21:59 | Evening   |
| 22:00–04:59 | Night     |

---

### 4.2 Multiple Message Variations

Each time category contains a list of supportive messages stored locally.

Example:

**Morning list may include**

* Good morning! Hope you have a great day today!
* A fresh start ☀️ You’ve got this!
* Sending you calm energy for today 🌸

---

### 4.3 Stable Random Selection Logic (CRITICAL)

When a new time block begins:

1. Detect the new time category
2. Randomly select one message from that category
3. Store the selected message locally
4. Keep displaying that message throughout the time block

The system must **NOT** change messages during:

* widget refresh
* screen unlock
* redraw
* app reopen

---

### 4.4 Home Screen Widget (PRIMARY DELIVERY)

The Android widget must:

* Display emoji or lightweight illustration
* Display supportive message text
* Load without opening the app
* Refresh when time block changes
* Persist the selected message
* Work offline

Minimum requirement:

* One widget size supported in MVP

---

### 4.5 Main Application Screen

The app contains one simple screen that:

* Shows the same message currently displayed in the widget
* Displays emoji / illustration
* Shows instruction text encouraging user to add the widget

No login or settings required.

---

## 5. 🎨 Visual Design Requirements

---

### 5.1 Theme System (REQUIRED)

The application must support two theme families.

#### Pastel Theme

* Soft calming background colors
* Warm emotional tone
* Default theme

#### Monochrome Theme

* Neutral grayscale palette
* Minimalist aesthetic
* High readability

---

### 5.2 Optional Time-Based Color Variation

Within the selected theme, background tone may vary by time category.

Example:

* Morning → lighter tone
* Afternoon → neutral tone
* Night → darker tone

---

### 5.3 Layout Rules

Widget and app share the same structure:

```
TOP: emoji / illustration
CENTER: supportive message
BACKGROUND: theme color
```

Constraints:

* Large readable typography
* Center aligned
* Minimal clutter
* Lightweight assets only

GIF animation is excluded from MVP.

---

## 6. ⚙️ Functional Requirements

* FR-1: Read device local time
* FR-2: Classify time into categories
* FR-3: Load message list from local storage
* FR-4: Randomly select message only on block transition
* FR-5: Persist selected message locally
* FR-6: Widget displays stored message consistently
* FR-7: Must work offline
* FR-8: Widget must load after reboot
* FR-9: Support pastel and monochrome themes

---

## 7. 🛡 Technical Guardrails (MANDATORY)

### Widget Performance

* Static layouts only
* No heavy animation
* No network image loading
* All assets bundled locally

---

### Update Frequency

* Update only when time block changes
* Frequent polling prohibited
* Manual refresh via widget tap allowed

---

### Message Stability

* Randomization allowed only once per block
* Must store:

```
time_block
message_index
```

* Refresh must NOT trigger new selection

---

### Offline-First Rule

* All messages stored locally
* No backend dependency allowed

---

## 8. 🛠 Technical Stack (APPROVED)

**Primary stack**

* Flutter (Dart)
* VS Code
* Android widget integration via `home_widget` plugin

**Local storage**

* Bundled JSON message file
* Optional SharedPreferences for persistence

**Assets**

* Emoji preferred
* Small PNG optional
* Vector assets encouraged
* GIF excluded from MVP

---

## 9. 🏗 System Architecture

Required modules:

1. **Time Classifier** → determines time category
2. **Message Repository** → loads JSON message lists
3. **Message Selector** → handles random selection + persistence
4. **Display Layer** → renders UI for app and widget

This modular separation is required to prevent refresh bugs.

---

## 10. 📊 User Flow

### Installation

1. User installs app
2. Opens app
3. Sees supportive message
4. Prompt suggests adding widget

---

### Daily Usage

1. User unlocks phone
2. Widget visible
3. Message matches current time category
4. Message remains stable for that period

No interaction required.

---

## 11. 🧪 Acceptance Criteria

* Morning 08:00 → correct morning message
* Message does not change while still in same block
* At 11:00 → new message selected from noon list
* Widget displays correctly after reboot
* Works without internet
* Theme renders correctly (pastel or monochrome)

---

## 12. 🚫 Out of Scope (Version 1)

* User accounts
* Cloud sync
* Editable custom messages
* Chat system
* Social sharing
* Animated widget assets
* Multiple widget layouts
* Notification scheduling

---

## 13. 🔮 Future Enhancements

* User-selectable theme switcher
* Multiple widget sizes
* Custom message editing
* Notifications
* Mood tracking
* Illustration packs
* Lightweight animation support

---

## 14. 📦 MVP Completion Definition

The MVP is complete when:

* Android app installs successfully
* Widget can be added to home screen
* Correct time-based message appears
* Random selection works per time block
* Message persists within block
* Theme system supports pastel or monochrome
* System runs fully offline

---

## ✅ Final Summary

KindHour is a single-purpose emotional support widget focused on passive encouragement, stable time-based behavior, and calming visual presentation. The widget is the central experience, while the application exists primarily as a preview and installation surface.

---

**END OF PRD**
