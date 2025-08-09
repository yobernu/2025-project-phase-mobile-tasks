import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/create_chat_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/get_chat_by_id_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/get_my_chat_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/message_usecases/get_message_usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/message_usecases/mark_as_read_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/message_usecases/resend_pending_messages_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/message_usecases/send_messages.usecase.dart';
import 'package:ecommerce_app/features/messaging/presentation/provider/chat_events.dart';
import 'package:ecommerce_app/features/messaging/presentation/provider/chat_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Improved Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CreateChatUseCase createChatUseCase;
  final GetChatByIdUseCase getChatByIdUseCase;
  final GetChatsForUserUseCase getChatsForUserUseCase;
  final GetMessageUseCase getMessageUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final ResendPendingMessagesUseCase resendPendingMessagesUseCase;

  ChatBloc({
    required this.createChatUseCase,
    required this.getChatByIdUseCase,
    required this.getChatsForUserUseCase,
    required this.getMessageUseCase,
    required this.sendMessageUseCase,
    required this.markAsReadUseCase,
    required this.resendPendingMessagesUseCase,
  }) : super(const ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<CreateChatEvent>(_onCreateChat);
    on<GetChatByIdEvent>(_onGetChatById);
    on<GetChatsForUserEvent>(_onGetChatsForUser);
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<ResendPendingMessagesEvent>(_onResendPendingMessages);
    on<DisposeEvent>(_onDispose);
  }

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await getChatsForUserUseCase.call(NoParams());
    result.fold(
      (failure) => emit(ChatError(ChatFailure(failure.message))),
      (chats) => emit(ChatListLoaded(chats)),
    );
  }

  Future<void> _onCreateChat(
    CreateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await createChatUseCase.call(
      CreateChatParams(userId: event.user2Id),
    );
    result.fold(
      (failure) => emit(ChatError(ChatFailure(failure.message))),
      (chat) => emit(ChatOperationSuccess(chat)),
    );
  }

  Future<void> _onGetChatById(
    GetChatByIdEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await getChatByIdUseCase.call(
      GetChatByIdParams(chatId: event.chatId),
    );
    result.fold(
      (failure) => emit(ChatError(ChatFailure(failure.message))),
      (chat) => emit(ChatOperationSuccess(chat)),
    );
  }

  Future<void> _onGetChatsForUser(
    GetChatsForUserEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await getChatsForUserUseCase.call(NoParams());

    result.fold(
      (failure) => emit(ChatError(ChatFailure(failure.message))),
      (chats) => emit(ChatListLoaded(chats)),
    );
  }

  Future<void> _onGetMessages(
    GetMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await getMessageUseCase.call(
      GetMessageParams(chatId: event.chatId),
    );
    result.fold(
      (failure) => emit(ChatError(ChatFailure(failure.message))),
      (messages) => emit(MessagesLoaded(messages)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await sendMessageUseCase.call(
      SendMessageParams(chatId: event.chatId, content: event.content),
    );
    result.fold(
      (failure) => emit(ChatError(ChatFailure(failure.message))),
      (_) => emit(const ChatOperationSuccess(null)),
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await markAsReadUseCase.call(
      MarkAsReadParams(messageId: event.messageId),
    );
    result.fold(
      (failure) => emit(ChatError(ChatFailure(failure.message))),
      (_) => emit(const ChatOperationSuccess(null)),
    );
  }

  Future<void> _onResendPendingMessages(
    ResendPendingMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await resendPendingMessagesUseCase.call(NoParams());
    result.fold(
      (failure) => emit(ChatError(ChatFailure(failure.message))),
      (_) => emit(const ChatOperationSuccess(null)),
    );
  }

  void _onDispose(DisposeEvent event, Emitter<ChatState> emit) {
    // Cleanup resources if needed
  }
}
