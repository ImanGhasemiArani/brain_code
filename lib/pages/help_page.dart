import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../commands_controller.dart';
import '../widgets/command_text.dart';
import 'levels/l_test.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lTestObjController = TestLObjController();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight:
            kToolbarHeight + MediaQuery.of(context).size.height * 0.25,
        flexibleSpace: TestL(lTestObjController),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: CommandsController().commands.length,
          itemBuilder: (context, index) {
            final command = CommandsController().commands[index];
            return AnimationConfiguration.staggeredList(
              position: index + 7,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: Text(
                        command.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.blue.shade800,
                              fontFamily: 'Inconsolata',
                            ),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            command.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 10),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: command.example
                                      .split('\n')
                                      .map(
                                        (e) => TextCommand(e),
                                      )
                                      .toList(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: ['text', 'rotate', 'move', 'anim', 'select']
                              .contains(command.name)
                          ? IconButton(
                              onPressed: () {
                                switch (command.name) {
                                  case 'text':
                                    return () => lTestObjController
                                        .runCommandText(context, '');
                                  case 'rotate':
                                    return () => lTestObjController
                                        .runCommandRotate(context, '');
                                  case 'move':
                                    return () => lTestObjController
                                        .runCommandMove(context, '');
                                  case 'anim':
                                    return () => lTestObjController
                                        .runCommandAnim(context, '');
                                  case 'select':
                                    return () => lTestObjController
                                        .runCommandSelect(context, '');
                                  default:
                                    return null;
                                }
                              }(),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
