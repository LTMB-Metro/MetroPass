import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction_model.dart';
import '../../themes/colors/colors.dart';
import '../../widgets/skeleton/transaction_card_skeleton.dart';
import '../../widgets/transaction/transaction_card.dart';
import '../../widgets/transaction/transaction_details_sheet.dart';
import '../../widgets/transaction/transaction_filter_dialog.dart';

class ProfileTransactionPage extends StatefulWidget {
  const ProfileTransactionPage({super.key});

  @override
  State<ProfileTransactionPage> createState() => _ProfileTransactionPageState();
}

class _ProfileTransactionPageState extends State<ProfileTransactionPage> {
  final TransactionController _transactionController = TransactionController();
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _selectedFilter = 'all'; // all, ticket_purchase, wallet_topup, refund
  DateTime? _startDate;
  DateTime? _endDate;
  List<TransactionModel> _filteredTransactions = [];
  List<TransactionModel> _allTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTransactions() async {
    setState(() => _isLoading = true);

    try {
      await _loadTransactionsFromUserTickets();
      _formatTransactionDescriptions();
    } catch (e) {
      debugPrint('Lỗi khi tải giao dịch: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadTransactionsFromUserTickets() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      // Lấy tất cả vé từ subcollection user_tickets
      final querySnapshot =
          await _db
              .collection('users')
              .doc(currentUser.uid)
              .collection('user_tickets')
              .orderBy('booking_time', descending: true)
              .get();

      _allTransactions =
          querySnapshot.docs.map((doc) {
            final data = doc.data();

            // Tạo mã giao dịch từ ticket ID (6 ký tự cuối)
            final ticketId = doc.id;
            final transactionCode =
                '#MT${ticketId.substring(ticketId.length - 6).toUpperCase()}';

            // Chuyển đổi timestamp thành DateTime
            DateTime bookingTime;
            if (data['booking_time'] is Timestamp) {
              bookingTime = (data['booking_time'] as Timestamp).toDate();
            } else {
              bookingTime = DateTime.now();
            }

            return TransactionModel(
              transactionId: doc.id,
              userId: currentUser.uid,
              type: 'ticket_purchase',
              description: 'Mua ${data['ticket_name'] ?? 'vé metro'}',
              amount: -(data['price'] ?? 0).toInt(),
              transactionCode: transactionCode,
              createdAt: bookingTime,
              status: _mapTicketStatusToTransactionStatus(
                data['status'] ?? 'available',
              ),
              relatedTicketId: doc.id,
            );
          }).toList();

      _filteredTransactions = List.from(_allTransactions);
      setState(() {});
    } catch (e) {
      debugPrint('Lỗi khi tải từ user_tickets: $e');
      _allTransactions = [];
      _filteredTransactions = [];
    }
  }

  void _formatTransactionDescriptions() {
    final localizations = AppLocalizations.of(context)!;
    _allTransactions =
        _allTransactions.map((transaction) {
          if (transaction.type == 'ticket_purchase') {
            // Extract ticket name from description (remove "Mua " prefix)
            final ticketName = transaction.description.replaceFirst('Mua ', '');
            return TransactionModel(
              transactionId: transaction.transactionId,
              userId: transaction.userId,
              type: transaction.type,
              description: localizations.purchaseTicket(ticketName),
              amount: transaction.amount,
              transactionCode: transaction.transactionCode,
              createdAt: transaction.createdAt,
              status: transaction.status,
              relatedTicketId: transaction.relatedTicketId,
              metadata: transaction.metadata,
            );
          }
          return transaction;
        }).toList();
    _filteredTransactions = List.from(_allTransactions);
  }

  String _mapTicketStatusToTransactionStatus(String ticketStatus) {
    switch (ticketStatus) {
      case 'available':
      case 'unused':
        return 'success';
      case 'expired':
        return 'failed';
      case 'used':
        return 'success';
      default:
        return 'success';
    }
  }

  void _filterTransactions() {
    setState(() {
      _filteredTransactions =
          _allTransactions.where((transaction) {
            // Filter by type
            if (_selectedFilter != 'all' &&
                transaction.type != _selectedFilter) {
              return false;
            }

            // Filter by date range
            if (_startDate != null && _endDate != null) {
              if (transaction.createdAt.isBefore(_startDate!) ||
                  transaction.createdAt.isAfter(
                    _endDate!.add(Duration(days: 1)),
                  )) {
                return false;
              }
            }

            // Filter by search text
            final searchText = _searchController.text.toLowerCase();
            if (searchText.isNotEmpty) {
              return transaction.description.toLowerCase().contains(
                    searchText,
                  ) ||
                  transaction.transactionCode.toLowerCase().contains(
                    searchText,
                  );
            }

            return true;
          }).toList();
    });
  }

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder:
          (context) => TransactionFilterDialog(
            selectedFilter: _selectedFilter,
            startDate: _startDate,
            endDate: _endDate,
            onFilterChanged: (filter, start, end) {
              setState(() {
                _selectedFilter = filter;
                _startDate = start;
                _endDate = end;
              });
              _filterTransactions();
            },
          ),
    );
  }

  void _showTransactionDetails(TransactionModel transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionDetailsSheet(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(MyColor.black) : const Color(MyColor.pr1),
      appBar: AppBar(
        title: Text(localizations.transactionHistory),
        backgroundColor:
            isDarkMode ? const Color(MyColor.black) : const Color(MyColor.pr8),
        foregroundColor: const Color(MyColor.white),
        elevation: 0,
        shape:
            isDarkMode
                ? const Border(
                  bottom: BorderSide(color: Color(MyColor.white), width: 0.5),
                )
                : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: _showFilterDialog,
            tooltip: localizations.filterBy,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _loadTransactions,
            tooltip: localizations.refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? const Color(MyColor.black)
                      : const Color(MyColor.pr8),
              border:
                  isDarkMode
                      ? const Border(
                        bottom: BorderSide(
                          color: Color(MyColor.white),
                          width: 0.5,
                        ),
                      )
                      : null,
              boxShadow:
                  isDarkMode
                      ? null
                      : [
                        BoxShadow(
                          color: const Color(MyColor.black).withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterTransactions(),
              style: const TextStyle(color: Color(MyColor.white)),
              decoration: InputDecoration(
                hintText: localizations.searchTransactions,
                hintStyle: TextStyle(
                  color: const Color(MyColor.white).withOpacity(0.7),
                ),
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: const Color(MyColor.white).withOpacity(0.7),
                ),
                filled: true,
                fillColor: const Color(MyColor.white).withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Transaction List
          Expanded(
            child:
                _isLoading
                    ? _buildLoadingState()
                    : _filteredTransactions.isEmpty
                    ? _buildEmptyState(theme, localizations, isDarkMode)
                    : RefreshIndicator(
                      onRefresh: () async => _loadTransactions(),
                      color: const Color(MyColor.pr8),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _filteredTransactions[index];
                          return TransactionCard(
                            transaction: transaction,
                            onTap: () => _showTransactionDetails(transaction),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const TransactionCardSkeleton();
      },
    );
  }

  Widget _buildEmptyState(
    ThemeData theme,
    AppLocalizations localizations,
    bool isDarkMode,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: const Color(MyColor.grey).withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.noTransactions,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isDarkMode
                        ? const Color(MyColor.white).withOpacity(0.8)
                        : const Color(MyColor.pr9).withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localizations.noTransactionsMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isDarkMode
                        ? const Color(MyColor.white).withOpacity(0.6)
                        : const Color(MyColor.pr9).withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTransactionTypeColor(String type) {
    switch (type) {
      case 'ticket_purchase':
        return const Color(MyColor.pr5);
      case 'wallet_topup':
        return const Color(MyColor.pr4);
      case 'refund':
        return const Color(MyColor.pr7);
      default:
        return const Color(MyColor.grey);
    }
  }

  IconData _getTransactionTypeIcon(String type) {
    switch (type) {
      case 'ticket_purchase':
        return Icons.confirmation_number;
      case 'wallet_topup':
        return Icons.account_balance_wallet;
      case 'refund':
        return Icons.money_off;
      default:
        return Icons.receipt;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'success':
        return const Color(MyColor.pr4);
      case 'pending':
        return const Color(MyColor.pr7);
      case 'failed':
        return const Color(MyColor.red);
      default:
        return const Color(MyColor.grey);
    }
  }
}
