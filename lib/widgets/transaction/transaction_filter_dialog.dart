import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../themes/colors/colors.dart';

class TransactionFilterDialog extends StatefulWidget {
  final String selectedFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String filter, DateTime? start, DateTime? end) onFilterChanged;

  const TransactionFilterDialog({
    super.key,
    required this.selectedFilter,
    required this.startDate,
    required this.endDate,
    required this.onFilterChanged,
  });

  @override
  State<TransactionFilterDialog> createState() =>
      _TransactionFilterDialogState();
}

class _TransactionFilterDialogState extends State<TransactionFilterDialog> {
  late String _selectedFilter;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor:
          isDarkMode ? const Color(MyColor.black) : const Color(MyColor.white),
      surfaceTintColor: const Color(MyColor.pr1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            Icons.filter_list_outlined,
            color: const Color(MyColor.pr8),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            localizations.filterBy,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode
                      ? const Color(MyColor.white)
                      : const Color(MyColor.pr9),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Type Filter
            Text(
              localizations.transactionType,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isDarkMode
                        ? const Color(MyColor.white)
                        : const Color(MyColor.pr9),
              ),
            ),
            const SizedBox(height: 12),
            ..._buildFilterOptions(localizations, theme, isDarkMode),
            const SizedBox(height: 24),

            // Date Range Filter
            Text(
              localizations.dateRange,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isDarkMode
                        ? const Color(MyColor.white)
                        : const Color(MyColor.pr9),
              ),
            ),
            const SizedBox(height: 12),
            _DateRangePicker(
              startDate: _startDate,
              endDate: _endDate,
              onStartDateChanged: (date) => setState(() => _startDate = date),
              onEndDateChanged: (date) => setState(() => _endDate = date),
              theme: theme,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedFilter = 'all';
              _startDate = null;
              _endDate = null;
            });
            widget.onFilterChanged(_selectedFilter, _startDate, _endDate);
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: const Color(MyColor.grey),
          ),
          child: Text(localizations.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onFilterChanged(_selectedFilter, _startDate, _endDate);
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(MyColor.pr8),
            foregroundColor: const Color(MyColor.white),
          ),
          child: const Text('Áp dụng'),
        ),
      ],
    );
  }

  List<Widget> _buildFilterOptions(
    AppLocalizations localizations,
    ThemeData theme,
    bool isDarkMode,
  ) {
    final options = [
      {'value': 'all', 'label': localizations.allTransactions},
      {'value': 'ticket_purchase', 'label': localizations.ticketPurchase},
    ];

    return options.map((option) {
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              _selectedFilter == option['value']
                  ? const Color(MyColor.pr2)
                  : Colors.transparent,
        ),
        child: RadioListTile<String>(
          title: Text(
            option['label']!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  _selectedFilter == option['value']
                      ? const Color(MyColor.pr8)
                      : (isDarkMode
                          ? const Color(MyColor.white)
                          : const Color(MyColor.pr9)),
              fontWeight:
                  _selectedFilter == option['value']
                      ? FontWeight.w600
                      : FontWeight.normal,
            ),
          ),
          value: option['value']!,
          groupValue: _selectedFilter,
          activeColor: const Color(MyColor.pr8),
          onChanged: (value) {
            setState(() {
              _selectedFilter = value!;
            });
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      );
    }).toList();
  }
}

class _DateRangePicker extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final ThemeData theme;

  const _DateRangePicker({
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateButton(
            label: 'Từ ngày',
            date: startDate,
            onPressed: () => _selectDate(context, true),
            theme: theme,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.arrow_forward,
            color: const Color(MyColor.grey),
            size: 16,
          ),
        ),
        Expanded(
          child: _DateButton(
            label: 'Đến ngày',
            date: endDate,
            onPressed: () => _selectDate(context, false),
            theme: theme,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? startDate : endDate) ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(MyColor.pr8),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      if (isStartDate) {
        onStartDateChanged(date);
      } else {
        onEndDateChanged(date);
      }
    }
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onPressed;
  final ThemeData theme;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            date != null ? const Color(MyColor.pr8) : const Color(MyColor.grey),
        side: BorderSide(
          color:
              date != null
                  ? const Color(MyColor.pr8)
                  : const Color(MyColor.grey),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(MyColor.grey),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date != null
                ? DateFormat('dd/MM/yyyy').format(date!)
                : '--/--/----',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color:
                  date != null
                      ? const Color(MyColor.pr8)
                      : const Color(MyColor.grey),
            ),
          ),
        ],
      ),
    );
  }
}
