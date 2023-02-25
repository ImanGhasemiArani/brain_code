import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../commands_controller.dart';
import '../strs.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight:
            kToolbarHeight + MediaQuery.of(context).size.height * 0.25,
        leading: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close_rounded,
              size: 35,
            ),
          ),
        ),
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(40),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(Strs.help,
                style: Theme.of(context).textTheme.headlineLarge),
          ),
        ),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: CommandsController().commands.length,
          itemBuilder: (context, index) {
            final command = CommandsController().commands[index];
            return AnimationConfiguration.staggeredList(
              position: index + 6,
              duration: const Duration(milliseconds: 375),
              child: FadeInAnimation(
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    title: Text(
                      command.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                    subtitle: Text(
                      command.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: ['text', 'rotate', 'move', 'anim', 'select']
                            .contains(command.name)
                        ? IconButton(
                            onPressed: () {},
                            icon: Transform.scale(
                              scaleX: -1,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 30,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : const SizedBox.square(dimension: 30 + 8 * 2),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
