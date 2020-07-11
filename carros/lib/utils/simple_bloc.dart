import 'dart:async';

class SimpleBloc<T>{
  final _controller = StreamController<T>();

  //Nunca deixe o acesso as propriedades da classe de forma direta.
  Stream<T> get stream => _controller.stream;

  void add(T object){
    _controller.add(object);
  }

  void addError(Object error){
    if (!_controller.isClosed) {
      _controller.addError(error);
    }
  }


  void dispose() {
    //Destroi ou fecha o Listener do Stream.
    _controller.close();
  }
}