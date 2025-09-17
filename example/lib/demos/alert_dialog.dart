import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

class AlertDialogDemoPage extends StatefulWidget {
  const AlertDialogDemoPage({super.key});

  @override
  State<AlertDialogDemoPage> createState() => _AlertDialogDemoPageState();
}

class _AlertDialogDemoPageState extends State<AlertDialogDemoPage> {
  String _last = 'None';

  Future<void> _showAlert() async {
    final index = await CNAlertDialog.show(
      context: context,
      title: 'Delete File?',
      message: 'This action cannot be undone.',
      actions: const [
        CNAlertAction(label: 'Cancel', style: CNAlertActionStyle.cancel),
        CNAlertAction(label: 'Delete', style: CNAlertActionStyle.destructive),
      ],
      style: CNAlertPresentationStyle.alert,
    );
    setState(() => _last = 'Alert result: ${index ?? 'cancel'}');
  }

  Future<void> _showActionSheet() async {
    final index = await CNAlertDialog.show(
      context: context,
      title: 'Choose Option',
      actions: const [
        CNAlertAction(label: 'Copy'),
        CNAlertAction(label: 'Share'),
        CNAlertAction(label: 'Delete', style: CNAlertActionStyle.destructive),
        CNAlertAction(label: 'Cancel', style: CNAlertActionStyle.cancel),
      ],
      style: CNAlertPresentationStyle.actionSheet,
    );
    setState(() => _last = 'Sheet result: ${index ?? 'cancel'}');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Alert Dialog')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoListSection.insetGrouped(
              header: const Text('Dialogs'),
              children: [
                CupertinoListTile(
                  title: const Text('Show Alert'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _showAlert,
                ),
                CupertinoListTile(
                  title: const Text('Show Action Sheet'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _showActionSheet,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(child: Text('Last: $_last')),
          ],
        ),
      ),
    );
  }
}

