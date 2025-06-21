import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../themes/colors/colors.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final isIncome = transaction.isIncome;
    final amountColor =
        isIncome ? const Color(MyColor.pr4) : const Color(MyColor.red);
    final amountPrefix = isIncome ? '+' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? const Color(MyColor.black)
                : const Color(MyColor.white),
        borderRadius: BorderRadius.circular(12),
        border:
            isDarkMode
                ? Border.all(color: const Color(MyColor.white).withOpacity(0.2))
                : null,
        boxShadow:
            isDarkMode
                ? null
                : [
                  BoxShadow(
                    color: const Color(MyColor.black).withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getTransactionTypeColor(
            transaction.type,
          ).withOpacity(0.15),
          child: Icon(
            _getTransactionTypeIcon(transaction.type),
            color: _getTransactionTypeColor(transaction.type),
            size: 20,
          ),
        ),
        title: Text(
          transaction.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color:
                isDarkMode
                    ? const Color(MyColor.white)
                    : const Color(MyColor.pr9),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(transaction.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isDarkMode
                        ? const Color(MyColor.white).withOpacity(0.7)
                        : const Color(MyColor.grey),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${AppLocalizations.of(context)!.transactionCode}: ${transaction.transactionCode}',
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isDarkMode
                        ? const Color(MyColor.white).withOpacity(0.7)
                        : const Color(MyColor.grey),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$amountPrefix${NumberFormat('#,###', 'vi_VN').format(transaction.amount.abs())} đ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
            const SizedBox(height: 6),
            _StatusBadge(
              status: transaction.status,
              textTheme: theme.textTheme,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getTransactionTypeColor(String type) {
    switch (type) {
      case 'ticket_purchase':
        return const Color(MyColor.pr8); // Light green for tickets
      case 'wallet_topup':
        return const Color(MyColor.pr4); // Green accent
      case 'refund':
        return const Color(MyColor.pr7); // Blue accent
      default:
        return const Color(MyColor.grey);
    }
  }

  IconData _getTransactionTypeIcon(String type) {
    switch (type) {
      case 'ticket_purchase':
        return Icons.confirmation_number_outlined;
      case 'wallet_topup':
        return Icons.account_balance_wallet_outlined;
      case 'refund':
        return Icons.money_off_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final TextTheme textTheme;

  const _StatusBadge({required this.status, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        _getStatusText(status, context),
        style: textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'success':
        return const Color(MyColor.pr8); // Success color
      case 'pending':
        return const Color(MyColor.pr7); // Pending blue
      case 'failed':
        return const Color(MyColor.red); // Failed red
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
