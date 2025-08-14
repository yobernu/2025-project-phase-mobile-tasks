import 'dart:async';
import 'dart:developer' as dev;
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import '../../domain/usecases/get_chats.dart';
import '../../domain/usecases/get_chat_by_id.dart';
import '../../domain/usecases/get_chat_messages.dart';
import '../../domain/usecases/initiate_chat.dart';
import '../../domain/usecases/delete_chat.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChats getChats;
  final GetChatById getChatById;
  final GetChatMessages getChatMessages;
  final InitiateChat initiateChat;
  final DeleteChat deleteChat;
  final SendMessage sendMessage;
  final ChatRepository chatRepository;

  StreamSubscription? _messageSubscription;

  ChatBloc({
    required this.getChats,
    required this.getChatById,
    required this.getChatMessages,
    required this.initiateChat,
    required this.deleteChat,
    required this.sendMessage,
    required this.chatRepository,
  }) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<LoadChatById>(_onLoadChatById);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<ShowChatMessagesEmpty>(_onShowChatMessagesEmpty);
    on<InitiateNewChat>(_onInitiateNewChat);
    on<DeleteChatEvent>(_onDeleteChat);
    on<SendMessageEvent>(_onSendMessage);
    on<ConnectToRealTime>(_onConnectToRealTime);
    on<DisconnectFromRealTime>(_onDisconnectFromRealTime);
    on<NewMessageReceived>(_onNewMessageReceived);
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    final result = await getChats(NoParams());

    result.fold(
      (failure) => emit(ChatError(_mapFailureToMessage(failure))),
      (chats) => emit(ChatsLoaded(chats)),
    );
  }

  Future<void> _onLoadChatById(
    LoadChatById event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await getChatById(event.chatId);

    result.fold(
      (failure) => emit(ChatError(_mapFailureToMessage(failure))),
      (chat) => emit(ChatLoaded(chat)),
    );
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await getChatMessages(event.chatId);

    result.fold(
      (failure) => emit(ChatError(_mapFailureToMessage(failure))),
      (messages) =>
          emit(ChatMessagesLoaded(chatId: event.chatId, messages: messages)),
    );
  }

  Future<void> _onShowChatMessagesEmpty(
    ShowChatMessagesEmpty event,
    Emitter<ChatState> emit,
  ) async {
    // Immediately show an empty list for the chat without hitting HTTP
    emit(ChatMessagesLoaded(chatId: event.chatId, messages: const []));
  }

  Future<void> _onInitiateNewChat(
    InitiateNewChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await initiateChat(event.userId);

    result.fold(
      (failure) => emit(ChatError(_mapFailureToMessage(failure))),
      (chat) => emit(ChatInitiated(chat)),
    );
  }

  Future<void> _onDeleteChat(
    DeleteChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await deleteChat(event.chatId);

    result.fold(
      (failure) => emit(ChatError(_mapFailureToMessage(failure))),
      (_) => emit(ChatDeleted(event.chatId)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    dev.log(
      '[ChatBloc] _onSendMessage: chatId=${event.chatId}, '
      'content.length=${event.content.length}, type=${event.type}',
    );

    final result = await sendMessage(
      SendMessageParams(
        chatId: event.chatId,
        content: event.content,
        type: event.type,
      ),
    );

    result.fold(
      (failure) {
        final msg = _mapFailureToMessage(failure);
        dev.log('[ChatBloc] _onSendMessage FAILURE: $msg');
        emit(ChatError(msg));
      },
      (message) {
        dev.log('[ChatBloc] _onSendMessage SUCCESS: messageId=${message.id}');

        // Optimistic update: append message to current list if loaded
        final currentState = state;
        final targetChatId = message.chatId;
        if (currentState is ChatMessagesLoaded &&
            currentState.chatId == targetChatId) {
          final updated = List.of(currentState.messages)..add(message);
          emit(ChatMessagesLoaded(chatId: targetChatId, messages: updated));
        } else {
          // If not currently viewing loaded messages for this chat, create a new list
          emit(ChatMessagesLoaded(chatId: targetChatId, messages: [message]));
        }

        emit(MessageSent(message));
      },
    );
  }

  Future<void> _onConnectToRealTime(
    ConnectToRealTime event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await chatRepository.connectToRealTime();

      // Listen to real-time messages
      _messageSubscription = chatRepository.messageStream.listen((message) {
        add(NewMessageReceived(message));
      });

      emit(RealTimeConnected());
    } catch (e) {
      emit(ChatError('Failed to connect to real-time messaging'));
    }
  }

  Future<void> _onDisconnectFromRealTime(
    DisconnectFromRealTime event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _messageSubscription?.cancel();
      _messageSubscription = null;
      await chatRepository.disconnectFromRealTime();
      emit(RealTimeDisconnected());
    } catch (e) {
      emit(ChatError('Failed to disconnect from real-time messaging'));
    }
  }

  Future<void> _onNewMessageReceived(
    NewMessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    // Merge incoming socket message: replace matching provisional (temp-*) or append
    final incoming = event.message;
    final currentState = state;
    if (currentState is ChatMessagesLoaded &&
        currentState.chatId == incoming.chatId) {
      final updated = List.of(currentState.messages);
      final idx = updated.indexWhere((m) =>
          m.id.startsWith('temp-') &&
          m.chatId == incoming.chatId &&
          m.sender.id == incoming.sender.id &&
          m.content == incoming.content);
      if (idx != -1) {
        updated[idx] = incoming; // replace provisional with delivered
      } else {
        updated.add(incoming);
      }
      emit(ChatMessagesLoaded(chatId: currentState.chatId, messages: updated));
    } else {
      // If no messages loaded yet for this chat, start a new list
      emit(ChatMessagesLoaded(chatId: incoming.chatId, messages: [incoming]));
    }
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      case NetworkFailure:
        return 'Network error occurred';
      default:
        return 'Unexpected error occurred';
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
