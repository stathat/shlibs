import haxe.Http;

/*
 * Make sure you're using the latest version of HaXe (tested as working with 3.1.3).
 */
class StatHat
{
  private static var API_ENDPOINT:String    = "http://api.stathat.com/"; 
  private static var EZ_API_ENDPOINT:String = "http://api.stathat.com/ez";

  public static function postValue(userKey:String, statKey:String, value:Float):Void
  {
    var request:Http = new Http(API_ENDPOINT + "v");
    request.setParameter("key", statKey);
    request.setParameter("ukey", userKey);
    request.setParameter("value", '$value');

    request.request(true);
  }

  public static function postCount(userKey:String, statKey:String, count:Float):Void
  {
    var request:Http = new Http(API_ENDPOINT + "c");
    request.setParameter("key", statKey);
    request.setParameter("ukey", userKey);
    request.setParameter("count", '$count');

    request.request(true);
  }

  public static function ezPostValue(ezkey:String, statName:String, value:Float):Void
  {
    var request:Http = new Http(EZ_API_ENDPOINT);
    request.setParameter("stat", statName);
    request.setParameter("ezkey", ezkey);
    request.setParameter("value", '$value');

    request.request(true);
  }

  public static function ezPostCount(ezkey:String, statName:String, count:Float):Void
  {
    var request:Http = new Http(EZ_API_ENDPOINT);
    request.setParameter("stat", statName);
    request.setParameter("ezkey", ezkey);
    request.setParameter("count", '$count');

    request.request(true);
  }
}