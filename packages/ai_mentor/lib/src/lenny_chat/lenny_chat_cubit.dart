import 'dart:convert';
import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatHistoryItem extends Equatable {
  const ChatHistoryItem({required this.role, required this.text});

  final String role;
  final String text;

  Map<String, dynamic> toJson() => {'role': role, 'text': text};

  @override
  List<Object> get props => [role, text];
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });

  final String text;
  final bool isUser;
  final DateTime time;

  @override
  List<Object> get props => [text, isUser, time];
}

sealed class LennyChatState extends Equatable {
  const LennyChatState({required this.messages});
  final List<ChatMessage> messages;
}

final class LennyChatIdle extends LennyChatState {
  const LennyChatIdle({required super.messages});
  @override
  List<Object> get props => [messages];
}

final class LennyChatTyping extends LennyChatState {
  const LennyChatTyping({required super.messages});
  @override
  List<Object> get props => [messages];
}

final class LennyChatError extends LennyChatState {
  const LennyChatError({required super.messages, required this.error});
  final String error;
  @override
  List<Object> get props => [messages, error];
}

class LennyChatCubit extends Cubit<LennyChatState> {
  LennyChatCubit({required this.userId, required this.apiClient})
    : super(const LennyChatIdle(messages: []));

  final String userId;
  final BaseApiClients apiClient;

  final List<ChatHistoryItem> _history = [];
  static const int _maxHistory = 10;

  void addGreeting(String mentorText) {
    final msg = ChatMessage(
      text: mentorText,
      isUser: false,
      time: DateTime.now(),
    );
    emit(LennyChatIdle(messages: [...state.messages, msg]));
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMsg = ChatMessage(
      text: trimmed,
      isUser: true,
      time: DateTime.now(),
    );
    final updatedMessages = [...state.messages, userMsg];
    _history.add(ChatHistoryItem(role: 'user', text: trimmed));
    _trimHistory();

    emit(LennyChatTyping(messages: updatedMessages));

    try {
      final response = await _callApi(trimmed);
      final mentorMsg = ChatMessage(
        text: response,
        isUser: false,
        time: DateTime.now(),
      );
      _history.add(ChatHistoryItem(role: 'mentor', text: response));
      _trimHistory();
      emit(LennyChatIdle(messages: [...updatedMessages, mentorMsg]));
    } catch (e) {
      log('LennyChatCubit error: $e');
      emit(
        LennyChatError(
          messages: updatedMessages,
          error: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void clearError() {
    if (state is LennyChatError) {
      emit(LennyChatIdle(messages: state.messages));
    }
  }

  Future<String> _callApi(String message) async {
    final historyForApi = _history
        .where((h) => h.text != message || h.role != 'user')
        .take(_maxHistory)
        .map((h) => h.toJson())
        .toList();

    final response = await apiClient.post(
      Endpoints.aiMentorChat,
      body: {'userId': userId, 'message': message, 'history': historyForApi},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return body['data']?['response'] as String? ??
          body['response'] as String? ??
          'I had trouble understanding that. Could you try again?';
    }

    final body = json.decode(response.body);
    throw Exception(body['message'] ?? 'API error ${response.statusCode}');
  }

  void _trimHistory() {
    if (_history.length > _maxHistory) {
      _history.removeRange(0, _history.length - _maxHistory);
    }
  }
}
