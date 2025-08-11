# Chat Feature - Clean Architecture Implementation

This is a comprehensive chat feature built using Clean Architecture principles with Flutter, BLoC pattern, and real-time messaging via Socket.IO.

## Features

- ✅ **Real-time messaging** with Socket.IO
- ✅ **Clean Architecture** with Domain, Data, and Presentation layers
- ✅ **BLoC State Management** for reactive UI
- ✅ **Offline support** with local caching
- ✅ **Network connectivity** handling
- ✅ **Dependency injection** with get_it
- ✅ **Modern UI** with Material Design

## API Endpoints

Base URL: `https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3`

- **GET /chats** - Get all chats for current user
- **GET /chats/{chatId}** - Get specific chat details
- **GET /chats/{chatId}/messages** - Get messages for a chat
- **POST /chats** - Initiate new chat with user
- **DELETE /chats/{chatId}** - Delete a chat
- **POST /chats/{chatId}/messages** - Send message to chat

## Architecture Overview

```
lib/features/chat/
├── domain/                 # Business Logic Layer
│   ├── entities/          # Core business objects
│   │   ├── user.dart
│   │   ├── chat.dart
│   │   └── message.dart
│   ├── repositories/      # Abstract repository interfaces
│   │   └── chat_repository.dart
│   └── usecases/         # Business use cases
│       ├── get_chats.dart
│       ├── get_chat_by_id.dart
│       ├── get_chat_messages.dart
│       ├── initiate_chat.dart
│       ├── delete_chat.dart
│       └── send_message.dart
├── data/                  # Data Access Layer
│   ├── models/           # Data models with JSON serialization
│   │   ├── user_model.dart
│   │   ├── chat_model.dart
│   │   └── message_model.dart
│   ├── datasources/      # Data source implementations
│   │   ├── chat_remote_data_source.dart
│   │   └── chat_local_data_source.dart
│   ├── repositories/     # Repository implementations
│   │   └── chat_repository_impl.dart
│   └── services/         # External services
│       └── socket_service.dart
├── presentation/          # UI Layer
│   ├── bloc/             # BLoC state management
│   │   ├── chat_bloc.dart
│   │   ├── chat_event.dart
│   │   └── chat_state.dart
│   └── pages/            # UI screens
│       ├── chat_list_page.dart
│       └── chat_detail_page.dart
├── injection_container.dart  # Dependency injection setup
├── chat_feature.dart        # Main feature entry point
└── README.md                # This file
```

## Usage

### 1. Initialize the Chat Feature

```dart
import 'package:ecommerce_app/features/chat/chat_feature.dart';

// In your main.dart or app initialization
await ChatFeature.initialize();
```

### 2. Navigate to Chat Feature

```dart
// Simple integration
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChatFeature.getChatPage(),
  ),
);

// Or use the example integration widget
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ChatIntegrationExample(),
  ),
);
```

### 3. Custom BLoC Usage

```dart
// Create custom BLoC instance
final chatBloc = ChatFeature.createChatBloc();

// Use with custom provider
BlocProvider.value(
  value: chatBloc,
  child: ChatFeature.getChatPageWithCustomBloc(chatBloc),
)
```

## Dependencies

All required dependencies are already included in `pubspec.yaml`:

- `flutter_bloc: ^8.1.4` - State management
- `get_it: ^7.6.7` - Dependency injection
- `equatable: ^2.0.5` - Value equality
- `dartz: ^0.10.1` - Functional programming
- `http: ^1.2.0` - HTTP requests
- `shared_preferences: ^2.2.2` - Local storage
- `socket_io_client: ^2.0.0` - Real-time messaging
- `connectivity_plus: ^6.1.4` - Network connectivity

## Real-time Messaging

The chat feature includes real-time messaging capabilities:

- **Automatic connection** when entering chat screens
- **Message broadcasting** via Socket.IO
- **Offline message queuing** with automatic retry
- **Connection status** monitoring

## Error Handling

The feature includes comprehensive error handling:

- **Network failures** with offline fallback
- **Server errors** with user-friendly messages
- **Cache failures** with retry mechanisms
- **Socket connection** error recovery

## Offline Support

- **Local caching** of chats and messages
- **Automatic sync** when connection restored
- **Pending message** queue for offline sending
- **Cache management** with cleanup utilities

## Testing

The architecture supports easy testing with:

- **Mockable interfaces** for all external dependencies
- **Isolated business logic** in use cases
- **Testable BLoC** with clear state transitions
- **Injectable dependencies** for test doubles

## Customization

### Styling
Modify the UI components in the `presentation/pages/` directory to match your app's design system.

### API Integration
Update the base URL and headers in `ChatRemoteDataSourceImpl` for your specific API requirements.

### Socket Configuration
Modify the Socket.IO configuration in `SocketService` for your real-time messaging setup.

## Future Enhancements

- [ ] Message status indicators (sent, delivered, read)
- [ ] File and image sharing
- [ ] Push notifications
- [ ] Message encryption
- [ ] Group chat support
- [ ] Message search functionality
- [ ] Chat themes and customization
