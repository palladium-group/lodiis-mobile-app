
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/monitoring_option.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/monitoring_picker_util.dart';

class MonitoringPickerSheet extends StatelessWidget {
  final bool isHousehold;
  final void Function(MonitoringOption option) onSelect;

  const MonitoringPickerSheet({
    Key? key,
    required this.isHousehold,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = MonitoringPickerUtil.optionsForCurrentSelection(
      context,
      isHousehold: isHousehold,
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: items.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text('No suitable monitoring forms available'),
          ),
        )
            : ListView.separated(
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, idx) {
            final opt = items[idx];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: CircleAvatar(
                child: Icon(opt.icon),
              ),
              title: Text(opt.title),
              subtitle: opt.subtitle == null ? null : Text(opt.subtitle!),
              onTap: () {
                Navigator.of(context).pop();
                onSelect(opt);
              },
            );
          },
        ),
      ),
    );
  }
}
