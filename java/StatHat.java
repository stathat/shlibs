import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.BufferedReader;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

class StatHat {

        private static void httpPost(String path, String data) {
                try {
                        URL url = new URL(path);
                        URLConnection conn = url.openConnection();
                        conn.setDoOutput(true);
                        OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
                        wr.write(data);
                        wr.flush();

                        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                        String line;
                        while ((line = rd.readLine()) != null) {
                                System.out.println(line);
                        }
                        wr.close();
                        rd.close();
                }
                catch (Exception e) {
                        System.err.println(e);
                }
        }

        public static void postValue(String userKey, String statKey, Double value) {
                try {
                        String data = URLEncoder.encode("ukey", "UTF-8") + "=" + URLEncoder.encode(userKey, "UTF-8");
                        data += "&" + URLEncoder.encode("key", "UTF-8") + "=" + URLEncoder.encode(statKey, "UTF-8");
                        data += "&" + URLEncoder.encode("value", "UTF-8") + "=" + URLEncoder.encode(value.toString(), "UTF-8");
                        httpPost("http://api.stathat.com/v", data);
                }
                catch (Exception e) {
                        System.err.println("postValue exception:  " + e);
                }
        }

        public static void postCount(String userKey, String statKey, Double count) {
                try {
                        String data = URLEncoder.encode("ukey", "UTF-8") + "=" + URLEncoder.encode(userKey, "UTF-8");
                        data += "&" + URLEncoder.encode("key", "UTF-8") + "=" + URLEncoder.encode(statKey, "UTF-8");
                        data += "&" + URLEncoder.encode("count", "UTF-8") + "=" + URLEncoder.encode(count.toString(), "UTF-8");
                        httpPost("http://api.stathat.com/c", data);
                }
                catch (Exception e) {
                        System.err.println("postCount exception:  " + e);
                }
        }

        public static void ezPostValue(String ezkey, String statName, Double value) {
                try {
                        String data = URLEncoder.encode("ezkey", "UTF-8") + "=" + URLEncoder.encode(ezkey, "UTF-8");
                        data += "&" + URLEncoder.encode("stat", "UTF-8") + "=" + URLEncoder.encode(statName, "UTF-8");
                        data += "&" + URLEncoder.encode("value", "UTF-8") + "=" + URLEncoder.encode(value.toString(), "UTF-8");
                        httpPost("http://api.stathat.com/ez", data);
                }
                catch (Exception e) {
                        System.err.println("ezPostValue exception:  " + e);
                }
        }

        public static void ezPostCount(String ezkey, String statName, Double count) {
                try {
                        String data = URLEncoder.encode("ezkey", "UTF-8") + "=" + URLEncoder.encode(ezkey, "UTF-8");
                        data += "&" + URLEncoder.encode("stat", "UTF-8") + "=" + URLEncoder.encode(statName, "UTF-8");
                        data += "&" + URLEncoder.encode("count", "UTF-8") + "=" + URLEncoder.encode(count.toString(), "UTF-8");
                        httpPost("http://api.stathat.com/ez", data);
                }
                catch (Exception e) {
                        System.err.println("ezPostCount exception:  " + e);
                }
        }
}
