# GeorgeInterviewHomework

An iOS application built as part of a technical assignment. It displays a list of bank accounts and provides detailed information for each account, including recent transactions.

## Screenshots

| Account List | Account Detail |
|--------------|----------------|
| ![Simulator Screenshot - iPhone 16 Pro Max - 2025-05-18 at 12 25 13](https://github.com/user-attachments/assets/dab0ac65-4bb4-4533-896d-0ee889d73c36)| ![Simulator Screenshot - iPhone 16 Pro Max - 2025-05-18 at 12 25 15](https://github.com/user-attachments/assets/ce9e11c0-debf-4827-92d5-e1b00025bd84)

## Technologies Used
- SwiftUI
- The Composable Architecture (TCA)

## Architecture

The project uses **The Composable Architecture (TCA)** for state management and side-effect handling:

- `AccountList` — lists accounts with pagination and search
- `AccountDetail` — shows account details and transactions
-  Organized by reducer/state/action patterns
- `@Dependency` and `@ObservableState` used for clarity and testability

## Features

- Search through accounts
- Pagination
- Transaction history
- Overlay loading indicators
- Modular and testable structure
