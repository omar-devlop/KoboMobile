import 'package:flutter/material.dart';

class ThemeColorSettingWidget extends StatelessWidget {
  const ThemeColorSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Strings texts = Strings.of(context);
    // Settings appSettings = ref.watch(settingsProvider);
    Color selectedThemeColor = Colors.red;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.onInverseSurface,
      ),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(vertical: 16),
        leading: Icon(Icons.color_lens, color: theme.colorScheme.primary),
        collapsedIconColor: theme.colorScheme.primary,
        initiallyExpanded: true,
        shape: Border(),
        title: Text(
          'texts.colorTheme',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {},
                    // => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.white),
                    icon: Icon(
                      selectedThemeColor == Colors.white
                          ? Icons.hdr_auto
                          : Icons.hdr_auto_outlined,
                    ),
                    color: theme.colorScheme.primary,
                  ),
                  IconButton(
                    onPressed: () {},
                    //  => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.indigo),
                    icon: Icon(
                      selectedThemeColor == Colors.indigo
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.indigo,
                  ),
                  IconButton(
                    onPressed: () {},
                    //  => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.blue),
                    icon: Icon(
                      selectedThemeColor == Colors.blue
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () {},
                    // () => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.teal),
                    icon: Icon(
                      selectedThemeColor == Colors.teal
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.teal,
                  ),
                  IconButton(
                    onPressed: () {},
                    // => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.green),
                    icon: Icon(
                      selectedThemeColor == Colors.green
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.green,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {},
                    //  => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.yellow),
                    icon: Icon(
                      selectedThemeColor == Colors.yellow
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.yellow,
                  ),
                  IconButton(
                    onPressed: () {},
                    // => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.orange),
                    icon: Icon(
                      selectedThemeColor == Colors.orange
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.orange,
                  ),
                  IconButton(
                    onPressed: () {},
                    //  => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.deepOrange),
                    icon: Icon(
                      selectedThemeColor == Colors.deepOrange
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.deepOrange,
                  ),
                  IconButton(
                    onPressed: () {},
                    //  => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.pink),
                    icon: Icon(
                      selectedThemeColor == Colors.pink
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.pink,
                  ),
                  IconButton(
                    onPressed: () {},
                    //  => ref
                    //     .read(settingsProvider.notifier)
                    //     .setThemeColor(Colors.purple),
                    icon: Icon(
                      selectedThemeColor == Colors.purple
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    color: Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
