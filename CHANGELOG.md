# Changelog

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
