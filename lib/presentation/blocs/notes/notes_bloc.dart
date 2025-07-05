import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wilson_note_taker/data/repositories/notes_repository.dart';
import 'package:wilson_note_taker/presentation/blocs/notes/notes_event.dart';
import 'package:wilson_note_taker/presentation/blocs/notes/notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;

  NotesBloc({required NotesRepository notesRepository})
    : _notesRepository = notesRepository,
      super(NotesInitial()) {
    on<NotesLoadRequested>(_onNotesLoadRequested);
    on<NotesAddRequested>(_onNotesAddRequested);
    on<NotesUpdateRequested>(_onNotesUpdateRequested);
    on<NotesDeleteRequested>(_onNotesDeleteRequested);
  }

  Future<void> _onNotesLoadRequested(
    NotesLoadRequested event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    try {
      final notes = await _notesRepository.fetchNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onNotesAddRequested(
    NotesAddRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.addNote(event.text);
      add(NotesLoadRequested());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onNotesUpdateRequested(
    NotesUpdateRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.updateNote(event.id, event.text);
      add(NotesLoadRequested());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onNotesDeleteRequested(
    NotesDeleteRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.deleteNote(event.id);
      add(NotesLoadRequested());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
}
