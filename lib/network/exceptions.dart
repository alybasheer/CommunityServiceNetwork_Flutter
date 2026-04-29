 abstract class AppExceptions implements Exception{
 final String msg;
 final String? details;
 AppExceptions(this.msg,this.details);


 }
 class FetchDataExceptions extends AppExceptions {
  FetchDataExceptions([String? msg]) : super(msg!, '');

 }
 class BadRequestException  extends AppExceptions{
 BadRequestException ([String? msg]) : super (msg!, 'Invalid Request: ');
}
 class UnauthorizedException  extends AppExceptions{
 UnauthorizedException ([String? msg]) : super (msg!, 'Unauthorized: ');
}
 class InvalidInputException  extends AppExceptions{
 InvalidInputException ([String? msg]) : super (msg!, 'Invalid Input:');
}


