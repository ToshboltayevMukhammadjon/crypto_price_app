import 'package:crypto_app/blocs/crypto_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Top Coins',
          ),
        ),
        body: BlocBuilder<CryptoBloc, CryptoState>(

          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Theme.of(context).primaryColor,
                    Colors.grey[900]
                  ])),
              child: _buildBody(state),
            );
          },
        ),
      ),
    );
  }

  _buildBody(CryptoState state) {
    if (state is CryptoLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
        ),
      );
    } else if (state is CryptoLoaded) {
      return RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          BlocProvider.of<CryptoBloc>(context).add(RefreshCoins());
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification)=>_onScrollNotification(notification, state),
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              final coin = state.coins[index];
              return ListTile(
                leading: Text('${++index}',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600)),
                title: Text(
                  coin.fullName,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  coin.name,
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  '\$${coin.price.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600),
                ),
              );
            },
            itemCount: state.coins.length,
          ),
        ),
      );
    } else if (state is CryptoError) {
      return Center(
        child: Text(
          'Error loading coins!\nPlease check your connection',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }


  bool _onScrollNotification(ScrollNotification notification, CryptoLoaded state){
    if(notification is ScrollNotification && _scrollController.position.extentAfter==0){
      BlocProvider.of<CryptoBloc>(context).add(LoadMoreCoins(coins: state.coins));
    }
    return false;
  }

}
