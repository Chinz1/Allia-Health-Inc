class NetworkDataResponse<T> {
  late Status status;
  T? data;
  late String message;

  NetworkDataResponse.idle() : status = Status.IDLE;

  NetworkDataResponse.loading(this.message) : status = Status.LOADING;

  NetworkDataResponse.completed(this.data) : status = Status.COMPLETED;

  NetworkDataResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }

}

enum Status { LOADING, COMPLETED, ERROR, IDLE }