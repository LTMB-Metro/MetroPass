import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../themes/colors/colors.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailsSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? const Color(MyColor.black)
                : const Color(MyColor.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDarkMode
                  ? const Color(MyColor.white).withOpacity(0.2)
                  : const Color(MyColor.grey).withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  color: const Color(MyColor.pr2),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localizations.transactionDetails,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode
                              ? const Color(MyColor.white)
                              : const Color(MyColor.pr9),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Transaction details
            _DetailRow(
              label: localizations.transactionCode,
              value: transaction.transactionCode,
              theme: theme,
              isDarkMode: isDarkMode,
            ),
            _DetailRow(
              label: localizations.description,
              value: transaction.description,
              theme: theme,
              isDarkMode: isDarkMode,
            ),
            _DetailRow(
              label: localizations.amount,
              value:
                  '${transaction.isIncome ? '+' : '-'}${NumberFormat('#,###', 'vi_VN').format(transaction.amount.abs())} đ',
              valueColor:
                  transaction.isIncome
                      ? const Color(MyColor.pr4)
                      : const Color(MyColor.red),
              theme: theme,
              isDarkMode: isDarkMode,
            ),
            _DetailRow(
              label: localizations.date,
              value: DateFormat(
                'dd/MM/yyyy HH:mm:ss',
              ).format(transaction.createdAt),
              theme: theme,
              isDarkMode: isDarkMode,
            ),
            _DetailRow(
              label: localizations.status,
              value: _getStatusText(transaction.status, context),
              valueColor: _getStatusColor(transaction.status),
              theme: theme,
              isDarkMode: isDarkMode,
            ),

            if (transaction.relatedTicketId != null) ...[
              _DetailRow(
                label: 'Ticket ID',
                value: transaction.relatedTicketId!,
                theme: theme,
                isDarkMode: isDarkMode,
                isSmallText: true,
              ),
            ],

            const SizedBox(height: 32),

            // Close button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(MyColor.pr8),
                  foregroundColor: const Color(MyColor.white),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  localizations.close,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'success':
        return const Color(MyColor.pr8);
      case 'pending':
        return const Color(MyColor.pr7);
      case 'failed':
        return const Color(MyColor.red);
      default:
        return const Color(MyColor.grey);
    }
  }

  String _getStatusText(String status, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (status) {
      case 'success':
        return localizations.success;
      case 'pending':
        return localizations.pending;
      case 'failed':
        return localizations.failed;
      default:
        return status;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final ThemeData theme;
  final bool isDarkMode;
  final bool isSmallText;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    required this.theme,
    required this.isDarkMode,
    this.isSmallText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: (isSmallText
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(
                    color:
                        isDarkMode
                            ? const Color(MyColor.white).withOpacity(0.7)
                            : const Color(MyColor.grey),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: (isSmallText
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(
                    color:
                        valueColor ??
                        (isDarkMode
                            ? const Color(MyColor.white)
                            : const Color(MyColor.pr9)),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
