# Changelog

## 1.1.7

### Enhancements
  - `PhraseLive.Edit` Created a dedicated edit phrase page
  - `PhraseLive.TranslationForm` Add translations to a phrase
  - `SearchLive.Index` Squashed `SearchLive.RecentPhrases` and `SearchLive.Phrase` into `SearchLive.Index`
  - `SearchLive.Index` Better support for multiline translations
  - `SearchLive.Index` Phrases are now navagatable and clickable
  - `SearchLive.Index` Show matching phrases on search
  - `SearchLive.Index` Show only matching translaitons while searching
  - `SearchLive.SearchField` Disable create buton with invalid search parameters
  - `UILive.Translation` Abstracted translation view into reusable component
  - `SRSLive.Flashcards` Show a random native language on card flip
  - `LibraryLive.Index` Replaced with new library context
  - `DialogueLive.Edit` Edit dialogues live

### Bugfixes
  - `UILive.Translation` Provide @user_id
  - `SRSLive.Flashcards` Fix rendering of scoring buttons
  - `SearchLive.Index` Deletes, multiple results, and cleared input all render correctly now
  - `AccountLive.Index` Create a profile when none exists on page load

## 1.1.6

Improvements to session pages

### Enhancements
  - Remove logging and debugging strategies
  - `.g--container` Style anchor tags

### Bugfixes
  - Remove all references to Accounts
  - `SessionLive.SignUp` Fix form styles
  - `SessionLive.SignIn` Fix `/signup` link

## 1.1.4

Redirect failed logins to an existing page

## 1.1.3

Updates to error tracking config

## 1.1.2

Add error tracking

### Enhancements
  - `config` Add sentry to config

## 1.1.1

Updates to user card management

### Enhancements
  - `SRSLive.Cards` Activate and deactivate cards
  - `SRSLive.Cards` Show all cards

### Breaking changes
  - `SRS.list_active_cards/1` moved `user_id` to a named parameter

## 1.1.0

First functional version! Can now search for and create phrases, add them to your memory, study the cards, and see the results.

### Enhancements
  - Add `/cards` page to view active cards
  - Add `/flashcards` page to study active cards
  - Move `SRSLive.Cards` and `SRSLive.Flashcards` from `get` routes to `live` routes
  - Add `/flashcards` to the nav bar
