part of 'crypto_bloc.dart';

abstract class CryptoState extends Equatable {
  const CryptoState();

  @override
  List<Object> get props => [];
}

class CryptoEmpty extends CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<Coin> coins;

  CryptoLoaded({this.coins});

  @override
  List<Object> get props => [coins];

  @override
  String toString() => 'Crypto Loaded {coins = $coins}';
}

class CryptoError extends CryptoState {}