import 'package:comingsoon/constants/routes.dart';
import 'package:comingsoon/enums/enums_menu_actions.dart';
import 'package:comingsoon/services/auth/auth_services.dart';
import 'package:comingsoon/services/auth/bloc/auth_bloc.dart';
import 'package:comingsoon/services/auth/bloc/auth_event.dart';
import 'package:comingsoon/services/cloud/cloud_note.dart';
import 'package:comingsoon/services/cloud/firebase_cloud_storage.dart';
import 'package:comingsoon/utilities/dialogs/logout_dialog.dart';
import 'package:comingsoon/views/notes/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Notes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          PopupMenuButton<MenuActions>(
            surfaceTintColor: Colors.white,
            iconColor: Colors.white,
            shadowColor: Colors.white,
            onSelected: (value) async {
              switch (value) {
                case MenuActions.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuActions>(
                    value: MenuActions.logout, child: Text("Logout"))
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListVew(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              }
              return const Text("active");
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
