import 'package:comingsoon/services/crud/notes_service.dart';
import 'package:comingsoon/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesListVew extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;
  const NotesListVew({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 3,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
