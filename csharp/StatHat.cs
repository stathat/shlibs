using System;
using System.Collections.Generic;
using System.IO;
using System.Net;

namespace StatHat
{
    // Delegates
    public delegate void ReplyDelegate(string reply);

    public static class Post
    {
        // ===================
        // How to use StatHat:
        // ===================
        //
        // 1. Add StatHat.cs to your .NET project.
        // 2. Call its functions!
        //
        // -----------------------------------------------------------------------------------
        //
        // A simple example of posting a Counter:
        //
        //    StatHat.Post.Counter("FERF34fREF3443432","23FSDfEFWFEF22323", 9.95);
        //
        // -----------------------------------------------------------------------------------
        //
        // A simple example of posting a Value:
        //
        //    StatHat.Post.Value("FERF34fREF3443432","23FSDfEFWFEF22323", 512.2);
        //
        // -----------------------------------------------------------------------------------
        //
        // A simple example of posting a counter with our EZ API - this registers the stat automatically
        // if it doesn't exist (and registers you for the site if you don't have a membership):
        //
        //    StatHat.Post.EzCounter("you@example.com","dollars earned", 9.95);
        //
        // -----------------------------------------------------------------------------------
        //
        // If you care to read what the server is replying to your call (for error handling, curiosity, etc.)
        // you can pass a delegate function expecting a string for callback. Like so:
        //
        //
        //    // Here's some function I want StatHat to call with the reply:
        //    // ---------------------------------------------------
        //    void PrintStatHatReply(string reply) { Console.WriteLine(reply); }
        //
        //    // Make a delegate out of it.
        //    // -----------------------------
        //    StatHat.ReplyDelegate myDelegate = new StatHat.ReplyDelegate(PrintStatHatReply);
        //
        //    // Pass that delegate as a parameter:
        //    // ----------------------------------
        //    StatHat.Post.Counter("FERF34fREF3443432","23FSDfEFWFEF22323", 1.0, myDelegate);
        //
        //

        private const string BaseUrl = "http://api.stathat.com";

