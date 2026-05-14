import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/messaging/messaging_bloc.dart';

class QueryListPage extends StatelessWidget {
  const QueryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Query History')),
      body: BlocBuilder<MessagingBloc, MessagingState>(
        builder: (context, state) {
          if (state is MessagingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MessagingLoaded) {
            return ListView.builder(
              itemCount: state.queries.length,
              itemBuilder: (context, index) {
                final query = state.queries[index];
                return ListTile(
                  title: Text(query.title),
                  subtitle: Text(query.content),
                  trailing: Text(query.timestamp.toString().split(' ')[0]),
                );
              },
            );
          } else if (state is MessagingError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Fetch queries to see history'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MessagingBloc>().add(FetchQueriesRequested());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
