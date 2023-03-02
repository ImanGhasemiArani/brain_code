import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import '../strs.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close_rounded,
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontSize: 40),
                          children: [
                            const TextSpan(text: Strs.appNameP1),
                            TextSpan(
                              text: ' ${Strs.appNameP2} ',
                              style: TextStyle(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    Strs.by,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontSize: 30),
                          children: [
                            TextSpan(
                              text: ' ${Strs.nameP1} ',
                              style: TextStyle(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            const TextSpan(text: ' ${Strs.nameP2}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.shop_rounded,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            url.launchUrl(
                                Uri.parse('https://t.me/iman_ghasemi_arani'),
                                mode: url.LaunchMode.externalApplication);
                          },
                          icon: const Icon(
                            CupertinoIcons.paperplane_fill,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            url.launchUrl(Uri.parse(
                                'mailto:ghassemiimaniman2002@gmail.com?subject=Brain Code&body='));
                          },
                          icon: const Icon(
                            CupertinoIcons.envelope_fill,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            url.launchUrl(
                                Uri.https('imanghasemiarani.github.io'),
                                mode: url.LaunchMode.externalApplication);
                          },
                          icon: const Icon(
                            Icons.language_rounded,
                            size: 40,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Text(
              '${Strs.version} ۱.۰.۰',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