        /// <summary>
        /// Posts a counter increment to stathat over HTTP
        /// </summary>
        /// <param name="key">the stat's posting key</param>
        /// <param name="ukey">your user key</param>
        /// <param name="count">the number to increment</param>
        public static void Counter(string key, string ukey, float count)
        {
            var p = new Dictionary<string, string>
            {
                { "key", key },
                { "ukey", ukey },
                { "count", count.ToString() },
                { "vb", "1" }
            };
            new FormPoster(Post.BaseUrl, "/c", p);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP
        /// </summary>
        /// <param name="key">the stat's posting key</param>
        /// <param name="ukey">your user key</param>
        /// <param name="count">the number to increment</param>
        public static void Counter(string key, string ukey, int count)
        {
            Post.Counter(key, ukey, (float)count);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP
        /// </summary>
        /// <param name="key">the stat's posting key</param>
        /// <param name="ukey">your user key</param>
        /// <param name="count">the number to increment</param>
        /// <param name="replyDelegate">the function you'd like called with the reply from stathat's server</param>
        public static void Counter(string key, string ukey, float count, ReplyDelegate replyDelegate)
        {
            var p = new Dictionary<string, string>
            {
                { "key", key },
                { "ukey", ukey },
                { "count", count.ToString() },
                { "vb", "1" }
            };
            new FormPoster(Post.BaseUrl, "/c", p, replyDelegate);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP
        /// </summary>
        /// <param name="key">the stat's posting key</param>
        /// <param name="ukey">your user key</param>
        /// <param name="count">the number to increment</param>
        /// <param name="replyDelegate">the function you'd like called with the reply from stathat's server</param>
        public static void Counter(string key, string ukey, int count, ReplyDelegate replyDelegate)
        {
            Post.Counter(key, ukey, (float)count, replyDelegate);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP using ez API - the stat and/or you don't have to be pre-registered
        /// </summary>
        /// <param name="ezkey">your ezkey (defaults to email address).  If you already have a stathat account, use the one associated with it.</param>
        /// <param name="stat">the name for your stat</param>
        /// <param name="count">the number to increment</param>
        public static void EzCounter(string ezkey, string stat, float count)
        {
            var p = new Dictionary<string, string>
            {
                { "ezkey", ezkey },
                { "stat", stat },
                { "count", count.ToString() },
                { "vb", "1" }
            };
            new FormPoster(Post.BaseUrl, "/ez", p);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP using ez API - the stat and/or you don't have to be pre-registered
        /// </summary>
        /// <param name="ezkey">your ezkey (defaults to email address).  If you already have a stathat account, use the one associated with it.</param>
        /// <param name="stat">the name for your stat</param>
        /// <param name="count">the number to increment</param>
        public static void EzCounter(string ezkey, string stat, int count)
        {
            Post.EzCounter(ezkey, stat, (float)count);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP using ez API - the stat and/or you don't have to be pre-registered
        /// </summary>
        /// <param name="ezkey">your ezkey (defaults to email address).  If you already have a stathat account, use the one associated with it.</param>
        /// <param name="stat">the name for your stat</param>
        /// <param name="count">the number to increment</param>
        /// <param name="replyDelegate">the function you'd like called with the reply from stathat's server</param>
        public static void EzCounter(string ezkey, string stat, float count, ReplyDelegate replyDelegate)
        {
            var p = new Dictionary<string, string>
            {
                { "ezkey", ezkey },
                { "stat", stat },
                { "count", count.ToString() },
                { "vb", "1" }
            };
            new FormPoster(Post.BaseUrl, "/ez", p, replyDelegate);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP using ez API - the stat and/or you don't have to be pre-registered
        /// </summary>
        /// <param name="ezkey">your ezkey (defaults to email address).  If you already have a stathat account, use the one associated with it.</param>
        /// <param name="stat">the name for your stat</param>
        /// <param name="count">the number to increment</param>
        /// <param name="replyDelegate">the function you'd like called with the reply from stathat's server</param>
        public static void EzCounter(string ezkey, string stat, int count, ReplyDelegate replyDelegate)
        {
            Post.EzCounter(ezkey, stat, (float)count, replyDelegate);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP using ez API - the stat and/or you don't have to be pre-registered
        /// </summary>
        /// <param name="ezkey">your ezkey (defaults to email address).  If you already have a stathat account, use the one associated with it.</param>
        /// <param name="stat">the name for your stat</param>
        /// <param name="count">the number</param>
        public static void EzValue(string ezkey, string stat, float value)
        {
            var p = new Dictionary<string, string>
            {
                { "ezkey", ezkey },
                { "stat", stat },
                { "value", value.ToString() },
                { "vb", "1" }
            };
            new FormPoster(Post.BaseUrl, "/ez", p);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP using ez API - the stat and/or you don't have to be pre-registered
        /// </summary>
        /// <param name="ezkey">your ezkey (defaults to email address).  If you already have a stathat account, use the one associated with it.</param>
        /// <param name="stat">the name for your stat</param>
        /// <param name="count">the number</param>
        public static void EzValue(string ezkey, string stat, int value)
        {
            Post.EzValue(ezkey, stat, (float)value);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP using ez API - the stat and/or you don't have to be pre-registered
        /// </summary>
        /// <param name="ezkey">your ezkey (defaults to email address).  If you already have a stathat account, use the one associated with it.</param>
        /// <param name="stat">the name for your stat</param>
        /// <param name="count">the number</param>
        /// <param name="replyDelegate">the function you'd like called with the reply from stathat's server</param>
        public static void EzValue(string ezkey, string stat, float value, ReplyDelegate replyDelegate)
        {
            var p = new Dictionary<string, string>
            {
                { "ezkey", ezkey },
                { "stat", stat },
                { "value", value.ToString() },
                { "vb", "1" }
            };
            new FormPoster(Post.BaseUrl, "/ez", p, replyDelegate);
        }

        /// <summary>
        /// Posts a counter increment to stathat over HTTP using ez API - the stat and/or you don't have to be pre-registered
        /// </summary>
        /// <param name="ezkey">your ezkey (defaults to email address).  If you already have a stathat account, use the one associated with it.</param>
        /// <param name="stat">the name for your stat</param>
        /// <param name="count">the number</param>
        /// <param name="replyDelegate">the function you'd like called with the reply from stathat's server</param>
        public static void EzValue(string ezkey, string stat, int value, ReplyDelegate replyDelegate)
        {
            Post.EzValue(ezkey, stat, (float)value, replyDelegate);
        }

        /// <summary>
        /// Posts a value to stathat over HTTP
        /// </summary>
        /// <param name="key">the stat's posting key</param>
        /// <param name="ukey">your user key</param>
        /// <param name="value">the number</param>
        public static void Value(string key, string ukey, float value)
        {
            var p = new Dictionary<string, string>
            {
                { "key", key },
                { "ukey", ukey },
                { "value", value.ToString() },
                { "vb", "1" }
            };
            new FormPoster(Post.BaseUrl, "/v", p);
        }

        /// <summary>
        /// Posts a value to stathat over HTTP
        /// </summary>
        /// <param name="key">the stat's posting key</param>
        /// <param name="ukey">your user key</param>
        /// <param name="value">the number</param>
        public static void Value(string key, string ukey, int value)
        {
            Post.Value(key, ukey, (float)value);
        }

        /// <summary>
        /// Posts a value to stathat over HTTP
        /// </summary>
        /// <param name="key">the stat's posting key</param>
        /// <param name="ukey">your user key</param>
        /// <param name="value">the number</param>
        /// <param name="replyDelegate">the function you'd like called with the reply from stathat's server</param>
        public static void Value(string key, string ukey, float value, ReplyDelegate replyDelegate)
        {
            var p = new Dictionary<string, string>
            {
                { "key", key },
                { "ukey", ukey },
                { "value", value.ToString() },
                { "vb", "1" }
            };
            new FormPoster(Post.BaseUrl, "/v", p, replyDelegate);
        }

        /// <summary>
        /// Posts a value to stathat over HTTP
        /// </summary>
        /// <param name="key">the stat's posting key</param>
        /// <param name="ukey">your user key</param>
        /// <param name="value">the number</param>
        /// <param name="replyDelegate">the function you'd like called with the reply from stathat's server</param>
        public static void Value(string key, string ukey, int value, ReplyDelegate replyDelegate)
        {
            Post.Value(key, ukey, (float)value, replyDelegate);
        }

        private class FormPoster
        {
            private readonly string _baseUrl;

            private readonly Dictionary<string, string> _parameters;

            private readonly string _relUrl;

            private readonly ReplyDelegate _reply;

            // Members
            private HttpWebRequest _request;

            // Methods
            public FormPoster(string base_url, string rel_url, Dictionary<string, string> parameters, ReplyDelegate replyDelegate)
            {
                _baseUrl = base_url;
                _parameters = parameters;
                _reply = replyDelegate;
                _relUrl = rel_url;
                PostForm();
            }

            public FormPoster(string base_url, string rel_url, Dictionary<string, string> parameters)
            {
                _baseUrl = base_url;
                _parameters = parameters;
                _reply = new ReplyDelegate((rep) => { });
                _relUrl = rel_url;
                PostForm();
            }

            private string EncodeUriComponent(string s)
            {
                var res = s.Replace("&", "%26");
                res = res.Replace(" ", "%20");
                return res;
            }

            private void PostForm()
            {
                _request = (HttpWebRequest)WebRequest.Create(_baseUrl + _relUrl);
                _request.Method = "POST";
                _request.ContentType = "application/x-www-form-urlencoded";
                _request.BeginGetRequestStream(RequestCallback, _request);
            }

            private void RequestCallback(IAsyncResult asyncResult)
            {
                try
                {
                    var postData = "";
                    foreach (var key in _parameters.Keys)
                    {
                        postData += EncodeUriComponent(key) + "=" + EncodeUriComponent(_parameters[key]) + "&";
                    }
                    var newStream = _request.EndGetRequestStream(asyncResult);
                    var streamWriter = new StreamWriter(newStream);
                    streamWriter.Write(postData);
                    streamWriter.Close();
                    _request.BeginGetResponse(ResponseCallback, _request);
                }
                catch (Exception e)
                {
                    _reply(e.Message);
                }
                finally { }
            }

            private void ResponseCallback(IAsyncResult asyncResult)
            {
                try
                {
                    var response = _request.EndGetResponse(asyncResult);
                    var dataStream = response.GetResponseStream();
                    var reader = new StreamReader(dataStream);
                    var result = reader.ReadToEnd();
                    _reply(result);
                }
                catch (Exception e)
                {
                    _reply(e.Message);
                }
                finally { }
            }
        }
    }
}
