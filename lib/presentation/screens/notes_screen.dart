import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wilson_note_taker/domain/models/note.dart';
import 'package:wilson_note_taker/presentation/blocs/auth/auth_bloc.dart';
import 'package:wilson_note_taker/presentation/blocs/auth/auth_event.dart';
import 'package:wilson_note_taker/presentation/blocs/notes/notes_bloc.dart';
import 'package:wilson_note_taker/presentation/blocs/notes/notes_event.dart';
import 'package:wilson_note_taker/presentation/blocs/notes/notes_state.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(NotesLoadRequested());
  }

  void _showAddNoteDialog() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Note'),
            // backgroundColor: Colors.grey[100],
            backgroundColor: const Color.fromARGB(255, 13, 33, 50),
            titleTextStyle: TextStyle(
              color: Colors.white, // Change text color here
              fontSize: 20, // Optional: Adjust font size
              fontWeight: FontWeight.bold, // Optional: Adjust font weight
            ),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter your note...',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red, // Set your desired color here
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ), // This sets the text color
                ),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final text = textController.text.trim();
                  if (text.isNotEmpty) {
                    context.read<NotesBloc>().add(
                      NotesAddRequested(text: text),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note added successfully!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green, // Set your desired color here
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ), // This sets the text color
                ),
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showEditNoteDialog(Note note) {
    final textController = TextEditingController(text: note.text);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Note'),
            titleTextStyle: TextStyle(
              color: Colors.white, // Change text color here
              fontSize: 20, // Optional: Adjust font size
              fontWeight: FontWeight.bold, // Optional: Adjust font weight
            ),
            // backgroundColor: Colors.grey[100],
            backgroundColor: const Color.fromARGB(255, 13, 33, 50),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter your note...',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red, // Set your desired color here
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ), // This sets the text color
                ),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final text = textController.text.trim();
                  if (text.isNotEmpty) {
                    context.read<NotesBloc>().add(
                      NotesUpdateRequested(id: note.id, text: text),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note updated successfully!'),
                        backgroundColor: Colors.amber,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.amber, // Set your desired color here
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ), // This sets the text color
                ),
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmationDialog(Note note) {
    showDialog(
      context: context,

      builder:
          (context) => AlertDialog(
            title: const Text('Delete Note'),
            titleTextStyle: TextStyle(
              color: Colors.white, // Change text color here
              fontSize: 20, // Optional: Adjust font size
              fontWeight: FontWeight.bold, // Optional: Adjust font weight
            ),
            content: const Text('Are you sure you want to delete this note?'),
            contentTextStyle: TextStyle(color: Colors.white),
            // backgroundColor: Colors.grey[100],
            backgroundColor: const Color.fromARGB(255, 13, 33, 50),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red, // Set your desired color here
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ), // This sets the text color
                ),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<NotesBloc>().add(
                    NotesDeleteRequested(id: note.id),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note deleted successfully!'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green, // Set your desired color here
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ), // This sets the text color
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 33, 50),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 33, 50),
        title: const Text('My Notes'),
        titleTextStyle: TextStyle(
          color: Colors.white, // Change text color here
          fontSize: 20, // Optional: Adjust font size
          fontWeight: FontWeight.bold, // Optional: Adjust font weight
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotesLoaded) {
              if (state.notes.isEmpty) {
                return const Center(
                  child: Text(
                    'Nothing here yet—tap ➕ to add a note.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(note.text),
                      subtitle: Text(
                        'Created: ${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.amber),
                            onPressed: () => _showEditNoteDialog(note),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => _showDeleteConfirmationDialog(note),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Something went wrong. Please try again.'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
