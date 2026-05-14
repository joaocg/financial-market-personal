import 'package:equatable/equatable.dart';

class FamilyAccount extends Equatable {
  final String id;
  final String bankName;
  final String accountType;
  final double balance;

  const FamilyAccount({
    required this.id,
    required this.bankName,
    required this.accountType,
    required this.balance,
  });

  factory FamilyAccount.fromJson(Map<String, dynamic> json) {
    return FamilyAccount(
      id: json['id'],
      bankName: json['bank_name'],
      accountType: json['account_type'] ?? 'Standard',
      balance: (json['balance'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, bankName, accountType, balance];
}
