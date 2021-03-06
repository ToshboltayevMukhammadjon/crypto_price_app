import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crypto_app/models/coin_model.dart';
import 'package:crypto_app/repositories/crypto_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'crypto_event.dart';

part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository _cryptoRepository;

  CryptoBloc({@required CryptoRepository cryptoRepository})
      : assert(cryptoRepository != null),
        _cryptoRepository = cryptoRepository, super(null);

  @override
  Stream<CryptoState> mapEventToState(CryptoEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCoins) {
      yield* _getCoins(coins: []);
    } else if (event is LoadMoreCoins) {
      yield* _mapLoadMoreCoins(event);
    }
  }


  CryptoState get initialState => CryptoEmpty();

  Stream<CryptoState> _getCoins({List<Coin> coins, int page = 0}) async* {
    try {
      List<Coin> newCoinsList =
          coins + await _cryptoRepository.getTopCoins(page: page);
      yield CryptoLoaded(coins: newCoinsList);
    } catch (err) {
      yield CryptoError();
    }
  }

  Stream<CryptoState> _mapAppStartedToState() async* {
    yield CryptoLoading();
    yield* _getCoins(coins: []);
  }

  Stream<CryptoState> _mapLoadMoreCoins(LoadMoreCoins event) async* {
    final int nextPage = event.coins.length ~/ CryptoRepository.perPage;
    yield* _getCoins(coins: event.coins, page: nextPage);
  }
}